-- =========================================================
-- Billing / Invoices
-- An order can produce one or more invoices:
--  - Single customer: 1 order -> 1 invoice
--  - Split bill: 1 order -> N invoices (one per payer), OR
--    1 visit -> multiple orders -> multiple invoices
-- invoice_splits tracks how an order's total is divided.
-- =========================================================
CREATE SCHEMA IF NOT EXISTS billing;
SET
search_path TO billing;

-- ---------------------------------------------------------
-- invoice_main
-- ---------------------------------------------------------
CREATE TABLE invoice_main
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_code         character varying(50)  NOT NULL UNIQUE,
    invoice_number        character varying(50)  NOT NULL,   -- regulatory/customer-visible
    tenant_id             BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id           BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id             BIGINT                 NOT NULL REFERENCES core.branches (id),

    -- Source order (required — invoices are always tied to an order)
    order_id              BIGINT                 NOT NULL REFERENCES sales.order_main (id),

    -- Bill-to party
    customer_account_id   BIGINT REFERENCES security.customer_accounts (id),
    bill_to_name          character varying(200) NOT NULL,
    bill_to_phone         character varying(30),
    bill_to_email         character varying(150),
    bill_to_address_line1 character varying(255),
    bill_to_address_line2 character varying(255),
    bill_to_city_id       INT REFERENCES core.m_city (id),
    bill_to_country_id    INT REFERENCES core.m_country (id),
    bill_to_tax_reg_no    character varying(50),

    -- Dates
    issue_date            DATE                   NOT NULL DEFAULT CURRENT_DATE,
    due_date              DATE,

    -- Money
    currency_id           INT                    NOT NULL REFERENCES core.m_currency (id),
    subtotal_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    discount_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    tax_amount            NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    surcharge_amount      NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    tip_amount            NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    rounding_amount       NUMERIC(8, 2)          NOT NULL DEFAULT 0,
    total_amount          NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    amount_paid           NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    amount_refunded       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    amount_due            NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    -- Lifecycle
    invoice_status_id     INT                    NOT NULL REFERENCES core.m_invoice_status (id),
    payment_status_id     INT                    NOT NULL REFERENCES core.m_payment_status (id),
    issued_at             TIMESTAMPTZ,
    paid_at               TIMESTAMPTZ,
    voided_at             TIMESTAMPTZ,
    void_reason           character varying(255),

    -- Split bill context
    is_split_bill         BOOLEAN                NOT NULL DEFAULT FALSE,
    split_share_percent   NUMERIC(5, 2),                   -- percentage of order this invoice covers (informational)

    -- Compliance / regulatory fields
    fiscal_year           character varying(10),
    place_of_supply       character varying(100),
    reverse_charge        BOOLEAN                NOT NULL DEFAULT FALSE,
    -- Cross-reference to a credit note if this invoice was later credited
    credit_note_for_id    BIGINT REFERENCES invoice_main (id),

    notes                 TEXT,
    internal_notes        TEXT,
    pdf_url               TEXT,

    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               BIGINT                 NOT NULL DEFAULT 1,

    CHECK (amount_paid >= 0 AND amount_refunded >= 0),
    CHECK (amount_due = total_amount - amount_paid + amount_refunded),
    UNIQUE (tenant_id, invoice_number)
);
CREATE INDEX idx_invoice_order ON invoice_main (order_id);
CREATE INDEX idx_invoice_branch_date ON invoice_main (branch_id, issue_date DESC);
CREATE INDEX idx_invoice_customer ON invoice_main (customer_account_id, issue_date DESC)
    WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_invoice_unpaid ON invoice_main (branch_id, payment_status_id)
    WHERE status = 'A' AND amount_due > 0;
CREATE INDEX idx_invoice_status ON invoice_main (invoice_status_id) WHERE status = 'A';

-- ---------------------------------------------------------
-- invoice_line
-- Mirrors order_line but frozen at invoice issue time.
-- An order_line can appear on multiple invoices (split bill)
-- with proportional quantities/amounts.
-- ---------------------------------------------------------
CREATE TABLE invoice_line
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_code         character varying(50)  NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES core.tenants (id),
    invoice_id            BIGINT                 NOT NULL REFERENCES invoice_main (id) ON DELETE CASCADE,
    order_line_id         BIGINT                 NOT NULL REFERENCES sales.order_line (id),
    line_seq              INT                    NOT NULL,

    line_type_id          INT                    NOT NULL REFERENCES core.m_order_line_type (id),
    name_snapshot         character varying(200) NOT NULL,
    description_snapshot  TEXT,
    hsn_code              character varying(30),
    uom_id                INT REFERENCES core.m_uom (id),

    quantity              NUMERIC(12, 3)         NOT NULL,
    unit_price            NUMERIC(12, 2)         NOT NULL,
    gross_amount          NUMERIC(14, 2)         NOT NULL,
    discount_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    taxable_amount        NUMERIC(14, 2)         NOT NULL,
    tax_amount            NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    line_total            NUMERIC(14, 2)         NOT NULL,

    -- Split ratio applied from the order_line (1.0 = full line on this invoice)
    split_ratio           NUMERIC(6, 4)          NOT NULL DEFAULT 1.0 CHECK (split_ratio > 0 AND split_ratio <= 1),

    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1,
    UNIQUE (invoice_id, line_seq)
);
CREATE INDEX idx_invoice_line_invoice ON invoice_line (invoice_id);
CREATE INDEX idx_invoice_line_order_line ON invoice_line (order_line_id);

-- ---------------------------------------------------------
-- invoice_tax_summary
-- Aggregated tax breakdown per invoice (printed on bill footer)
-- ---------------------------------------------------------
CREATE TABLE invoice_tax_summary
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT                 NOT NULL REFERENCES core.tenants (id),
    invoice_id     BIGINT                 NOT NULL REFERENCES invoice_main (id) ON DELETE CASCADE,
    tax_type_id    INT                    NOT NULL REFERENCES core.m_tax_type (id),
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
    version        INT                    NOT NULL DEFAULT 1,
    UNIQUE (invoice_id, tax_type_id, rate_percent, is_inclusive)
);

-- ---------------------------------------------------------
-- invoice_splits
-- How an order is divided into multiple invoices (split bill).
-- Each row points to an invoice and records the split basis.
-- ---------------------------------------------------------
CREATE TABLE invoice_splits
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    order_id            BIGINT                 NOT NULL REFERENCES sales.order_main (id) ON DELETE CASCADE,
    invoice_id          BIGINT                 NOT NULL REFERENCES invoice_main (id) ON DELETE CASCADE,

    -- Optional attendee this split is for (when split is by person)
    visit_attendee_id   BIGINT REFERENCES visit.visit_attendees (id),

    -- How the split is calculated
    split_method        character varying(20)  NOT NULL
        CHECK (split_method IN ('EQUAL', 'PERCENT', 'AMOUNT', 'BY_ITEMS')),
    split_share_percent NUMERIC(5, 2),          -- used when split_method = 'PERCENT' or 'EQUAL'
    split_amount        NUMERIC(14, 2)         NOT NULL,
    -- When split_method = 'BY_ITEMS', the specific order_lines mapping
    -- is captured via invoice_line.order_line_id + split_ratio.

    bill_to_name        character varying(200),
    bill_to_phone       character varying(30),
    bill_to_email       character varying(150),

    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,
    UNIQUE (invoice_id)
);
CREATE INDEX idx_invoice_splits_order ON invoice_splits (order_id);
CREATE INDEX idx_invoice_splits_attendee ON invoice_splits (visit_attendee_id)
    WHERE visit_attendee_id IS NOT NULL;