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
INSERT INTO service_types (internal_id, name, display_order, status, created_at, updated_at, version)
VALUES ('SVC-TYPE-001', 'Hair', 1, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-002', 'Skin', 2, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-003', 'Nails', 3, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-004', 'Makeup', 4, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-005', 'Massage', 5, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-006', 'Spa', 6, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-007', 'Beard', 7, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-008', 'Eyebrow', 8, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-009', 'Eyelash', 9, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-010', 'Waxing', 10, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-011', 'Threading', 11, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-012', 'Hair Removal', 12, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-013', 'Tattoo', 13, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-014', 'Piercing', 14, 'A', NOW(), NOW(), 1),
       ('SVC-TYPE-015', 'Men Grooming', 15, 'A', NOW(), NOW(), 1);

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

INSERT INTO service_categories (internal_id, service_type_id, name, description, display_order, status, created_at,
                                updated_at, version)
VALUES

-- Hair (service_type_id = 1)
('SVC-CAT-001', 1, 'Haircut', 'Cutting and styling of hair', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-002', 1, 'Hair Colouring', 'Colouring, highlights and toning', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-003', 1, 'Hair Treatment', 'Deep conditioning and repair treatments', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-004', 1, 'Hair Styling', 'Blow dry, straightening, curling', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-005', 1, 'Hair Extensions', 'Clip-in, tape-in, fusion extensions', 5, 'A', NOW(), NOW(), 1),
('SVC-CAT-006', 1, 'Scalp Treatment', 'Scalp care and dandruff treatments', 6, 'A', NOW(), NOW(), 1),
('SVC-CAT-007', 1, 'Keratin Treatment', 'Smoothing and keratin treatments', 7, 'A', NOW(), NOW(), 1),

-- Skin (service_type_id = 2)
('SVC-CAT-008', 2, 'Facial', 'Deep cleansing and hydrating facials', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-009', 2, 'Skin Brightening', 'Brightening and glow treatments', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-010', 2, 'Anti-Ageing', 'Wrinkle and anti-ageing treatments', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-011', 2, 'Acne Treatment', 'Acne and blemish control treatments', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-012', 2, 'Chemical Peel', 'Exfoliating chemical peel treatments', 5, 'A', NOW(), NOW(), 1),
('SVC-CAT-013', 2, 'Microdermabrasion', 'Skin resurfacing treatments', 6, 'A', NOW(), NOW(), 1),
('SVC-CAT-014', 2, 'Face Mask', 'Hydrating and purifying face masks', 7, 'A', NOW(), NOW(), 1),

-- Nails (service_type_id = 3)
('SVC-CAT-015', 3, 'Manicure', 'Nail shaping and polish for hands', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-016', 3, 'Pedicure', 'Nail shaping and polish for feet', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-017', 3, 'Gel Nails', 'Gel polish application and removal', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-018', 3, 'Acrylic Nails', 'Acrylic nail extensions', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-019', 3, 'Nail Art', 'Decorative nail art designs', 5, 'A', NOW(), NOW(), 1),
('SVC-CAT-020', 3, 'Nail Extensions', 'Nail lengthening and shaping', 6, 'A', NOW(), NOW(), 1),

-- Makeup (service_type_id = 4)
('SVC-CAT-021', 4, 'Bridal Makeup', 'Full bridal makeup for weddings', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-022', 4, 'Party Makeup', 'Makeup for events and parties', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-023', 4, 'Everyday Makeup', 'Natural everyday makeup looks', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-024', 4, 'Airbrush Makeup', 'Airbrush technique makeup application', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-025', 4, 'Makeup Lessons', 'Personal makeup training sessions', 5, 'A', NOW(), NOW(), 1),

-- Massage (service_type_id = 5)
('SVC-CAT-026', 5, 'Swedish Massage', 'Relaxing full body Swedish massage', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-027', 5, 'Deep Tissue Massage', 'Intensive muscle relief massage', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-028', 5, 'Hot Stone Massage', 'Massage using heated stones', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-029', 5, 'Aromatherapy Massage', 'Massage with essential oils', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-030', 5, 'Sports Massage', 'Massage for athletes and active lifestyle', 5, 'A', NOW(), NOW(), 1),
('SVC-CAT-031', 5, 'Prenatal Massage', 'Safe massage for pregnant women', 6, 'A', NOW(), NOW(), 1),
('SVC-CAT-032', 5, 'Head Massage', 'Scalp and head relaxation massage', 7, 'A', NOW(), NOW(), 1),
('SVC-CAT-033', 5, 'Foot Massage', 'Reflexology and foot relaxation', 8, 'A', NOW(), NOW(), 1),

-- Spa (service_type_id = 6)
('SVC-CAT-034', 6, 'Body Wrap', 'Detox and hydrating body wrap treatments', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-035', 6, 'Body Scrub', 'Exfoliating full body scrub', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-036', 6, 'Hydrotherapy', 'Water-based spa treatments', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-037', 6, 'Sauna', 'Dry sauna sessions', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-038', 6, 'Steam Bath', 'Steam room and steam bath sessions', 5, 'A', NOW(), NOW(), 1),
('SVC-CAT-039', 6, 'Spa Package', 'Combined spa treatment packages', 6, 'A', NOW(), NOW(), 1),

-- Beard (service_type_id = 7)
('SVC-CAT-040', 7, 'Beard Trim', 'Shaping and trimming of beard', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-041', 7, 'Beard Shave', 'Traditional wet shave', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-042', 7, 'Beard Styling', 'Beard design and styling', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-043', 7, 'Beard Colouring', 'Beard dye and colouring', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-044', 7, 'Beard Treatment', 'Beard conditioning and care treatments', 5, 'A', NOW(), NOW(), 1),

-- Eyebrow (service_type_id = 8)
('SVC-CAT-045', 8, 'Eyebrow Threading', 'Threading for eyebrow shaping', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-046', 8, 'Eyebrow Tinting', 'Eyebrow colour tinting', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-047', 8, 'Eyebrow Lamination', 'Eyebrow straightening and setting', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-048', 8, 'Microblading', 'Semi-permanent eyebrow tattooing', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-049', 8, 'Eyebrow Waxing', 'Wax-based eyebrow shaping', 5, 'A', NOW(), NOW(), 1),

-- Eyelash (service_type_id = 9)
('SVC-CAT-050', 9, 'Lash Extensions', 'Individual or cluster lash extensions', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-051', 9, 'Lash Lift', 'Lash curling and lifting treatment', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-052', 9, 'Lash Tinting', 'Eyelash colour tinting', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-053', 9, 'Lash Removal', 'Safe removal of lash extensions', 4, 'A', NOW(), NOW(), 1),

-- Waxing (service_type_id = 10)
('SVC-CAT-054', 10, 'Full Body Wax', 'Complete body waxing service', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-055', 10, 'Leg Wax', 'Waxing for upper and lower legs', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-056', 10, 'Arm Wax', 'Waxing for full or half arms', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-057', 10, 'Bikini Wax', 'Bikini line and Brazilian waxing', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-058', 10, 'Face Wax', 'Facial hair waxing', 5, 'A', NOW(), NOW(), 1),
('SVC-CAT-059', 10, 'Back Wax', 'Back and shoulder waxing', 6, 'A', NOW(), NOW(), 1),

-- Threading (service_type_id = 11)
('SVC-CAT-060', 11, 'Face Threading', 'Full face threading for hair removal', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-061', 11, 'Upper Lip Threading', 'Upper lip hair removal by threading', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-062', 11, 'Chin Threading', 'Chin area hair removal by threading', 3, 'A', NOW(), NOW(), 1),

-- Hair Removal (service_type_id = 12)
('SVC-CAT-063', 12, 'Laser Hair Removal', 'Permanent laser hair reduction', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-064', 12, 'IPL Hair Removal', 'Intense pulsed light hair removal', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-065', 12, 'Electrolysis', 'Permanent hair removal by electrolysis', 3, 'A', NOW(), NOW(), 1),

-- Tattoo (service_type_id = 13)
('SVC-CAT-066', 13, 'Permanent Tattoo', 'Custom permanent tattoo designs', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-067', 13, 'Temporary Tattoo', 'Henna and temporary tattoo designs', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-068', 13, 'Tattoo Removal', 'Laser tattoo removal treatment', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-069', 13, 'Tattoo Touch Up', 'Existing tattoo colour and line touch up', 4, 'A', NOW(), NOW(), 1),

-- Piercing (service_type_id = 14)
('SVC-CAT-070', 14, 'Ear Piercing', 'Earlobe and cartilage piercing', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-071', 14, 'Nose Piercing', 'Nostril and septum piercing', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-072', 14, 'Body Piercing', 'Navel, eyebrow and body piercing', 3, 'A', NOW(), NOW(), 1),

-- Men Grooming (service_type_id = 15)
('SVC-CAT-073', 15, 'Haircut', 'Men haircut and styling', 1, 'A', NOW(), NOW(), 1),
('SVC-CAT-074', 15, 'Hair Colouring', 'Men hair colouring and highlights', 2, 'A', NOW(), NOW(), 1),
('SVC-CAT-075', 15, 'Face Clean Up', 'Men facial cleansing treatment', 3, 'A', NOW(), NOW(), 1),
('SVC-CAT-076', 15, 'Head Massage', 'Scalp and head massage for men', 4, 'A', NOW(), NOW(), 1),
('SVC-CAT-077', 15, 'Hot Towel Shave', 'Traditional hot towel wet shave', 5, 'A', NOW(), NOW(), 1),
('SVC-CAT-078', 15, 'Grooming Package', 'Combined men grooming service package', 6, 'A', NOW(), NOW(), 1);
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
INSERT INTO pricing_types (internal_id, type_key, label, status, created_at, updated_at, version)
VALUES ('PRC-TYP-001', 'FIXED', 'Fixed Price', 'A', NOW(), NOW(), 1),
       ('PRC-TYP-002', 'FROM_PRICE', 'Starting From', 'A', NOW(), NOW(), 1),
       ('PRC-TYP-003', 'PER_HOUR', 'Per Hour', 'A', NOW(), NOW(), 1),
       ('PRC-TYP-004', 'PER_SESSION', 'Per Session', 'A', NOW(), NOW(), 1),
       ('PRC-TYP-005', 'PACKAGE', 'Package Price', 'A', NOW(), NOW(), 1),
       ('PRC-TYP-006', 'FREE', 'Free', 'A', NOW(), NOW(), 1);

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
INSERT INTO duration_units (internal_id, name, to_minutes, status, created_at, updated_at, version)
VALUES ('DUR-UNIT-001', 'Minutes', 1, 'A', NOW(), NOW(), 1),
       ('DUR-UNIT-002', 'Hours', 60, 'A', NOW(), NOW(), 1),
       ('DUR-UNIT-003', 'Days', 1440, 'A', NOW(), NOW(), 1);

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

INSERT INTO addon_types (internal_id, type_key, name, status, version)
VALUES ('ADDONTYP-001', 'PRODUCT', 'Product', 'A', 1),
       ('ADDONTYP-002', 'SERVICE_EXTENSION', 'Service Extension', 'A', 1),
       ('ADDONTYP-003', 'UPGRADE', 'Upgrade', 'A', 1);

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
INSERT INTO staff_tiers (internal_id, name, display_order, status, created_at, updated_at, version)
VALUES ('STF-TIER-001', 'Trainee', 1, 'A', NOW(), NOW(), 1),
       ('STF-TIER-002', 'Junior', 2, 'A', NOW(), NOW(), 1),
       ('STF-TIER-003', 'Senior', 3, 'A', NOW(), NOW(), 1),
       ('STF-TIER-004', 'Master', 4, 'A', NOW(), NOW(), 1),
       ('STF-TIER-005', 'Director', 5, 'A', NOW(), NOW(), 1);


CREATE TABLE media_types
(
    id                 SERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    type_key           character varying(30)  NOT NULL UNIQUE,
    name               character varying(100) NOT NULL,
    allowed_extensions JSONB                  NOT NULL DEFAULT '[]',
    max_size_mb        INT                    NOT NULL DEFAULT 10,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
);
INSERT INTO media_types
(internal_id, type_key, name, allowed_extensions, mime_types, max_size_mb, status, version)
VALUES ('MEDIA-TYPE-001', 'IMAGE', 'Image', '[
  "jpg",
  "jpeg",
  "png",
  "webp"
]', '["image/jpeg","image/png","image/webp"]', 5, 'A', 1),
       ('MEDIA-TYPE-002', 'VIDEO', 'Video', '[
         "mp4",
         "mov"
       ]', '["video/mp4","video/quicktime"]', 50, 'A', 1),
       ('MEDIA-TYPE-003', 'DOCUMENT', 'Document', '[
         "pdf"
       ]', '["application/pdf"]', 10, 'A', 1);

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
    branch_id    BIGINT                 NOT NULL REFERENCES branches (id),
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
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
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
CREATE TABLE branch_services
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    service_id  BIGINT                 NOT NULL REFERENCES services (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_id, service_id)
);

CREATE TABLE service_pricing
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id         BIGINT                 NOT NULL REFERENCES branches (id),
    branch_service_id BIGINT                 NOT NULL REFERENCES branch_services (id),
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
