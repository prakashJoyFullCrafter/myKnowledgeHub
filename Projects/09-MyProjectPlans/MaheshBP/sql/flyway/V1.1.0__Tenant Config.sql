set
search_path to core;

CREATE TABLE tenants
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_code         character varying(50)  NOT NULL UNIQUE,
    name                character varying(200) NOT NULL,
    legal_name          character varying(200) NOT NULL,
    country_id          INT                    NOT NULL REFERENCES m_country (id),
    default_locale_id   INT REFERENCES m_locale (id),
    default_currency_id INT                    NOT NULL REFERENCES m_currency (id),
    default_timezone_id INT REFERENCES m_timezone (id),
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE tenant_subscriptions
(
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    tenant_id            BIGINT                 NOT NULL REFERENCES tenants (id),
    plan_id              INT                    NOT NULL REFERENCES m_subscription_plan (id),
    subscription_status  character varying(30)  NOT NULL DEFAULT 'trial'
        CHECK (subscription_status IN ('trial', 'active', 'grace', 'suspended', 'cancelled', 'expired')),
    billing_interval     character varying(10)  NOT NULL DEFAULT 'monthly'
        CHECK (billing_interval IN ('monthly', 'annually')),
    current_period_start DATE                   NOT NULL,
    current_period_end   DATE                   NOT NULL,
    trial_ends_at        TIMESTAMPTZ,
    cancelled_at         TIMESTAMPTZ,
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1
);

CREATE TABLE tenant_subscription_invoices
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            character varying(200) NOT NULL UNIQUE,
    tenant_id              BIGINT                 NOT NULL REFERENCES tenants (id),
    tenant_subscription_id BIGINT                 NOT NULL REFERENCES tenant_subscriptions (id),
    currency_id            INT                    NOT NULL REFERENCES m_currency (id),
    locale_id              INT REFERENCES m_locale (id),
    amount                 NUMERIC(12, 2)         NOT NULL,
    tax_amount             NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    total_amount           NUMERIC(12, 2)         NOT NULL,
    subscription_status    character varying(20)  NOT NULL DEFAULT 'pending'
        CHECK (subscription_status IN ('pending', 'paid', 'failed', 'void')),
    due_date               DATE                   NOT NULL,
    paid_at                TIMESTAMPTZ,
    invoice_number         character varying(50) UNIQUE,
    status                 character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT,
    updated_by             BIGINT,
    version                INT                    NOT NULL DEFAULT 1
);

CREATE TABLE tenant_settings
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES tenants (id),
    setting_key   character varying(100) NOT NULL,
    setting_value TEXT,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, setting_key)
);

CREATE TABLE tenant_modules
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    module_id   INT                    NOT NULL REFERENCES m_module (id),
    is_enabled  BOOLEAN                NOT NULL DEFAULT FALSE,
    enabled_at  TIMESTAMPTZ,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, module_id)
);

CREATE TABLE tenant_item_code_prefix
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    name        character varying(5)   NOT NULL,
    last_number INT                    NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);