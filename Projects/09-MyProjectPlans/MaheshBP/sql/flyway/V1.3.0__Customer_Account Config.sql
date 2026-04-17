set
search_path to security;
CREATE TABLE customer_accounts
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    country_id        INT                    NOT NULL REFERENCES core.m_country (id),
    phone_country_id  INT REFERENCES core.m_country_calling_code (id),
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
    version           INT                    NOT NULL DEFAULT 1
);
CREATE TABLE customer_social_accounts
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    customer_account_id BIGINT                 NOT NULL REFERENCES customer_accounts (id),
    provider_id         INT                    NOT NULL REFERENCES security.m_auth_provider (id),
    provider_user_id    character varying(255) NOT NULL,
    email               character varying(255),
    access_token        TEXT,
    refresh_token       TEXT,
    token_expires_at    TIMESTAMPTZ,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,

    -- same provider account cannot link to two users
    CONSTRAINT uq_provider_user UNIQUE (provider_id, provider_user_id)


);

CREATE TABLE customer_accounts_verification_requests
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    customer_account_id BIGINT                 NOT NULL REFERENCES customer_accounts (id),
    type                character varying(10)  NOT NULL CHECK (type IN ('email', 'phone')),
    token               character varying(10)  NOT NULL,
    expires_at          TIMESTAMPTZ            NOT NULL,
    verified_at         TIMESTAMPTZ,
    is_verified         BOOLEAN                NOT NULL DEFAULT FALSE,
    attempt_count       INT                    NOT NULL DEFAULT 0,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE customer_profiles
(
    id            BIGINT PRIMARY KEY REFERENCES customer_accounts (id) ON DELETE CASCADE,
    internal_id   character varying(200) NOT NULL UNIQUE,
    first_name    character varying(100),
    last_name     character varying(100),
    display_name  character varying(150), -- for customer facing display
    avatar_url    TEXT,                   -- profile photo
    gender_id     INT                    NOT NULL references core.m_gender (id),
    date_of_birth DATE,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);


CREATE TABLE customer_devices
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    customer_account_id BIGINT                 NOT NULL REFERENCES customer_accounts (id),
    device_token        TEXT                   NOT NULL UNIQUE,
    device_type_id      INT                    NOT NULL REFERENCES core.m_device_type (id),
    os_type_id          INT                    NOT NULL REFERENCES core.m_os_type (id),
    browser_type_id     INT REFERENCES core.m_browser_type (id),
    device_name         character varying(100),
    app_version         character varying(20),
    last_seen_at        TIMESTAMPTZ,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE customer_sessions
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    customer_account_id BIGINT                 NOT NULL REFERENCES customer_accounts (id),
    device_id           BIGINT REFERENCES customer_devices (id),
    refresh_token       TEXT                   NOT NULL UNIQUE,
    ip_address          INET,
    user_agent          TEXT,
    expires_at          TIMESTAMPTZ            NOT NULL,
    revoked_at          TIMESTAMPTZ,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);
