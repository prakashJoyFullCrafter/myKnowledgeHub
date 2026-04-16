set
search_path to core;

CREATE TABLE service_types
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_categories
(
    id              SERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    service_type_id INT                    NOT NULL REFERENCES service_types (id),
    name            character varying(150) NOT NULL,
    description     TEXT,
    icon_key        character varying(50),
    display_order   INT                    NOT NULL DEFAULT 0,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_category_translations
(
    id                  SERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    service_category_id INT                    NOT NULL REFERENCES service_categories (id),
    language_id         INT                    NOT NULL REFERENCES languages (id),
    name                character varying(150) NOT NULL,
    description         TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE pricing_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    name        character varying(100) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE duration_units
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    name        character varying(50)  NOT NULL,
    to_minutes  INT                    NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE addon_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    type_key    character varying(50)  NOT NULL UNIQUE,
    name        character varying(100) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE staff_tiers
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version       INT                    NOT NULL DEFAULT 1
);


---------------------------------------------------------------


CREATE TABLE service_pricing
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id         BIGINT REFERENCES branches (id),
    branch_service_id BIGINT REFERENCES branch_services (id),
    pricing_type_id   INT REFERENCES pricing_types (id),
    price             NUMERIC(12, 2)         NOT NULL,
    currency_id       INT                    NOT NULL REFERENCES currencies (id),
    valid_from        DATE,
    valid_until       DATE,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version           INT                    NOT NULL DEFAULT 1
);

CREATE TABLE branch_service_addons
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            character varying(200) NOT NULL UNIQUE,
    tenant_id              BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id              BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id      BIGINT                 NOT NULL REFERENCES branch_services (id),
    service_addon_id       BIGINT                 NOT NULL REFERENCES service_addons (id),
    price                  NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    duration_extra_minutes INT                    NOT NULL DEFAULT 0,
    status                 character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users (id),
    updated_by             BIGINT REFERENCES users (id),
    version                INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_service_id, service_addon_id)
);

CREATE TABLE service_pricing_tiers
(
    id                        BIGSERIAL PRIMARY KEY,
    internal_id               character varying(200) NOT NULL UNIQUE,
    tenant_id                 BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id                 BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id         BIGINT                 NOT NULL REFERENCES branch_services (id),
    staff_tier_id             INT                    NOT NULL REFERENCES staff_tiers (id),
    price                     NUMERIC(12, 2)         NOT NULL,
    duration_override_minutes INT,
    status                    character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at                TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at                TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version                   INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_service_id, staff_tier_id)
);

CREATE TABLE service_duration_rules
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id             BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id     BIGINT                 NOT NULL REFERENCES branch_services (id),
    duration_minutes      INT                    NOT NULL,
    buffer_after_minutes  INT                    NOT NULL DEFAULT 0,
    buffer_before_minutes INT                    NOT NULL DEFAULT 0,
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version               INT                    NOT NULL DEFAULT 1
);


CREATE TABLE service_availability_rules
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id         BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id BIGINT                 NOT NULL REFERENCES branch_services (id),
    day_of_week       SMALLINT CHECK (day_of_week BETWEEN 0 AND 6),
    available_from    TIME,
    available_until   TIME,
    is_unavailable    BOOLEAN                NOT NULL DEFAULT FALSE,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version           INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_home_service_config
(
    id                        BIGSERIAL PRIMARY KEY,
    internal_id               character varying(200) NOT NULL UNIQUE,
    tenant_id                 BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id                 BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id         BIGINT                 NOT NULL UNIQUE REFERENCES branch_services (id),
    is_home_service_available BOOLEAN                NOT NULL DEFAULT FALSE,
    surcharge                 NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    surcharge_type            character varying(10)  NOT NULL DEFAULT 'flat'
        CHECK (surcharge_type IN ('flat', 'percent')),
    status                    character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at                TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at                TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version                   INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_tags
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tag_key     character varying(50)  NOT NULL UNIQUE,
    name        character varying(100) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE service_tag_assignments
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT                 NOT NULL REFERENCES tenants (id),
    service_id     BIGINT                 NOT NULL REFERENCES services (id),
    service_tag_id INT                    NOT NULL REFERENCES service_tags (id),
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1,
    UNIQUE (service_id, service_tag_id)
);

CREATE TABLE service_faqs
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES tenants (id),
    service_id    BIGINT                 NOT NULL REFERENCES services (id),
    language_id   INT                    NOT NULL REFERENCES languages (id),
    question      TEXT                   NOT NULL,
    answer        TEXT                   NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);


CREATE TABLE service_media
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES tenants (id),
    service_id    BIGINT                 NOT NULL REFERENCES services (id),
    media_type_id INT                    NOT NULL REFERENCES media_types (id),
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
