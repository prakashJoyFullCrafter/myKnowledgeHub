-- =========================================================
-- Bill Return (Sale Return)
-- Reversal counterpart to invoice_main / invoice_line.
-- Generates item_trans rows (qty_rec, daybook=SALE_RETURN)
-- for products and a SALE_RETURN accounting voucher.
-- =========================================================
SET
search_path TO billing;

CREATE TABLE bill_return_main
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_code         character varying(50)  NOT NULL UNIQUE,
    return_number         character varying(50)  NOT NULL,
    tenant_id             BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id           BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id             BIGINT                 NOT NULL REFERENCES core.branches (id),

    -- Original invoice being (partially) returned
    original_invoice_id   BIGINT                 NOT NULL REFERENCES invoice_main (id),
    original_order_id     BIGINT                 NOT NULL REFERENCES sales.order_main (id),

    -- Daybook is always SALE_RETURN (pinned at app layer)
    daybook_id            INT                    NOT NULL REFERENCES core.m_daybook (id),

    return_date           DATE                   NOT NULL DEFAULT CURRENT_DATE,
    reason_id             INT REFERENCES core.m_refund_reason (id),
    reason_notes          TEXT,

    -- Who the return is credited to
    customer_account_id   BIGINT REFERENCES security.customer_accounts (id),
    bill_to_name          character varying(200),
    bill_to_phone         character varying(30),
    bill_to_email         character varying(150),
    bill_to_tax_reg_no    character varying(50),

    -- Money
    currency_id           INT                    NOT NULL REFERENCES core.m_currency (id),
    subtotal_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    discount_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    tax_amount            NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    rounding_amount       NUMERIC(8, 2)          NOT NULL DEFAULT 0,
    total_amount          NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    -- Settlement: how the customer was made whole
    settlement_type       character varying(20)  NOT NULL DEFAULT 'PENDING'
        CHECK (settlement_type IN ('PENDING', 'REFUND', 'CREDIT_NOTE', 'EXCHANGE', 'ADJUST_ON_NEXT_INVOICE')),
    refund_id             BIGINT REFERENCES refunds (id),               -- when settlement_type = REFUND
    credit_note_invoice_id BIGINT REFERENCES invoice_main (id),         -- when settlement_type = CREDIT_NOTE

    return_status         character varying(20)  NOT NULL DEFAULT 'DRAFT'
        CHECK (return_status IN ('DRAFT', 'POSTED', 'SETTLED', 'VOIDED')),
    posted_at             TIMESTAMPTZ,
    posted_by             BIGINT,

    -- Accounting voucher raised when posted
    voucher_id            BIGINT,   -- references accounting.ac_voucher (id)

    notes                 TEXT,
    internal_notes        TEXT,

    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1,

    UNIQUE (tenant_id, return_number)
);
CREATE INDEX idx_brm_invoice ON bill_return_main (original_invoice_id);
CREATE INDEX idx_brm_branch_date ON bill_return_main (branch_id, return_date DESC);
CREATE INDEX idx_brm_customer ON bill_return_main (customer_account_id) WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_brm_status ON bill_return_main (return_status) WHERE status = 'A';

-- ---------------------------------------------------------
-- bill_return_line
-- ---------------------------------------------------------
CREATE TABLE bill_return_line
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_code         character varying(50)  NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id           BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id             BIGINT                 NOT NULL REFERENCES core.branches (id),
    bill_return_id        BIGINT                 NOT NULL REFERENCES bill_return_main (id) ON DELETE CASCADE,
    line_seq              INT                    NOT NULL,

    -- Original line being returned
    original_invoice_line_id BIGINT              NOT NULL REFERENCES invoice_line (id),
    original_order_line_id   BIGINT              NOT NULL REFERENCES sales.order_line (id),

    line_type_id          INT                    NOT NULL REFERENCES core.m_order_line_type (id),
    product_id            BIGINT REFERENCES core.product_master (id),
    product_variant_id    BIGINT REFERENCES core.product_variants (id),
    service_id            BIGINT REFERENCES core.service_master (id),
    uom_id                INT REFERENCES core.m_uom (id),
    hsn_code              character varying(30),

    name_snapshot         character varying(200) NOT NULL,
    description_snapshot  TEXT,

    quantity              NUMERIC(14, 3)         NOT NULL CHECK (quantity > 0),
    unit_price            NUMERIC(12, 2)         NOT NULL,
    gross_amount          NUMERIC(14, 2)         NOT NULL,
    discount_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    taxable_amount        NUMERIC(14, 2)         NOT NULL,
    tax_amount            NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    line_total            NUMERIC(14, 2)         NOT NULL,

    -- Stock handling for product returns
    restock               BOOLEAN                NOT NULL DEFAULT FALSE,
    batch_number          character varying(80),
    expiry_date           DATE,
    -- Pointer to the item_trans row raised on post (qty_rec, daybook=SALE_RETURN)
    item_trans_id         BIGINT REFERENCES core.item_trans (id),

    notes                 TEXT,
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1,
    UNIQUE (bill_return_id, line_seq)
);
CREATE INDEX idx_brl_return ON bill_return_line (bill_return_id, line_seq);
CREATE INDEX idx_brl_original_inv_line ON bill_return_line (original_invoice_line_id);
CREATE INDEX idx_brl_product ON bill_return_line (product_id) WHERE product_id IS NOT NULL;

-- ---------------------------------------------------------
-- bill_return_line_tax (per-tax breakdown on the return)
-- ---------------------------------------------------------
CREATE TABLE bill_return_line_tax
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES core.tenants (id),
    bill_return_id     BIGINT                 NOT NULL REFERENCES bill_return_main (id) ON DELETE CASCADE,
    bill_return_line_id BIGINT                NOT NULL REFERENCES bill_return_line (id) ON DELETE CASCADE,
    tax_type_id        INT                    NOT NULL REFERENCES core.m_tax_type (id),
    tax_rate_id        BIGINT REFERENCES core.tax_rates (id),
    tax_name           character varying(100) NOT NULL,
    rate_percent       NUMERIC(6, 3)          NOT NULL,
    is_inclusive       BOOLEAN                NOT NULL DEFAULT FALSE,
    taxable_amount     NUMERIC(14, 2)         NOT NULL,
    tax_amount         NUMERIC(14, 2)         NOT NULL,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_brlt_line ON bill_return_line_tax (bill_return_line_id);
