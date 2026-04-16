-- ============================================================
-- DOMAIN 12: PAYMENTS
-- ============================================================

CREATE TABLE payment_statuses
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(30)  NOT NULL UNIQUE,
    label         character varying(100) NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE payment_methods_master
(
    id              SERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    method_type_key character varying(30)  NOT NULL UNIQUE,
    label           character varying(100) NOT NULL,
    icon_key        character varying(50),
    is_online       BOOLEAN                NOT NULL DEFAULT TRUE,
    is_active       BOOLEAN                NOT NULL DEFAULT TRUE,
    display_order   INT                    NOT NULL DEFAULT 0,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE transaction_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    type_key    character varying(50)  NOT NULL UNIQUE,
    label       character varying(100) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE refund_reasons
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    reason_key  character varying(50)  NOT NULL UNIQUE,
    label       character varying(150) NOT NULL,
    actor       character varying(20)  NOT NULL CHECK (actor IN ('customer', 'merchant', 'system', 'admin')),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE tax_rules
(
    id              SERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    country_id      INT                    NOT NULL REFERENCES countries (id),
    state_id        INT REFERENCES states (id),
    locale_id       INT REFERENCES locales (id),
    tax_name        character varying(50)  NOT NULL,
    rate            NUMERIC(6, 4)          NOT NULL,
    applies_to      character varying(30),
    is_active       BOOLEAN                NOT NULL DEFAULT TRUE,
    effective_from  DATE,
    effective_until DATE,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE payment_methods
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    user_id        BIGINT                 NOT NULL REFERENCES users (id),
    method_type_id INT                    NOT NULL REFERENCES payment_methods_master (id),
    provider       character varying(50),
    provider_token TEXT,
    last_four      character varying(4),
    expiry_month   SMALLINT,
    expiry_year    SMALLINT,
    is_default     BOOLEAN                NOT NULL DEFAULT FALSE,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE payments
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES tenants (id),
    appointment_id      BIGINT REFERENCES appointments (id),
    customer_id         BIGINT                 NOT NULL REFERENCES users (id),
    payment_method_id   BIGINT REFERENCES payment_methods (id),
    transaction_type_id INT                    NOT NULL REFERENCES transaction_types (id),
    status_id           INT                    NOT NULL REFERENCES payment_statuses (id),
    amount              NUMERIC(12, 2)         NOT NULL,
    currency_id         INT                    NOT NULL REFERENCES currencies (id),
    provider            character varying(50),
    provider_reference  character varying(255),
    paid_at             TIMESTAMPTZ,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE payment_transactions
(
    id                         BIGSERIAL PRIMARY KEY,
    internal_id                character varying(200) NOT NULL UNIQUE,
    payment_id                 BIGINT                 NOT NULL REFERENCES payments (id),
    transaction_type_id        INT                    NOT NULL REFERENCES transaction_types (id),
    amount                     NUMERIC(12, 2)         NOT NULL,
    currency_id                INT                    NOT NULL REFERENCES currencies (id),
    pt_provider_transaction_id character varying(255),
    status                     character varying(30)  NOT NULL,
    metadata                   JSONB                  NOT NULL DEFAULT '{}',
    status                     character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at                 TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at                 TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by                 BIGINT,
    updated_by                 BIGINT,
    version                    INT                    NOT NULL DEFAULT 1
);

CREATE TABLE refunds
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    payment_id         BIGINT                 NOT NULL REFERENCES payments (id),
    reason_id          INT REFERENCES refund_reasons (id),
    amount             NUMERIC(12, 2)         NOT NULL,
    currency_id        INT                    NOT NULL REFERENCES currencies (id),
    status             character varying(20)  NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'processed', 'failed')),
    provider_refund_id character varying(255),
    refunded_at        TIMESTAMPTZ,
    initiated_by       BIGINT REFERENCES users (id),
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
);

CREATE TABLE invoices
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    appointment_id  BIGINT REFERENCES appointments (id),
    customer_id     BIGINT                 NOT NULL REFERENCES users (id),
    branch_id       BIGINT                 NOT NULL REFERENCES branches (id),
    currency_id     INT                    NOT NULL REFERENCES currencies (id),
    invoice_number  character varying(50) UNIQUE,
    subtotal        NUMERIC(12, 2)         NOT NULL,
    tax_amount      NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    discount_amount NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    tip_amount      NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    total_amount    NUMERIC(12, 2)         NOT NULL,
    status          character varying(20)  NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'issued', 'paid', 'void')),
    issued_at       TIMESTAMPTZ,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE invoice_items
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    invoice_id  BIGINT                 NOT NULL REFERENCES invoices (id),
    description character varying(255) NOT NULL,
    quantity    INT                    NOT NULL DEFAULT 1,
    unit_price  NUMERIC(12, 2)         NOT NULL,
    total_price NUMERIC(12, 2)         NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE tips
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    appointment_id BIGINT                 NOT NULL REFERENCES appointments (id),
    payment_id     BIGINT                 NOT NULL REFERENCES payments (id),
    staff_id       BIGINT REFERENCES staff (id),
    amount         NUMERIC(12, 2)         NOT NULL,
    currency_id    INT                    NOT NULL REFERENCES currencies (id),
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);
