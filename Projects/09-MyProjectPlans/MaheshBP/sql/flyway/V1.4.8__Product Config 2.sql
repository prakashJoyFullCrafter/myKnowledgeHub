/*set
search_path to core;

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
    last_movement_at   TIMESTAMPTZ,
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

CREATE TABLE stock_movements
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_code      character varying(50)  NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id        BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id          BIGINT                 NOT NULL REFERENCES branches (id),
    product_id         BIGINT                 NOT NULL REFERENCES product_master (id),
    product_variant_id BIGINT REFERENCES product_variants (id),
    movement_type_id   INT                    NOT NULL REFERENCES m_stock_movement_type (id),
    uom_id             INT                    NOT NULL REFERENCES m_uom (id),
    -- Signed quantity (+ = IN, - = OUT). Caller applies sign based on movement_type.direction.
    quantity           NUMERIC(14, 3)         NOT NULL,
    unit_cost          NUMERIC(12, 4),
    total_cost         NUMERIC(14, 2),
    -- Running balance after this movement (denormalized for audit)
    balance_after      NUMERIC(14, 3)         NOT NULL,
    -- Source / reference polymorphic linkage
    reference_type     character varying(30),   -- e.g. 'ORDER_LINE', 'PURCHASE_RECEIPT_LINE', 'ADJUSTMENT', 'TRANSFER'
    reference_id       BIGINT,
    movement_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    notes              TEXT,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1,
    CHECK (quantity <> 0)
);
CREATE INDEX idx_stock_mvt_branch_product ON stock_movements (branch_id, product_id, movement_at DESC);
CREATE INDEX idx_stock_mvt_reference ON stock_movements (reference_type, reference_id) WHERE reference_id IS NOT NULL;
CREATE INDEX idx_stock_mvt_type ON stock_movements (movement_type_id, movement_at DESC);

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
    stock_movement_id  BIGINT REFERENCES stock_movements (id),
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
    stock_movement_id   BIGINT REFERENCES stock_movements (id),
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
    WHERE expiry_date IS NOT NULL AND status = 'A';*/