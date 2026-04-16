set
search_path to core;


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