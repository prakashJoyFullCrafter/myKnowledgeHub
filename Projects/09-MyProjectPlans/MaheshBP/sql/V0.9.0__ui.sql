CREATE TABLE feature_flag_keys
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    flag_key      character varying(100)           NOT NULL UNIQUE,
    label         character varying(150)           NOT NULL,
    description   TEXT,
    default_value BOOLEAN                NOT NULL DEFAULT FALSE,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE ui_themes
(
    id              SERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    name            character varying(100)           NOT NULL,
    primary_color   character varying(7),
    secondary_color character varying(7),
    font_family     character varying(100),
    border_radius   character varying(10),
    button_style    character varying(20),
    logo_url        TEXT,
    favicon_url     TEXT,
    is_system       BOOLEAN                NOT NULL DEFAULT FALSE,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE ui_layouts
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    page_type     character varying(50)            NOT NULL,
    name          character varying(100)           NOT NULL,
    layout_config JSONB                  NOT NULL DEFAULT '{}',
    is_default    BOOLEAN                NOT NULL DEFAULT FALSE,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE ui_banners
(
    id               SERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    title            character varying(200)           NOT NULL,
    body             TEXT,
    image_url        TEXT,
    link_url         TEXT,
    display_location character varying(50)            NOT NULL,
    active_from      TIMESTAMPTZ,
    active_to        TIMESTAMPTZ,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE ui_onboarding_steps
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    step_key      character varying(50)            NOT NULL UNIQUE,
    title         character varying(150)           NOT NULL,
    description   TEXT,
    display_order INT                    NOT NULL,
    is_required   BOOLEAN                NOT NULL DEFAULT TRUE,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE search_filters
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    filter_key    character varying(50)            NOT NULL UNIQUE,
    label         character varying(100)           NOT NULL,
    filter_type   character varying(20)            NOT NULL CHECK (filter_type IN ('range', 'toggle', 'multi_select')),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE homepage_sections
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    section_type  character varying(50)            NOT NULL,
    title         character varying(150),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE booking_flow_steps
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    step_key      character varying(50)            NOT NULL UNIQUE,
    title         character varying(150)           NOT NULL,
    description   TEXT,
    display_order INT                    NOT NULL,
    is_skippable  BOOLEAN                NOT NULL DEFAULT FALSE,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE ui_feature_flags
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    flag_key_id INT                    NOT NULL REFERENCES feature_flag_keys (id),
    entity_type character varying(20)            NOT NULL CHECK (entity_type IN ('platform', 'tenant', 'branch')),
    entity_id   BIGINT,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (flag_key_id, entity_type, entity_id)
);

CREATE TABLE ui_theme_assignments
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    theme_id       INT                    NOT NULL REFERENCES ui_themes (id),
    entity_type    character varying(20)            NOT NULL CHECK (entity_type IN ('platform', 'tenant', 'branch')),
    entity_id      BIGINT,
    effective_from DATE,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE ui_layout_assignments
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    layout_id   INT                    NOT NULL REFERENCES ui_layouts (id),
    entity_type character varying(20)            NOT NULL CHECK (entity_type IN ('tenant', 'branch')),
    entity_id   BIGINT                 NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (entity_type, entity_id, layout_id)
);

CREATE TABLE ui_banner_assignments
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    banner_id     INT                    NOT NULL REFERENCES ui_banners (id),
    entity_type   character varying(20)            NOT NULL CHECK (entity_type IN ('platform', 'tenant', 'branch')),
    entity_id     BIGINT,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1,
    UNIQUE (banner_id, entity_type, entity_id)
);

CREATE TABLE ui_onboarding_progress
(
    id           BIGSERIAL PRIMARY KEY,
    internal_id  character varying(200) NOT NULL UNIQUE,
    tenant_id    BIGINT                 NOT NULL REFERENCES tenants (id),
    step_key     character varying(50)            NOT NULL,
    completed_at TIMESTAMPTZ,
    status       character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by   BIGINT,
    updated_by   BIGINT,
    version      INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, step_key)
);

CREATE TABLE service_display_configs
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    branch_service_id  BIGINT                 NOT NULL UNIQUE REFERENCES branch_services (id),
    display_order      INT                    NOT NULL DEFAULT 0,
    is_featured        BOOLEAN                NOT NULL DEFAULT FALSE,
    badge_label        character varying(50),
    visible_in_search  BOOLEAN                NOT NULL DEFAULT TRUE,
    visible_in_profile BOOLEAN                NOT NULL DEFAULT TRUE,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
);

CREATE TABLE search_filter_translations
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    filter_id   INT                    NOT NULL REFERENCES search_filters (id),
    language_id INT                    NOT NULL REFERENCES languages (id),
    label       character varying(100)           NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (filter_id, language_id)
);

CREATE TABLE homepage_section_items
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    section_id    INT                    NOT NULL REFERENCES homepage_sections (id),
    entity_type   character varying(20)            NOT NULL CHECK (entity_type IN ('branch', 'service', 'promotion')),
    entity_id     BIGINT                 NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE booking_flow_configs
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    step_key      character varying(50)            NOT NULL,
    entity_type   character varying(20)            NOT NULL CHECK (entity_type IN ('tenant', 'branch')),
    entity_id     BIGINT                 NOT NULL,
    is_enabled    BOOLEAN                NOT NULL DEFAULT TRUE,
    display_order INT,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1,
    UNIQUE (step_key, entity_type, entity_id)
);

CREATE TABLE booking_confirmation_templates
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    language_id INT                    NOT NULL REFERENCES languages (id),
    heading     character varying(255),
    subheading  character varying(255),
    footer_note TEXT,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, language_id)
);


-- ============================================================
-- DOMAIN 17: TRANSLATIONS AND STORAGE
-- ============================================================

CREATE TABLE translations
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    table_name       character varying(100)           NOT NULL,
    record_id        BIGINT                 NOT NULL,
    field_name       character varying(100)           NOT NULL,
    language_id      INT                    NOT NULL REFERENCES languages (id),
    translated_value TEXT                   NOT NULL,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1,
    UNIQUE (table_name, record_id, field_name, language_id)
);

CREATE TABLE file_storage_buckets
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    bucket_key  character varying(50)            NOT NULL UNIQUE,
    label       character varying(100)           NOT NULL,
    provider    character varying(50)            NOT NULL,
    base_url    TEXT                   NOT NULL,
    is_public   BOOLEAN                NOT NULL DEFAULT TRUE,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);