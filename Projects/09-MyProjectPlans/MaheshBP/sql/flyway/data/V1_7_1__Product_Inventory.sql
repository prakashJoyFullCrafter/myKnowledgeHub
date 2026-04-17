-- =========================================================
-- Product Inventory
-- Branch-level stock, immutable item transaction ledger,
-- adjustments, GRN.
--
-- item_trans is the single source of truth for all inventory
-- movements. It is append-only: UPDATE and DELETE are blocked
-- at the database level via trigger. Stock corrections are
-- done by posting a new reversing transaction, not by editing.
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- Current stock snapshot (one row per branch × product × variant)
-- Updated by application logic when posting an item_trans row.
-- (item_trans itself is immutable; this snapshot is derived.)
-- ---------------------------------------------------------
CREATE TABLE branch_product_stock
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id        BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id          BIGINT                 NOT NULL REFERENCES branches (id),
    product_id         BIGINT                 NOT NULL REFERENCES product_master (id),
    product_variant_id BIGINT REFERENCES product_variants (id),
    uom_id             INT                    NOT NULL REFERENCES m_uom (id),
    quantity_on_hand   NUMERIC(14, 3)         NOT NULL DEFAULT 0,
    quantity_reserved  NUMERIC(14, 3)         NOT NULL DEFAULT 0,
    -- Weighted average cost (for COGS)
    avg_cost_price     NUMERIC(12, 4),
    last_cost_price    NUMERIC(12, 4),
    last_trans_at      TIMESTAMPTZ,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1,
    CHECK (quantity_on_hand >= 0 OR status = 'I'),
    CHECK (quantity_reserved >= 0),
    UNIQUE (branch_id, product_id, product_variant_id)
);
CREATE INDEX idx_bps_branch_product ON branch_product_stock (branch_id, product_id);
CREATE INDEX idx_bps_low_stock ON branch_product_stock (branch_id, product_id)
    WHERE status = 'A' AND quantity_on_hand <= 0;

-- ---------------------------------------------------------
-- item_trans  --  IMMUTABLE item transaction ledger
--
-- Every inventory change (purchase, sale, adjustment, transfer,
-- wastage, return) produces exactly one row here. Rows are
-- never updated or deleted. To correct a mistake, post a
-- reversing transaction referencing the original via
-- reverses_trans_id.
-- ---------------------------------------------------------
CREATE TABLE item_trans
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_code      character varying(50)  NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id        BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id          BIGINT                 NOT NULL REFERENCES branches (id),

    -- Item being moved (products only)
    product_id         BIGINT                 NOT NULL REFERENCES product_master (id),
    product_variant_id BIGINT REFERENCES product_variants (id),

    -- What kind of movement
    movement_type_id   INT                    NOT NULL REFERENCES m_stock_movement_type (id),
    -- Daybook classifies the voucher (SALE, PURCHASE, STK_TRF_OUT, STK_TRF_IN, etc.)
    daybook_id         INT                    NOT NULL REFERENCES m_daybook (id),
    uom_id             INT                    NOT NULL REFERENCES m_uom (id),

    -- Received (IN) and Issued (OUT) quantities.
    -- Exactly one of these is > 0 on any given row; the other is 0.
    -- The movement_type.direction determines which column is used.
    qty_rec            NUMERIC(14, 3)         NOT NULL DEFAULT 0,
    qty_iss            NUMERIC(14, 3)         NOT NULL DEFAULT 0,
    unit_cost          NUMERIC(12, 4),
    total_cost         NUMERIC(14, 2),

    -- Running balance after this transaction (snapshot for audit)
    balance_after      NUMERIC(14, 3)         NOT NULL,

    -- In-transit flag: used for stock transfer pipeline.
    -- Branch 1 issues (qty_iss, in_transit=FALSE) and simultaneously posts
    --   a IN_TRANSIT row (qty_rec, in_transit=TRUE) for destination_branch_id.
    -- Branch 2 receives (qty_rec, in_transit=FALSE) and consumes the
    --   in-transit row via reverses_trans_id (qty_iss, in_transit=TRUE).
    in_transit         BOOLEAN                NOT NULL DEFAULT FALSE,
    source_branch_id      BIGINT REFERENCES branches (id),
    destination_branch_id BIGINT REFERENCES branches (id),

    -- Polymorphic source linkage
    reference_type     character varying(30),   -- e.g. 'ORDER_LINE', 'PURCHASE_RECEIPT_LINE', 'ADJUSTMENT', 'REFUND_LINE', 'TRANSFER_LINE', 'BILL_RETURN_LINE'
    reference_id       BIGINT,

    -- Reversal linkage: if this row corrects/cancels a previous one
    reverses_trans_id  BIGINT REFERENCES item_trans (id),

    -- Batch / expiry tracked at the movement level (important for traceability)
    batch_number       character varying(80),
    expiry_date        DATE,

    trans_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    notes              TEXT,

    -- Audit (created_by only; no updated_by/updated_at because rows are immutable)
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,

    -- Quantities are always non-negative
    CHECK (qty_rec >= 0 AND qty_iss >= 0),
    -- Exactly one side has a quantity (XOR): either a receipt or an issue, not both, not neither
    CHECK ((qty_rec > 0 AND qty_iss = 0) OR (qty_rec = 0 AND qty_iss > 0))
);
CREATE INDEX idx_item_trans_branch_product ON item_trans (branch_id, product_id, trans_at DESC);
CREATE INDEX idx_item_trans_product_variant ON item_trans (product_variant_id, trans_at DESC)
    WHERE product_variant_id IS NOT NULL;
CREATE INDEX idx_item_trans_reference ON item_trans (reference_type, reference_id)
    WHERE reference_id IS NOT NULL;
CREATE INDEX idx_item_trans_type ON item_trans (movement_type_id, trans_at DESC);
CREATE INDEX idx_item_trans_reverses ON item_trans (reverses_trans_id) WHERE reverses_trans_id IS NOT NULL;
CREATE INDEX idx_item_trans_batch_expiry ON item_trans (product_id, batch_number, expiry_date)
    WHERE batch_number IS NOT NULL;
CREATE INDEX idx_item_trans_in_transit ON item_trans (destination_branch_id, product_id)
    WHERE in_transit = TRUE;
CREATE INDEX idx_item_trans_daybook ON item_trans (daybook_id, trans_at DESC);

-- ---------------------------------------------------------
-- Immutability enforcement
-- Any UPDATE, DELETE or TRUNCATE on item_trans raises an exception.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.trg_item_trans_block_modify()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        RAISE EXCEPTION 'item_trans is append-only: UPDATE is not permitted (id=%). Post a reversing transaction instead.', OLD.id
            USING ERRCODE = 'restrict_violation';
    ELSIF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'item_trans is append-only: DELETE is not permitted (id=%). Post a reversing transaction instead.', OLD.id
            USING ERRCODE = 'restrict_violation';
    ELSIF TG_OP = 'TRUNCATE' THEN
        RAISE EXCEPTION 'item_trans is append-only: TRUNCATE is not permitted.'
            USING ERRCODE = 'restrict_violation';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_item_trans_no_update
    BEFORE UPDATE ON item_trans
    FOR EACH ROW EXECUTE FUNCTION core.trg_item_trans_block_modify();

CREATE TRIGGER trg_item_trans_no_delete
    BEFORE DELETE ON item_trans
    FOR EACH ROW EXECUTE FUNCTION core.trg_item_trans_block_modify();

-- TRUNCATE bypasses row-level triggers, so guard it at statement level.
CREATE TRIGGER trg_item_trans_no_truncate
    BEFORE TRUNCATE ON item_trans
    FOR EACH STATEMENT EXECUTE FUNCTION core.trg_item_trans_block_modify();

-- ---------------------------------------------------------
-- Manual stock adjustments (header for grouped adjustments)
-- Each adjustment line posts one row to item_trans when posted.
-- ---------------------------------------------------------
CREATE TABLE stock_adjustments
(
    id              BIGSERIAL PRIMARY KEY,
    internal_code   character varying(50)  NOT NULL UNIQUE,
    tenant_id       BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id     BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id       BIGINT                 NOT NULL REFERENCES branches (id),
    adjustment_date DATE                   NOT NULL DEFAULT CURRENT_DATE,
    reason          character varying(255) NOT NULL,
    notes           TEXT,
    posted_at       TIMESTAMPTZ,
    posted_by       BIGINT,
    status          character varying(20)  NOT NULL DEFAULT 'DRAFT'
        CHECK (status IN ('DRAFT', 'POSTED', 'VOIDED')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE stock_adjustment_lines
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES tenants (id),
    adjustment_id      BIGINT                 NOT NULL REFERENCES stock_adjustments (id) ON DELETE CASCADE,
    product_id         BIGINT                 NOT NULL REFERENCES product_master (id),
    product_variant_id BIGINT REFERENCES product_variants (id),
    uom_id             INT                    NOT NULL REFERENCES m_uom (id),
    quantity_before    NUMERIC(14, 3)         NOT NULL,
    quantity_after     NUMERIC(14, 3)         NOT NULL,
    -- Computed: quantity_after - quantity_before
    quantity_delta     NUMERIC(14, 3)         NOT NULL,
    unit_cost          NUMERIC(12, 4),
    item_trans_id      BIGINT REFERENCES item_trans (id),
    notes              TEXT,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1,
    CHECK (quantity_delta = quantity_after - quantity_before)
);
CREATE INDEX idx_stock_adj_lines_adjustment ON stock_adjustment_lines (adjustment_id);

-- ---------------------------------------------------------
-- Goods Received Note (purchase receipt from supplier)
-- Each receipt line posts one row to item_trans (IN) when posted.
-- ---------------------------------------------------------
CREATE TABLE purchase_receipts
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_code      character varying(50)  NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id        BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id          BIGINT                 NOT NULL REFERENCES branches (id),
    supplier_id        BIGINT                 NOT NULL REFERENCES suppliers (id),
    receipt_date       DATE                   NOT NULL DEFAULT CURRENT_DATE,
    supplier_invoice_no character varying(100),
    supplier_invoice_date DATE,
    currency_id        INT                    NOT NULL REFERENCES m_currency (id),
    subtotal_amount    NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    tax_amount         NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    discount_amount    NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    shipping_amount    NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    total_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    notes              TEXT,
    posted_at          TIMESTAMPTZ,
    posted_by          BIGINT,
    status             character varying(20)  NOT NULL DEFAULT 'DRAFT'
        CHECK (status IN ('DRAFT', 'POSTED', 'VOIDED')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_pr_branch_date ON purchase_receipts (branch_id, receipt_date DESC);
CREATE INDEX idx_pr_supplier ON purchase_receipts (supplier_id);

CREATE TABLE purchase_receipt_lines
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES tenants (id),
    purchase_receipt_id BIGINT                 NOT NULL REFERENCES purchase_receipts (id) ON DELETE CASCADE,
    product_id          BIGINT                 NOT NULL REFERENCES product_master (id),
    product_variant_id  BIGINT REFERENCES product_variants (id),
    uom_id              INT                    NOT NULL REFERENCES m_uom (id),
    quantity            NUMERIC(14, 3)         NOT NULL CHECK (quantity > 0),
    unit_cost           NUMERIC(12, 4)         NOT NULL,
    tax_percent         NUMERIC(6, 3)          NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    discount_percent    NUMERIC(6, 3)          NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    line_total          NUMERIC(14, 2)         NOT NULL,
    -- Batch / expiry tracking (optional)
    batch_number        character varying(80),
    manufacture_date    DATE,
    expiry_date         DATE,
    item_trans_id       BIGINT REFERENCES item_trans (id),
    notes               TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_pr_lines_receipt ON purchase_receipt_lines (purchase_receipt_id);
CREATE INDEX idx_pr_lines_product ON purchase_receipt_lines (product_id);
CREATE INDEX idx_pr_lines_expiry ON purchase_receipt_lines (expiry_date)
    WHERE expiry_date IS NOT NULL AND status = 'A';
