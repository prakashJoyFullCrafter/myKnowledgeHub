set
search_path to core;



CREATE TABLE tenants
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_code         character varying(50)  NOT NULL UNIQUE,
    name                character varying(200) NOT NULL,
    country_id          INT                    NOT NULL REFERENCES countries (id),
    default_locale_id   INT REFERENCES locales (id),
    default_currency_id INT                    NOT NULL REFERENCES currencies (id),
    default_timezone_id INT REFERENCES timezones (id),
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
    plan_id              INT                    NOT NULL REFERENCES subscription_plans (id),
    subscription_status  character varying(30)  NOT NULL DEFAULT 'trial'
        CHECK (status IN ('trial', 'active', 'grace', 'suspended', 'cancelled', 'expired')),
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

CREATE TABLE subscription_invoices
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            character varying(200) NOT NULL UNIQUE,
    tenant_id              BIGINT                 NOT NULL REFERENCES tenants (id),
    tenant_subscription_id BIGINT                 NOT NULL REFERENCES tenant_subscriptions (id),
    currency_id            INT                    NOT NULL REFERENCES currencies (id),
    locale_id              INT REFERENCES locales (id),
    amount                 NUMERIC(12, 2)         NOT NULL,
    tax_amount             NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    total_amount           NUMERIC(12, 2)         NOT NULL,
    subscription_status    character varying(20)  NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'paid', 'failed', 'void')),
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
    module_id   INT                    NOT NULL REFERENCES modules (id),
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

CREATE TABLE businesses
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    business_type_id      INT                    NOT NULL REFERENCES business_types (id),
    registered_country_id INT                    NOT NULL REFERENCES countries (id),
    preferred_locale_id   INT REFERENCES locales (id),
    name                  character varying(200) NOT NULL,
    legal_name            character varying(200),
    description           TEXT,
    logo_url              TEXT,
    website_url           TEXT,
    deleted_at            TIMESTAMPTZ,
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, name)
);

CREATE TABLE branches
(
    id                      BIGSERIAL PRIMARY KEY,
    internal_id             character varying(200) NOT NULL UNIQUE,
    business_id             BIGINT                 NOT NULL REFERENCES businesses (id),
    tenant_id               BIGINT                 NOT NULL REFERENCES tenants (id),
    name                    character varying(200) NOT NULL,
    phone                   character varying(30),
    email                   character varying(255),
    timezone_id             INT                    NOT NULL REFERENCES timezones (id),
    is_home_service_enabled BOOLEAN                NOT NULL DEFAULT FALSE,
    is_active               BOOLEAN                NOT NULL DEFAULT TRUE,
    deleted_at              TIMESTAMPTZ,
    status                  character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by              BIGINT,
    updated_by              BIGINT,
    version                 INT                    NOT NULL DEFAULT 1,
    UNIQUE (business_id, name)
);

CREATE TABLE branch_addresses
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id   BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id     BIGINT                 NOT NULL UNIQUE REFERENCES branches (id),
    address_line1 character varying(255) NOT NULL,
    address_line2 character varying(255),
    locality_id   INT REFERENCES localities (id),
    city_id       INT                    NOT NULL REFERENCES cities (id),
    state_id      INT REFERENCES country_administrative_divisions (id),
    country_id    INT                    NOT NULL REFERENCES countries (id),
    postal_code   character varying(20),
    --location      GEOGRAPHY(POINT, 4326) NOT NULL,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE branch_operating_hours
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200),
    tenant_id   BIGINT      NOT NULL REFERENCES tenants (id),
    business_id BIGINT      NOT NULL REFERENCES businesses (id),
    branch_id   BIGINT      NOT NULL REFERENCES branches (id),
    day_of_week SMALLINT    NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    open_time   TIME        NOT NULL,
    close_time  TIME        NOT NULL,
    is_closed   BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version     INT         NOT NULL DEFAULT 1,
    UNIQUE (branch_id, day_of_week)
);

CREATE TABLE branch_holidays
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id         BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id           BIGINT                 NOT NULL REFERENCES branches (id),
    holiday_date        DATE                   NOT NULL,
    name                character varying(150),
    is_recurring_yearly BOOLEAN                NOT NULL DEFAULT FALSE,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_id, holiday_date)
);

CREATE TABLE branch_closures
(
    id           BIGSERIAL PRIMARY KEY,
    internal_id  character varying(200) NOT NULL UNIQUE,
    tenant_id    BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id  BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id    BIGINT                 NOT NULL REFERENCES branches (id),
    closure_date DATE                   NOT NULL,
    reason       character varying(255),
    close_from   TIME,
    close_until  TIME,
    status       character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by   BIGINT,
    updated_by   BIGINT,
    version      INT                    NOT NULL DEFAULT 1
);

CREATE TABLE branch_service_areas
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    city_id     INT REFERENCES cities (id),
    locality_id INT REFERENCES localities (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE branch_home_service_zones
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            character varying(200) NOT NULL UNIQUE,
    tenant_id              BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id            BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id              BIGINT                 NOT NULL REFERENCES branches (id),
    zone_type              character varying(20)  NOT NULL DEFAULT 'radius'
        CHECK (zone_type IN ('radius', 'polygon', 'locality_list')),
    radius_km              NUMERIC(8, 2),
    --polygon                GEOGRAPHY(POLYGON, 4326),
    locality_ids           JSONB                  NOT NULL DEFAULT '[]',
    travel_buffer_minutes  INT                    NOT NULL DEFAULT 30,
    home_service_surcharge NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    status                 character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT,
    updated_by             BIGINT,
    version                INT                    NOT NULL DEFAULT 1
);

CREATE TABLE branch_amenities
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id   BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id     BIGINT                 NOT NULL REFERENCES branches (id),
    amenity_key   character varying(50)  NOT NULL UNIQUE,
    label         character varying(100) NOT NULL,
    icon_key      character varying(50),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE branch_amenity_assignments
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    amenity_id  INT                    NOT NULL REFERENCES branch_amenities (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_id, amenity_id)
);


CREATE TABLE branch_media
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id   BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id     BIGINT                 NOT NULL REFERENCES branches (id),
    media_type_id INT                    NOT NULL REFERENCES media_types (id),
    language_id   INT REFERENCES languages (id),
    url           TEXT                   NOT NULL,
    caption       character varying(255),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE branch_service_tier_mappings
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200) NOT NULL UNIQUE,
    tenant_id       BIGINT       NOT NULL REFERENCES tenants (id),
    business_id     BIGINT       NOT NULL REFERENCES businesses (id),
    branch_id       BIGINT       NOT NULL REFERENCES branches (id),
    service_tier_id INT          NOT NULL REFERENCES service_tiers (id),
    status          VARCHAR(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version         INT          NOT NULL DEFAULT 1,
    UNIQUE (branch_id, service_tier_id)
);

CREATE TABLE branch_customer_tier_mappings
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200)  NOT NULL UNIQUE,
    tenant_id        BIGINT        NOT NULL REFERENCES tenants (id),
    business_id      BIGINT        NOT NULL REFERENCES businesses (id),
    branch_id        BIGINT        NOT NULL REFERENCES branches (id),
    customer_tier_id INT           NOT NULL REFERENCES customer_tiers (id),
    discount_percent NUMERIC(5, 2) NOT NULL DEFAULT 0, -- discount given to this tier at this branch
    status           VARCHAR(1)    NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version          INT           NOT NULL DEFAULT 1,
    UNIQUE (branch_id, customer_tier_id)
);