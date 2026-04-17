-- =========================================================
-- Master Config 7
-- Accounting masters (Tally-style CoA), daybook codes.
--
-- Hierarchy:
--   m_account_nature   (Asset / Liability / Income / Expense / Equity)
--     ↓
--   m_account_primary_group  (Current Assets, Fixed Assets,
--                             Direct Income, Indirect Income,
--                             Direct Expense, Indirect Expense, …)
--     ↓
--   account_group  (tenant-owned, can nest via parent_group_id)
--     ↓
--   account_master (tenant-owned, the actual ledger posted to)
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- Nature of account (top of the accounting classification tree)
-- Drives P&L vs Balance Sheet reporting and sign convention.
-- ---------------------------------------------------------
CREATE TABLE m_account_nature
(
    id              SERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    nature_key      character varying(30)  NOT NULL UNIQUE,   -- ASSET, LIABILITY, INCOME, EXPENSE, EQUITY
    name            character varying(100) NOT NULL,
    -- Normal balance side: 'D' (debit-normal) or 'C' (credit-normal)
    normal_balance  CHAR(1)                NOT NULL CHECK (normal_balance IN ('D', 'C')),
    -- Reporting classification
    is_pnl          BOOLEAN                NOT NULL DEFAULT FALSE,  -- appears on Profit & Loss
    is_bs           BOOLEAN                NOT NULL DEFAULT FALSE,  -- appears on Balance Sheet
    display_order   INT                    NOT NULL DEFAULT 0,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------
-- Primary group (fixed, system-defined Tally-style groupings)
-- Tenants do NOT create new primary groups; they create
-- account_group rows that roll up to these.
-- ---------------------------------------------------------
CREATE TABLE m_account_primary_group
(
    id              SERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    group_key       character varying(50)  NOT NULL UNIQUE,
    name            character varying(100) NOT NULL,
    nature_id       INT                    NOT NULL REFERENCES m_account_nature (id),
    -- P&L section: DIRECT_INCOME, INDIRECT_INCOME, DIRECT_EXPENSE, INDIRECT_EXPENSE,
    --              COGS, TRADING_INCOME, or NULL for BS-only groups
    pnl_section     character varying(30),
    display_order   INT                    NOT NULL DEFAULT 0,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------
-- Account group (tenant-level, hierarchical)
-- e.g. "Sales Accounts" under Direct Income (system),
--      "Branch-wise Sales" as a child of "Sales Accounts".
-- ---------------------------------------------------------
CREATE TABLE account_group
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES tenants (id),
    primary_group_id   INT                    NOT NULL REFERENCES m_account_primary_group (id),
    parent_group_id    BIGINT REFERENCES account_group (id),
    code               character varying(30)  NOT NULL,
    name               character varying(150) NOT NULL,
    description        TEXT,
    is_system          BOOLEAN                NOT NULL DEFAULT FALSE,  -- provisioned by system, cannot be deleted
    display_order      INT                    NOT NULL DEFAULT 0,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, code)
);
CREATE INDEX idx_account_group_tenant ON account_group (tenant_id) WHERE status = 'A';
CREATE INDEX idx_account_group_parent ON account_group (parent_group_id) WHERE parent_group_id IS NOT NULL;
CREATE INDEX idx_account_group_primary ON account_group (primary_group_id);

-- ---------------------------------------------------------
-- Account master (the actual ledger)
-- e.g. "Cash in Hand — Branch A", "Visa Card Clearing",
--      "Sale Account — Branch A", "VAT Output 5%".
-- Scoped to tenant; may be optionally tied to a branch for
-- branch-specific ledgers (sale/purchase/cash per branch).
-- ---------------------------------------------------------
CREATE TABLE account_master
(
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    tenant_id            BIGINT                 NOT NULL REFERENCES tenants (id),
    account_group_id     BIGINT                 NOT NULL REFERENCES account_group (id),
    -- Optional branch binding (NULL = shared across branches, e.g. Tax ledgers)
    branch_id            BIGINT REFERENCES branches (id),
    code                 character varying(30)  NOT NULL,
    name                 character varying(200) NOT NULL,
    description          TEXT,

    -- Classification (denormalized for fast reporting)
    nature_id            INT                    NOT NULL REFERENCES m_account_nature (id),
    primary_group_id     INT                    NOT NULL REFERENCES m_account_primary_group (id),

    -- Ledger type (hints at usage)
    ledger_type          character varying(30)  NOT NULL DEFAULT 'GENERAL'
        CHECK (ledger_type IN ('GENERAL', 'CASH', 'BANK', 'CREDIT_CARD', 'WALLET', 'UPI',
                               'SALES', 'PURCHASE', 'SALES_RETURN', 'PURCHASE_RETURN',
                               'TAX_OUTPUT', 'TAX_INPUT', 'STOCK', 'DISCOUNT', 'TIP',
                               'CUSTOMER', 'SUPPLIER', 'STAFF_COMMISSION', 'EXPENSE',
                               'ROUNDING', 'OPENING_BALANCE', 'CAPITAL')),

    currency_id          INT                    NOT NULL REFERENCES m_currency (id),
    -- Party linkage (when ledger IS a customer or supplier)
    customer_account_id  BIGINT REFERENCES security.customer_accounts (id),
    supplier_id          BIGINT REFERENCES suppliers (id),
    -- Tax ledger linkage
    tax_type_id          INT REFERENCES m_tax_type (id),
    tax_rate_id          BIGINT REFERENCES tax_rates (id),
    -- Payment method binding (for CASH/CARD/UPI/WALLET ledgers)
    payment_method_id    INT REFERENCES m_payment_method (id),

    -- Flags
    is_system            BOOLEAN                NOT NULL DEFAULT FALSE,
    is_reconcilable      BOOLEAN                NOT NULL DEFAULT FALSE,  -- bank reconciliation ledgers
    allow_manual_posting BOOLEAN                NOT NULL DEFAULT TRUE,
    -- Opening balance (as of the tenant's books-start-date)
    opening_balance      NUMERIC(16, 2)         NOT NULL DEFAULT 0,
    opening_balance_dc   CHAR(1)                NOT NULL DEFAULT 'D' CHECK (opening_balance_dc IN ('D', 'C')),

    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1,

    UNIQUE (tenant_id, code),
    -- Only one party binding per account
    CHECK ((customer_account_id IS NULL) OR (supplier_id IS NULL))
);
CREATE INDEX idx_acc_master_tenant ON account_master (tenant_id) WHERE status = 'A';
CREATE INDEX idx_acc_master_group ON account_master (account_group_id);
CREATE INDEX idx_acc_master_branch ON account_master (branch_id) WHERE branch_id IS NOT NULL;
CREATE INDEX idx_acc_master_ledger_type ON account_master (tenant_id, ledger_type);
CREATE INDEX idx_acc_master_customer ON account_master (customer_account_id) WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_acc_master_supplier ON account_master (supplier_id) WHERE supplier_id IS NOT NULL;

-- ---------------------------------------------------------
-- Daybook  --  defined in V1_6_0 (needed by item_trans).
-- This migration only adds daybook_acc.
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- Daybook → default accounts map
-- Links each daybook to the default ledgers used by auto-postings.
-- Resolution is branch-specific when branch_id is set, else tenant-wide.
-- ---------------------------------------------------------
CREATE TABLE daybook_acc
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id         BIGINT REFERENCES branches (id),
    daybook_id        INT                    NOT NULL REFERENCES daybook_master (id),
    -- Role of the account within this daybook
    role_key          character varying(50)  NOT NULL,
    -- e.g. 'SALE_INCOME', 'SALES_RETURN', 'COGS', 'PURCHASE', 'PURCHASE_RETURN',
    --      'CASH', 'STOCK', 'OUTPUT_TAX', 'INPUT_TAX', 'DISCOUNT_GIVEN',
    --      'ROUNDING', 'TIP_PAYABLE', 'STOCK_IN_TRANSIT'
    account_id        BIGINT                 NOT NULL REFERENCES account_master (id),
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, branch_id, daybook_id, role_key)
);
CREATE INDEX idx_dbmap_lookup ON daybook_acc (tenant_id, daybook_id, branch_id);
