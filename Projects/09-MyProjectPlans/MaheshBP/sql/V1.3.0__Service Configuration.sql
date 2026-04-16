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
    created_by    BIGINT,
    updated_by    BIGINT,
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
    created_by      BIGINT,
    updated_by      BIGINT,
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
    created_by          BIGINT,
    updated_by          BIGINT,
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
    created_by  BIGINT,
    updated_by  BIGINT,
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
    created_by  BIGINT,
    updated_by  BIGINT,
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
    created_by  BIGINT,
    updated_by  BIGINT,
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
    created_by    BIGINT,
    updated_by    BIGINT,
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
    created_by        BIGINT,
    updated_by        BIGINT,
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
    created_by                BIGINT,
    updated_by                BIGINT,
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
    created_by            BIGINT,
    updated_by            BIGINT,
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
    created_by        BIGINT,
    updated_by        BIGINT,
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
    created_by                BIGINT,
    updated_by                BIGINT,
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
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);
INSERT INTO service_tags (internal_id, tag_key, name, status, version)
VALUES

    -- Trending / Popularity
    ('SVC-TAG-001', 'TRENDING', 'Trending', 'A', 1),
    ('SVC-TAG-002', 'BESTSELLER', 'Best Seller', 'A', 1),
    ('SVC-TAG-003', 'NEW', 'New', 'A', 1),
    ('SVC-TAG-004', 'POPULAR', 'Popular', 'A', 1),
    ('SVC-TAG-005', 'STAFF_PICK', 'Staff Pick', 'A', 1),

    -- Pricing
    ('SVC-TAG-006', 'OFFER', 'Offer', 'A', 1),
    ('SVC-TAG-007', 'LIMITED_TIME', 'Limited Time', 'A', 1),
    ('SVC-TAG-008', 'VALUE_PACK', 'Value Pack', 'A', 1),
    ('SVC-TAG-009', 'PREMIUM', 'Premium', 'A', 1),
    ('SVC-TAG-010', 'BUDGET_FRIENDLY', 'Budget Friendly', 'A', 1),

    -- Service Type
    ('SVC-TAG-011', 'HOME_SERVICE', 'Home Service', 'A', 1),
    ('SVC-TAG-012', 'IN_STORE', 'In Store', 'A', 1),
    ('SVC-TAG-013', 'EXPRESS', 'Express', 'A', 1),
    ('SVC-TAG-014', 'APPOINTMENT_ONLY', 'Appointment Only', 'A', 1),
    ('SVC-TAG-015', 'WALK_IN', 'Walk In', 'A', 1),

    -- Gender
    ('SVC-TAG-016', 'MALE', 'Male', 'A', 1),
    ('SVC-TAG-017', 'FEMALE', 'Female', 'A', 1),
    ('SVC-TAG-018', 'UNISEX', 'Unisex', 'A', 1),
    ('SVC-TAG-019', 'KIDS', 'Kids', 'A', 1),

    -- Occasion
    ('SVC-TAG-020', 'BRIDAL', 'Bridal', 'A', 1),
    ('SVC-TAG-021', 'PARTY', 'Party', 'A', 1),
    ('SVC-TAG-022', 'PROM', 'Prom', 'A', 1),
    ('SVC-TAG-023', 'GRADUATION', 'Graduation', 'A', 1),
    ('SVC-TAG-024', 'CORPORATE', 'Corporate', 'A', 1),
    ('SVC-TAG-025', 'EVERYDAY', 'Everyday', 'A', 1),

    -- Hair
    ('SVC-TAG-026', 'HAIR_COLOR', 'Hair Color', 'A', 1),
    ('SVC-TAG-027', 'HAIR_TREATMENT', 'Hair Treatment', 'A', 1),
    ('SVC-TAG-028', 'HAIR_EXTENSION', 'Hair Extension', 'A', 1),
    ('SVC-TAG-029', 'KERATIN', 'Keratin', 'A', 1),
    ('SVC-TAG-030', 'BALAYAGE', 'Balayage', 'A', 1),
    ('SVC-TAG-031', 'HIGHLIGHTS', 'Highlights', 'A', 1),
    ('SVC-TAG-032', 'SCALP_TREATMENT', 'Scalp Treatment', 'A', 1),

    -- Skin
    ('SVC-TAG-033', 'ANTI_AGING', 'Anti Aging', 'A', 1),
    ('SVC-TAG-034', 'ACNE_TREATMENT', 'Acne Treatment', 'A', 1),
    ('SVC-TAG-035', 'BRIGHTENING', 'Brightening', 'A', 1),
    ('SVC-TAG-036', 'HYDRATING', 'Hydrating', 'A', 1),
    ('SVC-TAG-037', 'ORGANIC', 'Organic', 'A', 1),
    ('SVC-TAG-038', 'SENSITIVE_SKIN', 'Sensitive Skin', 'A', 1),

    -- Nails
    ('SVC-TAG-039', 'GEL', 'Gel', 'A', 1),
    ('SVC-TAG-040', 'ACRYLIC', 'Acrylic', 'A', 1),
    ('SVC-TAG-041', 'NAIL_ART', 'Nail Art', 'A', 1),
    ('SVC-TAG-042', 'FRENCH', 'French', 'A', 1),
    ('SVC-TAG-043', 'OMBRE', 'Ombre', 'A', 1),

    -- Wellness
    ('SVC-TAG-044', 'RELAXING', 'Relaxing', 'A', 1),
    ('SVC-TAG-045', 'DEEP_TISSUE', 'Deep Tissue', 'A', 1),
    ('SVC-TAG-046', 'AROMATHERAPY', 'Aromatherapy', 'A', 1),
    ('SVC-TAG-047', 'HOT_STONE', 'Hot Stone', 'A', 1),
    ('SVC-TAG-048', 'COUPLES', 'Couples', 'A', 1),

    -- Duration
    ('SVC-TAG-049', 'QUICK_30MIN', 'Quick 30 Min', 'A', 1),
    ('SVC-TAG-050', 'ONE_HOUR', 'One Hour', 'A', 1),
    ('SVC-TAG-051', 'HALF_DAY', 'Half Day', 'A', 1),
    ('SVC-TAG-052', 'FULL_DAY', 'Full Day', 'A', 1),

    -- Certification / Quality
    ('SVC-TAG-053', 'CERTIFIED', 'Certified', 'A', 1),
    ('SVC-TAG-054', 'AWARD_WINNING', 'Award Winning', 'A', 1),
    ('SVC-TAG-055', 'LUXURY', 'Luxury', 'A', 1),
    ('SVC-TAG-056', 'ECO_FRIENDLY', 'Eco Friendly', 'A', 1),
    ('SVC-TAG-057', 'CRUELTY_FREE', 'Cruelty Free', 'A', 1),
    ('SVC-TAG-058', 'VEGAN', 'Vegan', 'A', 1);


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
