-- =========================================================
-- Posting Helper Functions (Business Flows)
--
-- These wrap the low-level helpers (post_item_trans +
-- create_voucher) into one call per business event.
--
-- Flow summary:
--   post_purchase_post()        → inventory + accounting (PURCHASE)
--   post_sale_post()            → inventory + accounting (SALE)
--   post_bill_return_post()     → inventory + accounting (SALE_RETURN)
--   post_stock_transfer_issue() → inventory only, two item_trans rows
--   post_stock_transfer_receive() → inventory only, two item_trans rows
--   post_purchase_payment_post()→ accounting only (PAYMENT to supplier)
--   post_customer_payment_post()→ accounting only (RECEIPT from customer)
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- post_purchase
-- Takes a DRAFT purchase_main + purchase_line + purchase_line_tax rows
-- and posts them: creates item_trans (qty_rec per line), accounting
-- voucher, and flips purchase_status to POSTED.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.post_purchase(
    p_purchase_id BIGINT,
    p_posted_by   BIGINT
) RETURNS BIGINT AS $$
DECLARE
    v_ph                  RECORD;
    v_line                RECORD;
    v_tax_total           NUMERIC(14,2);
    v_item_trans_id       BIGINT;
    v_voucher_id          BIGINT;
    v_stock_account       BIGINT;
    v_supplier_account    BIGINT;
    v_input_tax_account   BIGINT;
    v_discount_account    BIGINT;
    v_lines               accounting.voucher_line[] := ARRAY[]::accounting.voucher_line[];
BEGIN
    SELECT * INTO v_ph FROM purchase_main WHERE id = p_purchase_id FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Purchase % not found', p_purchase_id; END IF;
    IF v_ph.purchase_status <> 'DRAFT' THEN
        RAISE EXCEPTION 'Purchase % is not in DRAFT (status=%)', p_purchase_id, v_ph.purchase_status;
    END IF;

    -- Resolve accounts
    v_stock_account     := resolve_daybook_account(v_ph.tenant_id, v_ph.branch_id, 'PURCHASE', 'STOCK');
    v_input_tax_account := resolve_daybook_account(v_ph.tenant_id, v_ph.branch_id, 'PURCHASE', 'INPUT_TAX');

    -- Supplier account: find the account_master row linked to this supplier
    SELECT id INTO v_supplier_account
      FROM account_master
     WHERE tenant_id = v_ph.tenant_id
       AND supplier_id = v_ph.supplier_id
       AND status = 'A'
     LIMIT 1;
    IF v_supplier_account IS NULL THEN
        RAISE EXCEPTION 'No ledger for supplier % (tenant %). Create a Sundry Creditor ledger first.',
            v_ph.supplier_id, v_ph.tenant_id;
    END IF;

    -- Post item_trans for each line (qty_rec) + build voucher_line list
    FOR v_line IN
        SELECT * FROM purchase_line WHERE purchase_id = p_purchase_id AND status = 'A' ORDER BY line_seq
    LOOP
        v_item_trans_id := post_item_trans(
            v_ph.tenant_id, v_ph.business_id, v_ph.branch_id,
            v_line.product_id, v_line.product_variant_id,
            'PURCHASE_RECEIPT', 'PURCHASE', v_line.uom_id,
            v_line.quantity,        -- qty_rec
            0,                      -- qty_iss
            v_line.unit_cost,
            FALSE, NULL, NULL,
            'PURCHASE_LINE', v_line.id,
            NULL,
            v_line.batch_number, v_line.expiry_date,
            NULL, p_posted_by
        );
        UPDATE purchase_line SET item_trans_id = v_item_trans_id WHERE id = v_line.id;

        -- Add stock debit line (at taxable amount - this is the inventory-booked cost)
        v_lines := v_lines || ROW(
            v_stock_account, v_line.taxable_amount, 0,
            v_line.name_snapshot, NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END LOOP;

    -- Input tax debit (grouped total)
    SELECT COALESCE(SUM(tax_amount), 0) INTO v_tax_total
      FROM purchase_line_tax WHERE purchase_id = p_purchase_id AND status = 'A';
    IF v_tax_total > 0 THEN
        v_lines := v_lines || ROW(
            v_input_tax_account, v_tax_total, 0,
            'Input Tax', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;

    -- Supplier credit (total amount payable)
    v_lines := v_lines || ROW(
        v_supplier_account, 0, v_ph.total_amount,
        CONCAT('Purchase from supplier — invoice ', COALESCE(v_ph.supplier_invoice_no, '')),
        v_ph.supplier_invoice_no, NULL, v_ph.supplier_id, NULL
    )::accounting.voucher_line;

    -- Create voucher
    v_voucher_id := accounting.create_voucher(
        v_ph.tenant_id, v_ph.business_id, v_ph.branch_id,
        'PURCHASE', v_ph.purchase_date, v_ph.currency_id,
        'PURCHASE', v_ph.id, v_ph.purchase_number,
        CONCAT('Purchase ', v_ph.purchase_number),
        v_lines, p_posted_by
    );

    -- Flip status
    UPDATE purchase_main
       SET purchase_status = 'POSTED',
           posted_at = NOW(),
           posted_by = p_posted_by,
           voucher_id = v_voucher_id,
           amount_due = total_amount - amount_paid,
           updated_at = NOW(),
           updated_by = p_posted_by,
           version = version + 1
     WHERE id = p_purchase_id;

    RETURN v_voucher_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- post_sale
-- Posts an invoice_main that has already been issued.
-- Creates item_trans (qty_iss) for product lines, invoice payments
-- are handled separately via post_customer_payment.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.post_sale(
    p_invoice_id BIGINT,
    p_posted_by  BIGINT
) RETURNS BIGINT AS $$
DECLARE
    v_inv              RECORD;
    v_order            RECORD;
    v_line             RECORD;
    v_tax_total        NUMERIC(14,2);
    v_disc_total       NUMERIC(14,2);
    v_service_total    NUMERIC(14,2) := 0;
    v_product_total    NUMERIC(14,2) := 0;
    v_item_trans_id    BIGINT;
    v_voucher_id       BIGINT;
    v_customer_account BIGINT;
    v_sale_account     BIGINT;
    v_service_account  BIGINT;
    v_output_tax_acc   BIGINT;
    v_discount_acc     BIGINT;
    v_stock_account    BIGINT;
    v_rounding_acc     BIGINT;
    v_cogs_total       NUMERIC(14,2) := 0;
    v_cogs_account     BIGINT;
    v_lines            accounting.voucher_line[] := ARRAY[]::accounting.voucher_line[];
    v_product_type_id  INT;
    v_product_variant_type_id INT;
BEGIN
    SELECT * INTO v_inv FROM billing.invoice_main WHERE id = p_invoice_id FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Invoice % not found', p_invoice_id; END IF;

    SELECT * INTO v_order FROM sales.order_main WHERE id = v_inv.order_id;

    -- Resolve accounts
    v_sale_account    := resolve_daybook_account(v_inv.tenant_id, v_inv.branch_id, 'SALE', 'SALE_INCOME');
    v_service_account := resolve_daybook_account(v_inv.tenant_id, v_inv.branch_id, 'SALE', 'SERVICE_INCOME');
    v_output_tax_acc  := resolve_daybook_account(v_inv.tenant_id, v_inv.branch_id, 'SALE', 'OUTPUT_TAX');
    v_discount_acc    := resolve_daybook_account(v_inv.tenant_id, v_inv.branch_id, 'SALE', 'DISCOUNT_GIVEN');
    v_stock_account   := resolve_daybook_account(v_inv.tenant_id, v_inv.branch_id, 'SALE', 'STOCK');
    v_rounding_acc    := resolve_daybook_account(v_inv.tenant_id, v_inv.branch_id, 'SALE', 'ROUNDING');
    -- COGS: route to PURCHASE daybook STOCK role for direct offset, or use a dedicated COGS ledger
    v_cogs_account    := v_stock_account;  -- COGS posting goes to stock by default

    -- Customer account: create if needed, else use a generic Sundry Debtors ledger
    IF v_inv.customer_account_id IS NOT NULL THEN
        SELECT id INTO v_customer_account
          FROM account_master
         WHERE tenant_id = v_inv.tenant_id
           AND customer_account_id = v_inv.customer_account_id
           AND status = 'A' LIMIT 1;
    END IF;

    -- Find m_order_line_type ids for PRODUCT and PRODUCT_VARIANT (to drive stock issuance)
    SELECT id INTO v_product_type_id FROM m_order_line_type WHERE type_key = 'PRODUCT';
    SELECT id INTO v_product_variant_type_id FROM m_order_line_type WHERE type_key = 'PRODUCT_VARIANT';

    -- Walk the invoice lines
    FOR v_line IN
        SELECT il.*, ol.product_id, ol.product_variant_id, ol.uom_id AS line_uom_id,
               ol.service_id, ol.cost_price, ol.line_type_id AS ol_line_type_id
          FROM billing.invoice_line il
          JOIN sales.order_line ol ON ol.id = il.order_line_id
         WHERE il.invoice_id = p_invoice_id AND il.status = 'A'
         ORDER BY il.line_seq
    LOOP
        -- Product lines: post qty_iss + accumulate COGS
        IF v_line.ol_line_type_id IN (v_product_type_id, v_product_variant_type_id)
           AND v_line.product_id IS NOT NULL THEN
            v_item_trans_id := post_item_trans(
                v_inv.tenant_id, v_inv.business_id, v_inv.branch_id,
                v_line.product_id, v_line.product_variant_id,
                'SALE', 'SALE', v_line.line_uom_id,
                0, v_line.quantity,    -- qty_iss
                v_line.cost_price, FALSE, NULL, NULL,
                'INVOICE_LINE', v_line.id,
                NULL, NULL, NULL, NULL, p_posted_by
            );
            v_product_total := v_product_total + v_line.taxable_amount;
            v_cogs_total := v_cogs_total + COALESCE(v_line.cost_price, 0) * v_line.quantity;
        ELSE
            v_service_total := v_service_total + v_line.taxable_amount;
        END IF;
    END LOOP;

    -- Build voucher lines
    -- Debit: debtor / cash (we'll assume it goes to Sundry Debtors if unpaid; payments voucher
    -- will later move balance to cash/card accounts)
    IF v_customer_account IS NULL THEN
        -- If no per-customer ledger, post to the generic SUNDRY_DEBTORS account
        SELECT id INTO v_customer_account FROM account_master
         WHERE tenant_id = v_inv.tenant_id AND ledger_type = 'CUSTOMER' AND status = 'A'
         LIMIT 1;
        IF v_customer_account IS NULL THEN
            -- Fall back to generic SUSPENSE account
            SELECT id INTO v_customer_account FROM account_master
             WHERE tenant_id = v_inv.tenant_id AND code = 'SUSPENSE' AND status = 'A';
        END IF;
    END IF;

    v_lines := v_lines || ROW(
        v_customer_account, v_inv.total_amount, 0,
        CONCAT('Sale invoice ', v_inv.invoice_number),
        v_inv.invoice_number, v_inv.customer_account_id, NULL, NULL
    )::accounting.voucher_line;

    IF v_product_total > 0 THEN
        v_lines := v_lines || ROW(
            v_sale_account, 0, v_product_total,
            'Product Sale', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;
    IF v_service_total > 0 THEN
        v_lines := v_lines || ROW(
            v_service_account, 0, v_service_total,
            'Service Income', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;
    IF v_inv.tax_amount > 0 THEN
        v_lines := v_lines || ROW(
            v_output_tax_acc, 0, v_inv.tax_amount,
            'Output Tax', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;
    IF v_inv.discount_amount > 0 THEN
        v_lines := v_lines || ROW(
            v_discount_acc, v_inv.discount_amount, 0,
            'Discount Allowed', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;
    IF v_inv.rounding_amount <> 0 THEN
        IF v_inv.rounding_amount > 0 THEN
            v_lines := v_lines || ROW(
                v_rounding_acc, 0, v_inv.rounding_amount,
                'Rounding Off', NULL, NULL, NULL, NULL
            )::accounting.voucher_line;
        ELSE
            v_lines := v_lines || ROW(
                v_rounding_acc, ABS(v_inv.rounding_amount), 0,
                'Rounding Off', NULL, NULL, NULL, NULL
            )::accounting.voucher_line;
        END IF;
    END IF;

    v_voucher_id := accounting.create_voucher(
        v_inv.tenant_id, v_inv.business_id, v_inv.branch_id,
        'SALE', v_inv.issue_date, v_inv.currency_id,
        'SALE_INVOICE', v_inv.id, v_inv.invoice_number,
        CONCAT('Sale invoice ', v_inv.invoice_number),
        v_lines, p_posted_by
    );

    -- If there's COGS (product sale), post a separate JOURNAL for Dr COGS / Cr Stock
    IF v_cogs_total > 0 THEN
        PERFORM accounting.create_voucher(
            v_inv.tenant_id, v_inv.business_id, v_inv.branch_id,
            'JOURNAL', v_inv.issue_date, v_inv.currency_id,
            'SALE_COGS', v_inv.id, v_inv.invoice_number,
            CONCAT('COGS for invoice ', v_inv.invoice_number),
            ARRAY[
                ROW(v_cogs_account, v_cogs_total, 0,
                    'Cost of Goods Sold', NULL, NULL, NULL, NULL)::accounting.voucher_line,
                ROW(v_stock_account, 0, v_cogs_total,
                    'Stock issued', NULL, NULL, NULL, NULL)::accounting.voucher_line
            ],
            p_posted_by
        );
    END IF;

    RETURN v_voucher_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- post_bill_return
-- Posts a DRAFT bill_return_main: generates item_trans rows
-- (qty_rec, daybook=SALE_RETURN) and an accounting voucher.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.post_bill_return(
    p_bill_return_id BIGINT,
    p_posted_by      BIGINT
) RETURNS BIGINT AS $$
DECLARE
    v_br               RECORD;
    v_line             RECORD;
    v_item_trans_id    BIGINT;
    v_voucher_id       BIGINT;
    v_customer_account BIGINT;
    v_sales_ret_acc    BIGINT;
    v_output_tax_acc   BIGINT;
    v_stock_account    BIGINT;
    v_lines            accounting.voucher_line[] := ARRAY[]::accounting.voucher_line[];
BEGIN
    SELECT * INTO v_br FROM billing.bill_return_main WHERE id = p_bill_return_id FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Bill return % not found', p_bill_return_id; END IF;
    IF v_br.return_status <> 'DRAFT' THEN
        RAISE EXCEPTION 'Bill return % is not in DRAFT (status=%)', p_bill_return_id, v_br.return_status;
    END IF;

    v_sales_ret_acc  := resolve_daybook_account(v_br.tenant_id, v_br.branch_id, 'SALE_RETURN', 'SALES_RETURN');
    v_output_tax_acc := resolve_daybook_account(v_br.tenant_id, v_br.branch_id, 'SALE_RETURN', 'OUTPUT_TAX');
    v_stock_account  := resolve_daybook_account(v_br.tenant_id, v_br.branch_id, 'SALE_RETURN', 'STOCK');

    -- Customer account
    IF v_br.customer_account_id IS NOT NULL THEN
        SELECT id INTO v_customer_account FROM account_master
         WHERE tenant_id = v_br.tenant_id AND customer_account_id = v_br.customer_account_id
           AND status = 'A' LIMIT 1;
    END IF;
    IF v_customer_account IS NULL THEN
        SELECT id INTO v_customer_account FROM account_master
         WHERE tenant_id = v_br.tenant_id AND code = 'SUSPENSE' AND status = 'A';
    END IF;

    -- Restock any products flagged for restock
    FOR v_line IN
        SELECT * FROM billing.bill_return_line WHERE bill_return_id = p_bill_return_id AND status = 'A'
    LOOP
        IF v_line.product_id IS NOT NULL AND v_line.restock THEN
            v_item_trans_id := post_item_trans(
                v_br.tenant_id, v_br.business_id, v_br.branch_id,
                v_line.product_id, v_line.product_variant_id,
                'CUSTOMER_RETURN', 'SALE_RETURN', v_line.uom_id,
                v_line.quantity, 0,      -- qty_rec
                NULL, FALSE, NULL, NULL,
                'BILL_RETURN_LINE', v_line.id,
                NULL, v_line.batch_number, v_line.expiry_date,
                NULL, p_posted_by
            );
            UPDATE billing.bill_return_line SET item_trans_id = v_item_trans_id WHERE id = v_line.id;
        END IF;
    END LOOP;

    -- Voucher lines: Dr Sales Return + Dr Output Tax, Cr Customer/Cash
    IF v_br.subtotal_amount > 0 THEN
        v_lines := v_lines || ROW(
            v_sales_ret_acc, v_br.subtotal_amount - v_br.discount_amount, 0,
            'Sale return', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;
    IF v_br.tax_amount > 0 THEN
        v_lines := v_lines || ROW(
            v_output_tax_acc, v_br.tax_amount, 0,
            'Output tax reversal', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;
    v_lines := v_lines || ROW(
        v_customer_account, 0, v_br.total_amount,
        CONCAT('Sale return ', v_br.return_number),
        v_br.return_number, v_br.customer_account_id, NULL, NULL
    )::accounting.voucher_line;

    v_voucher_id := accounting.create_voucher(
        v_br.tenant_id, v_br.business_id, v_br.branch_id,
        'SALE_RETURN', v_br.return_date, v_br.currency_id,
        'BILL_RETURN', v_br.id, v_br.return_number,
        CONCAT('Sale return ', v_br.return_number),
        v_lines, p_posted_by
    );

    UPDATE billing.bill_return_main
       SET return_status = 'POSTED',
           posted_at = NOW(),
           posted_by = p_posted_by,
           voucher_id = v_voucher_id,
           updated_at = NOW(),
           updated_by = p_posted_by,
           version = version + 1
     WHERE id = p_bill_return_id;

    RETURN v_voucher_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- post_stock_transfer_issue
-- Branch 1 issues stock. For each line:
--   1. post qty_iss @ source branch (STK_TRF_OUT)
--   2. post qty_rec @ destination branch, in_transit=TRUE (STK_TRF_IN_TRANSIT)
-- No accounting entries (internal movement, same tenant).
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.post_stock_transfer_issue(
    p_transfer_id BIGINT,
    p_issued_by   BIGINT
) RETURNS VOID AS $$
DECLARE
    v_tr              RECORD;
    v_line            RECORD;
    v_issue_id        BIGINT;
    v_transit_id      BIGINT;
    v_source_business BIGINT;
    v_dest_business   BIGINT;
BEGIN
    SELECT * INTO v_tr FROM stock_transfer_main WHERE id = p_transfer_id FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Stock transfer % not found', p_transfer_id; END IF;
    IF v_tr.transfer_status <> 'DRAFT' THEN
        RAISE EXCEPTION 'Stock transfer % is not in DRAFT (status=%)', p_transfer_id, v_tr.transfer_status;
    END IF;

    SELECT business_id INTO v_source_business FROM branches WHERE id = v_tr.source_branch_id;
    SELECT business_id INTO v_dest_business   FROM branches WHERE id = v_tr.destination_branch_id;

    FOR v_line IN
        SELECT * FROM stock_transfer_line WHERE transfer_id = p_transfer_id AND status = 'A' ORDER BY line_seq
    LOOP
        -- 1. Issue from source branch
        v_issue_id := post_item_trans(
            v_tr.tenant_id, v_source_business, v_tr.source_branch_id,
            v_line.product_id, v_line.product_variant_id,
            'STOCK_TRANSFER_OUT', 'STK_TRF_OUT', v_line.uom_id,
            0, v_line.quantity_issued,
            v_line.unit_cost, FALSE,
            v_tr.source_branch_id, v_tr.destination_branch_id,
            'STOCK_TRANSFER_LINE', v_line.id,
            NULL, v_line.batch_number, v_line.expiry_date,
            CONCAT('Transfer ', v_tr.transfer_number, ' to branch ', v_tr.destination_branch_id),
            p_issued_by
        );

        -- 2. Receipt at destination branch, in_transit=TRUE
        v_transit_id := post_item_trans(
            v_tr.tenant_id, v_dest_business, v_tr.destination_branch_id,
            v_line.product_id, v_line.product_variant_id,
            'STOCK_TRANSFER_IN', 'STK_TRF_IN_TRANSIT', v_line.uom_id,
            v_line.quantity_issued, 0,
            v_line.unit_cost, TRUE,
            v_tr.source_branch_id, v_tr.destination_branch_id,
            'STOCK_TRANSFER_LINE', v_line.id,
            NULL, v_line.batch_number, v_line.expiry_date,
            CONCAT('In-transit from branch ', v_tr.source_branch_id),
            p_issued_by
        );

        UPDATE stock_transfer_line
           SET issue_trans_id = v_issue_id,
               in_transit_trans_id = v_transit_id,
               quantity_in_transit = v_line.quantity_issued,
               line_status = 'IN_TRANSIT',
               updated_at = NOW(),
               updated_by = p_issued_by,
               version = version + 1
         WHERE id = v_line.id;
    END LOOP;

    UPDATE stock_transfer_main
       SET transfer_status = 'IN_TRANSIT',
           issued_at = NOW(),
           issued_by = p_issued_by,
           updated_at = NOW(),
           updated_by = p_issued_by,
           version = version + 1
     WHERE id = p_transfer_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- post_stock_transfer_receive
-- Branch 2 receives stock. For each line:
--   1. post qty_rec @ destination branch (STK_TRF_IN) - physical
--   2. post qty_iss @ destination branch, in_transit=TRUE,
--      reverses_trans_id=<in-transit row> — consumes the virtual in-transit stock
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.post_stock_transfer_receive(
    p_transfer_id BIGINT,
    p_received_by BIGINT,
    p_lines       BIGINT[] DEFAULT NULL,   -- optional list of stock_transfer_line ids to receive
    p_quantities  NUMERIC[] DEFAULT NULL   -- parallel array; NULL = full outstanding qty per line
) RETURNS VOID AS $$
DECLARE
    v_tr              RECORD;
    v_line            RECORD;
    v_receive_id      BIGINT;
    v_consume_id      BIGINT;
    v_dest_business   BIGINT;
    v_qty_to_receive  NUMERIC(14,3);
    v_idx             INT;
    v_all_received    BOOLEAN := TRUE;
BEGIN
    SELECT * INTO v_tr FROM stock_transfer_main WHERE id = p_transfer_id FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Stock transfer % not found', p_transfer_id; END IF;
    IF v_tr.transfer_status NOT IN ('IN_TRANSIT', 'PARTIALLY_RECEIVED') THEN
        RAISE EXCEPTION 'Stock transfer % not ready for receiving (status=%)', p_transfer_id, v_tr.transfer_status;
    END IF;

    SELECT business_id INTO v_dest_business FROM branches WHERE id = v_tr.destination_branch_id;

    FOR v_line IN
        SELECT * FROM stock_transfer_line WHERE transfer_id = p_transfer_id AND status = 'A' ORDER BY line_seq
    LOOP
        -- Determine the quantity to receive for this line
        v_qty_to_receive := v_line.quantity_in_transit;  -- default: all outstanding
        IF p_lines IS NOT NULL THEN
            v_qty_to_receive := 0;
            FOR v_idx IN 1..array_length(p_lines, 1) LOOP
                IF p_lines[v_idx] = v_line.id THEN
                    v_qty_to_receive := COALESCE(p_quantities[v_idx], v_line.quantity_in_transit);
                    EXIT;
                END IF;
            END LOOP;
        END IF;

        IF v_qty_to_receive <= 0 THEN
            IF v_line.quantity_in_transit > 0 THEN v_all_received := FALSE; END IF;
            CONTINUE;
        END IF;
        IF v_qty_to_receive > v_line.quantity_in_transit THEN
            RAISE EXCEPTION 'Receive qty % exceeds in-transit qty % for line %',
                v_qty_to_receive, v_line.quantity_in_transit, v_line.id;
        END IF;

        -- 1. Physical receipt at destination
        v_receive_id := post_item_trans(
            v_tr.tenant_id, v_dest_business, v_tr.destination_branch_id,
            v_line.product_id, v_line.product_variant_id,
            'STOCK_TRANSFER_IN', 'STK_TRF_IN', v_line.uom_id,
            v_qty_to_receive, 0,
            v_line.unit_cost, FALSE,
            v_tr.source_branch_id, v_tr.destination_branch_id,
            'STOCK_TRANSFER_LINE', v_line.id,
            NULL, v_line.batch_number, v_line.expiry_date,
            CONCAT('Received from transfer ', v_tr.transfer_number),
            p_received_by
        );

        -- 2. Consume in-transit virtual stock (qty_iss, in_transit=TRUE, reverses the in-transit row)
        v_consume_id := post_item_trans(
            v_tr.tenant_id, v_dest_business, v_tr.destination_branch_id,
            v_line.product_id, v_line.product_variant_id,
            'STOCK_TRANSFER_OUT', 'STK_TRF_IN', v_line.uom_id,
            0, v_qty_to_receive,
            v_line.unit_cost, TRUE,
            v_tr.source_branch_id, v_tr.destination_branch_id,
            'STOCK_TRANSFER_LINE', v_line.id,
            v_line.in_transit_trans_id,
            v_line.batch_number, v_line.expiry_date,
            CONCAT('In-transit consumed for transfer ', v_tr.transfer_number),
            p_received_by
        );

        UPDATE stock_transfer_line
           SET quantity_received = quantity_received + v_qty_to_receive,
               quantity_in_transit = quantity_in_transit - v_qty_to_receive,
               receive_trans_id = COALESCE(receive_trans_id, v_receive_id),
               line_status = CASE
                   WHEN quantity_received + v_qty_to_receive >= quantity_issued THEN 'RECEIVED'
                   ELSE 'PARTIALLY_RECEIVED'
               END,
               updated_at = NOW(),
               updated_by = p_received_by,
               version = version + 1
         WHERE id = v_line.id;

        IF (v_line.quantity_in_transit - v_qty_to_receive) > 0 THEN
            v_all_received := FALSE;
        END IF;
    END LOOP;

    UPDATE stock_transfer_main
       SET transfer_status = CASE WHEN v_all_received THEN 'RECEIVED' ELSE 'PARTIALLY_RECEIVED' END,
           received_at = CASE WHEN v_all_received THEN NOW() ELSE received_at END,
           received_by = CASE WHEN v_all_received THEN p_received_by ELSE received_by END,
           updated_at = NOW(),
           updated_by = p_received_by,
           version = version + 1
     WHERE id = p_transfer_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- post_purchase_payment
-- Money out to a supplier. Generates a PAYMENT voucher:
--   Dr Supplier (Sundry Creditor)
--     Cr Cash / Bank (from paid_from_account_id)
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.post_purchase_payment(
    p_purchase_payment_id BIGINT,
    p_posted_by           BIGINT
) RETURNS BIGINT AS $$
DECLARE
    v_pay              RECORD;
    v_supplier_account BIGINT;
    v_voucher_id       BIGINT;
BEGIN
    SELECT * INTO v_pay FROM purchase_payment WHERE id = p_purchase_payment_id FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Purchase payment % not found', p_purchase_payment_id; END IF;

    SELECT id INTO v_supplier_account
      FROM account_master
     WHERE tenant_id = v_pay.tenant_id AND supplier_id = v_pay.supplier_id AND status = 'A'
     LIMIT 1;
    IF v_supplier_account IS NULL THEN
        RAISE EXCEPTION 'No ledger for supplier % (tenant %)', v_pay.supplier_id, v_pay.tenant_id;
    END IF;

    v_voucher_id := accounting.create_voucher(
        v_pay.tenant_id, v_pay.business_id, v_pay.branch_id,
        'PAYMENT', v_pay.payment_date, v_pay.currency_id,
        'PURCHASE_PAYMENT', v_pay.id, v_pay.payment_number,
        CONCAT('Payment to supplier ', v_pay.payment_number),
        ARRAY[
            ROW(v_supplier_account, v_pay.amount, 0,
                'Payment to supplier', v_pay.reference_number,
                NULL, v_pay.supplier_id, NULL)::accounting.voucher_line,
            ROW(v_pay.paid_from_account_id, 0, v_pay.amount,
                CONCAT('Payment by ', v_pay.payment_method_id), v_pay.reference_number,
                NULL, NULL, NULL)::accounting.voucher_line
        ],
        p_posted_by
    );

    UPDATE purchase_payment
       SET voucher_id = v_voucher_id,
           updated_at = NOW(),
           updated_by = p_posted_by,
           version = version + 1
     WHERE id = p_purchase_payment_id;

    -- Roll up allocations onto the bills
    UPDATE purchase_main pm
       SET amount_paid = amount_paid + alloc.allocated_amount,
           amount_due = total_amount - (amount_paid + alloc.allocated_amount),
           updated_at = NOW(),
           updated_by = p_posted_by,
           version = version + 1
      FROM purchase_payment_allocations alloc
     WHERE alloc.purchase_payment_id = p_purchase_payment_id
       AND pm.id = alloc.purchase_id;

    RETURN v_voucher_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- post_customer_payment
-- Money in from a customer against an invoice. Generates a RECEIPT voucher.
-- (Works against billing.payment_main.)
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.post_customer_payment(
    p_payment_id BIGINT,
    p_posted_by  BIGINT
) RETURNS BIGINT AS $$
DECLARE
    v_pay              RECORD;
    v_tender           RECORD;
    v_customer_account BIGINT;
    v_cash_account     BIGINT;
    v_tip_account      BIGINT;
    v_voucher_id       BIGINT;
    v_lines            accounting.voucher_line[] := ARRAY[]::accounting.voucher_line[];
    v_inv              RECORD;
BEGIN
    SELECT * INTO v_pay FROM billing.payment_main WHERE id = p_payment_id FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Payment % not found', p_payment_id; END IF;
    SELECT * INTO v_inv FROM billing.invoice_main WHERE id = v_pay.invoice_id;

    v_tip_account := resolve_daybook_account(v_pay.tenant_id, v_pay.branch_id, 'SALE', 'TIP_PAYABLE');

    -- Customer ledger
    IF v_pay.customer_account_id IS NOT NULL THEN
        SELECT id INTO v_customer_account FROM account_master
         WHERE tenant_id = v_pay.tenant_id AND customer_account_id = v_pay.customer_account_id
           AND status = 'A' LIMIT 1;
    END IF;
    IF v_customer_account IS NULL THEN
        SELECT id INTO v_customer_account FROM account_master
         WHERE tenant_id = v_pay.tenant_id AND code = 'SUSPENSE' AND status = 'A';
    END IF;

    -- For each tender, Dr the corresponding cash/card/UPI ledger
    FOR v_tender IN
        SELECT pt.*, pm_ledger.id AS ledger_id
          FROM billing.payment_tender pt
          LEFT JOIN account_master pm_ledger
              ON pm_ledger.tenant_id = v_pay.tenant_id
             AND pm_ledger.branch_id = v_pay.branch_id
             AND pm_ledger.payment_method_id = pt.payment_method_id
             AND pm_ledger.status = 'A'
         WHERE pt.payment_id = p_payment_id
           AND pt.status = 'A'
    LOOP
        v_cash_account := v_tender.ledger_id;
        IF v_cash_account IS NULL THEN
            -- fallback to branch cash
            v_cash_account := resolve_daybook_account(v_pay.tenant_id, v_pay.branch_id, 'RECEIPT', 'CASH');
        END IF;

        v_lines := v_lines || ROW(
            v_cash_account, v_tender.amount, 0,
            CONCAT('Receipt via ', v_tender.tender_type_id),
            v_tender.reference_number, NULL, NULL, NULL
        )::accounting.voucher_line;
    END LOOP;

    -- If no tenders (shouldn't happen but fallback to primary payment method)
    IF array_length(v_lines, 1) IS NULL OR array_length(v_lines, 1) = 0 THEN
        v_cash_account := resolve_daybook_account(v_pay.tenant_id, v_pay.branch_id, 'RECEIPT', 'CASH');
        v_lines := v_lines || ROW(
            v_cash_account, v_pay.amount, 0,
            'Receipt', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;

    -- Credit: customer (for the invoice amount) + tip payable (for tip portion)
    IF v_pay.amount > 0 THEN
        v_lines := v_lines || ROW(
            v_customer_account, 0, v_pay.amount,
            CONCAT('Payment from customer against invoice ', v_inv.invoice_number),
            v_inv.invoice_number, v_pay.customer_account_id, NULL, NULL
        )::accounting.voucher_line;
    END IF;
    IF v_pay.tip_amount > 0 THEN
        v_lines := v_lines || ROW(
            v_tip_account, 0, v_pay.tip_amount,
            'Tip received', NULL, NULL, NULL, NULL
        )::accounting.voucher_line;
    END IF;

    v_voucher_id := accounting.create_voucher(
        v_pay.tenant_id, v_pay.business_id, v_pay.branch_id,
        'RECEIPT', v_pay.received_at::date, v_pay.currency_id,
        'CUSTOMER_PAYMENT', v_pay.id, v_pay.payment_number,
        CONCAT('Customer payment ', v_pay.payment_number),
        v_lines, p_posted_by
    );

    -- Update invoice rollup
    UPDATE billing.invoice_main
       SET amount_paid = amount_paid + v_pay.amount,
           amount_due = total_amount - (amount_paid + v_pay.amount) + amount_refunded,
           paid_at = CASE WHEN total_amount - (amount_paid + v_pay.amount) + amount_refunded <= 0
                          THEN NOW() ELSE paid_at END,
           updated_at = NOW(),
           updated_by = p_posted_by,
           version = version + 1
     WHERE id = v_pay.invoice_id;

    RETURN v_voucher_id;
END;
$$ LANGUAGE plpgsql;
