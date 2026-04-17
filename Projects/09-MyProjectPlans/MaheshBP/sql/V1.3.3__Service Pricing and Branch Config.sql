set
search_path to core;

-- ============================================================
-- UNIFIED SERVICE PRICING (3 scopes: TENANT → BUSINESS → BRANCH)
-- (Depends on: tenants, businesses, branches, services,
--  branch_services, pricing_scope, service_tiers, pricing_types,
--  currencies — from V1.0.0, V1.1.0, V1.3.1, V1.3.2)
-- ============================================================

CREATE TABLE service_pricing
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id       BIGINT                 REFERENCES businesses (id),
    branch_id         BIGINT                 REFERENCES branches (id),
    pricing_scope_id  INT                    NOT NULL REFERENCES pricing_scope (id),
    service_id        BIGINT                 NOT NULL REFERENCES services (id),
    branch_service_id BIGINT                 REFERENCES branch_services (id),
    service_tier_id   INT                    REFERENCES service_tiers (id),  -- NULL = base price for all customers
    pricing_type_id   INT                    NOT NULL REFERENCES pricing_types (id),
    price             NUMERIC(12, 2)         NOT NULL,
    currency_id       INT                    NOT NULL REFERENCES currencies (id),
    valid_from        DATE,
    valid_until       DATE,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT REFERENCES security.users (id),
    updated_by        BIGINT REFERENCES security.users (id),
    version           INT                    NOT NULL DEFAULT 1,

    -- TENANT scope:   business_id NULL, branch_id NULL, branch_service_id NULL
    CONSTRAINT chk_scope_tenant CHECK (
        pricing_scope_id != (SELECT id FROM pricing_scope WHERE name = 'TENANT')
        OR (business_id IS NULL AND branch_id IS NULL AND branch_service_id IS NULL)
    ),
    -- BUSINESS scope:  business_id SET, branch_id NULL, branch_service_id NULL
    CONSTRAINT chk_scope_business CHECK (
        pricing_scope_id != (SELECT id FROM pricing_scope WHERE name = 'BUSINESS')
        OR (business_id IS NOT NULL AND branch_id IS NULL AND branch_service_id IS NULL)
    ),
    -- BRANCH scope:   business_id SET, branch_id SET
    CONSTRAINT chk_scope_branch CHECK (
        pricing_scope_id != (SELECT id FROM pricing_scope WHERE name = 'BRANCH')
        OR (business_id IS NOT NULL AND branch_id IS NOT NULL)
    )
);

-- Prevent duplicate active pricing per scope + service + tier
CREATE UNIQUE INDEX uq_sp_tenant_scope
    ON service_pricing (tenant_id, service_id, COALESCE(service_tier_id, 0))
    WHERE pricing_scope_id = 1 AND status = 'A';

CREATE UNIQUE INDEX uq_sp_business_scope
    ON service_pricing (tenant_id, business_id, service_id, COALESCE(service_tier_id, 0))
    WHERE pricing_scope_id = 2 AND status = 'A';

CREATE UNIQUE INDEX uq_sp_branch_scope
    ON service_pricing (tenant_id, branch_id, service_id, COALESCE(service_tier_id, 0))
    WHERE pricing_scope_id = 3 AND status = 'A';

-- Lookup indexes for price resolution query
CREATE INDEX idx_sp_branch   ON service_pricing (branch_id, service_id)   WHERE branch_id IS NOT NULL;
CREATE INDEX idx_sp_business ON service_pricing (business_id, service_id) WHERE business_id IS NOT NULL;
CREATE INDEX idx_sp_tenant   ON service_pricing (tenant_id, service_id);


-- ============================================================
-- STAFF TIER PRICE OVERRIDES (child of service_pricing)
-- Inherits scope from parent: if parent is TENANT-scope,
-- these overrides apply at tenant level, etc.
-- ============================================================

CREATE TABLE service_pricing_staff_tiers
(
    id                        BIGSERIAL PRIMARY KEY,
    internal_id               character varying(200) NOT NULL UNIQUE,
    service_pricing_id        BIGINT                 NOT NULL REFERENCES service_pricing (id),
    staff_tier_id             INT                    NOT NULL REFERENCES staff_tiers (id),
    price                     NUMERIC(12, 2)         NOT NULL,
    duration_override_minutes INT,
    status                    character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at                TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at                TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by                BIGINT REFERENCES security.users (id),
    updated_by                BIGINT REFERENCES security.users (id),
    version                   INT                    NOT NULL DEFAULT 1,
    UNIQUE (service_pricing_id, staff_tier_id)
);


-- ============================================================
-- SERVICE TIER ↔ CUSTOMER TIER MAPPING
-- Maps the customer-facing service tiers (NORMAL, SILVER, GOLD,
-- VIP, PREMIUM) to the simpler customer tiers (Bronze, Silver,
-- Gold, Platinum). Many-to-many.
-- ============================================================

CREATE TABLE service_tier_customer_tier_map
(
    id               SERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    service_tier_id  INT                    NOT NULL REFERENCES service_tiers (id),
    customer_tier_id INT                    NOT NULL REFERENCES customer_tiers (id),
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1,
    UNIQUE (service_tier_id, customer_tier_id)
);


-- ============================================================
-- BRANCH-LEVEL SERVICE CONFIGURATION
-- (All depend on branch_services from V1.3.2)
-- ============================================================

CREATE TABLE branch_service_addons
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            character varying(200) NOT NULL UNIQUE,
    tenant_id              BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id            BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id              BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id      BIGINT                 NOT NULL REFERENCES branch_services (id),
    service_addon_id       BIGINT                 NOT NULL REFERENCES service_addons (id),
    price                  NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    duration_extra_minutes INT                    NOT NULL DEFAULT 0,
    status                 character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES security.users (id),
    updated_by             BIGINT REFERENCES security.users (id),
    version                INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_service_id, service_addon_id)
);

CREATE TABLE service_duration_rules
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id           BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id             BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id     BIGINT                 NOT NULL REFERENCES branch_services (id),
    duration_minutes      INT                    NOT NULL,
    buffer_after_minutes  INT                    NOT NULL DEFAULT 0,
    buffer_before_minutes INT                    NOT NULL DEFAULT 0,
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT REFERENCES security.users (id),
    updated_by            BIGINT REFERENCES security.users (id),
    version               INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_availability_rules
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id       BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id         BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id BIGINT                 NOT NULL REFERENCES branch_services (id),
    day_of_week       SMALLINT CHECK (day_of_week BETWEEN 0 AND 6),
    available_from    TIME,
    available_until   TIME,
    is_unavailable    BOOLEAN                NOT NULL DEFAULT FALSE,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT REFERENCES security.users (id),
    updated_by        BIGINT REFERENCES security.users (id),
    version           INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_home_service_config
(
    id                        BIGSERIAL PRIMARY KEY,
    internal_id               character varying(200) NOT NULL UNIQUE,
    tenant_id                 BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id               BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id                 BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id         BIGINT                 NOT NULL UNIQUE REFERENCES branch_services (id),
    is_home_service_available BOOLEAN                NOT NULL DEFAULT FALSE,
    surcharge                 NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    surcharge_type            character varying(10)  NOT NULL DEFAULT 'flat'
        CHECK (surcharge_type IN ('flat', 'percent')),
    status                    character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at                TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at                TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by                BIGINT REFERENCES security.users (id),
    updated_by                BIGINT REFERENCES security.users (id),
    version                   INT                    NOT NULL DEFAULT 1
);
