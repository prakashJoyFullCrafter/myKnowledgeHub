-- =========================================================
-- Accounting Transactions
-- Double-entry ledger.
--
-- ac_voucher (header) — one per business event
-- ac_transaction (lines) — one row per affected account,
--                          either dr_amount or cr_amount set.
-- Every voucher is balanced: Σ dr_amount = Σ cr_amount.
-- =========================================================
CREATE SCHEMA IF NOT EXISTS accounting;
SET
search_path TO accounting;

-- ---------------------------------------------------------
-- ac_voucher
-- One row per accounting event. Groups ac_transaction rows.
-- ---------------------------------------------------------
CREATE TABLE ac_voucher
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_code       character varying(50)  NOT NULL UNIQUE,
    voucher_number      character varying(50)  NOT NULL,       -- e.g. SL/2026/0001
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id         BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id           BIGINT                 NOT NULL REFERENCES core.branches (id),

    daybook_id          INT                    NOT NULL REFERENCES core.m_daybook (id),
    voucher_date        DATE                   NOT NULL DEFAULT CURRENT_DATE,
    voucher_time        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),

    -- Voucher totals (both must equal)
    currency_id         INT                    NOT NULL REFERENCES core.m_currency (id),
    total_debit         NUMERIC(16, 2)         NOT NULL DEFAULT 0,
    total_credit        NUMERIC(16, 2)         NOT NULL DEFAULT 0,

    -- Polymorphic source document linkage
    -- source_type ∈ 'SALE_INVOICE', 'PURCHASE', 'PAYMENT', 'REFUND', 'DEPOSIT',
    --               'SALE_RETURN', 'PURCHASE_RETURN', 'JOURNAL', …
    source_type         character varying(30),
    source_id           BIGINT,
    source_code         character varying(50),

    -- Narration / description shown on printed vouchers
    narration           TEXT,

    -- Lifecycle
    voucher_status      character varying(20)  NOT NULL DEFAULT 'POSTED'
        CHECK (voucher_status IN ('DRAFT', 'POSTED', 'VOIDED', 'REVERSED')),
    posted_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    posted_by           BIGINT,
    voided_at           TIMESTAMPTZ,
    voided_by           BIGINT,
    void_reason         character varying(255),
    -- If this voucher reverses another (for corrections)
    reverses_voucher_id BIGINT REFERENCES ac_voucher (id),

    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,

    CHECK (total_debit = total_credit),
    CHECK (total_debit >= 0),
    UNIQUE (tenant_id, voucher_number)
);
CREATE INDEX idx_ac_voucher_tenant_date ON ac_voucher (tenant_id, voucher_date DESC);
CREATE INDEX idx_ac_voucher_branch_date ON ac_voucher (branch_id, voucher_date DESC);
CREATE INDEX idx_ac_voucher_daybook ON ac_voucher (daybook_id, voucher_date DESC);
CREATE INDEX idx_ac_voucher_source ON ac_voucher (source_type, source_id) WHERE source_id IS NOT NULL;
CREATE INDEX idx_ac_voucher_status ON ac_voucher (voucher_status) WHERE status = 'A';

-- ---------------------------------------------------------
-- ac_transaction (ledger posting lines)
-- One row per affected account. Exactly one of dr_amount or
-- cr_amount is > 0 per row.
--
-- Example (Cash Sale with VAT):
--   Dr Cash             110.00
--       Cr Sale Account             100.00
--       Cr VAT Output                10.00
-- Produces 3 rows:
--   (Cash account,  dr=110, cr=0)
--   (Sale account,  dr=0,   cr=100)
--   (VAT Output,    dr=0,   cr=10)
-- ---------------------------------------------------------
CREATE TABLE ac_transaction
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_code       character varying(50)  NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id         BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id           BIGINT                 NOT NULL REFERENCES core.branches (id),

    voucher_id          BIGINT                 NOT NULL REFERENCES ac_voucher (id) ON DELETE CASCADE,
    voucher_line_seq    INT                    NOT NULL,
    daybook_id          INT                    NOT NULL REFERENCES core.m_daybook (id),
    voucher_date        DATE                   NOT NULL,

    -- The ledger being posted to
    account_id          BIGINT                 NOT NULL REFERENCES core.account_master (id),
    -- Denormalized for reporting speed
    primary_group_id    INT                    NOT NULL REFERENCES core.m_account_primary_group (id),
    nature_id           INT                    NOT NULL REFERENCES core.m_account_nature (id),

    -- The debit / credit amounts. Exactly one is > 0.
    currency_id         INT                    NOT NULL REFERENCES core.m_currency (id),
    dr_amount           NUMERIC(16, 2)         NOT NULL DEFAULT 0,
    cr_amount           NUMERIC(16, 2)         NOT NULL DEFAULT 0,

    -- Party / reference (when the account is a customer/supplier ledger)
    customer_account_id BIGINT REFERENCES security.customer_accounts (id),
    supplier_id         BIGINT REFERENCES core.suppliers (id),

    -- Optional cost center / analytic tag
    staff_id            BIGINT REFERENCES security.tenant_staff_users (id),

    -- Narration at the line level
    narration           TEXT,
    reference_number    character varying(100),       -- cheque no, card last4, UPI ref…

    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,

    -- Non-negative amounts, exactly one side populated
    CHECK (dr_amount >= 0 AND cr_amount >= 0),
    CHECK ((dr_amount > 0 AND cr_amount = 0) OR (dr_amount = 0 AND cr_amount > 0)),
    UNIQUE (voucher_id, voucher_line_seq)
);
CREATE INDEX idx_act_voucher ON ac_transaction (voucher_id, voucher_line_seq);
CREATE INDEX idx_act_account_date ON ac_transaction (account_id, voucher_date DESC);
CREATE INDEX idx_act_branch_date ON ac_transaction (branch_id, voucher_date DESC);
CREATE INDEX idx_act_daybook ON ac_transaction (daybook_id, voucher_date DESC);
CREATE INDEX idx_act_primary_group ON ac_transaction (tenant_id, primary_group_id, voucher_date);
CREATE INDEX idx_act_customer ON ac_transaction (customer_account_id) WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_act_supplier ON ac_transaction (supplier_id) WHERE supplier_id IS NOT NULL;

-- ---------------------------------------------------------
-- Balanced-voucher enforcement
-- When the last ac_transaction of a voucher is inserted,
-- the app should roll up total_debit/total_credit on ac_voucher.
-- The CHECK on ac_voucher guarantees they match; use the
-- validation function below for in-code verification.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION accounting.validate_voucher_balance(p_voucher_id BIGINT)
RETURNS BOOLEAN AS $$
DECLARE
    v_dr NUMERIC(16, 2);
    v_cr NUMERIC(16, 2);
BEGIN
    SELECT COALESCE(SUM(dr_amount), 0), COALESCE(SUM(cr_amount), 0)
      INTO v_dr, v_cr
      FROM ac_transaction
     WHERE voucher_id = p_voucher_id AND status = 'A';
    IF v_dr <> v_cr THEN
        RAISE EXCEPTION 'Voucher % is unbalanced: Dr=% Cr=%', p_voucher_id, v_dr, v_cr
            USING ERRCODE = 'check_violation';
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
