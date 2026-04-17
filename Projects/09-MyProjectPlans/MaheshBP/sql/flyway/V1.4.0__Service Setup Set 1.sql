set
search_path to core;

CREATE TABLE item_master
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    item_code             character varying(25)  NOT NULL UNIQUE,
    name                  character varying(200) NOT NULL,
    item_type_id          INT                    NOT NULL REFERENCES m_item_type (id),
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_master
(
    id                    BIGINT REFERENCES item_master(id)  PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    item_code             character varying(25)  NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    service_category_id   INT                    NOT NULL REFERENCES m_service_category (id),
    name                  character varying(200) NOT NULL,
    is_inventory_required BOOLEAN                NOT NULL DEFAULT FALSE,
    description           TEXT,
    base_duration_minutes INT                    NOT NULL,
    base_price            NUMERIC(12, 2),
    pricing_type_id       INT REFERENCES m_pricing_type (id),
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_translations
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    service_id  BIGINT                 NOT NULL REFERENCES service_master (id),
    language_id INT                    NOT NULL REFERENCES m_language (id),
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
    service_id       BIGINT                 NOT NULL REFERENCES service_master (id),
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
    service_id             BIGINT                 NOT NULL REFERENCES service_master (id),
    addon_type_id          INT REFERENCES m_addon_type (id),
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
    service_id  BIGINT                 NOT NULL REFERENCES service_master (id),
    quantity    INT                    NOT NULL DEFAULT 1,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (bundle_id, service_id)
);