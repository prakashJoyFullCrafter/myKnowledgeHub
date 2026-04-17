-- =========================================================
-- Payments, Deposits, Refunds
-- payment_main   : one payment transaction against an invoice
-- payment_tender : multi-tender breakdown (cash + card, etc.)
-- deposits       : advance / pre-service holds against an order
-- refunds        : full or partial refund against a payment/invoice
-- refund_tender  : how the refund was issued (back to card, cash, credit note)
-- =========================================================
CREATE SCHEMA IF NOT EXISTS billing;
SET
search_path TO billing;

-- ---------------------------------------------------------
-- deposits
-- Advance / pre-service payments held against an order (or booking).
-- Applied to the invoice when billed.
-- ---------------------------------------------------------
CREATE TABLE deposits
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_code       character varying(50)  NOT NULL UNIQUE,
    deposit_number      character varying(50)  NOT NULL,
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id         BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id           BIGINT                 NOT NULL REFERENCES core.branches (id),

    -- What the deposit is held against (at least one required)
    order_id            BIGINT REFERENCES sales.order_main (id),
    booking_id          BIGINT REFERENCES booking.booking_main (id),
    visit_id            BIGINT REFERENCES visit.visits (id),

    customer_account_id BIGINT REFERENCES security.customer_accounts (id),
    bill_to_name        character varying(200),
    bill_to_phone       character varying(30),

    currency_id         INT                    NOT NULL REFERENCES core.m_currency (id),
    amount              NUMERIC(14, 2)         NOT NULL CHECK (amount > 0),
    amount_applied      NUMERIC(14, 2)         NOT NULL DEFAULT 0,   -- applied to invoice(s)
    amount_refunded     NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    amount_available    NUMERIC(14, 2)         NOT NULL,             -- amount - amount_applied - amount_refunded

    payment_method_id   INT                    NOT NULL REFERENCES core.m_payment_method (id),
    received_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),

    deposit_status      character varying(20)  NOT NULL DEFAULT 'HELD'
        CHECK (deposit_status IN ('HELD', 'APPLIED', 'PARTIALLY_APPLIED', 'REFUNDED', 'FORFEITED', 'VOIDED')),

    -- Gateway / external reference if paid online
    external_reference  character varying(200),

    notes               TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,

    CHECK (order_id IS NOT NULL OR booking_id IS NOT NULL OR visit_id IS NOT NULL),
    CHECK (amount_applied >= 0 AND amount_refunded >= 0),
    CHECK (amount_available = amount - amount_applied - amount_refunded),
    CHECK (amount_applied + amount_refunded <= amount),
    UNIQUE (tenant_id, deposit_number)
);
CREATE INDEX idx_deposits_order ON deposits (order_id) WHERE order_id IS NOT NULL;
CREATE INDEX idx_deposits_booking ON deposits (booking_id) WHERE booking_id IS NOT NULL;
CREATE INDEX idx_deposits_customer ON deposits (customer_account_id) WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_deposits_held ON deposits (branch_id, deposit_status) WHERE status = 'A';

-- ---------------------------------------------------------
-- deposit_applications
-- Ledger of how deposits are applied to invoices.
-- ---------------------------------------------------------
CREATE TABLE deposit_applications
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    tenant_id       BIGINT                 NOT NULL REFERENCES core.tenants (id),
    deposit_id      BIGINT                 NOT NULL REFERENCES deposits (id) ON DELETE CASCADE,
    invoice_id      BIGINT                 NOT NULL REFERENCES invoice_main (id),
    applied_amount  NUMERIC(14, 2)         NOT NULL CHECK (applied_amount > 0),
    applied_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    notes           TEXT,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_dep_app_deposit ON deposit_applications (deposit_id);
CREATE INDEX idx_dep_app_invoice ON deposit_applications (invoice_id);

-- ---------------------------------------------------------
-- payment_main
-- One settlement event against an invoice.
-- A single payment can use multiple tenders (see payment_tender).
-- ---------------------------------------------------------
CREATE TABLE payment_main
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_code       character varying(50)  NOT NULL UNIQUE,
    payment_number      character varying(50)  NOT NULL,
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id         BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id           BIGINT                 NOT NULL REFERENCES core.branches (id),

    invoice_id          BIGINT                 NOT NULL REFERENCES invoice_main (id),
    order_id            BIGINT                 NOT NULL REFERENCES sales.order_main (id),
    customer_account_id BIGINT REFERENCES security.customer_accounts (id),

    currency_id         INT                    NOT NULL REFERENCES core.m_currency (id),
    amount              NUMERIC(14, 2)         NOT NULL CHECK (amount > 0),
    tip_amount          NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    tendered_amount     NUMERIC(14, 2)         NOT NULL,    -- total cash/card/etc collected
    change_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    -- Primary method is for reporting when there's only one tender;
    -- multi-tender details live in payment_tender.
    payment_method_id   INT                    NOT NULL REFERENCES core.m_payment_method (id),
    payment_status_id   INT                    NOT NULL REFERENCES core.m_payment_status (id),

    received_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    received_by_staff_id BIGINT REFERENCES security.tenant_staff_users (id),

    -- Gateway metadata (when payment goes through an online processor)
    gateway_name        character varying(50),
    gateway_txn_id      character varying(200),
    gateway_auth_code   character varying(100),
    gateway_response    JSONB,

    notes               TEXT,
    voided_at           TIMESTAMPTZ,
    void_reason         character varying(255),

    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,

    CHECK (tendered_amount >= amount),
    CHECK (change_amount = tendered_amount - amount - tip_amount OR change_amount = 0),
    UNIQUE (tenant_id, payment_number)
);
CREATE INDEX idx_payment_invoice ON payment_main (invoice_id);
CREATE INDEX idx_payment_order ON payment_main (order_id);
CREATE INDEX idx_payment_branch_date ON payment_main (branch_id, received_at DESC);
CREATE INDEX idx_payment_customer ON payment_main (customer_account_id) WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_payment_gateway_txn ON payment_main (gateway_txn_id) WHERE gateway_txn_id IS NOT NULL;

-- ---------------------------------------------------------
-- payment_tender
-- Line-per-tender for a payment. Sum of amount should equal
-- payment_main.tendered_amount (including tip).
-- ---------------------------------------------------------
CREATE TABLE payment_tender
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    payment_id          BIGINT                 NOT NULL REFERENCES payment_main (id) ON DELETE CASCADE,
    tender_seq          INT                    NOT NULL,
    tender_type_id      INT                    NOT NULL REFERENCES core.m_tender_type (id),
    payment_method_id   INT                    NOT NULL REFERENCES core.m_payment_method (id),
    amount              NUMERIC(14, 2)         NOT NULL CHECK (amount > 0),
    -- Card / cheque / UPI reference
    reference_number    character varying(200),
    card_last4          character varying(8),
    card_brand          character varying(30),
    auth_code           character varying(100),
    -- Gateway bits per-tender
    gateway_txn_id      character varying(200),
    gateway_response    JSONB,
    notes               TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,
    UNIQUE (payment_id, tender_seq)
);
CREATE INDEX idx_pay_tender_payment ON payment_tender (payment_id);
CREATE INDEX idx_pay_tender_type ON payment_tender (tender_type_id);

-- ---------------------------------------------------------
-- refunds
-- A refund issued against a payment (and thus an invoice).
-- Can be partial; multiple refunds may exist per payment.
-- ---------------------------------------------------------
CREATE TABLE refunds
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_code       character varying(50)  NOT NULL UNIQUE,
    refund_number       character varying(50)  NOT NULL,
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id         BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id           BIGINT                 NOT NULL REFERENCES core.branches (id),

    invoice_id          BIGINT                 NOT NULL REFERENCES invoice_main (id),
    order_id            BIGINT                 NOT NULL REFERENCES sales.order_main (id),
    payment_id          BIGINT REFERENCES payment_main (id),     -- original payment (null for deposit-only refund)
    deposit_id          BIGINT REFERENCES deposits (id),          -- when refunding a held deposit
    customer_account_id BIGINT REFERENCES security.customer_accounts (id),

    refund_reason_id    INT                    NOT NULL REFERENCES core.m_refund_reason (id),
    reason_notes        TEXT,

    currency_id         INT                    NOT NULL REFERENCES core.m_currency (id),
    amount              NUMERIC(14, 2)         NOT NULL CHECK (amount > 0),

    refund_status       character varying(20)  NOT NULL DEFAULT 'PENDING'
        CHECK (refund_status IN ('PENDING', 'APPROVED', 'PROCESSED', 'FAILED', 'VOIDED')),
    approved_by         BIGINT,
    approved_at         TIMESTAMPTZ,
    processed_at        TIMESTAMPTZ,
    processed_by_staff_id BIGINT REFERENCES security.tenant_staff_users (id),

    gateway_name        character varying(50),
    gateway_refund_id   character varying(200),
    gateway_response    JSONB,

    notes               TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,

    CHECK (payment_id IS NOT NULL OR deposit_id IS NOT NULL),
    UNIQUE (tenant_id, refund_number)
);
CREATE INDEX idx_refund_invoice ON refunds (invoice_id);
CREATE INDEX idx_refund_payment ON refunds (payment_id) WHERE payment_id IS NOT NULL;
CREATE INDEX idx_refund_customer ON refunds (customer_account_id) WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_refund_branch_date ON refunds (branch_id, created_at DESC);
CREATE INDEX idx_refund_pending ON refunds (branch_id, refund_status) WHERE status = 'A' AND refund_status IN ('PENDING', 'APPROVED');

-- ---------------------------------------------------------
-- refund_tender
-- How each refund was returned to the customer (back to card,
-- cash, as a credit note, etc.). Supports multi-tender refunds.
-- ---------------------------------------------------------
CREATE TABLE refund_tender
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    refund_id           BIGINT                 NOT NULL REFERENCES refunds (id) ON DELETE CASCADE,
    tender_seq          INT                    NOT NULL,
    tender_type_id      INT                    NOT NULL REFERENCES core.m_tender_type (id),
    payment_method_id   INT                    NOT NULL REFERENCES core.m_payment_method (id),
    amount              NUMERIC(14, 2)         NOT NULL CHECK (amount > 0),
    reference_number    character varying(200),
    gateway_refund_id   character varying(200),
    gateway_response    JSONB,
    notes               TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,
    UNIQUE (refund_id, tender_seq)
);
CREATE INDEX idx_refund_tender_refund ON refund_tender (refund_id);

-- ---------------------------------------------------------
-- refund_lines
-- Which invoice_lines / quantities are being refunded.
-- Optional: for full-invoice refunds, no rows here are needed.
-- ---------------------------------------------------------
CREATE TABLE refund_lines
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES core.tenants (id),
    refund_id        BIGINT                 NOT NULL REFERENCES refunds (id) ON DELETE CASCADE,
    invoice_line_id  BIGINT                 NOT NULL REFERENCES invoice_line (id),
    quantity         NUMERIC(12, 3)         NOT NULL CHECK (quantity > 0),
    refund_amount    NUMERIC(14, 2)         NOT NULL CHECK (refund_amount > 0),
    -- For product refunds — put stock back?
    restock          BOOLEAN                NOT NULL DEFAULT FALSE,
    stock_movement_id BIGINT REFERENCES core.stock_movements (id),
    reason           character varying(255),
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_refund_lines_refund ON refund_lines (refund_id);
CREATE INDEX idx_refund_lines_invoice_line ON refund_lines (invoice_line_id);