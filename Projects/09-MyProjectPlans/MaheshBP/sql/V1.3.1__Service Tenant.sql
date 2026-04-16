set
search_path to core;

CREATE TABLE services
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    service_category_id   INT                    NOT NULL REFERENCES service_categories (id),
    name                  character varying(200) NOT NULL,
    is_inventory_required BOOLEAN                NOT NULL DEFAULT FALSE,
    description           TEXT,
    base_duration_minutes INT                    NOT NULL,
    base_price            NUMERIC(12, 2),
    pricing_type_id       INT REFERENCES pricing_types (id),
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_tiers
(
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200) NOT NULL UNIQUE,
    tier_key      VARCHAR(30)  NOT NULL UNIQUE, -- NORMAL, VIP, PREMIUM
    name          VARCHAR(100) NOT NULL,
    description   TEXT,
    display_order INT          NOT NULL DEFAULT 0,
    status        VARCHAR(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users (id),
    updated_by    BIGINT REFERENCES users (id),
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE service_translations
(
    id          BIGSERIAL PRIMARY KEY,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    internal_id character varying(200) NOT NULL UNIQUE,
    service_id  BIGINT                 NOT NULL REFERENCES services (id),
    language_id INT                    NOT NULL REFERENCES languages (id),
    name        character varying(200) NOT NULL,
    description TEXT,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (service_id, language_id)
);

CREATE TABLE service_variants
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    service_id       BIGINT                 NOT NULL REFERENCES services (id),
    name             character varying(150) NOT NULL,
    description      TEXT,
    duration_minutes INT,
    price_override   NUMERIC(12, 2),
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_addons
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            character varying(200) NOT NULL UNIQUE,
    tenant_id              BIGINT                 NOT NULL REFERENCES tenants (id),
    service_id             BIGINT                 NOT NULL REFERENCES services (id),
    addon_type_id          INT REFERENCES addon_types (id),
    name                   character varying(150) NOT NULL,
    price                  NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    duration_extra_minutes INT                    NOT NULL DEFAULT 0,
    status                 character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT,
    updated_by             BIGINT,
    version                INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_bundles
(
    id           BIGSERIAL PRIMARY KEY,
    internal_id  character varying(200) NOT NULL UNIQUE,
    tenant_id    BIGINT                 NOT NULL REFERENCES tenants (id),
    name         character varying(200) NOT NULL,
    description  TEXT,
    bundle_price NUMERIC(12, 2)         NOT NULL,
    status       character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by   BIGINT,
    updated_by   BIGINT,
    version      INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_bundle_items
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    bundle_id   BIGINT                 NOT NULL REFERENCES service_bundles (id),
    service_id  BIGINT                 NOT NULL REFERENCES services (id),
    quantity    INT                    NOT NULL DEFAULT 1,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT REFERENCES users (id),
    updated_by  BIGINT REFERENCES users (id),
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (bundle_id, service_id)
);