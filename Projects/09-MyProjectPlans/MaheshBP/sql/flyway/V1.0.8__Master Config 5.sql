CREATE SCHEMA security;
set
search_path to security;

CREATE TYPE user_type AS ENUM (
    'PLATFORM_ADMIN',
    'MERCHANT_OWNER',
    'BRANCH_MANAGER',
    'STAFF'
);
CREATE TABLE m_auth_provider
(
    id           SERIAL PRIMARY KEY,
    internal_id  character varying(200) NOT NULL UNIQUE,
    provider_key character varying(30)  NOT NULL UNIQUE,
    name         character varying(100) NOT NULL,
    status       character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by   BIGINT,
    updated_by   BIGINT,
    version      INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_role
(
    id                  SERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    role_key            character varying(50)  NOT NULL UNIQUE,
    user_type           user_type              NOT NULL, -- which user type this role belongs to
    name                character varying(100) NOT NULL,
    description         TEXT,
    is_system           BOOLEAN                NOT NULL DEFAULT FALSE,
    branch_level_access BOOLEAN                NOT NULL DEFAULT FALSE,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);


CREATE TABLE m_permission
(
    id             SERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    permission_key character varying(100) NOT NULL UNIQUE,
    name           character varying(150) NOT NULL,
    domain         character varying(50),
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE map_role_permission
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    role_id       INT                    NOT NULL REFERENCES m_role (id),
    permission_id INT                    NOT NULL REFERENCES m_permission (id),
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1,
    UNIQUE (role_id, permission_id)
);
