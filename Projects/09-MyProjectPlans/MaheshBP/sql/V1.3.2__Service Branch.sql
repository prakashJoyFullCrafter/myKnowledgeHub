set
search_path to core;

-- ============================================================
-- BUSINESS-LEVEL SERVICE MAPPING
-- (Depends on: tenants, businesses, services — from V1.1.0, V1.3.1)
-- ============================================================

CREATE TABLE business_services
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id BIGINT                 NOT NULL REFERENCES businesses (id),
    service_id  BIGINT                 NOT NULL REFERENCES services (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (business_id, service_id)
);

-- ============================================================
-- BRANCH-LEVEL SERVICE MAPPING
-- (Depends on: tenants, businesses, branches, services)
-- ============================================================

CREATE TABLE branch_services
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    service_id  BIGINT                 NOT NULL REFERENCES services (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_id, service_id)
);

-- ============================================================
-- STAFF COMMISSIONS PER BRANCH SERVICE
-- ============================================================

CREATE TABLE staff_commissions
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    staff_id          BIGINT                 NOT NULL REFERENCES staff_profiles (id),
    branch_service_id BIGINT REFERENCES branch_services (id),
    commission_type   character varying(10)  NOT NULL DEFAULT 'percent'
        CHECK (commission_type IN ('percent', 'flat')),
    commission_value  NUMERIC(8, 4)          NOT NULL,
    valid_from        DATE,
    valid_until       DATE,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT REFERENCES security.users (id),
    updated_by        BIGINT REFERENCES security.users (id),
    version           INT                    NOT NULL DEFAULT 1
);
