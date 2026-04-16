set
search_path to core;


CREATE TABLE staff_profiles
(
    id               BIGINT PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    user_id          BIGINT REFERENCES security.users (id),
    first_name       character varying(100) NOT NULL,
    last_name        character varying(100),
    display_name     character varying(150),
    phone            character varying(30),
    email            character varying(255),
    gender           character varying(20),
    date_of_birth    DATE,
    bio              TEXT,
    experience_years INT,
    specialties      JSONB                  NOT NULL DEFAULT '[]',
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES security.users (id),
    updated_by       BIGINT REFERENCES security.users (id),
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE staff_media
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    staff_id      BIGINT                 NOT NULL REFERENCES staff_profiles (id),
    media_type_id INT                    NOT NULL REFERENCES media_types (id),
    url           TEXT                   NOT NULL,
    alt_text      character varying(255),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE staff_branch_assignments
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    staff_id       BIGINT                 NOT NULL REFERENCES staff_profiles (id),
    branch_id      BIGINT                 NOT NULL REFERENCES branches (id),
    is_primary     BOOLEAN                NOT NULL DEFAULT FALSE,
    assigned_from  DATE,
    assigned_until DATE,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES security.users (id),
    updated_by     BIGINT REFERENCES security.users (id),
    version        INT                    NOT NULL DEFAULT 1,
        UNIQUE (staff_id, branch_id)
);

CREATE TABLE staff_roles
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    user_id     BIGINT                 NOT NULL REFERENCES security.users (id),
    role_id     INT                    NOT NULL REFERENCES security.roles (id),
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id   BIGINT REFERENCES branches (id),                       -- NULL means all branches
    assigned_by BIGINT                 NOT NULL REFERENCES security.users (id), -- who assigned this role
    assigned_at TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    expires_at  TIMESTAMPTZ,                                           -- optional role expiry
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT REFERENCES security.users (id),
    updated_by  BIGINT REFERENCES security.users (id),
    version     INT                    NOT NULL DEFAULT 1

    -- only merchant side user types allowed here

);

CREATE UNIQUE INDEX uq_staff_roles_with_branch
    ON staff_roles (user_id, role_id, branch_id) WHERE branch_id IS NOT NULL;

CREATE UNIQUE INDEX uq_staff_roles_all_branches
    ON staff_roles (user_id, role_id) WHERE branch_id IS NULL;
