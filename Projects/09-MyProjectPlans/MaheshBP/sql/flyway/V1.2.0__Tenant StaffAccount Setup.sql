set
search_path to core;
CREATE TYPE security.tenant_user_type AS ENUM (    'PLATFORM_ADMIN',    'MERCHANT_OWNER',    'BRANCH_MANAGER',    'STAFF');

CREATE TABLE security.tenant_staff_users
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    user_type         security.user_type     NOT NULL,
    username          character varying(40)  NOT NULL UNIQUE,
    email             character varying(255) UNIQUE,
    email_verified    BOOLEAN                NOT NULL DEFAULT FALSE,
    email_verified_at TIMESTAMPTZ,
    password_hash     TEXT,
    last_login_at     TIMESTAMPTZ,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);

CREATE TABLE tenant_staff_profiles
(
    id                BIGINT REFERENCES security.tenant_staff_users (id) PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    country_id        INT                    NOT NULL REFERENCES m_country (id),
    phone_country_id  INT REFERENCES m_country_calling_code (id),
    phone             character varying(30) UNIQUE,
    phone_verified    BOOLEAN                NOT NULL DEFAULT FALSE,
    phone_verified_at TIMESTAMPTZ,
    first_name        character varying(100) NOT NULL,
    last_name         character varying(100),
    display_name      character varying(150),
    gender_id         INT                    NOT NULL references m_gender (id),
    date_of_birth     DATE,
    bio               TEXT,
    experience_years  INT,
    specialties       JSONB                  NOT NULL DEFAULT '[]',
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);


CREATE TABLE tenant_staff_media
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES tenants (id),
    staff_id      BIGINT                 NOT NULL REFERENCES tenant_staff_profiles (id),
    media_type_id INT                    NOT NULL REFERENCES m_media_type (id),
    url           TEXT                   NOT NULL,
    alt_text      character varying(255),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE tenant_staff_branch_assignments
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT                 NOT NULL REFERENCES tenants (id),
    staff_id       BIGINT                 NOT NULL REFERENCES tenant_staff_profiles (id),
    branch_id      BIGINT                 NOT NULL REFERENCES branches (id),
    is_primary     BOOLEAN                NOT NULL DEFAULT FALSE,
    assigned_from  DATE,
    assigned_until DATE,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1,
    UNIQUE (staff_id, branch_id)
);

