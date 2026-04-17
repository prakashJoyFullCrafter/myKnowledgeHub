-- =========================================================
-- Purchase (header + lines + payment) and Stock Transfer
-- Same-tenant only; FKs + CHECKs enforce this.
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- purchase_main (supplier bill header)
-- A purchase can pull from one purchase_receipt (GRN) or be
-- recorded directly without a prior GRN.
-- ---------------------------------------------------------
CREATE TABLE purchase_main
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_code         character varying(50)  NOT NULL UNIQUE,
    purchase_number       character varying(50)  NOT NULL,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id           BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id             BIGINT                 NOT NULL REFERENCES branches (id),

    supplier_id           BIGINT                 NOT NULL REFERENCES suppliers (id),

    -- Daybook always PURCHASE or PURCHASE_RETURN (set by app)
    daybook_id            INT                    NOT NULL REFERENCES m_daybook (id),
    -- Optional link to a GRN if purchase was booked via goods receipt
    purchase_receipt_id   BIGINT REFERENCES purchase_receipts (id),

    purchase_date         DATE                   NOT NULL DEFAULT CURRENT_DATE,
    supplier_invoice_no   character varying(100),
    supplier_invoice_date DATE,
    due_date              DATE,

    -- Money
    currency_id           INT                    NOT NULL REFERENCES m_currency (id),
    subtotal_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    discount_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    tax_amount            NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    shipping_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    other_charges         NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    rounding_amount       NUMERIC(8, 2)          NOT NULL DEFAULT 0,
    total_amount          NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    amount_paid           NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    amount_due            NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    -- Lifecycle
    purchase_status       character varying(20)  NOT NULL DEFAULT 'DRAFT'
        CHECK (purchase_status IN ('DRAFT', 'POSTED', 'CANCELLED')),
    payment_status_id     INT                    NOT NULL REFERENCES m_payment_status (id),
    posted_at             TIMESTAMPTZ,
    posted_by             BIGINT,

    -- Accounting voucher raised when posted
    voucher_id            BIGINT,   -- references accounting.ac_voucher (id)

    notes                 TEXT,
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1,

    CHECK (amount_paid >= 0 AND amount_due >= 0),
    CHECK (amount_due = total_amount - amount_paid),
    UNIQUE (tenant_id, purchase_number)
);
CREATE INDEX idx_purchase_branch_date ON purchase_main (branch_id, purchase_date DESC);
CREATE INDEX idx_purchase_supplier ON purchase_main (supplier_id);
CREATE INDEX idx_purchase_grn ON purchase_main (purchase_receipt_id) WHERE purchase_receipt_id IS NOT NULL;
CREATE INDEX idx_purchase_unpaid ON purchase_main (branch_id, payment_status_id) WHERE status = 'A' AND amount_due > 0;

-- ---------------------------------------------------------
-- purchase_line
-- ---------------------------------------------------------
CREATE TABLE purchase_line
(
    id                   BIGSERIAL PRIMARY KEY,
    internal_code        character varying(50)  NOT NULL UNIQUE,
    tenant_id            BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id          BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id            BIGINT                 NOT NULL REFERENCES branches (id),
    purchase_id          BIGINT                 NOT NULL REFERENCES purchase_main (id) ON DELETE CASCADE,
    line_seq             INT                    NOT NULL,

    product_id           BIGINT                 NOT NULL REFERENCES product_master (id),
    product_variant_id   BIGINT REFERENCES product_variants (id),
    uom_id               INT                    NOT NULL REFERENCES m_uom (id),
    hsn_code             character varying(30),

    name_snapshot        character varying(200) NOT NULL,
    description_snapshot TEXT,

    quantity             NUMERIC(14, 3)         NOT NULL CHECK (quantity > 0),
    unit_cost            NUMERIC(12, 4)         NOT NULL,
    gross_amount         NUMERIC(14, 2)         NOT NULL,

    -- Line-level discount
    discount_percent     NUMERIC(6, 3)          NOT NULL DEFAULT 0,
    discount_amount      NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    taxable_amount       NUMERIC(14, 2)         NOT NULL,
    tax_amount           NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    line_total           NUMERIC(14, 2)         NOT NULL,

    -- Batch / expiry (for the item_trans row we post)
    batch_number         character varying(80),
    manufacture_date     DATE,
    expiry_date          DATE,

    -- Link to the GRN line that actually brought stock in
    purchase_receipt_line_id BIGINT REFERENCES purchase_receipt_lines (id),
    -- Link to the item_trans row created on posting (qty_rec, daybook=PURCHASE)
    item_trans_id        BIGINT REFERENCES item_trans (id),

    notes                TEXT,
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1,
    UNIQUE (purchase_id, line_seq)
);
CREATE INDEX idx_purchase_line_purchase ON purchase_line (purchase_id, line_seq);
CREATE INDEX idx_purchase_line_product ON purchase_line (product_id);

-- ---------------------------------------------------------
-- purchase_line_tax (per-tax breakdown for each line)
-- ---------------------------------------------------------
CREATE TABLE purchase_line_tax
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT                 NOT NULL REFERENCES tenants (id),
    purchase_id    BIGINT                 NOT NULL REFERENCES purchase_main (id) ON DELETE CASCADE,
    purchase_line_id BIGINT               NOT NULL REFERENCES purchase_line (id) ON DELETE CASCADE,
    tax_type_id    INT                    NOT NULL REFERENCES m_tax_type (id),
    tax_rate_id    BIGINT REFERENCES tax_rates (id),
    tax_name       character varying(100) NOT NULL,
    rate_percent   NUMERIC(6, 3)          NOT NULL,
    is_inclusive   BOOLEAN                NOT NULL DEFAULT FALSE,
    taxable_amount NUMERIC(14, 2)         NOT NULL,
    tax_amount     NUMERIC(14, 2)         NOT NULL,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_pln_tax_line ON purchase_line_tax (purchase_line_id);

-- ---------------------------------------------------------
-- purchase_payment  (payment made to supplier)
-- Generates a PAYMENT daybook voucher.
-- ---------------------------------------------------------
CREATE TABLE purchase_payment
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_code       character varying(50)  NOT NULL UNIQUE,
    payment_number      character varying(50)  NOT NULL,
    tenant_id           BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id         BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id           BIGINT                 NOT NULL REFERENCES branches (id),

    supplier_id         BIGINT                 NOT NULL REFERENCES suppliers (id),
    -- Payment may settle one or more purchases (see purchase_payment_allocations)
    payment_date        DATE                   NOT NULL DEFAULT CURRENT_DATE,

    currency_id         INT                    NOT NULL REFERENCES m_currency (id),
    amount              NUMERIC(14, 2)         NOT NULL CHECK (amount > 0),

    payment_method_id   INT                    NOT NULL REFERENCES m_payment_method (id),
    -- Cash/bank ledger the money went out of
    paid_from_account_id BIGINT                NOT NULL REFERENCES account_master (id),

    reference_number    character varying(200),
    cheque_number       character varying(50),
    cheque_date         DATE,
    bank_name           character varying(150),

    voucher_id          BIGINT,   -- references accounting.ac_voucher (id)

    payment_status      character varying(20)  NOT NULL DEFAULT 'POSTED'
        CHECK (payment_status IN ('DRAFT', 'POSTED', 'BOUNCED', 'VOIDED')),
    notes               TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, payment_number)
);
CREATE INDEX idx_ppay_supplier ON purchase_payment (supplier_id, payment_date DESC);
CREATE INDEX idx_ppay_branch_date ON purchase_payment (branch_id, payment_date DESC);

-- ---------------------------------------------------------
-- purchase_payment_allocations (money against specific bills)
-- ---------------------------------------------------------
CREATE TABLE purchase_payment_allocations
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES tenants (id),
    purchase_payment_id BIGINT                 NOT NULL REFERENCES purchase_payment (id) ON DELETE CASCADE,
    purchase_id         BIGINT                 NOT NULL REFERENCES purchase_main (id),
    allocated_amount    NUMERIC(14, 2)         NOT NULL CHECK (allocated_amount > 0),
    allocated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,
    UNIQUE (purchase_payment_id, purchase_id)
);
CREATE INDEX idx_ppalloc_purchase ON purchase_payment_allocations (purchase_id);

-- =========================================================
-- STOCK TRANSFER  (same-tenant only)
-- Flow:
--   1. DRAFT            : user creates header + lines
--   2. ISSUED           : branch1 posts item_trans (qty_iss, STK_TRF_OUT)
--                         AND posts item_trans (qty_rec, in_transit=TRUE,
--                         destination_branch_id=branch2, STK_TRF_IN_TRANSIT)
--                         visible to branch2 as "in-transit" stock
--   3. RECEIVED         : branch2 posts item_trans (qty_rec, STK_TRF_IN)
--                         and a reversing item_trans (qty_iss, in_transit=TRUE,
--                         reverses_trans_id=<in-transit row>) to consume it
-- No accounting entries are generated (your requirement).
-- =========================================================

CREATE TABLE stock_transfer_main
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_code         character varying(50)  NOT NULL UNIQUE,
    transfer_number       character varying(50)  NOT NULL,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id           BIGINT                 NOT NULL REFERENCES businesses (id),

    source_branch_id      BIGINT                 NOT NULL REFERENCES branches (id),
    destination_branch_id BIGINT                 NOT NULL REFERENCES branches (id),

    transfer_date         DATE                   NOT NULL DEFAULT CURRENT_DATE,
    expected_arrival_date DATE,

    -- Lifecycle
    transfer_status       character varying(20)  NOT NULL DEFAULT 'DRAFT'
        CHECK (transfer_status IN ('DRAFT', 'ISSUED', 'IN_TRANSIT', 'PARTIALLY_RECEIVED', 'RECEIVED', 'CANCELLED')),
    issued_at             TIMESTAMPTZ,
    issued_by             BIGINT,
    received_at           TIMESTAMPTZ,
    received_by           BIGINT,

    -- Value of the transfer (at issuing-branch cost)
    currency_id           INT REFERENCES m_currency (id),
    total_value           NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    reason                character varying(255),
    notes                 TEXT,

    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1,

    -- Can't transfer to the same branch
    CHECK (source_branch_id <> destination_branch_id),
    UNIQUE (tenant_id, transfer_number)
);
CREATE INDEX idx_stk_trf_source ON stock_transfer_main (source_branch_id, transfer_date DESC);
CREATE INDEX idx_stk_trf_dest ON stock_transfer_main (destination_branch_id, transfer_date DESC);
CREATE INDEX idx_stk_trf_status ON stock_transfer_main (transfer_status) WHERE status = 'A';

-- Same-tenant guard (trigger; CHECK can't do cross-row validation)
CREATE OR REPLACE FUNCTION core.trg_stock_transfer_same_tenant()
    RETURNS TRIGGER AS $$
DECLARE
    v_src_tenant BIGINT;
    v_dst_tenant BIGINT;
    v_src_business BIGINT;
    v_dst_business BIGINT;
BEGIN
    SELECT tenant_id, business_id INTO v_src_tenant, v_src_business
      FROM branches WHERE id = NEW.source_branch_id;
    SELECT tenant_id, business_id INTO v_dst_tenant, v_dst_business
      FROM branches WHERE id = NEW.destination_branch_id;
    IF v_src_tenant IS NULL OR v_dst_tenant IS NULL THEN
        RAISE EXCEPTION 'Invalid source or destination branch';
    END IF;
    IF v_src_tenant <> NEW.tenant_id OR v_dst_tenant <> NEW.tenant_id THEN
        RAISE EXCEPTION 'Stock transfer must be within the same tenant (source tenant %, destination tenant %, header tenant %)',
            v_src_tenant, v_dst_tenant, NEW.tenant_id
            USING ERRCODE = 'check_violation';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stock_transfer_same_tenant
    BEFORE INSERT OR UPDATE OF source_branch_id, destination_branch_id, tenant_id
    ON stock_transfer_main
    FOR EACH ROW EXECUTE FUNCTION core.trg_stock_transfer_same_tenant();

-- ---------------------------------------------------------
-- stock_transfer_line
-- ---------------------------------------------------------
CREATE TABLE stock_transfer_line
(
    id                      BIGSERIAL PRIMARY KEY,
    internal_code           character varying(50)  NOT NULL UNIQUE,
    tenant_id               BIGINT                 NOT NULL REFERENCES tenants (id),
    transfer_id             BIGINT                 NOT NULL REFERENCES stock_transfer_main (id) ON DELETE CASCADE,
    line_seq                INT                    NOT NULL,

    product_id              BIGINT                 NOT NULL REFERENCES product_master (id),
    product_variant_id      BIGINT REFERENCES product_variants (id),
    uom_id                  INT                    NOT NULL REFERENCES m_uom (id),

    name_snapshot           character varying(200) NOT NULL,
    quantity_issued         NUMERIC(14, 3)         NOT NULL CHECK (quantity_issued > 0),
    quantity_received       NUMERIC(14, 3)         NOT NULL DEFAULT 0 CHECK (quantity_received >= 0),
    quantity_in_transit     NUMERIC(14, 3)         NOT NULL DEFAULT 0,
    -- At-cost valuation at time of issue
    unit_cost               NUMERIC(12, 4),
    line_value              NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    batch_number            character varying(80),
    expiry_date             DATE,

    -- Pointers to the three item_trans rows generated
    issue_trans_id          BIGINT REFERENCES item_trans (id),   -- branch1 qty_iss
    in_transit_trans_id     BIGINT REFERENCES item_trans (id),   -- branch2 qty_rec in_transit=TRUE
    receive_trans_id        BIGINT REFERENCES item_trans (id),   -- branch2 qty_rec final

    line_status             character varying(20)  NOT NULL DEFAULT 'DRAFT'
        CHECK (line_status IN ('DRAFT', 'ISSUED', 'IN_TRANSIT', 'PARTIALLY_RECEIVED', 'RECEIVED')),

    notes                   TEXT,
    status                  character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by              BIGINT,
    updated_by              BIGINT,
    version                 INT                    NOT NULL DEFAULT 1,

    CHECK (quantity_received <= quantity_issued),
    CHECK (quantity_in_transit = quantity_issued - quantity_received),
    UNIQUE (transfer_id, line_seq)
);
CREATE INDEX idx_stk_trf_line_transfer ON stock_transfer_line (transfer_id, line_seq);
CREATE INDEX idx_stk_trf_line_product ON stock_transfer_line (product_id);
