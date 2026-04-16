# Beauty SaaS Platform — PostgreSQL Schema
# ID Convention:
#   SERIAL (INT)  → master/reference tables (no branch_id / tenant_id)
#   BIGSERIAL     → operational tables (have branch_id or tenant_id)
#
# Every table has these standard columns in this order:
#   id           SERIAL or BIGSERIAL PRIMARY KEY
#   internal_id  VARCHAR(200)               -- business-facing reference code
#   created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
#   updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
#   created_by   BIGINT REFERENCES users(id)
#   updated_by   BIGINT REFERENCES users(id)
#   version      INT NOT NULL DEFAULT 1     -- optimistic locking
#
# Bootstrap note: users table is created inside Domain 3 before the rest of
#   the domains, then all earlier BIGINT created_by/updated_by columns are
#   wired up via ALTER TABLE ADD CONSTRAINT after users exists.
#
# Required PostgreSQL extensions: postgis, pgcrypto
# Beauty SaaS Platform — PostgreSQL Schema
# Convention:
#   SERIAL (INT)  → master/reference tables (no branch_id / tenant_id)
#   BIGSERIAL     → operational tables (have branch_id or tenant_id)
#   internal_id   → VARCHAR(200), human-readable business reference code
#   created_at    → TIMESTAMPTZ NOT NULL DEFAULT NOW()
#   updated_at    → TIMESTAMPTZ NOT NULL DEFAULT NOW()
#   created_by    → BIGINT REFERENCES users(id)
#   updated_by    → BIGINT REFERENCES users(id)
#   version       → INT NOT NULL DEFAULT 1  (optimistic locking)
#
# Extensions: postgis, pgcrypto

```sql

-- ============================================================
-- EXTENSIONS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "postgis";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";


-- ============================================================
-- DOMAIN 1: LOCATION REFERENCE  (master → SERIAL)
-- ============================================================

-- ============================================================
-- DOMAIN 3: USERS (declared early; FKs patched after)
-- ============================================================

CREATE TABLE subscription_plans (
    id                    SERIAL PRIMARY KEY,
    internal_id           VARCHAR(200),
    plan_key              VARCHAR(50)  NOT NULL UNIQUE,
    name                  VARCHAR(100) NOT NULL,
    description           TEXT,
    price_monthly         NUMERIC(12,2),
    price_annually        NUMERIC(12,2),
    currency_id           INT          NOT NULL REFERENCES currencies(id),
    branch_limit          INT,
    staff_limit           INT,
    booking_limit_monthly INT,
    commission_rate       NUMERIC(5,4) NOT NULL DEFAULT 0.06,
    feature_flags         JSONB        NOT NULL DEFAULT '{}',
    is_active             BOOLEAN      NOT NULL DEFAULT TRUE,
    display_order         INT          NOT NULL DEFAULT 0,
    created_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT          NOT NULL DEFAULT 1
);

CREATE TABLE tenants (
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    tenant_code          VARCHAR(50)  NOT NULL UNIQUE,
    name                 VARCHAR(200) NOT NULL,
    country_id           INT          NOT NULL REFERENCES countries(id),
    default_locale_id    INT REFERENCES locales(id),
    default_currency_id  INT          NOT NULL REFERENCES currencies(id),
    default_timezone_id  INT REFERENCES timezones(id),
    is_active            BOOLEAN      NOT NULL DEFAULT TRUE,
    deleted_at           TIMESTAMPTZ,
    created_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT          NOT NULL DEFAULT 1
);

CREATE TABLE users (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    tenant_id     BIGINT REFERENCES tenants(id),
    email         VARCHAR(255) UNIQUE,
    phone         VARCHAR(30)  UNIQUE,
    password_hash TEXT,
    is_verified   BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    last_login_at TIMESTAMPTZ,
    deleted_at    TIMESTAMPTZ,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

-- Back-fill created_by / updated_by FKs on tables declared before users
ALTER TABLE timezones             ADD CONSTRAINT fk_tz_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE timezones             ADD CONSTRAINT fk_tz_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE countries             ADD CONSTRAINT fk_co_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE countries             ADD CONSTRAINT fk_co_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE states                ADD CONSTRAINT fk_sta_cb  FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE states                ADD CONSTRAINT fk_sta_ub  FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE cities                ADD CONSTRAINT fk_ci_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE cities                ADD CONSTRAINT fk_ci_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE localities            ADD CONSTRAINT fk_lo_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE localities            ADD CONSTRAINT fk_lo_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE postal_codes          ADD CONSTRAINT fk_pc_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE postal_codes          ADD CONSTRAINT fk_pc_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE address_types         ADD CONSTRAINT fk_at_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE address_types         ADD CONSTRAINT fk_at_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE country_calling_codes ADD CONSTRAINT fk_ccc_cb  FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE country_calling_codes ADD CONSTRAINT fk_ccc_ub  FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE languages             ADD CONSTRAINT fk_la_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE languages             ADD CONSTRAINT fk_la_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE locales               ADD CONSTRAINT fk_lc_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE locales               ADD CONSTRAINT fk_lc_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE currencies            ADD CONSTRAINT fk_cu_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE currencies            ADD CONSTRAINT fk_cu_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE currency_exchange_rates ADD CONSTRAINT fk_cer_cb FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE currency_exchange_rates ADD CONSTRAINT fk_cer_ub FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE subscription_plans    ADD CONSTRAINT fk_sp_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE subscription_plans    ADD CONSTRAINT fk_sp_ub   FOREIGN KEY (updated_by) REFERENCES users(id);
ALTER TABLE tenants               ADD CONSTRAINT fk_te_cb   FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE tenants               ADD CONSTRAINT fk_te_ub   FOREIGN KEY (updated_by) REFERENCES users(id);


-- ============================================================
-- DOMAIN 4: USER AND ACCESS
-- ============================================================

CREATE TABLE roles (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    role_key     VARCHAR(50)  NOT NULL UNIQUE,
    name         VARCHAR(100) NOT NULL,
    description  TEXT,
    is_system    BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE permissions (
    id              SERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    permission_key  VARCHAR(100) NOT NULL UNIQUE,
    name            VARCHAR(150) NOT NULL,
    domain          VARCHAR(50),
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT          NOT NULL DEFAULT 1
);

CREATE TABLE role_permissions (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    role_id        INT         NOT NULL REFERENCES roles(id),
    permission_id  INT         NOT NULL REFERENCES permissions(id),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT         NOT NULL DEFAULT 1,
    UNIQUE (role_id, permission_id)
);

CREATE TABLE user_profiles (
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           VARCHAR(200),
    user_id               BIGINT      NOT NULL UNIQUE REFERENCES users(id),
    first_name            VARCHAR(100),
    last_name             VARCHAR(100),
    display_name          VARCHAR(150),
    avatar_url            TEXT,
    gender                VARCHAR(20),
    date_of_birth         DATE,
    preferred_language_id INT REFERENCES languages(id),
    preferred_locale_id   INT REFERENCES locales(id),
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by            BIGINT REFERENCES users(id),
    updated_by            BIGINT REFERENCES users(id),
    version               INT         NOT NULL DEFAULT 1
);

CREATE TABLE user_roles (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    user_id      BIGINT      NOT NULL REFERENCES users(id),
    role_id      INT         NOT NULL REFERENCES roles(id),
    tenant_id    BIGINT REFERENCES tenants(id),
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (user_id, role_id, tenant_id)
);

CREATE TABLE user_addresses (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    user_id          BIGINT      NOT NULL REFERENCES users(id),
    address_type_id  INT REFERENCES address_types(id),
    label            VARCHAR(100),
    address_line1    VARCHAR(255) NOT NULL,
    address_line2    VARCHAR(255),
    locality_id      INT REFERENCES localities(id),
    city_id          INT          NOT NULL REFERENCES cities(id),
    state_id         INT REFERENCES states(id),
    country_id       INT          NOT NULL REFERENCES countries(id),
    postal_code      VARCHAR(20),
    location         GEOGRAPHY(POINT, 4326),
    is_default       BOOLEAN      NOT NULL DEFAULT FALSE,
    deleted_at       TIMESTAMPTZ,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT          NOT NULL DEFAULT 1
);

CREATE TABLE user_devices (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    user_id       BIGINT      NOT NULL REFERENCES users(id),
    device_token  TEXT        NOT NULL,
    platform      VARCHAR(20) NOT NULL CHECK (platform IN ('ios','android','web')),
    app_version   VARCHAR(20),
    last_seen_at  TIMESTAMPTZ,
    is_active     BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT         NOT NULL DEFAULT 1
);

CREATE TABLE user_notification_preferences (
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            VARCHAR(200),
    user_id                BIGINT      NOT NULL REFERENCES users(id),
    notification_type_key  VARCHAR(100) NOT NULL,
    channel                VARCHAR(30)  NOT NULL CHECK (channel IN ('email','sms','push','whatsapp','in_app')),
    is_enabled             BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at             TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users(id),
    updated_by             BIGINT REFERENCES users(id),
    version                INT          NOT NULL DEFAULT 1,
    UNIQUE (user_id, notification_type_key, channel)
);

CREATE TABLE tenant_subscriptions (
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    tenant_id            BIGINT      NOT NULL REFERENCES tenants(id),
    plan_id              INT         NOT NULL REFERENCES subscription_plans(id),
    status               VARCHAR(30) NOT NULL DEFAULT 'trial'
        CHECK (status IN ('trial','active','grace','suspended','cancelled','expired')),
    billing_interval     VARCHAR(10) NOT NULL DEFAULT 'monthly'
        CHECK (billing_interval IN ('monthly','annually')),
    current_period_start DATE        NOT NULL,
    current_period_end   DATE        NOT NULL,
    trial_ends_at        TIMESTAMPTZ,
    cancelled_at         TIMESTAMPTZ,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users(id),
    updated_by           BIGINT REFERENCES users(id),
    version              INT         NOT NULL DEFAULT 1
);

CREATE TABLE subscription_invoices (
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            VARCHAR(200),
    tenant_id              BIGINT        NOT NULL REFERENCES tenants(id),
    tenant_subscription_id BIGINT        NOT NULL REFERENCES tenant_subscriptions(id),
    currency_id            INT           NOT NULL REFERENCES currencies(id),
    locale_id              INT REFERENCES locales(id),
    amount                 NUMERIC(12,2) NOT NULL,
    tax_amount             NUMERIC(12,2) NOT NULL DEFAULT 0,
    total_amount           NUMERIC(12,2) NOT NULL,
    status                 VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','paid','failed','void')),
    due_date               DATE          NOT NULL,
    paid_at                TIMESTAMPTZ,
    invoice_number         VARCHAR(50) UNIQUE,
    created_at             TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users(id),
    updated_by             BIGINT REFERENCES users(id),
    version                INT           NOT NULL DEFAULT 1
);

CREATE TABLE tenant_settings (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    tenant_id     BIGINT       NOT NULL REFERENCES tenants(id),
    setting_key   VARCHAR(100) NOT NULL,
    setting_value TEXT,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, setting_key)
);

CREATE TABLE tenant_modules (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    tenant_id    BIGINT       NOT NULL REFERENCES tenants(id),
    module_key   VARCHAR(100) NOT NULL,
    is_enabled   BOOLEAN      NOT NULL DEFAULT FALSE,
    enabled_at   TIMESTAMPTZ,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, module_key)
);


-- ============================================================
-- DOMAIN 5: MERCHANT STRUCTURE
-- ============================================================

CREATE TABLE business_types (
    id                            SERIAL PRIMARY KEY,
    internal_id                   VARCHAR(200),
    type_key                      VARCHAR(50)  NOT NULL UNIQUE,
    label                         VARCHAR(100) NOT NULL,
    icon_key                      VARCHAR(50),
    description                   TEXT,
    default_service_category_keys JSONB        NOT NULL DEFAULT '[]',
    display_order                 INT          NOT NULL DEFAULT 0,
    is_active                     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at                    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at                    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by                    BIGINT REFERENCES users(id),
    updated_by                    BIGINT REFERENCES users(id),
    version                       INT          NOT NULL DEFAULT 1
);

CREATE TABLE business_type_translations (
    id                SERIAL PRIMARY KEY,
    internal_id       VARCHAR(200),
    business_type_id  INT          NOT NULL REFERENCES business_types(id),
    language_id       INT          NOT NULL REFERENCES languages(id),
    label             VARCHAR(100) NOT NULL,
    description       TEXT,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by        BIGINT REFERENCES users(id),
    updated_by        BIGINT REFERENCES users(id),
    version           INT          NOT NULL DEFAULT 1,
    UNIQUE (business_type_id, language_id)
);

CREATE TABLE businesses (
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           VARCHAR(200),
    tenant_id             BIGINT       NOT NULL REFERENCES tenants(id),
    business_type_id      INT          NOT NULL REFERENCES business_types(id),
    registered_country_id INT          NOT NULL REFERENCES countries(id),
    preferred_locale_id   INT REFERENCES locales(id),
    name                  VARCHAR(200) NOT NULL,
    legal_name            VARCHAR(200),
    description           TEXT,
    logo_url              TEXT,
    website_url           TEXT,
    is_active             BOOLEAN      NOT NULL DEFAULT TRUE,
    deleted_at            TIMESTAMPTZ,
    created_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by            BIGINT REFERENCES users(id),
    updated_by            BIGINT REFERENCES users(id),
    version               INT          NOT NULL DEFAULT 1
);

CREATE TABLE branches (
    id                       BIGSERIAL PRIMARY KEY,
    internal_id              VARCHAR(200),
    business_id              BIGINT       NOT NULL REFERENCES businesses(id),
    tenant_id                BIGINT       NOT NULL REFERENCES tenants(id),
    name                     VARCHAR(200) NOT NULL,
    phone                    VARCHAR(30),
    email                    VARCHAR(255),
    timezone_id              INT          NOT NULL REFERENCES timezones(id),
    is_home_service_enabled  BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active                BOOLEAN      NOT NULL DEFAULT TRUE,
    deleted_at               TIMESTAMPTZ,
    created_at               TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by               BIGINT REFERENCES users(id),
    updated_by               BIGINT REFERENCES users(id),
    version                  INT          NOT NULL DEFAULT 1
);

CREATE TABLE branch_addresses (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    branch_id     BIGINT       NOT NULL UNIQUE REFERENCES branches(id),
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    locality_id   INT REFERENCES localities(id),
    city_id       INT          NOT NULL REFERENCES cities(id),
    state_id      INT REFERENCES states(id),
    country_id    INT          NOT NULL REFERENCES countries(id),
    postal_code   VARCHAR(20),
    location      GEOGRAPHY(POINT, 4326) NOT NULL,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE branch_operating_hours (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    branch_id    BIGINT      NOT NULL REFERENCES branches(id),
    day_of_week  SMALLINT    NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    open_time    TIME        NOT NULL,
    close_time   TIME        NOT NULL,
    is_closed    BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (branch_id, day_of_week)
);

CREATE TABLE branch_holidays (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    branch_id           BIGINT      NOT NULL REFERENCES branches(id),
    holiday_date        DATE        NOT NULL,
    name                VARCHAR(150),
    is_recurring_yearly BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT         NOT NULL DEFAULT 1,
    UNIQUE (branch_id, holiday_date)
);

CREATE TABLE branch_closures (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    branch_id     BIGINT      NOT NULL REFERENCES branches(id),
    closure_date  DATE        NOT NULL,
    reason        VARCHAR(255),
    close_from    TIME,
    close_until   TIME,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT         NOT NULL DEFAULT 1
);

CREATE TABLE branch_service_areas (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    branch_id    BIGINT      NOT NULL REFERENCES branches(id),
    city_id      INT REFERENCES cities(id),
    locality_id  INT REFERENCES localities(id),
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1
);

CREATE TABLE branch_home_service_zones (
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            VARCHAR(200),
    branch_id              BIGINT       NOT NULL REFERENCES branches(id),
    zone_type              VARCHAR(20)  NOT NULL DEFAULT 'radius'
        CHECK (zone_type IN ('radius','polygon','locality_list')),
    radius_km              NUMERIC(8,2),
    polygon                GEOGRAPHY(POLYGON, 4326),
    locality_ids           JSONB        NOT NULL DEFAULT '[]',
    travel_buffer_minutes  INT          NOT NULL DEFAULT 30,
    home_service_surcharge NUMERIC(12,2) NOT NULL DEFAULT 0,
    is_active              BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at             TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users(id),
    updated_by             BIGINT REFERENCES users(id),
    version                INT          NOT NULL DEFAULT 1
);

CREATE TABLE branch_amenities (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    amenity_key   VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    icon_key      VARCHAR(50),
    display_order INT          NOT NULL DEFAULT 0,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE branch_amenity_assignments (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    branch_id    BIGINT      NOT NULL REFERENCES branches(id),
    amenity_id   INT         NOT NULL REFERENCES branch_amenities(id),
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (branch_id, amenity_id)
);



-- ============================================================
-- DOMAIN 6: CATALOG AND SERVICES
-- ============================================================

CREATE TABLE service_types (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    type_key      VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    display_order INT          NOT NULL DEFAULT 0,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE service_categories (
    id               SERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    service_type_id  INT          REFERENCES service_types(id),
    category_key     VARCHAR(50)  NOT NULL UNIQUE,
    name             VARCHAR(150) NOT NULL,
    description      TEXT,
    icon_key         VARCHAR(50),
    display_order    INT          NOT NULL DEFAULT 0,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT          NOT NULL DEFAULT 1
);

CREATE TABLE service_category_translations (
    id                   SERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    service_category_id  INT          NOT NULL REFERENCES service_categories(id),
    language_id          INT          NOT NULL REFERENCES languages(id),
    name                 VARCHAR(150) NOT NULL,
    description          TEXT,
    created_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users(id),
    updated_by           BIGINT REFERENCES users(id),
    version              INT          NOT NULL DEFAULT 1,
    UNIQUE (service_category_id, language_id)
);

CREATE TABLE pricing_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(30)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE duration_units (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    unit_key     VARCHAR(20)  NOT NULL UNIQUE,
    label        VARCHAR(50)  NOT NULL,
    to_minutes   INT          NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE addon_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(50)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE staff_tiers (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    tier_key      VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE media_types (
    id                  SERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    type_key            VARCHAR(30)  NOT NULL UNIQUE,
    label               VARCHAR(100) NOT NULL,
    allowed_extensions  JSONB        NOT NULL DEFAULT '[]',
    max_size_mb         INT          NOT NULL DEFAULT 10,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT          NOT NULL DEFAULT 1
);

CREATE TABLE services (
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           VARCHAR(200),
    tenant_id             BIGINT       NOT NULL REFERENCES tenants(id),
    service_category_id   INT          NOT NULL REFERENCES service_categories(id),
    name                  VARCHAR(200) NOT NULL,
    description           TEXT,
    base_duration_minutes INT          NOT NULL,
    base_price            NUMERIC(12,2),
    pricing_type_id       INT REFERENCES pricing_types(id),
    is_active             BOOLEAN      NOT NULL DEFAULT TRUE,
    deleted_at            TIMESTAMPTZ,
    created_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by            BIGINT REFERENCES users(id),
    updated_by            BIGINT REFERENCES users(id),
    version               INT          NOT NULL DEFAULT 1
);

CREATE TABLE service_translations (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    service_id   BIGINT       NOT NULL REFERENCES services(id),
    language_id  INT          NOT NULL REFERENCES languages(id),
    name         VARCHAR(200) NOT NULL,
    description  TEXT,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1,
    UNIQUE (service_id, language_id)
);

CREATE TABLE service_variants (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    service_id       BIGINT        NOT NULL REFERENCES services(id),
    name             VARCHAR(150)  NOT NULL,
    description      TEXT,
    duration_minutes INT,
    price_override   NUMERIC(12,2),
    is_active        BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT           NOT NULL DEFAULT 1
);

CREATE TABLE service_addons (
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            VARCHAR(200),
    service_id             BIGINT        NOT NULL REFERENCES services(id),
    addon_type_id          INT REFERENCES addon_types(id),
    name                   VARCHAR(150)  NOT NULL,
    price                  NUMERIC(12,2) NOT NULL DEFAULT 0,
    duration_extra_minutes INT           NOT NULL DEFAULT 0,
    is_active              BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at             TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users(id),
    updated_by             BIGINT REFERENCES users(id),
    version                INT           NOT NULL DEFAULT 1
);

CREATE TABLE service_bundles (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    tenant_id     BIGINT        NOT NULL REFERENCES tenants(id),
    name          VARCHAR(200)  NOT NULL,
    description   TEXT,
    bundle_price  NUMERIC(12,2) NOT NULL,
    is_active     BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT           NOT NULL DEFAULT 1
);

CREATE TABLE branch_services (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    branch_id    BIGINT      NOT NULL REFERENCES branches(id),
    service_id   BIGINT      NOT NULL REFERENCES services(id),
    is_active    BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (branch_id, service_id)
);

CREATE TABLE service_pricing (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    branch_service_id  BIGINT        NOT NULL REFERENCES branch_services(id),
    pricing_type_id    INT REFERENCES pricing_types(id),
    price              NUMERIC(12,2) NOT NULL,
    currency_id        INT           NOT NULL REFERENCES currencies(id),
    valid_from         DATE,
    valid_until        DATE,
    created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT           NOT NULL DEFAULT 1
);

CREATE TABLE service_pricing_tiers (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    branch_service_id  BIGINT        NOT NULL REFERENCES branch_services(id),
    staff_tier_id      INT           NOT NULL REFERENCES staff_tiers(id),
    price              NUMERIC(12,2) NOT NULL,
    duration_override_minutes INT,
    created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT           NOT NULL DEFAULT 1,
    UNIQUE (branch_service_id, staff_tier_id)
);

CREATE TABLE service_duration_rules (
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           VARCHAR(200),
    branch_service_id     BIGINT      NOT NULL REFERENCES branch_services(id),
    duration_minutes      INT         NOT NULL,
    buffer_after_minutes  INT         NOT NULL DEFAULT 0,
    buffer_before_minutes INT         NOT NULL DEFAULT 0,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by            BIGINT REFERENCES users(id),
    updated_by            BIGINT REFERENCES users(id),
    version               INT         NOT NULL DEFAULT 1
);

CREATE TABLE service_availability_rules (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    branch_service_id  BIGINT      NOT NULL REFERENCES branch_services(id),
    day_of_week        SMALLINT    CHECK (day_of_week BETWEEN 0 AND 6),
    available_from     TIME,
    available_until    TIME,
    is_unavailable     BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT         NOT NULL DEFAULT 1
);

CREATE TABLE service_home_service_config (
    id                         BIGSERIAL PRIMARY KEY,
    internal_id                VARCHAR(200),
    branch_service_id          BIGINT        NOT NULL UNIQUE REFERENCES branch_services(id),
    is_home_service_available  BOOLEAN       NOT NULL DEFAULT FALSE,
    surcharge                  NUMERIC(12,2) NOT NULL DEFAULT 0,
    surcharge_type             VARCHAR(10)   NOT NULL DEFAULT 'flat'
        CHECK (surcharge_type IN ('flat','percent')),
    created_at                 TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at                 TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by                 BIGINT REFERENCES users(id),
    updated_by                 BIGINT REFERENCES users(id),
    version                    INT           NOT NULL DEFAULT 1
);

CREATE TABLE service_tags (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    tag_key      VARCHAR(50)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    is_active    BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE service_tag_assignments (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    service_id      BIGINT      NOT NULL REFERENCES services(id),
    service_tag_id  INT         NOT NULL REFERENCES service_tags(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1,
    UNIQUE (service_id, service_tag_id)
);

CREATE TABLE service_faqs (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    service_id    BIGINT      NOT NULL REFERENCES services(id),
    language_id   INT         NOT NULL REFERENCES languages(id),
    question      TEXT        NOT NULL,
    answer        TEXT        NOT NULL,
    display_order INT         NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT         NOT NULL DEFAULT 1
);

CREATE TABLE service_media (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    service_id      BIGINT      NOT NULL REFERENCES services(id),
    media_type_id   INT         NOT NULL REFERENCES media_types(id),
    url             TEXT        NOT NULL,
    alt_text        VARCHAR(255),
    display_order   INT         NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1
);

CREATE TABLE branch_media (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    branch_id      BIGINT      NOT NULL REFERENCES branches(id),
    media_type_id  INT         NOT NULL REFERENCES media_types(id),
    language_id    INT REFERENCES languages(id),
    url            TEXT        NOT NULL,
    caption        VARCHAR(255),
    display_order  INT         NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT         NOT NULL DEFAULT 1
);


-- ============================================================
-- DOMAIN 7: STAFF
-- ============================================================

CREATE TABLE staff (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    tenant_id      BIGINT       NOT NULL REFERENCES tenants(id),
    user_id        BIGINT REFERENCES users(id),
    staff_tier_id  INT REFERENCES staff_tiers(id),
    first_name     VARCHAR(100) NOT NULL,
    last_name      VARCHAR(100),
    display_name   VARCHAR(150),
    phone          VARCHAR(30),
    email          VARCHAR(255),
    gender         VARCHAR(20),
    date_of_birth  DATE,
    is_active      BOOLEAN      NOT NULL DEFAULT TRUE,
    deleted_at     TIMESTAMPTZ,
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT          NOT NULL DEFAULT 1
);

CREATE TABLE staff_profiles (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    staff_id         BIGINT      NOT NULL UNIQUE REFERENCES staff(id),
    bio              TEXT,
    experience_years INT,
    specialties      JSONB       NOT NULL DEFAULT '[]',
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT         NOT NULL DEFAULT 1
);

CREATE TABLE staff_media (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    staff_id       BIGINT      NOT NULL REFERENCES staff(id),
    media_type_id  INT         NOT NULL REFERENCES media_types(id),
    url            TEXT        NOT NULL,
    alt_text       VARCHAR(255),
    display_order  INT         NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT         NOT NULL DEFAULT 1
);

CREATE TABLE staff_branch_assignments (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    staff_id       BIGINT      NOT NULL REFERENCES staff(id),
    branch_id      BIGINT      NOT NULL REFERENCES branches(id),
    is_primary     BOOLEAN     NOT NULL DEFAULT FALSE,
    assigned_from  DATE,
    assigned_until DATE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT         NOT NULL DEFAULT 1,
    UNIQUE (staff_id, branch_id)
);

CREATE TABLE staff_services (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    staff_id           BIGINT      NOT NULL REFERENCES staff(id),
    branch_service_id  BIGINT      NOT NULL REFERENCES branch_services(id),
    is_active          BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT         NOT NULL DEFAULT 1,
    UNIQUE (staff_id, branch_service_id)
);

CREATE TABLE staff_working_hours (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    staff_id     BIGINT      NOT NULL REFERENCES staff(id),
    branch_id    BIGINT      NOT NULL REFERENCES branches(id),
    day_of_week  SMALLINT    NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    start_time   TIME        NOT NULL,
    end_time     TIME        NOT NULL,
    is_day_off   BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (staff_id, branch_id, day_of_week)
);

CREATE TABLE staff_availability_overrides (
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           VARCHAR(200),
    staff_id              BIGINT      NOT NULL REFERENCES staff(id),
    branch_id             BIGINT      NOT NULL REFERENCES branches(id),
    is_accepting_bookings BOOLEAN     NOT NULL DEFAULT TRUE,
    override_from         TIMESTAMPTZ,
    override_until        TIMESTAMPTZ,
    reason                VARCHAR(255),
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by            BIGINT REFERENCES users(id),
    updated_by            BIGINT REFERENCES users(id),
    version               INT         NOT NULL DEFAULT 1
);

CREATE TABLE break_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(30)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE staff_breaks (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    staff_id       BIGINT      NOT NULL REFERENCES staff(id),
    branch_id      BIGINT      NOT NULL REFERENCES branches(id),
    break_type_id  INT REFERENCES break_types(id),
    break_date     DATE        NOT NULL,
    start_time     TIME        NOT NULL,
    end_time       TIME        NOT NULL,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT         NOT NULL DEFAULT 1
);

CREATE TABLE leave_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(30)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    is_paid      BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE staff_leaves (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    staff_id       BIGINT      NOT NULL REFERENCES staff(id),
    leave_type_id  INT         NOT NULL REFERENCES leave_types(id),
    start_date     DATE        NOT NULL,
    end_date       DATE        NOT NULL,
    reason         TEXT,
    approved_by    BIGINT REFERENCES users(id),
    status         VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','approved','rejected','cancelled')),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT         NOT NULL DEFAULT 1
);

CREATE TABLE staff_commissions (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    staff_id           BIGINT       NOT NULL REFERENCES staff(id),
    branch_service_id  BIGINT REFERENCES branch_services(id),
    commission_type    VARCHAR(10)  NOT NULL DEFAULT 'percent'
        CHECK (commission_type IN ('percent','flat')),
    commission_value   NUMERIC(8,4) NOT NULL,
    valid_from         DATE,
    valid_until        DATE,
    created_at         TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT          NOT NULL DEFAULT 1
);

CREATE TABLE staff_home_service_eligibility (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    staff_id         BIGINT       NOT NULL UNIQUE REFERENCES staff(id),
    is_eligible      BOOLEAN      NOT NULL DEFAULT FALSE,
    max_distance_km  NUMERIC(8,2),
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT          NOT NULL DEFAULT 1
);



-- ============================================================
-- DOMAIN 8: CANCELLATION AND NO-SHOW POLICY
-- ============================================================

CREATE TABLE cancellation_reasons (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    reason_key    VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(150) NOT NULL,
    actor         VARCHAR(20)  NOT NULL CHECK (actor IN ('customer','merchant','system')),
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE reschedule_reasons (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    reason_key    VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(150) NOT NULL,
    actor         VARCHAR(20)  NOT NULL CHECK (actor IN ('customer','merchant','system')),
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE no_show_reasons (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    reason_key    VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(150) NOT NULL,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE cancellation_policies (
    id                      BIGSERIAL PRIMARY KEY,
    internal_id             VARCHAR(200),
    branch_id               BIGINT        NOT NULL REFERENCES branches(id),
    free_cancellation_hours INT           NOT NULL DEFAULT 24,
    late_fee_type           VARCHAR(10)   NOT NULL DEFAULT 'flat'
        CHECK (late_fee_type IN ('flat','percent')),
    late_fee_value          NUMERIC(12,2) NOT NULL DEFAULT 0,
    policy_text             TEXT,
    is_active               BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by              BIGINT REFERENCES users(id),
    updated_by              BIGINT REFERENCES users(id),
    version                 INT           NOT NULL DEFAULT 1
);

CREATE TABLE no_show_policies (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    branch_id    BIGINT        NOT NULL REFERENCES branches(id),
    fee_type     VARCHAR(10)   NOT NULL DEFAULT 'flat'
        CHECK (fee_type IN ('flat','percent')),
    fee_value    NUMERIC(12,2) NOT NULL DEFAULT 0,
    charge_mode  VARCHAR(10)   NOT NULL DEFAULT 'manual'
        CHECK (charge_mode IN ('auto','manual')),
    is_active    BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT           NOT NULL DEFAULT 1
);

CREATE TABLE deposit_rules (
    id                         BIGSERIAL PRIMARY KEY,
    internal_id                VARCHAR(200),
    branch_service_id          BIGINT REFERENCES branch_services(id),
    branch_id                  BIGINT REFERENCES branches(id),
    deposit_type               VARCHAR(10)   NOT NULL DEFAULT 'flat'
        CHECK (deposit_type IN ('flat','percent')),
    deposit_value              NUMERIC(12,2) NOT NULL DEFAULT 0,
    refund_policy_text         TEXT,
    full_refund_until_hours    INT,
    partial_refund_percent     NUMERIC(5,2),
    partial_refund_until_hours INT,
    created_at                 TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at                 TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by                 BIGINT REFERENCES users(id),
    updated_by                 BIGINT REFERENCES users(id),
    version                    INT           NOT NULL DEFAULT 1
);


-- ============================================================
-- DOMAIN 9: BOOKING
-- ============================================================

CREATE TABLE appointment_statuses (
    id                  SERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    status_key          VARCHAR(50)  NOT NULL UNIQUE,
    label               VARCHAR(100) NOT NULL,
    color_hex           VARCHAR(7),
    is_terminal         BOOLEAN      NOT NULL DEFAULT FALSE,
    is_customer_visible BOOLEAN      NOT NULL DEFAULT TRUE,
    display_order       INT          NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT          NOT NULL DEFAULT 1
);

CREATE TABLE appointment_status_transitions (
    id              SERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    from_status_id  INT         NOT NULL REFERENCES appointment_statuses(id),
    to_status_id    INT         NOT NULL REFERENCES appointment_statuses(id),
    actor           VARCHAR(20) NOT NULL CHECK (actor IN ('customer','merchant','system')),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1,
    UNIQUE (from_status_id, to_status_id, actor)
);

CREATE TABLE group_bookings (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    tenant_id        BIGINT      NOT NULL REFERENCES tenants(id),
    branch_id        BIGINT      NOT NULL REFERENCES branches(id),
    lead_customer_id BIGINT      NOT NULL REFERENCES users(id),
    group_name       VARCHAR(200),
    party_size       INT         NOT NULL DEFAULT 1,
    booking_date     DATE        NOT NULL,
    status_key       VARCHAR(50) NOT NULL DEFAULT 'pending',
    notes            TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT         NOT NULL DEFAULT 1
);

CREATE TABLE appointments (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    tenant_id        BIGINT      NOT NULL REFERENCES tenants(id),
    branch_id        BIGINT      NOT NULL REFERENCES branches(id),
    customer_id      BIGINT      NOT NULL REFERENCES users(id),
    group_booking_id BIGINT REFERENCES group_bookings(id),
    status_id        INT         NOT NULL REFERENCES appointment_statuses(id),
    service_location VARCHAR(15) NOT NULL DEFAULT 'in_store'
        CHECK (service_location IN ('in_store','home_service')),
    home_address_id  BIGINT REFERENCES user_addresses(id),
    appointment_date DATE        NOT NULL,
    start_time       TIME        NOT NULL,
    end_time         TIME        NOT NULL,
    total_amount     NUMERIC(12,2),
    currency_id      INT REFERENCES currencies(id),
    notes            TEXT,
    deleted_at       TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT         NOT NULL DEFAULT 1
);

CREATE TABLE group_booking_members (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    group_booking_id BIGINT      NOT NULL REFERENCES group_bookings(id),
    appointment_id   BIGINT      NOT NULL REFERENCES appointments(id),
    customer_name    VARCHAR(150),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT         NOT NULL DEFAULT 1,
    UNIQUE (group_booking_id, appointment_id)
);

CREATE TABLE appointment_services (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    appointment_id      BIGINT        NOT NULL REFERENCES appointments(id),
    branch_service_id   BIGINT        NOT NULL REFERENCES branch_services(id),
    service_variant_id  BIGINT REFERENCES service_variants(id),
    duration_minutes    INT           NOT NULL,
    price               NUMERIC(12,2) NOT NULL,
    sequence_order      INT           NOT NULL DEFAULT 1,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT           NOT NULL DEFAULT 1
);

CREATE TABLE appointment_staff_assignments (
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            VARCHAR(200),
    appointment_id         BIGINT      NOT NULL REFERENCES appointments(id),
    appointment_service_id BIGINT REFERENCES appointment_services(id),
    staff_id               BIGINT      NOT NULL REFERENCES staff(id),
    is_primary             BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users(id),
    updated_by             BIGINT REFERENCES users(id),
    version                INT         NOT NULL DEFAULT 1
);

CREATE TABLE appointment_status_history (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    appointment_id   BIGINT      NOT NULL REFERENCES appointments(id),
    status_id        INT         NOT NULL REFERENCES appointment_statuses(id),
    changed_by       BIGINT REFERENCES users(id),
    changed_by_role  VARCHAR(30),
    reason           TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT         NOT NULL DEFAULT 1
);

CREATE TABLE appointment_notes (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    appointment_id  BIGINT      NOT NULL REFERENCES appointments(id),
    author_id       BIGINT      NOT NULL REFERENCES users(id),
    note            TEXT        NOT NULL,
    is_internal     BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1
);

CREATE TABLE appointment_reschedule_history (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    appointment_id      BIGINT      NOT NULL REFERENCES appointments(id),
    previous_date       DATE        NOT NULL,
    previous_start_time TIME        NOT NULL,
    new_date            DATE        NOT NULL,
    new_start_time      TIME        NOT NULL,
    reason_id           INT REFERENCES reschedule_reasons(id),
    rescheduled_by      BIGINT REFERENCES users(id),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT         NOT NULL DEFAULT 1
);

CREATE TABLE appointment_cancellations (
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    appointment_id       BIGINT        NOT NULL UNIQUE REFERENCES appointments(id),
    reason_id            INT REFERENCES cancellation_reasons(id),
    cancelled_by         BIGINT REFERENCES users(id),
    cancelled_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    is_late_cancellation BOOLEAN       NOT NULL DEFAULT FALSE,
    late_fee_applicable  NUMERIC(12,2),
    created_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users(id),
    updated_by           BIGINT REFERENCES users(id),
    version              INT           NOT NULL DEFAULT 1
);

CREATE TABLE appointment_checkins (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    appointment_id  BIGINT      NOT NULL UNIQUE REFERENCES appointments(id),
    checked_in_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    check_in_method VARCHAR(20) NOT NULL DEFAULT 'manual'
        CHECK (check_in_method IN ('qr','manual','app')),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1
);

CREATE TABLE slot_holds (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    branch_id          BIGINT      NOT NULL REFERENCES branches(id),
    staff_id           BIGINT      NOT NULL REFERENCES staff(id),
    branch_service_id  BIGINT      NOT NULL REFERENCES branch_services(id),
    customer_id        BIGINT      NOT NULL REFERENCES users(id),
    slot_date          DATE        NOT NULL,
    slot_start         TIME        NOT NULL,
    slot_end           TIME        NOT NULL,
    expires_at         TIMESTAMPTZ NOT NULL,
    is_converted       BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT         NOT NULL DEFAULT 1
);

CREATE TABLE waitlists (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    branch_id           BIGINT      NOT NULL REFERENCES branches(id),
    customer_id         BIGINT      NOT NULL REFERENCES users(id),
    branch_service_id   BIGINT      NOT NULL REFERENCES branch_services(id),
    preferred_date      DATE,
    preferred_staff_id  BIGINT REFERENCES staff(id),
    status              VARCHAR(20) NOT NULL DEFAULT 'waiting'
        CHECK (status IN ('waiting','notified','booked','expired','cancelled')),
    notified_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT         NOT NULL DEFAULT 1
);

CREATE TABLE queue_tokens (
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            VARCHAR(200),
    branch_id              BIGINT      NOT NULL REFERENCES branches(id),
    customer_id            BIGINT REFERENCES users(id),
    token_number           INT         NOT NULL,
    token_date             DATE        NOT NULL,
    branch_service_id      BIGINT REFERENCES branch_services(id),
    estimated_wait_minutes INT,
    status                 VARCHAR(20) NOT NULL DEFAULT 'waiting'
        CHECK (status IN ('waiting','called','in_service','completed','cancelled','no_show')),
    issued_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    called_at              TIMESTAMPTZ,
    completed_at           TIMESTAMPTZ,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users(id),
    updated_by             BIGINT REFERENCES users(id),
    version                INT         NOT NULL DEFAULT 1
);

CREATE TABLE cancellation_fee_charges (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    appointment_id  BIGINT        NOT NULL REFERENCES appointments(id),
    amount          NUMERIC(12,2) NOT NULL,
    currency_id     INT           NOT NULL REFERENCES currencies(id),
    charge_status   VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (charge_status IN ('pending','charged','waived','failed')),
    charged_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT           NOT NULL DEFAULT 1
);

CREATE TABLE no_show_fee_charges (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    appointment_id  BIGINT        NOT NULL REFERENCES appointments(id),
    reason_id       INT REFERENCES no_show_reasons(id),
    amount          NUMERIC(12,2) NOT NULL,
    currency_id     INT           NOT NULL REFERENCES currencies(id),
    charge_status   VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (charge_status IN ('pending','charged','waived','failed')),
    charged_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT           NOT NULL DEFAULT 1
);

CREATE TABLE no_show_records (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    appointment_id  BIGINT      NOT NULL UNIQUE REFERENCES appointments(id),
    customer_id     BIGINT      NOT NULL REFERENCES users(id),
    branch_id       BIGINT      NOT NULL REFERENCES branches(id),
    marked_by       BIGINT REFERENCES users(id),
    marked_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1
);



-- ============================================================
-- DOMAIN 10: NOTIFICATIONS
-- ============================================================

CREATE TABLE communication_channels (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    channel_key  VARCHAR(30)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    is_active    BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE notification_types (
    id                       SERIAL PRIMARY KEY,
    internal_id              VARCHAR(200),
    type_key                 VARCHAR(100) NOT NULL UNIQUE,
    label                    VARCHAR(150) NOT NULL,
    trigger_event            VARCHAR(100),
    default_channel_key      VARCHAR(30),
    is_customer_configurable BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at               TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by               BIGINT REFERENCES users(id),
    updated_by               BIGINT REFERENCES users(id),
    version                  INT          NOT NULL DEFAULT 1
);

CREATE TABLE notification_preference_options (
    id                   SERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    notification_type_id INT         NOT NULL REFERENCES notification_types(id),
    channel_id           INT         NOT NULL REFERENCES communication_channels(id),
    default_enabled      BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users(id),
    updated_by           BIGINT REFERENCES users(id),
    version              INT         NOT NULL DEFAULT 1,
    UNIQUE (notification_type_id, channel_id)
);

CREATE TABLE notification_templates (
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    notification_type_id INT         NOT NULL REFERENCES notification_types(id),
    channel_id           INT         NOT NULL REFERENCES communication_channels(id),
    language_id          INT         NOT NULL REFERENCES languages(id),
    tenant_id            BIGINT REFERENCES tenants(id),
    subject              VARCHAR(255),
    body                 TEXT        NOT NULL,
    is_active            BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users(id),
    updated_by           BIGINT REFERENCES users(id),
    version              INT         NOT NULL DEFAULT 1
);

CREATE TABLE notification_template_translations (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    template_id  BIGINT      NOT NULL REFERENCES notification_templates(id),
    language_id  INT         NOT NULL REFERENCES languages(id),
    subject      VARCHAR(255),
    body         TEXT        NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (template_id, language_id)
);

CREATE TABLE notifications (
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    tenant_id            BIGINT REFERENCES tenants(id),
    user_id              BIGINT      NOT NULL REFERENCES users(id),
    notification_type_id INT REFERENCES notification_types(id),
    channel_id           INT         NOT NULL REFERENCES communication_channels(id),
    title                VARCHAR(255),
    body                 TEXT        NOT NULL,
    reference_type       VARCHAR(50),
    reference_id         BIGINT,
    is_read              BOOLEAN     NOT NULL DEFAULT FALSE,
    read_at              TIMESTAMPTZ,
    scheduled_at         TIMESTAMPTZ,
    sent_at              TIMESTAMPTZ,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users(id),
    updated_by           BIGINT REFERENCES users(id),
    version              INT         NOT NULL DEFAULT 1
);

CREATE TABLE notification_logs (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    notification_id     BIGINT      NOT NULL REFERENCES notifications(id),
    status              VARCHAR(20) NOT NULL
        CHECK (status IN ('queued','sent','delivered','failed','bounced')),
    provider_message_id VARCHAR(255),
    error_message       TEXT,
    attempted_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT         NOT NULL DEFAULT 1
);

CREATE TABLE in_app_messages (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    user_id      BIGINT      NOT NULL REFERENCES users(id),
    title        VARCHAR(255) NOT NULL,
    body         TEXT         NOT NULL,
    action_url   TEXT,
    is_read      BOOLEAN      NOT NULL DEFAULT FALSE,
    read_at      TIMESTAMPTZ,
    expires_at   TIMESTAMPTZ,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);


-- ============================================================
-- DOMAIN 11: CUSTOMER ENGAGEMENT
-- ============================================================

CREATE TABLE favorites (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    user_id      BIGINT      NOT NULL REFERENCES users(id),
    branch_id    BIGINT      NOT NULL REFERENCES branches(id),
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (user_id, branch_id)
);

CREATE TABLE reviews (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    appointment_id     BIGINT      NOT NULL UNIQUE REFERENCES appointments(id),
    customer_id        BIGINT      NOT NULL REFERENCES users(id),
    branch_id          BIGINT      NOT NULL REFERENCES branches(id),
    staff_id           BIGINT REFERENCES staff(id),
    overall_rating     SMALLINT    NOT NULL CHECK (overall_rating BETWEEN 1 AND 5),
    cleanliness_rating SMALLINT    CHECK (cleanliness_rating BETWEEN 1 AND 5),
    staff_rating       SMALLINT    CHECK (staff_rating BETWEEN 1 AND 5),
    value_rating       SMALLINT    CHECK (value_rating BETWEEN 1 AND 5),
    review_text        TEXT,
    is_published       BOOLEAN     NOT NULL DEFAULT FALSE,
    moderated_at       TIMESTAMPTZ,
    moderated_by       BIGINT REFERENCES users(id),
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT         NOT NULL DEFAULT 1
);

CREATE TABLE review_replies (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    review_id    BIGINT      NOT NULL UNIQUE REFERENCES reviews(id),
    replied_by   BIGINT      NOT NULL REFERENCES users(id),
    reply_text   TEXT        NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1
);

CREATE TABLE ratings_summary (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    branch_id           BIGINT       NOT NULL UNIQUE REFERENCES branches(id),
    total_reviews       INT          NOT NULL DEFAULT 0,
    average_overall     NUMERIC(3,2) NOT NULL DEFAULT 0,
    average_cleanliness NUMERIC(3,2),
    average_staff       NUMERIC(3,2),
    average_value       NUMERIC(3,2),
    last_updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT          NOT NULL DEFAULT 1
);

CREATE TABLE customer_notes (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    branch_id    BIGINT      NOT NULL REFERENCES branches(id),
    customer_id  BIGINT      NOT NULL REFERENCES users(id),
    note         TEXT        NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT      NOT NULL REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1
);

CREATE TABLE customer_tags (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    branch_id    BIGINT      NOT NULL REFERENCES branches(id),
    customer_id  BIGINT      NOT NULL REFERENCES users(id),
    tag          VARCHAR(50) NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT      NOT NULL REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (branch_id, customer_id, tag)
);


-- ============================================================
-- DOMAIN 12: PAYMENTS
-- ============================================================

CREATE TABLE payment_statuses (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    status_key    VARCHAR(30)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    is_terminal   BOOLEAN      NOT NULL DEFAULT FALSE,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE payment_methods_master (
    id              SERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    method_type_key VARCHAR(30)  NOT NULL UNIQUE,
    label           VARCHAR(100) NOT NULL,
    icon_key        VARCHAR(50),
    is_online       BOOLEAN      NOT NULL DEFAULT TRUE,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    display_order   INT          NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT          NOT NULL DEFAULT 1
);

CREATE TABLE transaction_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(50)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE refund_reasons (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    reason_key   VARCHAR(50)  NOT NULL UNIQUE,
    label        VARCHAR(150) NOT NULL,
    actor        VARCHAR(20)  NOT NULL CHECK (actor IN ('customer','merchant','system','admin')),
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE tax_rules (
    id              SERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    country_id      INT           NOT NULL REFERENCES countries(id),
    state_id        INT REFERENCES states(id),
    locale_id       INT REFERENCES locales(id),
    tax_name        VARCHAR(50)   NOT NULL,
    rate            NUMERIC(6,4)  NOT NULL,
    applies_to      VARCHAR(30),
    is_active       BOOLEAN       NOT NULL DEFAULT TRUE,
    effective_from  DATE,
    effective_until DATE,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT           NOT NULL DEFAULT 1
);

CREATE TABLE payment_methods (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    user_id         BIGINT      NOT NULL REFERENCES users(id),
    method_type_id  INT         NOT NULL REFERENCES payment_methods_master(id),
    provider        VARCHAR(50),
    provider_token  TEXT,
    last_four       VARCHAR(4),
    expiry_month    SMALLINT,
    expiry_year     SMALLINT,
    is_default      BOOLEAN     NOT NULL DEFAULT FALSE,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1
);

CREATE TABLE payments (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    tenant_id           BIGINT        NOT NULL REFERENCES tenants(id),
    appointment_id      BIGINT REFERENCES appointments(id),
    customer_id         BIGINT        NOT NULL REFERENCES users(id),
    payment_method_id   BIGINT REFERENCES payment_methods(id),
    transaction_type_id INT           NOT NULL REFERENCES transaction_types(id),
    status_id           INT           NOT NULL REFERENCES payment_statuses(id),
    amount              NUMERIC(12,2) NOT NULL,
    currency_id         INT           NOT NULL REFERENCES currencies(id),
    provider            VARCHAR(50),
    provider_reference  VARCHAR(255),
    paid_at             TIMESTAMPTZ,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT           NOT NULL DEFAULT 1
);

CREATE TABLE payment_transactions (
    id                      BIGSERIAL PRIMARY KEY,
    internal_id             VARCHAR(200),
    payment_id              BIGINT        NOT NULL REFERENCES payments(id),
    transaction_type_id     INT           NOT NULL REFERENCES transaction_types(id),
    amount                  NUMERIC(12,2) NOT NULL,
    currency_id             INT           NOT NULL REFERENCES currencies(id),
    provider_transaction_id VARCHAR(255),
    status                  VARCHAR(30)   NOT NULL,
    metadata                JSONB         NOT NULL DEFAULT '{}',
    created_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by              BIGINT REFERENCES users(id),
    updated_by              BIGINT REFERENCES users(id),
    version                 INT           NOT NULL DEFAULT 1
);

CREATE TABLE refunds (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    payment_id         BIGINT        NOT NULL REFERENCES payments(id),
    reason_id          INT REFERENCES refund_reasons(id),
    amount             NUMERIC(12,2) NOT NULL,
    currency_id        INT           NOT NULL REFERENCES currencies(id),
    status             VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','processed','failed')),
    provider_refund_id VARCHAR(255),
    refunded_at        TIMESTAMPTZ,
    initiated_by       BIGINT REFERENCES users(id),
    created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT           NOT NULL DEFAULT 1
);

CREATE TABLE invoices (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    appointment_id  BIGINT        REFERENCES appointments(id),
    customer_id     BIGINT        NOT NULL REFERENCES users(id),
    branch_id       BIGINT        NOT NULL REFERENCES branches(id),
    currency_id     INT           NOT NULL REFERENCES currencies(id),
    invoice_number  VARCHAR(50)   UNIQUE,
    subtotal        NUMERIC(12,2) NOT NULL,
    tax_amount      NUMERIC(12,2) NOT NULL DEFAULT 0,
    discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    tip_amount      NUMERIC(12,2) NOT NULL DEFAULT 0,
    total_amount    NUMERIC(12,2) NOT NULL,
    status          VARCHAR(20)   NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft','issued','paid','void')),
    issued_at       TIMESTAMPTZ,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT           NOT NULL DEFAULT 1
);

CREATE TABLE invoice_items (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    invoice_id   BIGINT        NOT NULL REFERENCES invoices(id),
    description  VARCHAR(255)  NOT NULL,
    quantity     INT           NOT NULL DEFAULT 1,
    unit_price   NUMERIC(12,2) NOT NULL,
    total_price  NUMERIC(12,2) NOT NULL,
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT           NOT NULL DEFAULT 1
);

CREATE TABLE tips (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    appointment_id  BIGINT        NOT NULL REFERENCES appointments(id),
    payment_id      BIGINT        NOT NULL REFERENCES payments(id),
    staff_id        BIGINT REFERENCES staff(id),
    amount          NUMERIC(12,2) NOT NULL,
    currency_id     INT           NOT NULL REFERENCES currencies(id),
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT           NOT NULL DEFAULT 1
);



-- ============================================================
-- DOMAIN 13: COMMERCIAL AND SETTLEMENT
-- ============================================================

CREATE TABLE placement_products (
    id             SERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    placement_type VARCHAR(50)   NOT NULL,
    name           VARCHAR(150)  NOT NULL,
    description    TEXT,
    duration_days  INT           NOT NULL,
    price          NUMERIC(12,2) NOT NULL,
    currency_id    INT           NOT NULL REFERENCES currencies(id),
    is_active      BOOLEAN       NOT NULL DEFAULT TRUE,
    display_order  INT           NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT           NOT NULL DEFAULT 1
);

CREATE TABLE commission_rules (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    tenant_id       BIGINT REFERENCES tenants(id),
    fee_type        VARCHAR(30)  NOT NULL
        CHECK (fee_type IN ('booking','cancellation_fee','no_show_fee','placement')),
    rate            NUMERIC(6,4) NOT NULL,
    effective_from  DATE,
    effective_until DATE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT          NOT NULL DEFAULT 1
);

CREATE TABLE platform_fee_charges (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    tenant_id       BIGINT        NOT NULL REFERENCES tenants(id),
    appointment_id  BIGINT REFERENCES appointments(id),
    payment_id      BIGINT REFERENCES payments(id),
    fee_type        VARCHAR(30)   NOT NULL,
    gross_amount    NUMERIC(12,2) NOT NULL,
    commission_rate NUMERIC(6,4)  NOT NULL,
    fee_amount      NUMERIC(12,2) NOT NULL,
    currency_id     INT           NOT NULL REFERENCES currencies(id),
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT           NOT NULL DEFAULT 1
);

CREATE TABLE promotion_placement_orders (
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    tenant_id            BIGINT        NOT NULL REFERENCES tenants(id),
    branch_id            BIGINT REFERENCES branches(id),
    service_id           BIGINT REFERENCES services(id),
    placement_product_id INT           NOT NULL REFERENCES placement_products(id),
    amount_paid          NUMERIC(12,2) NOT NULL,
    currency_id          INT           NOT NULL REFERENCES currencies(id),
    start_date           DATE          NOT NULL,
    end_date             DATE          NOT NULL,
    status               VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','active','completed','cancelled')),
    created_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users(id),
    updated_by           BIGINT REFERENCES users(id),
    version              INT           NOT NULL DEFAULT 1
);

CREATE TABLE settlements (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    tenant_id        BIGINT        NOT NULL REFERENCES tenants(id),
    period_start     DATE          NOT NULL,
    period_end       DATE          NOT NULL,
    currency_id      INT           NOT NULL REFERENCES currencies(id),
    gross_amount     NUMERIC(12,2) NOT NULL DEFAULT 0,
    commission_total NUMERIC(12,2) NOT NULL DEFAULT 0,
    refunds_total    NUMERIC(12,2) NOT NULL DEFAULT 0,
    disputes_held    NUMERIC(12,2) NOT NULL DEFAULT 0,
    net_amount       NUMERIC(12,2) NOT NULL DEFAULT 0,
    status           VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','under_review','approved','paid','failed')),
    approved_by      BIGINT REFERENCES users(id),
    approved_at      TIMESTAMPTZ,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT           NOT NULL DEFAULT 1
);

CREATE TABLE settlement_items (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    settlement_id    BIGINT        NOT NULL REFERENCES settlements(id),
    reference_type   VARCHAR(30)   NOT NULL
        CHECK (reference_type IN ('appointment','refund','cancellation_fee','no_show_fee','placement','adjustment')),
    reference_id     BIGINT        NOT NULL,
    gross_amount     NUMERIC(12,2) NOT NULL,
    deduction_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    net_amount       NUMERIC(12,2) NOT NULL,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT           NOT NULL DEFAULT 1
);

CREATE TABLE payout_batches (
    id                BIGSERIAL PRIMARY KEY,
    internal_id       VARCHAR(200),
    settlement_ids    JSONB         NOT NULL DEFAULT '[]',
    provider_batch_id VARCHAR(255),
    status            VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','initiated','confirmed','failed')),
    total_amount      NUMERIC(12,2) NOT NULL,
    currency_id       INT           NOT NULL REFERENCES currencies(id),
    initiated_at      TIMESTAMPTZ,
    confirmed_at      TIMESTAMPTZ,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by        BIGINT REFERENCES users(id),
    updated_by        BIGINT REFERENCES users(id),
    version           INT           NOT NULL DEFAULT 1
);

CREATE TABLE merchant_subscriptions (
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          VARCHAR(200),
    tenant_id            BIGINT      NOT NULL REFERENCES tenants(id),
    plan_id              INT         NOT NULL REFERENCES subscription_plans(id),
    status               VARCHAR(30) NOT NULL DEFAULT 'trial'
        CHECK (status IN ('trial','active','grace','suspended','cancelled','expired')),
    billing_interval     VARCHAR(10) NOT NULL DEFAULT 'monthly'
        CHECK (billing_interval IN ('monthly','annually')),
    current_period_start DATE        NOT NULL,
    current_period_end   DATE        NOT NULL,
    trial_ends_at        TIMESTAMPTZ,
    cancelled_at         TIMESTAMPTZ,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users(id),
    updated_by           BIGINT REFERENCES users(id),
    version              INT         NOT NULL DEFAULT 1
);


-- ============================================================
-- DOMAIN 14: PROMOTIONS AND LOYALTY
-- ============================================================

CREATE TABLE promotion_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(50)  NOT NULL UNIQUE,
    label        VARCHAR(150) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE campaign_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(50)  NOT NULL UNIQUE,
    label        VARCHAR(150) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE loyalty_transaction_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(30)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE wallet_transaction_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(30)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE promotions (
    id                BIGSERIAL PRIMARY KEY,
    internal_id       VARCHAR(200),
    tenant_id         BIGINT        NOT NULL REFERENCES tenants(id),
    branch_id         BIGINT REFERENCES branches(id),
    promotion_type_id INT           NOT NULL REFERENCES promotion_types(id),
    name              VARCHAR(200)  NOT NULL,
    description       TEXT,
    discount_value    NUMERIC(12,2),
    discount_type     VARCHAR(10)   CHECK (discount_type IN ('flat','percent')),
    min_booking_value NUMERIC(12,2),
    valid_from        TIMESTAMPTZ,
    valid_until       TIMESTAMPTZ,
    usage_limit       INT,
    usage_count       INT           NOT NULL DEFAULT 0,
    is_active         BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by        BIGINT REFERENCES users(id),
    updated_by        BIGINT REFERENCES users(id),
    version           INT           NOT NULL DEFAULT 1
);

CREATE TABLE promo_codes (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    promotion_id  BIGINT      NOT NULL REFERENCES promotions(id),
    code          VARCHAR(50) NOT NULL UNIQUE,
    usage_limit   INT,
    usage_count   INT         NOT NULL DEFAULT 0,
    is_active     BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT         NOT NULL DEFAULT 1
);

CREATE TABLE promo_redemptions (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    promo_code_id    BIGINT        NOT NULL REFERENCES promo_codes(id),
    appointment_id   BIGINT        NOT NULL REFERENCES appointments(id),
    customer_id      BIGINT        NOT NULL REFERENCES users(id),
    discount_applied NUMERIC(12,2) NOT NULL,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT           NOT NULL DEFAULT 1
);

CREATE TABLE campaigns (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    tenant_id        BIGINT      NOT NULL REFERENCES tenants(id),
    campaign_type_id INT         NOT NULL REFERENCES campaign_types(id),
    name             VARCHAR(200) NOT NULL,
    description      TEXT,
    start_date       DATE,
    end_date         DATE,
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT         NOT NULL DEFAULT 1
);

CREATE TABLE referrals (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    referrer_id   BIGINT        NOT NULL REFERENCES users(id),
    referred_id   BIGINT        NOT NULL REFERENCES users(id),
    tenant_id     BIGINT        NOT NULL REFERENCES tenants(id),
    status        VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','qualified','rewarded','expired')),
    reward_amount NUMERIC(12,2),
    qualified_at  TIMESTAMPTZ,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT           NOT NULL DEFAULT 1
);

CREATE TABLE membership_plans (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    tenant_id        BIGINT        NOT NULL REFERENCES tenants(id),
    name             VARCHAR(150)  NOT NULL,
    description      TEXT,
    price            NUMERIC(12,2) NOT NULL,
    billing_interval VARCHAR(10)   NOT NULL DEFAULT 'monthly'
        CHECK (billing_interval IN ('monthly','annually')),
    currency_id      INT           NOT NULL REFERENCES currencies(id),
    benefits         JSONB         NOT NULL DEFAULT '{}',
    is_active        BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT           NOT NULL DEFAULT 1
);

CREATE TABLE memberships (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    tenant_id    BIGINT       NOT NULL REFERENCES tenants(id),
    name         VARCHAR(150) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE customer_memberships (
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200),
    customer_id        BIGINT      NOT NULL REFERENCES users(id),
    membership_plan_id BIGINT      NOT NULL REFERENCES membership_plans(id),
    status             VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('active','expired','cancelled','suspended')),
    started_at         DATE        NOT NULL,
    expires_at         DATE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users(id),
    updated_by         BIGINT REFERENCES users(id),
    version            INT         NOT NULL DEFAULT 1
);

CREATE TABLE loyalty_accounts (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    customer_id     BIGINT      NOT NULL REFERENCES users(id),
    tenant_id       BIGINT      NOT NULL REFERENCES tenants(id),
    points_balance  INT         NOT NULL DEFAULT 0,
    lifetime_points INT         NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1,
    UNIQUE (customer_id, tenant_id)
);

CREATE TABLE loyalty_transactions (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    loyalty_account_id  BIGINT      NOT NULL REFERENCES loyalty_accounts(id),
    transaction_type_id INT         NOT NULL REFERENCES loyalty_transaction_types(id),
    points              INT         NOT NULL,
    reference_type      VARCHAR(30),
    reference_id        BIGINT,
    expires_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT         NOT NULL DEFAULT 1
);

CREATE TABLE wallets (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    customer_id  BIGINT        NOT NULL REFERENCES users(id),
    tenant_id    BIGINT        NOT NULL REFERENCES tenants(id),
    currency_id  INT           NOT NULL REFERENCES currencies(id),
    balance      NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT           NOT NULL DEFAULT 1,
    UNIQUE (customer_id, tenant_id)
);

CREATE TABLE wallet_transactions (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    wallet_id           BIGINT        NOT NULL REFERENCES wallets(id),
    transaction_type_id INT           NOT NULL REFERENCES wallet_transaction_types(id),
    amount              NUMERIC(12,2) NOT NULL,
    reference_type      VARCHAR(30),
    reference_id        BIGINT,
    description         TEXT,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT           NOT NULL DEFAULT 1
);

CREATE TABLE gift_cards (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    tenant_id       BIGINT        NOT NULL REFERENCES tenants(id),
    code            VARCHAR(50)   NOT NULL UNIQUE,
    currency_id     INT           NOT NULL REFERENCES currencies(id),
    initial_value   NUMERIC(12,2) NOT NULL,
    remaining_value NUMERIC(12,2) NOT NULL,
    purchased_by    BIGINT REFERENCES users(id),
    redeemed_by     BIGINT REFERENCES users(id),
    status          VARCHAR(20)   NOT NULL DEFAULT 'active'
        CHECK (status IN ('active','redeemed','expired','cancelled')),
    expires_at      DATE,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT           NOT NULL DEFAULT 1
);



-- ============================================================
-- DOMAIN 15: ADMIN AND COMPLIANCE
-- ============================================================

CREATE TABLE verification_statuses (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    status_key    VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    is_terminal   BOOLEAN      NOT NULL DEFAULT FALSE,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE kyc_document_types (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    type_key      VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(150) NOT NULL,
    required_for  VARCHAR(20)  NOT NULL CHECK (required_for IN ('individual','business','both')),
    is_required   BOOLEAN      NOT NULL DEFAULT TRUE,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE merchant_suspension_reasons (
    id                  SERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    reason_key          VARCHAR(50)  NOT NULL UNIQUE,
    label               VARCHAR(150) NOT NULL,
    is_system_generated BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT          NOT NULL DEFAULT 1
);

CREATE TABLE dispute_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    type_key     VARCHAR(50)  NOT NULL UNIQUE,
    label        VARCHAR(150) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE dispute_statuses (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    status_key    VARCHAR(30)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    is_terminal   BOOLEAN      NOT NULL DEFAULT FALSE,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE complaint_categories (
    id               SERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    category_key     VARCHAR(50)  NOT NULL UNIQUE,
    label            VARCHAR(150) NOT NULL,
    escalation_level SMALLINT     NOT NULL DEFAULT 1,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT          NOT NULL DEFAULT 1
);

CREATE TABLE support_ticket_statuses (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    status_key    VARCHAR(30)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    is_terminal   BOOLEAN      NOT NULL DEFAULT FALSE,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE support_ticket_priorities (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    priority_key  VARCHAR(20)  NOT NULL UNIQUE,
    label         VARCHAR(50)  NOT NULL,
    sla_hours     INT          NOT NULL,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE system_event_types (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    event_key    VARCHAR(100) NOT NULL UNIQUE,
    label        VARCHAR(150) NOT NULL,
    domain       VARCHAR(50),
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE merchant_applications (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    tenant_id        BIGINT      NOT NULL REFERENCES tenants(id),
    business_id      BIGINT REFERENCES businesses(id),
    status_id        INT         NOT NULL REFERENCES verification_statuses(id),
    submitted_at     TIMESTAMPTZ,
    reviewed_by      BIGINT REFERENCES users(id),
    reviewed_at      TIMESTAMPTZ,
    rejection_reason TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT         NOT NULL DEFAULT 1
);

CREATE TABLE kyc_documents (
    id                      BIGSERIAL PRIMARY KEY,
    internal_id             VARCHAR(200),
    merchant_application_id BIGINT      NOT NULL REFERENCES merchant_applications(id),
    document_type_id        INT         NOT NULL REFERENCES kyc_document_types(id),
    file_url                TEXT        NOT NULL,
    status                  VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','verified','rejected')),
    verified_by             BIGINT REFERENCES users(id),
    verified_at             TIMESTAMPTZ,
    rejection_reason        TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by              BIGINT REFERENCES users(id),
    updated_by              BIGINT REFERENCES users(id),
    version                 INT         NOT NULL DEFAULT 1
);

CREATE TABLE verification_status_history (
    id                      BIGSERIAL PRIMARY KEY,
    internal_id             VARCHAR(200),
    merchant_application_id BIGINT      NOT NULL REFERENCES merchant_applications(id),
    status_id               INT         NOT NULL REFERENCES verification_statuses(id),
    changed_by              BIGINT REFERENCES users(id),
    notes                   TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by              BIGINT REFERENCES users(id),
    updated_by              BIGINT REFERENCES users(id),
    version                 INT         NOT NULL DEFAULT 1
);

CREATE TABLE disputes (
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    tenant_id       BIGINT      NOT NULL REFERENCES tenants(id),
    appointment_id  BIGINT REFERENCES appointments(id),
    raised_by       BIGINT      NOT NULL REFERENCES users(id),
    dispute_type_id INT         NOT NULL REFERENCES dispute_types(id),
    status_id       INT         NOT NULL REFERENCES dispute_statuses(id),
    description     TEXT        NOT NULL,
    resolution      TEXT,
    resolved_by     BIGINT REFERENCES users(id),
    resolved_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT         NOT NULL DEFAULT 1
);

CREATE TABLE complaints (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    tenant_id    BIGINT REFERENCES tenants(id),
    raised_by    BIGINT       NOT NULL REFERENCES users(id),
    category_id  INT REFERENCES complaint_categories(id),
    subject      VARCHAR(255) NOT NULL,
    description  TEXT         NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'open'
        CHECK (status IN ('open','in_progress','resolved','closed')),
    resolved_by  BIGINT REFERENCES users(id),
    resolved_at  TIMESTAMPTZ,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);

CREATE TABLE support_tickets (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    tenant_id      BIGINT REFERENCES tenants(id),
    raised_by      BIGINT      NOT NULL REFERENCES users(id),
    assigned_to    BIGINT REFERENCES users(id),
    status_id      INT         NOT NULL REFERENCES support_ticket_statuses(id),
    priority_id    INT REFERENCES support_ticket_priorities(id),
    subject        VARCHAR(255) NOT NULL,
    description    TEXT         NOT NULL,
    reference_type VARCHAR(30),
    reference_id   BIGINT,
    resolved_at    TIMESTAMPTZ,
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT          NOT NULL DEFAULT 1
);

CREATE TABLE audit_logs (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    tenant_id      BIGINT REFERENCES tenants(id),
    actor_id       BIGINT REFERENCES users(id),
    event_type_id  INT REFERENCES system_event_types(id),
    entity_type    VARCHAR(50) NOT NULL,
    entity_id      BIGINT      NOT NULL,
    old_values     JSONB,
    new_values     JSONB,
    ip_address     INET,
    user_agent     TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT         NOT NULL DEFAULT 1
);

CREATE TABLE platform_settings (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    setting_key   VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT,
    description   TEXT,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE platform_settings_translations (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    setting_key  VARCHAR(100) NOT NULL,
    language_id  INT          NOT NULL REFERENCES languages(id),
    label        VARCHAR(150) NOT NULL,
    description  TEXT,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1,
    UNIQUE (setting_key, language_id)
);


-- ============================================================
-- DOMAIN 16: UI CONFIGURATION
-- ============================================================

CREATE TABLE feature_flag_keys (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    flag_key      VARCHAR(100) NOT NULL UNIQUE,
    label         VARCHAR(150) NOT NULL,
    description   TEXT,
    default_value BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE ui_themes (
    id              SERIAL PRIMARY KEY,
    internal_id     VARCHAR(200),
    name            VARCHAR(100) NOT NULL,
    primary_color   VARCHAR(7),
    secondary_color VARCHAR(7),
    font_family     VARCHAR(100),
    border_radius   VARCHAR(10),
    button_style    VARCHAR(20),
    logo_url        TEXT,
    favicon_url     TEXT,
    is_system       BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users(id),
    updated_by      BIGINT REFERENCES users(id),
    version         INT          NOT NULL DEFAULT 1
);

CREATE TABLE ui_layouts (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    page_type     VARCHAR(50)  NOT NULL,
    name          VARCHAR(100) NOT NULL,
    layout_config JSONB        NOT NULL DEFAULT '{}',
    is_default    BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE ui_banners (
    id               SERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    title            VARCHAR(200) NOT NULL,
    body             TEXT,
    image_url        TEXT,
    link_url         TEXT,
    display_location VARCHAR(50)  NOT NULL,
    active_from      TIMESTAMPTZ,
    active_to        TIMESTAMPTZ,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT          NOT NULL DEFAULT 1
);

CREATE TABLE ui_onboarding_steps (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    step_key      VARCHAR(50)  NOT NULL UNIQUE,
    title         VARCHAR(150) NOT NULL,
    description   TEXT,
    display_order INT          NOT NULL,
    is_required   BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE search_filters (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    filter_key    VARCHAR(50)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    filter_type   VARCHAR(20)  NOT NULL CHECK (filter_type IN ('range','toggle','multi_select')),
    display_order INT          NOT NULL DEFAULT 0,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE homepage_sections (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    section_type  VARCHAR(50)  NOT NULL,
    title         VARCHAR(150),
    display_order INT          NOT NULL DEFAULT 0,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE booking_flow_steps (
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    step_key      VARCHAR(50)  NOT NULL UNIQUE,
    title         VARCHAR(150) NOT NULL,
    description   TEXT,
    display_order INT          NOT NULL,
    is_skippable  BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE ui_feature_flags (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    flag_key_id  INT         NOT NULL REFERENCES feature_flag_keys(id),
    entity_type  VARCHAR(20) NOT NULL CHECK (entity_type IN ('platform','tenant','branch')),
    entity_id    BIGINT,
    is_enabled   BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (flag_key_id, entity_type, entity_id)
);

CREATE TABLE ui_theme_assignments (
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200),
    theme_id       INT         NOT NULL REFERENCES ui_themes(id),
    entity_type    VARCHAR(20) NOT NULL CHECK (entity_type IN ('platform','tenant','branch')),
    entity_id      BIGINT,
    effective_from DATE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users(id),
    updated_by     BIGINT REFERENCES users(id),
    version        INT         NOT NULL DEFAULT 1
);

CREATE TABLE ui_layout_assignments (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    layout_id    INT         NOT NULL REFERENCES ui_layouts(id),
    entity_type  VARCHAR(20) NOT NULL CHECK (entity_type IN ('tenant','branch')),
    entity_id    BIGINT      NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (entity_type, entity_id, layout_id)
);

CREATE TABLE ui_banner_assignments (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    banner_id     INT         NOT NULL REFERENCES ui_banners(id),
    entity_type   VARCHAR(20) NOT NULL CHECK (entity_type IN ('platform','tenant','branch')),
    entity_id     BIGINT,
    display_order INT         NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT         NOT NULL DEFAULT 1,
    UNIQUE (banner_id, entity_type, entity_id)
);

CREATE TABLE ui_onboarding_progress (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    tenant_id     BIGINT      NOT NULL REFERENCES tenants(id),
    step_key      VARCHAR(50) NOT NULL,
    completed_at  TIMESTAMPTZ,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT         NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, step_key)
);

CREATE TABLE service_display_configs (
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         VARCHAR(200),
    branch_service_id   BIGINT      NOT NULL UNIQUE REFERENCES branch_services(id),
    display_order       INT         NOT NULL DEFAULT 0,
    is_featured         BOOLEAN     NOT NULL DEFAULT FALSE,
    badge_label         VARCHAR(50),
    visible_in_search   BOOLEAN     NOT NULL DEFAULT TRUE,
    visible_in_profile  BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users(id),
    updated_by          BIGINT REFERENCES users(id),
    version             INT         NOT NULL DEFAULT 1
);

CREATE TABLE search_filter_translations (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    filter_id    INT          NOT NULL REFERENCES search_filters(id),
    language_id  INT          NOT NULL REFERENCES languages(id),
    label        VARCHAR(100) NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1,
    UNIQUE (filter_id, language_id)
);

CREATE TABLE homepage_section_items (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    section_id    INT         NOT NULL REFERENCES homepage_sections(id),
    entity_type   VARCHAR(20) NOT NULL CHECK (entity_type IN ('branch','service','promotion')),
    entity_id     BIGINT      NOT NULL,
    display_order INT         NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT         NOT NULL DEFAULT 1
);

CREATE TABLE booking_flow_configs (
    id            BIGSERIAL PRIMARY KEY,
    internal_id   VARCHAR(200),
    step_key      VARCHAR(50) NOT NULL,
    entity_type   VARCHAR(20) NOT NULL CHECK (entity_type IN ('tenant','branch')),
    entity_id     BIGINT      NOT NULL,
    is_enabled    BOOLEAN     NOT NULL DEFAULT TRUE,
    display_order INT,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users(id),
    updated_by    BIGINT REFERENCES users(id),
    version       INT         NOT NULL DEFAULT 1,
    UNIQUE (step_key, entity_type, entity_id)
);

CREATE TABLE booking_confirmation_templates (
    id           BIGSERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    tenant_id    BIGINT      NOT NULL REFERENCES tenants(id),
    language_id  INT         NOT NULL REFERENCES languages(id),
    heading      VARCHAR(255),
    subheading   VARCHAR(255),
    footer_note  TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT         NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, language_id)
);


-- ============================================================
-- DOMAIN 17: TRANSLATIONS AND STORAGE
-- ============================================================

CREATE TABLE translations (
    id               BIGSERIAL PRIMARY KEY,
    internal_id      VARCHAR(200),
    table_name       VARCHAR(100) NOT NULL,
    record_id        BIGINT       NOT NULL,
    field_name       VARCHAR(100) NOT NULL,
    language_id      INT          NOT NULL REFERENCES languages(id),
    translated_value TEXT         NOT NULL,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users(id),
    updated_by       BIGINT REFERENCES users(id),
    version          INT          NOT NULL DEFAULT 1,
    UNIQUE (table_name, record_id, field_name, language_id)
);

CREATE TABLE file_storage_buckets (
    id           SERIAL PRIMARY KEY,
    internal_id  VARCHAR(200),
    bucket_key   VARCHAR(50)  NOT NULL UNIQUE,
    label        VARCHAR(100) NOT NULL,
    provider     VARCHAR(50)  NOT NULL,
    base_url     TEXT         NOT NULL,
    is_public    BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users(id),
    updated_by   BIGINT REFERENCES users(id),
    version      INT          NOT NULL DEFAULT 1
);


-- ============================================================
-- INDEXES
-- ============================================================

-- Geolocation (PostGIS)
CREATE INDEX idx_branch_addresses_location     ON branch_addresses USING GIST (location);
CREATE INDEX idx_user_addresses_location       ON user_addresses   USING GIST (location);
CREATE INDEX idx_home_service_zones_polygon    ON branch_home_service_zones USING GIST (polygon);

-- Booking core
CREATE INDEX idx_appointments_branch_date      ON appointments (branch_id, appointment_date);
CREATE INDEX idx_appointments_customer         ON appointments (customer_id);
CREATE INDEX idx_appointments_status           ON appointments (status_id);
CREATE INDEX idx_appt_services_appt            ON appointment_services (appointment_id);
CREATE INDEX idx_slot_holds_expiry             ON slot_holds (expires_at);
CREATE INDEX idx_slot_holds_branch_staff_slot  ON slot_holds (branch_id, staff_id, slot_date, slot_start);
CREATE INDEX idx_group_booking_members_group   ON group_booking_members (group_booking_id);

-- Staff availability
CREATE INDEX idx_staff_working_hours_branch    ON staff_working_hours (branch_id, staff_id);
CREATE INDEX idx_staff_leaves_dates            ON staff_leaves (staff_id, start_date, end_date);
CREATE INDEX idx_staff_breaks_date             ON staff_breaks (staff_id, break_date);

-- Catalogue / search
CREATE INDEX idx_branch_services_branch        ON branch_services (branch_id);
CREATE INDEX idx_branch_services_service       ON branch_services (service_id);
CREATE INDEX idx_services_category             ON services (service_category_id);
CREATE INDEX idx_services_tenant               ON services (tenant_id);

-- Payments & settlement
CREATE INDEX idx_payments_appointment          ON payments (appointment_id);
CREATE INDEX idx_payments_customer             ON payments (customer_id);
CREATE INDEX idx_settlement_items_settlement   ON settlement_items (settlement_id);
CREATE INDEX idx_platform_fee_charges_tenant   ON platform_fee_charges (tenant_id);

-- Queue & waitlist
CREATE INDEX idx_queue_tokens_branch_date      ON queue_tokens (branch_id, token_date);
CREATE INDEX idx_waitlists_branch_service      ON waitlists (branch_id, branch_service_id);

-- Reviews
CREATE INDEX idx_reviews_branch                ON reviews (branch_id);
CREATE INDEX idx_reviews_customer              ON reviews (customer_id);

-- Notifications
CREATE INDEX idx_notifications_user            ON notifications (user_id);
CREATE INDEX idx_notifications_sent_at         ON notifications (sent_at);

-- Audit
CREATE INDEX idx_audit_logs_entity             ON audit_logs (entity_type, entity_id);
CREATE INDEX idx_audit_logs_tenant             ON audit_logs (tenant_id);
CREATE INDEX idx_audit_logs_actor              ON audit_logs (actor_id);

-- Translations
CREATE INDEX idx_translations_lookup           ON translations (table_name, record_id, language_id);

-- internal_id fast lookups
CREATE INDEX idx_tenants_internal_id           ON tenants (internal_id);
CREATE INDEX idx_branches_internal_id          ON branches (internal_id);
CREATE INDEX idx_appointments_internal_id      ON appointments (internal_id);
CREATE INDEX idx_payments_internal_id          ON payments (internal_id);
CREATE INDEX idx_users_internal_id             ON users (internal_id);
CREATE INDEX idx_staff_internal_id             ON staff (internal_id);

```
