set
search_path to security;
CREATE TABLE tenant_user_roles
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES core.tenants (id),
    staff_id    BIGINT                 NOT NULL REFERENCES tenant_staff_users (id),
    role_id     INT                    NOT NULL REFERENCES security.m_role (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (staff_id, role_id)
);

CREATE TABLE tenant_user_branch_assignment_roles
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id   BIGINT                 NOT NULL REFERENCES core.branches (id),
    staff_id    BIGINT                 NOT NULL REFERENCES tenant_staff_users (id),
    role_id     INT                    NOT NULL REFERENCES security.m_role (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (staff_id, role_id)
);


CREATE TABLE tenant_user_devices
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    tenant_id       BIGINT                 NOT NULL REFERENCES core.tenants (id),
    staff_id        BIGINT                 NOT NULL REFERENCES tenant_staff_users (id),
    device_token    TEXT                   NOT NULL UNIQUE,
    device_type_id  INT                    NOT NULL REFERENCES core.m_device_type (id),
    os_type_id      INT                    NOT NULL REFERENCES core.m_os_type (id),
    browser_type_id INT REFERENCES core.m_browser_type (id),
    device_name     character varying(100),
    app_version     character varying(20),
    last_seen_at    TIMESTAMPTZ,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE tenant_user_sessions
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES core.tenants (id),
    staff_id      BIGINT                 NOT NULL REFERENCES tenant_staff_users (id),
    device_id     BIGINT REFERENCES tenant_user_devices (id),
    refresh_token TEXT                   NOT NULL UNIQUE,
    ip_address    INET,
    user_agent    TEXT,
    expires_at    TIMESTAMPTZ            NOT NULL,
    revoked_at    TIMESTAMPTZ,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);
