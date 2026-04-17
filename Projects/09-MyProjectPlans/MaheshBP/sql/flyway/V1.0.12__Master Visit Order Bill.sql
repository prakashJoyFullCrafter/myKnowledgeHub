set
search_path to core;
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
    id                 SERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    tender_key         character varying(50)  NOT NULL UNIQUE,
    name               character varying(100) NOT NULL,
    -- Tender type classification: CASH, CARD, WALLET, UPI, BANK, CHEQUE, GIFT_CARD, LOYALTY, CREDIT_NOTE
    category           character varying(30)  NOT NULL,
    requires_reference BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order      INT                    NOT NULL DEFAULT 0,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
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
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id         BIGINT REFERENCES businesses (id),
    branch_id           BIGINT REFERENCES branches (id),
    tax_type_id         INT                    NOT NULL REFERENCES m_tax_type (id),
    name                character varying(100) NOT NULL,
    rate_percent        NUMERIC(6, 3)          NOT NULL CHECK (rate_percent >= 0),
    is_inclusive        BOOLEAN                NOT NULL DEFAULT FALSE,
    applies_to_services BOOLEAN                NOT NULL DEFAULT TRUE,
    applies_to_products BOOLEAN                NOT NULL DEFAULT TRUE,
    valid_from          DATE                   NOT NULL DEFAULT CURRENT_DATE,
    valid_until         DATE,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
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
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    movement_key  character varying(50)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    -- Direction: +1 = IN (increases stock), -1 = OUT (decreases stock)
    direction     SMALLINT               NOT NULL CHECK (direction IN (-1, 1)),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);