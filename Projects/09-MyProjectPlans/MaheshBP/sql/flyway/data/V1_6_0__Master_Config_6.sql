-- =========================================================
-- Master Config 6
-- Lookups needed by Visit/Registration, Order, Product/Inventory,
-- Billing, Payment, and Refund modules.
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- Booking / visit / order / invoice / payment status lookups
-- (referenced by booking_main and the new visit/order/invoice tables)
-- ---------------------------------------------------------
CREATE TABLE m_booking_channel
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    channel_key   character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_service_mode
(
    id                SERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    mode_key          character varying(50)  NOT NULL UNIQUE,
    name              character varying(100) NOT NULL,
    requires_address  BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order     INT                    NOT NULL DEFAULT 0,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_booking_status
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_cancellation_source
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    source_key    character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------
-- Visit (front-desk registration)
-- ---------------------------------------------------------
CREATE TABLE m_visit_status
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------
-- Order
-- ---------------------------------------------------------
CREATE TABLE m_order_status
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_order_line_type
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    type_key      character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------
-- Payment / Tender / Invoice
-- ---------------------------------------------------------
CREATE TABLE m_payment_status
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_payment_method
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    method_key    character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    is_online     BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_tender_type
(
    id              SERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    tender_key      character varying(50)  NOT NULL UNIQUE,
    name            character varying(100) NOT NULL,
    -- Tender type classification: CASH, CARD, WALLET, UPI, BANK, CHEQUE, GIFT_CARD, LOYALTY, CREDIT_NOTE
    category        character varying(30)  NOT NULL,
    requires_reference BOOLEAN             NOT NULL DEFAULT FALSE,
    display_order   INT                    NOT NULL DEFAULT 0,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_invoice_status
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_refund_reason
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    reason_key    character varying(50)  NOT NULL UNIQUE,
    name          character varying(150) NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------
-- Tax
-- ---------------------------------------------------------
CREATE TABLE m_tax_type
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tax_key       character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    -- VAT, GST, CGST, SGST, IGST, SERVICE_TAX, SALES_TAX
    category      character varying(30)  NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

-- Tenant-level tax rate configuration (applied at branch/business scope)
CREATE TABLE tax_rates
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id      BIGINT REFERENCES businesses (id),
    branch_id        BIGINT REFERENCES branches (id),
    tax_type_id      INT                    NOT NULL REFERENCES m_tax_type (id),
    name             character varying(100) NOT NULL,
    rate_percent     NUMERIC(6, 3)          NOT NULL CHECK (rate_percent >= 0),
    is_inclusive     BOOLEAN                NOT NULL DEFAULT FALSE,
    applies_to_services BOOLEAN             NOT NULL DEFAULT TRUE,
    applies_to_products BOOLEAN             NOT NULL DEFAULT TRUE,
    valid_from       DATE                   NOT NULL DEFAULT CURRENT_DATE,
    valid_until      DATE,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_tax_rates_scope ON tax_rates (tenant_id, business_id, branch_id) WHERE status = 'A';

-- ---------------------------------------------------------
-- Inventory
-- ---------------------------------------------------------
CREATE TABLE m_uom
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    uom_key       character varying(30)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    symbol        character varying(20),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_stock_movement_type
(
    id                SERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    movement_key      character varying(50)  NOT NULL UNIQUE,
    name              character varying(100) NOT NULL,
    -- Direction: +1 = IN (increases stock), -1 = OUT (decreases stock)
    direction         SMALLINT               NOT NULL CHECK (direction IN (-1, 1)),
    display_order     INT                    NOT NULL DEFAULT 0,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------
-- Daybook (defined here because item_trans references it)
-- Full accounting masters are created in V2_1_0.
-- ---------------------------------------------------------
CREATE TABLE daybook_master
(
    id                 SERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    daybook_key        character varying(50)  NOT NULL UNIQUE,
    name               character varying(150) NOT NULL,
    voucher_class      character varying(30)  NOT NULL
        CHECK (voucher_class IN ('PAYMENT', 'RECEIPT', 'CONTRA', 'JOURNAL',
                                 'SALE', 'SALE_RETURN', 'PURCHASE', 'PURCHASE_RETURN',
                                 'STOCK_TRANSFER', 'STOCK_ADJUSTMENT', 'STOCK_OPENING',
                                 'DEPOSIT', 'REFUND')),
    affects_accounting BOOLEAN                NOT NULL DEFAULT TRUE,
    affects_stock      BOOLEAN                NOT NULL DEFAULT FALSE,
    voucher_prefix     character varying(10),
    display_order      INT                    NOT NULL DEFAULT 0,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------
-- m_daybook_item
-- Line templates that describe the shape of a voucher for a
-- given daybook. Each row says: "when posting this daybook,
-- a line of this role appears, on this side (Dr/Cr), and is
-- populated based on this source".
--
-- Example seeds (SALE daybook):
--   seq=1  role=CUSTOMER        dr_cr=D  amount_source=TOTAL
--   seq=2  role=SALE_INCOME     dr_cr=C  amount_source=PRODUCT_TAXABLE
--   seq=3  role=SERVICE_INCOME  dr_cr=C  amount_source=SERVICE_TAXABLE
--   seq=4  role=OUTPUT_TAX      dr_cr=C  amount_source=TAX
--   seq=5  role=DISCOUNT_GIVEN  dr_cr=D  amount_source=DISCOUNT    (is_optional)
--   seq=6  role=ROUNDING        dr_cr=D  amount_source=ROUNDING    (is_optional,
--                                                                   sign_flip=TRUE)
--
-- The posting engine (post_sale / post_purchase / etc.) walks these
-- templates to build voucher_line[] dynamically, instead of
-- hard-coding each ledger inside the function.
-- ---------------------------------------------------------
CREATE TABLE m_daybook_item
(
    id                 SERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    daybook_id         INT                    NOT NULL REFERENCES daybook_master (id) ON DELETE CASCADE,
    line_seq           INT                    NOT NULL,

    -- Role key identifies which mapped account to resolve
    -- (looked up in daybook_acc by tenant/branch/daybook/role_key)
    role_key           character varying(50)  NOT NULL,
    -- Human-readable label used for the narration on the posted line
    label              character varying(150) NOT NULL,

    -- Dr or Cr posting
    dr_cr              CHAR(1)                NOT NULL CHECK (dr_cr IN ('D', 'C')),

    -- Source of the line amount. The posting engine interprets these:
    --   'TOTAL'             - total_amount of the source document (e.g. invoice total)
    --   'SUBTOTAL'          - subtotal before tax/discount
    --   'PRODUCT_TAXABLE'   - sum of taxable amounts on product lines
    --   'SERVICE_TAXABLE'   - sum of taxable amounts on service lines
    --   'TAX'               - total tax amount
    --   'DISCOUNT'          - total discount amount
    --   'ROUNDING'          - rounding amount (can be negative)
    --   'TIP'               - tip amount
    --   'PER_TENDER'        - one line per payment_tender (expands dynamically)
    --   'PER_TAX'           - one line per tax_type (expands dynamically)
    --   'COGS'              - cost-of-goods-sold computed from item costs
    --   'FIXED'             - a fixed amount supplied by the app
    --   'REMAINDER'         - whatever makes the voucher balance (balancing line)
    amount_source      character varying(30)  NOT NULL,

    -- If TRUE, this line is skipped when its computed amount is zero
    is_optional        BOOLEAN                NOT NULL DEFAULT FALSE,
    -- If TRUE, the engine swaps dr_cr when the amount is negative
    -- (useful for rounding / discounts that can swing either way)
    sign_flip          BOOLEAN                NOT NULL DEFAULT FALSE,

    -- Whether this template line represents a party ledger
    -- (customer / supplier) — drives which id is copied onto ac_transaction
    party_type         character varying(20) CHECK (party_type IS NULL OR party_type IN ('CUSTOMER', 'SUPPLIER', 'STAFF')),

    notes              TEXT,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1,
    UNIQUE (daybook_id, line_seq)
);
CREATE INDEX idx_daybook_item_daybook ON m_daybook_item (daybook_id, line_seq) WHERE status = 'A';
