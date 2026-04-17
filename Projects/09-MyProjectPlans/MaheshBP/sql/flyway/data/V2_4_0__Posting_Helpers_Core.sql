-- =========================================================
-- Posting Helper Functions (Core)
--
-- These are the ONLY entry points the application should use
-- to mutate accounting / inventory state. Each function:
--   - validates inputs
--   - inserts immutable item_trans rows
--   - updates branch_product_stock snapshot
--   - creates balanced ac_voucher + ac_transaction lines
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- resolve_daybook_account
-- Looks up the account for (tenant, branch, daybook_key, role_key)
-- with fallback to tenant-wide (branch_id IS NULL) mapping.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.resolve_daybook_account(
    p_tenant_id   BIGINT,
    p_branch_id   BIGINT,
    p_daybook_key character varying,
    p_role_key    character varying
) RETURNS BIGINT AS $$
DECLARE
    v_account_id BIGINT;
BEGIN
    SELECT dam.account_id INTO v_account_id
      FROM daybook_account_map dam
      JOIN m_daybook db ON db.id = dam.daybook_id
     WHERE dam.tenant_id = p_tenant_id
       AND dam.branch_id = p_branch_id
       AND db.daybook_key = p_daybook_key
       AND dam.role_key = p_role_key
       AND dam.status = 'A';

    IF v_account_id IS NULL THEN
        SELECT dam.account_id INTO v_account_id
          FROM daybook_account_map dam
          JOIN m_daybook db ON db.id = dam.daybook_id
         WHERE dam.tenant_id = p_tenant_id
           AND dam.branch_id IS NULL
           AND db.daybook_key = p_daybook_key
           AND dam.role_key = p_role_key
           AND dam.status = 'A';
    END IF;

    IF v_account_id IS NULL THEN
        RAISE EXCEPTION 'No daybook_account_map for tenant=%, branch=%, daybook=%, role=%',
            p_tenant_id, p_branch_id, p_daybook_key, p_role_key;
    END IF;

    RETURN v_account_id;
END;
$$ LANGUAGE plpgsql STABLE;

-- ---------------------------------------------------------
-- post_item_trans
-- Inserts one immutable item_trans row and updates the
-- branch_product_stock snapshot atomically.
--
-- For in_transit=TRUE rows, the snapshot is NOT updated
-- (the stock hasn't physically arrived / left yet).
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.post_item_trans(
    p_tenant_id             BIGINT,
    p_business_id           BIGINT,
    p_branch_id             BIGINT,
    p_product_id            BIGINT,
    p_product_variant_id    BIGINT,
    p_movement_type_key     character varying,
    p_daybook_key           character varying,
    p_uom_id                INT,
    p_qty_rec               NUMERIC,
    p_qty_iss               NUMERIC,
    p_unit_cost             NUMERIC,
    p_in_transit            BOOLEAN,
    p_source_branch_id      BIGINT,
    p_destination_branch_id BIGINT,
    p_reference_type        character varying,
    p_reference_id          BIGINT,
    p_reverses_trans_id     BIGINT,
    p_batch_number          character varying,
    p_expiry_date           DATE,
    p_notes                 TEXT,
    p_created_by            BIGINT
) RETURNS BIGINT AS $$
DECLARE
    v_movement_type_id INT;
    v_daybook_id       INT;
    v_next_id          BIGINT;
    v_internal_code    character varying;
    v_current_qty      NUMERIC(14,3);
    v_current_avg      NUMERIC(12,4);
    v_new_balance      NUMERIC(14,3);
    v_total_cost       NUMERIC(14,2);
    v_new_avg          NUMERIC(12,4);
    v_delta            NUMERIC(14,3);
BEGIN
    -- Resolve lookup ids
    SELECT id INTO v_movement_type_id FROM m_stock_movement_type WHERE movement_key = p_movement_type_key;
    IF v_movement_type_id IS NULL THEN
        RAISE EXCEPTION 'Unknown movement type: %', p_movement_type_key;
    END IF;

    SELECT id INTO v_daybook_id FROM m_daybook WHERE daybook_key = p_daybook_key;
    IF v_daybook_id IS NULL THEN
        RAISE EXCEPTION 'Unknown daybook: %', p_daybook_key;
    END IF;

    -- Validate: exactly one side of qty must be positive
    IF NOT ((COALESCE(p_qty_rec, 0) > 0 AND COALESCE(p_qty_iss, 0) = 0)
         OR (COALESCE(p_qty_rec, 0) = 0 AND COALESCE(p_qty_iss, 0) > 0)) THEN
        RAISE EXCEPTION 'Exactly one of qty_rec or qty_iss must be positive (got rec=%, iss=%)',
            p_qty_rec, p_qty_iss;
    END IF;

    -- Pre-allocate id so we can generate internal_code before insert (the table is
    -- immutable, so we cannot UPDATE the code post-insert).
    v_next_id := nextval(pg_get_serial_sequence('core.item_trans', 'id'));
    v_internal_code := CONCAT('IT-', LPAD(v_next_id::text, 12, '0'));

    -- Ensure the stock row exists and lock it
    INSERT INTO branch_product_stock
        (internal_id, tenant_id, business_id, branch_id, product_id, product_variant_id, uom_id,
         quantity_on_hand, quantity_reserved, status, version)
    VALUES
        (CONCAT('BPS-', p_branch_id, '-', p_product_id, '-', COALESCE(p_product_variant_id, 0)),
         p_tenant_id, p_business_id, p_branch_id, p_product_id, p_product_variant_id, p_uom_id,
         0, 0, 'A', 1)
    ON CONFLICT (branch_id, product_id, product_variant_id) DO NOTHING;

    SELECT quantity_on_hand, avg_cost_price
      INTO v_current_qty, v_current_avg
      FROM branch_product_stock
     WHERE branch_id = p_branch_id
       AND product_id = p_product_id
       AND product_variant_id IS NOT DISTINCT FROM p_product_variant_id
     FOR UPDATE;

    v_delta       := COALESCE(p_qty_rec, 0) - COALESCE(p_qty_iss, 0);
    v_new_balance := COALESCE(v_current_qty, 0) + v_delta;
    v_total_cost  := COALESCE(p_unit_cost, 0) * (COALESCE(p_qty_rec, 0) + COALESCE(p_qty_iss, 0));

    -- Weighted-average cost update (only for physical receipts)
    IF COALESCE(p_qty_rec, 0) > 0 AND p_unit_cost IS NOT NULL AND NOT COALESCE(p_in_transit, FALSE) THEN
        IF COALESCE(v_current_qty, 0) <= 0 OR v_current_avg IS NULL THEN
            v_new_avg := p_unit_cost;
        ELSE
            v_new_avg := ((v_current_qty * v_current_avg) + (p_qty_rec * p_unit_cost))
                         / (v_current_qty + p_qty_rec);
        END IF;
    ELSE
        v_new_avg := v_current_avg;
    END IF;

    -- Insert the immutable row
    INSERT INTO item_trans
        (id, internal_code, tenant_id, business_id, branch_id, product_id, product_variant_id,
         movement_type_id, daybook_id, uom_id,
         qty_rec, qty_iss, unit_cost, total_cost, balance_after,
         in_transit, source_branch_id, destination_branch_id,
         reference_type, reference_id, reverses_trans_id,
         batch_number, expiry_date, trans_at, notes, created_by)
    VALUES
        (v_next_id, v_internal_code, p_tenant_id, p_business_id, p_branch_id, p_product_id, p_product_variant_id,
         v_movement_type_id, v_daybook_id, p_uom_id,
         COALESCE(p_qty_rec, 0), COALESCE(p_qty_iss, 0), p_unit_cost, v_total_cost, v_new_balance,
         COALESCE(p_in_transit, FALSE), p_source_branch_id, p_destination_branch_id,
         p_reference_type, p_reference_id, p_reverses_trans_id,
         p_batch_number, p_expiry_date, NOW(), p_notes, p_created_by);

    -- Update snapshot (skip for in-transit rows)
    IF NOT COALESCE(p_in_transit, FALSE) THEN
        UPDATE branch_product_stock
           SET quantity_on_hand = v_new_balance,
               avg_cost_price   = v_new_avg,
               last_cost_price  = COALESCE(p_unit_cost, last_cost_price),
               last_trans_at    = NOW(),
               updated_at       = NOW(),
               updated_by       = p_created_by,
               version          = version + 1
         WHERE branch_id = p_branch_id
           AND product_id = p_product_id
           AND product_variant_id IS NOT DISTINCT FROM p_product_variant_id;
    END IF;

    RETURN v_next_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- create_voucher
-- Creates an ac_voucher + N ac_transaction lines.
-- p_lines is an array of (account_id, dr_amount, cr_amount, narration, reference_number).
-- Validates balance (Σ dr = Σ cr) and raises if unbalanced.
--
-- Returns the new voucher_id.
-- ---------------------------------------------------------
CREATE TYPE accounting.voucher_line AS (
    account_id          BIGINT,
    dr_amount           NUMERIC(16,2),
    cr_amount           NUMERIC(16,2),
    narration           TEXT,
    reference_number    character varying,
    customer_account_id BIGINT,
    supplier_id         BIGINT,
    staff_id            BIGINT
);

CREATE OR REPLACE FUNCTION accounting.create_voucher(
    p_tenant_id     BIGINT,
    p_business_id   BIGINT,
    p_branch_id     BIGINT,
    p_daybook_key   character varying,
    p_voucher_date  DATE,
    p_currency_id   INT,
    p_source_type   character varying,
    p_source_id     BIGINT,
    p_source_code   character varying,
    p_narration     TEXT,
    p_lines         accounting.voucher_line[],
    p_created_by    BIGINT
) RETURNS BIGINT AS $$
DECLARE
    v_daybook_id       INT;
    v_voucher_prefix   character varying;
    v_voucher_id       BIGINT;
    v_voucher_number   character varying;
    v_internal_code    character varying;
    v_total_dr         NUMERIC(16,2) := 0;
    v_total_cr         NUMERIC(16,2) := 0;
    v_seq              INT := 0;
    v_line             accounting.voucher_line;
    v_primary_group_id INT;
    v_nature_id        INT;
BEGIN
    SELECT id, voucher_prefix INTO v_daybook_id, v_voucher_prefix
      FROM core.m_daybook WHERE daybook_key = p_daybook_key;
    IF v_daybook_id IS NULL THEN
        RAISE EXCEPTION 'Unknown daybook: %', p_daybook_key;
    END IF;

    -- Sum the lines first and validate balance
    FOREACH v_line IN ARRAY p_lines LOOP
        v_total_dr := v_total_dr + COALESCE(v_line.dr_amount, 0);
        v_total_cr := v_total_cr + COALESCE(v_line.cr_amount, 0);
    END LOOP;

    IF v_total_dr <> v_total_cr THEN
        RAISE EXCEPTION 'Voucher unbalanced: total_dr=% total_cr=% (daybook=%)', v_total_dr, v_total_cr, p_daybook_key;
    END IF;
    IF v_total_dr = 0 THEN
        RAISE EXCEPTION 'Voucher has no amounts (daybook=%)', p_daybook_key;
    END IF;

    -- Voucher number: <PREFIX>/<YYYY>/<seq>
    v_voucher_id := nextval(pg_get_serial_sequence('accounting.ac_voucher', 'id'));
    v_voucher_number := CONCAT(
        COALESCE(v_voucher_prefix, 'VCH'), '/',
        EXTRACT(YEAR FROM p_voucher_date)::text, '/',
        LPAD(v_voucher_id::text, 8, '0'));
    v_internal_code := CONCAT('VCH-', LPAD(v_voucher_id::text, 12, '0'));

    INSERT INTO accounting.ac_voucher
        (id, internal_code, voucher_number, tenant_id, business_id, branch_id,
         daybook_id, voucher_date, currency_id,
         total_debit, total_credit,
         source_type, source_id, source_code, narration,
         voucher_status, posted_at, posted_by, status, version)
    VALUES
        (v_voucher_id, v_internal_code, v_voucher_number, p_tenant_id, p_business_id, p_branch_id,
         v_daybook_id, p_voucher_date, p_currency_id,
         v_total_dr, v_total_cr,
         p_source_type, p_source_id, p_source_code, p_narration,
         'POSTED', NOW(), p_created_by, 'A', 1);

    -- Insert the lines
    FOREACH v_line IN ARRAY p_lines LOOP
        v_seq := v_seq + 1;
        -- Skip zero lines silently (they may be produced by tax-free items)
        IF COALESCE(v_line.dr_amount, 0) = 0 AND COALESCE(v_line.cr_amount, 0) = 0 THEN
            CONTINUE;
        END IF;

        SELECT primary_group_id, nature_id
          INTO v_primary_group_id, v_nature_id
          FROM core.account_master WHERE id = v_line.account_id;
        IF v_primary_group_id IS NULL THEN
            RAISE EXCEPTION 'Account % not found', v_line.account_id;
        END IF;

        INSERT INTO accounting.ac_transaction
            (internal_code, tenant_id, business_id, branch_id, voucher_id, voucher_line_seq,
             daybook_id, voucher_date, account_id, primary_group_id, nature_id,
             currency_id, dr_amount, cr_amount,
             customer_account_id, supplier_id, staff_id,
             narration, reference_number, status, version)
        VALUES
            (CONCAT('ACT-', v_voucher_id, '-', v_seq),
             p_tenant_id, p_business_id, p_branch_id, v_voucher_id, v_seq,
             v_daybook_id, p_voucher_date, v_line.account_id, v_primary_group_id, v_nature_id,
             p_currency_id,
             COALESCE(v_line.dr_amount, 0), COALESCE(v_line.cr_amount, 0),
             v_line.customer_account_id, v_line.supplier_id, v_line.staff_id,
             v_line.narration, v_line.reference_number, 'A', 1);
    END LOOP;

    RETURN v_voucher_id;
END;
$$ LANGUAGE plpgsql;
