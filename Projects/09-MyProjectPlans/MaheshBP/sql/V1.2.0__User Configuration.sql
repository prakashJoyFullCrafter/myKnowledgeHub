set
search_path to security;

CREATE TYPE user_type AS ENUM (
    'PLATFORM_ADMIN',
    'MERCHANT_OWNER',
    'BRANCH_MANAGER',
    'STAFF',
    'CUSTOMER'
);

CREATE TABLE users
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT REFERENCES core.tenants (id),
    user_type         user_type              NOT NULL,
    username          character varying(40)  NOT NULL UNIQUE,
    country_id        INT                    NOT NULL REFERENCES core.countries (id),
    phone_country_id  INT REFERENCES core.country_calling_codes (id),
    phone             character varying(30) UNIQUE,
    phone_verified    BOOLEAN                NOT NULL DEFAULT FALSE,
    phone_verified_at TIMESTAMPTZ,
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
    version           INT                    NOT NULL DEFAULT 1,

    -- tenant must be set for merchant side, must be null for platform/customer
    CONSTRAINT chk_tenant_required CHECK (
        (user_type IN ('MERCHANT_OWNER', 'BRANCH_MANAGER', 'STAFF') AND tenant_id IS NOT NULL)
            OR
        (user_type IN ('CUSTOMER', 'PLATFORM_ADMIN') AND tenant_id IS NULL)
        ),

    -- at least one of email or phone must be provided
    CONSTRAINT chk_email_or_phone CHECK (
        email IS NOT NULL OR phone IS NOT NULL
        )
);


CREATE TABLE auth_providers
(
    id           SERIAL PRIMARY KEY,
    internal_id  character varying(200) NOT NULL UNIQUE,
    provider_key character varying(30)  NOT NULL UNIQUE,
    name         character varying(100) NOT NULL,
    status       character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by   BIGINT REFERENCES users (id),
    updated_by   BIGINT REFERENCES users (id),
    version      INT                    NOT NULL DEFAULT 1
);

CREATE TABLE user_social_accounts
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    user_id          BIGINT                 NOT NULL REFERENCES users (id),
    provider_id      INT                    NOT NULL REFERENCES auth_providers (id),
    provider_user_id character varying(255) NOT NULL,
    email            character varying(255),
    access_token     TEXT,
    refresh_token    TEXT,
    token_expires_at TIMESTAMPTZ,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users (id),
    updated_by       BIGINT REFERENCES users (id),
    version          INT                    NOT NULL DEFAULT 1,
    -- same provider account cannot link to two users
    CONSTRAINT uq_provider_user UNIQUE (provider_id, provider_user_id),
    -- social login only allowed for CUSTOMER
    CONSTRAINT chk_social_customer_only CHECK (
        (SELECT user_type
         FROM users
         WHERE id = user_id) = 'CUSTOMER'
        )
);

CREATE TABLE user_verification_requests
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    user_id       BIGINT                 NOT NULL REFERENCES users (id),
    type          character varying(10)  NOT NULL CHECK (type IN ('email', 'phone')),
    token         character varying(10)  NOT NULL,
    expires_at    TIMESTAMPTZ            NOT NULL,
    verified_at   TIMESTAMPTZ,
    is_verified   BOOLEAN                NOT NULL DEFAULT FALSE,
    attempt_count INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users (id),
    updated_by    BIGINT REFERENCES users (id),
    version       INT                    NOT NULL DEFAULT 1
);

----Profiles --------------------
CREATE TABLE user_profiles
(
    id            BIGINT PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    user_id       BIGINT                 NOT NULL UNIQUE REFERENCES users (id),
    first_name    character varying(100),
    last_name     character varying(100),
    display_name  character varying(150), -- for customer facing display
    avatar_url    TEXT,                   -- profile photo
    gender        character varying(10) CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
    date_of_birth DATE,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users (id),
    updated_by    BIGINT REFERENCES users (id),
    version       INT                    NOT NULL DEFAULT 1
);

-----Roles ---------------
CREATE TABLE roles
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    role_key    character varying(50)  NOT NULL UNIQUE,
    user_type   user_type              NOT NULL, -- which user type this role belongs to
    name        character varying(100) NOT NULL,
    description TEXT,
    is_system   BOOLEAN                NOT NULL DEFAULT FALSE,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE permissions
(
    id             SERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    permission_key character varying(100) NOT NULL UNIQUE,
    name           character varying(150) NOT NULL,
    domain         character varying(50),
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users (id),
    updated_by     BIGINT REFERENCES users (id),
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE role_permissions
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    role_id       INT                    NOT NULL REFERENCES roles (id),
    permission_id INT                    NOT NULL REFERENCES permissions (id),
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users (id),
    updated_by    BIGINT REFERENCES users (id),
    version       INT                    NOT NULL DEFAULT 1,
    UNIQUE (role_id, permission_id)
);

CREATE TABLE user_roles
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    user_id     BIGINT                 NOT NULL REFERENCES users (id),
    role_id     INT                    NOT NULL REFERENCES roles (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT REFERENCES users (id),
    updated_by  BIGINT REFERENCES users (id),
    version     INT                    NOT NULL DEFAULT 1,
    CONSTRAINT chk_user_roles_customer_only CHECK (
        (SELECT user_type
         FROM users
         WHERE id = user_id) = 'CUSTOMER'
        ),
    UNIQUE (user_id, role_id)
);

CREATE TABLE user_devices
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    user_id         BIGINT                 NOT NULL REFERENCES users (id),
    device_token    TEXT                   NOT NULL UNIQUE,
    device_type_id  INT                    NOT NULL REFERENCES device_types (id),
    os_type_id      INT                    NOT NULL REFERENCES os_types (id),
    browser_type_id INT REFERENCES browser_types (id),
    device_name     character varying(100),
    app_version     character varying(20),
    last_seen_at    TIMESTAMPTZ,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users (id),
    updated_by      BIGINT REFERENCES users (id),
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE user_sessions
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    user_id       BIGINT                 NOT NULL REFERENCES users (id),
    device_id     BIGINT REFERENCES user_devices (id),
    refresh_token TEXT                   NOT NULL UNIQUE,
    ip_address    INET,
    user_agent    TEXT,
    expires_at    TIMESTAMPTZ            NOT NULL,
    revoked_at    TIMESTAMPTZ,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users (id),
    updated_by    BIGINT REFERENCES users (id),
    version       INT                    NOT NULL DEFAULT 1
);

