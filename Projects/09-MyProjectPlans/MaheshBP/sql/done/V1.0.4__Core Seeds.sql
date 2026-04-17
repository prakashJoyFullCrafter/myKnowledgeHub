-- device_types
INSERT INTO device_types (internal_id, name, display_order, status, created_at, updated_at, version)
VALUES ('DEV-TYPE-001', 'Mobile', 1, 'A', NOW(), NOW(), 1),
       ('DEV-TYPE-002', 'Tablet', 2, 'A', NOW(), NOW(), 1),
       ('DEV-TYPE-003', 'Desktop', 3, 'A', NOW(), NOW(), 1);

-- browser_types
INSERT INTO browser_types (internal_id, name, display_order, status, created_at, updated_at, version)
VALUES ('BROW-TYPE-001', 'Chrome', 1, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-002', 'Safari', 2, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-003', 'Firefox', 3, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-004', 'Edge', 4, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-005', 'Opera', 5, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-006', 'Other', 6, 'A', NOW(), NOW(), 1);

-- os_types
INSERT INTO os_types (internal_id, name, display_order, status, created_at, updated_at, version)
VALUES ('OS-TYPE-001', 'iOS', 1, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-002', 'Android', 2, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-003', 'Windows', 3, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-004', 'macOS', 4, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-005', 'Linux', 5, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-006', 'Other', 6, 'A', NOW(), NOW(), 1);

INSERT INTO media_types (internal_id, type_key, name, allowed_extensions, max_size_mb, created_at, updated_at, version)
VALUES
    ('MED-TYP-001', 'IMAGE',     'Image',     '["jpg","jpeg","png","webp","heic"]', 5,   NOW(), NOW(), 1),
    ('MED-TYP-002', 'VIDEO',     'Video',     '["mp4","mov","avi"]',               50,  NOW(), NOW(), 1),
    ('MED-TYP-003', 'DOCUMENT',  'Document',  '["pdf","doc","docx"]',              10,  NOW(), NOW(), 1),
    ('MED-TYP-004', 'AVATAR',    'Avatar',    '["jpg","jpeg","png","webp"]',       2,   NOW(), NOW(), 1),
    ('MED-TYP-005', 'LOGO',      'Logo',      '["jpg","jpeg","png","webp","svg"]', 2,   NOW(), NOW(), 1),
    ('MED-TYP-006', 'BANNER',    'Banner',    '["jpg","jpeg","png","webp"]',       3,   NOW(), NOW(), 1),
    ('MED-TYP-007', 'KYC',       'KYC Document', '["jpg","jpeg","png","pdf"]',    10,  NOW(), NOW(), 1),
    ('MED-TYP-008', 'PORTFOLIO', 'Portfolio', '["jpg","jpeg","png","webp"]',       5,   NOW(), NOW(), 1);




INSERT INTO business_types (internal_id, type_key, label, icon_key, description, default_service_category_keys,
                            display_order, status, version)
VALUES ('BT-001', 'SALON', 'Salon', 'icon_salon', 'Full service hair and beauty salon', '[
  "HAIR_CUT",
  "HAIR_COLOR",
  "HAIR_TREATMENT",
  "BLOWDRY"
]', 1, 'A', 1),
       ('BT-002', 'BARBERSHOP', 'Barbershop', 'icon_barbershop', 'Men''s grooming and hair cutting', '[
         "MENS_HAIRCUT",
         "BEARD_TRIM",
         "SHAVE",
         "HAIR_COLOR"
       ]', 2, 'A', 1),
       ('BT-003', 'SPA', 'Spa', 'icon_spa', 'Relaxation and wellness treatments', '[
         "MASSAGE",
         "BODY_WRAP",
         "AROMATHERAPY",
         "HYDROTHERAPY"
       ]', 3, 'A', 1),
       ('BT-004', 'NAIL_STUDIO', 'Nail Studio', 'icon_nail', 'Nail care, manicure and pedicure services', '[
         "MANICURE",
         "PEDICURE",
         "NAIL_ART",
         "GEL_NAILS",
         "ACRYLIC_NAILS"
       ]', 4, 'A', 1),
       ('BT-005', 'BEAUTY_PARLOUR', 'Beauty Parlour', 'icon_beauty_parlour', 'Traditional beauty and grooming services',
        '[
          "FACIAL",
          "THREADING",
          "WAXING",
          "MAKEUP",
          "HAIR_CUT"
        ]', 5, 'A', 1),
       ('BT-006', 'MAKEUP_ARTIST', 'Makeup Artist', 'icon_makeup',
        'Professional makeup services for events and occasions', '[
         "BRIDAL_MAKEUP",
         "PARTY_MAKEUP",
         "EDITORIAL_MAKEUP",
         "AIRBRUSH_MAKEUP"
       ]', 6, 'A', 1),
       ('BT-007', 'MEDSPA', 'Medical Spa', 'icon_medspa', 'Medical grade aesthetic treatments', '[
         "BOTOX",
         "FILLERS",
         "LASER_HAIR_REMOVAL",
         "CHEMICAL_PEEL",
         "MICRONEEDLING"
       ]', 7, 'A', 1),
       ('BT-008', 'EYEBROW_STUDIO', 'Eyebrow Studio', 'icon_eyebrow', 'Specialist eyebrow shaping and styling', '[
         "EYEBROW_THREADING",
         "EYEBROW_TINTING",
         "MICROBLADING",
         "LAMINATION"
       ]', 8, 'A', 1),
       ('BT-009', 'LASH_STUDIO', 'Lash Studio', 'icon_lash', 'Eyelash extensions and treatments', '[
         "LASH_EXTENSIONS",
         "LASH_LIFT",
         "LASH_TINT",
         "LASH_REMOVAL"
       ]', 9, 'A', 1),
       ('BT-010', 'HAIR_STUDIO', 'Hair Studio', 'icon_hair', 'Specialist hair treatments and styling', '[
         "HAIR_CUT",
         "HAIR_COLOR",
         "KERATIN",
         "HAIR_EXTENSIONS",
         "SCALP_TREATMENT"
       ]', 10, 'A', 1),
       ('BT-011', 'TANNING_STUDIO', 'Tanning Studio', 'icon_tanning', 'Spray tan and sunbed services', '[
         "SPRAY_TAN",
         "SUNBED",
         "SELF_TAN_APPLICATION"
       ]', 11, 'A', 1),
       ('BT-012', 'TATTOO_STUDIO', 'Tattoo Studio', 'icon_tattoo', 'Tattoo and piercing services', '[
         "TATTOO",
         "PIERCING",
         "TATTOO_REMOVAL"
       ]', 12, 'A', 1),
       ('BT-013', 'GROOMING_STUDIO', 'Grooming Studio', 'icon_grooming', 'General grooming and personal care services',
        '[
          "HAIR_CUT",
          "BEARD_TRIM",
          "FACIAL",
          "WAXING"
        ]', 13, 'A', 1),
       ('BT-014', 'WELLNESS_CENTER', 'Wellness Center', 'icon_wellness', 'Holistic health and wellness services', '[
         "YOGA",
         "MEDITATION",
         "ACUPUNCTURE",
         "REFLEXOLOGY",
         "REIKI"
       ]', 14, 'A', 1),
       ('BT-015', 'PHYSIOTHERAPY', 'Physiotherapy Clinic', 'icon_physio',
        'Physical therapy and rehabilitation services', '[
         "PHYSIOTHERAPY",
         "SPORTS_MASSAGE",
         "REHABILITATION",
         "DRY_NEEDLING"
       ]', 15, 'A', 1),
       ('BT-016', 'HAIR_REMOVAL', 'Hair Removal Studio', 'icon_hair_removal', 'Specialist hair removal services', '[
         "LASER_HAIR_REMOVAL",
         "IPL",
         "WAXING",
         "THREADING",
         "ELECTROLYSIS"
       ]', 16, 'A', 1),
       ('BT-017', 'SKIN_CLINIC', 'Skin Clinic', 'icon_skin', 'Specialist skincare and dermatology services', '[
         "FACIAL",
         "CHEMICAL_PEEL",
         "MICRODERMABRASION",
         "SKIN_ANALYSIS"
       ]', 17, 'A', 1),
       ('BT-018', 'MASSAGE_CENTER', 'Massage Center', 'icon_massage', 'Therapeutic and relaxation massage services', '[
         "SWEDISH_MASSAGE",
         "DEEP_TISSUE",
         "HOT_STONE",
         "THAI_MASSAGE",
         "REFLEXOLOGY"
       ]', 18, 'A', 1),
       ('BT-019', 'BRIDAL_STUDIO', 'Bridal Studio', 'icon_bridal', 'Full bridal beauty and styling services', '[
         "BRIDAL_MAKEUP",
         "BRIDAL_HAIR",
         "MEHENDI",
         "BRIDAL_PACKAGE"
       ]', 19, 'A', 1),
       ('BT-020', 'KIDS_SALON', 'Kids Salon', 'icon_kids_salon', 'Hair and grooming services for children', '[
         "KIDS_HAIRCUT",
         "KIDS_STYLING"
       ]', 20, 'A', 1);



INSERT INTO customer_tiers (internal_id, name, status, created_at, updated_at, version)
VALUES ('CUST-TIER-001', 'Bronze', 'A', NOW(), NOW(), 1),
       ('CUST-TIER-002', 'Silver', 'A', NOW(), NOW(), 1),
       ('CUST-TIER-003', 'Gold', 'A', NOW(), NOW(), 1),
       ('CUST-TIER-004', 'Platinum', 'A', NOW(), NOW(), 1);

INSERT INTO address_types
    (internal_id, type_key, label, display_order, status)
VALUES ('ADDR_TYPE_HOME', 'HOME', 'Home', 1, 'A'),
       ('ADDR_TYPE_WORK', 'WORK', 'Work', 2, 'A'),
       ('ADDR_TYPE_BILLING', 'BILLING', 'Billing', 3, 'A'),
       ('ADDR_TYPE_SHIPPING', 'SHIPPING', 'Shipping', 4, 'A'),
       ('ADDR_TYPE_MAILING', 'MAILING', 'Mailing', 5, 'A'),
       ('ADDR_TYPE_REGISTERED', 'REGISTERED', 'Registered', 6, 'A'),
       ('ADDR_TYPE_PERMANENT', 'PERMANENT', 'Permanent', 7, 'A'),
       ('ADDR_TYPE_TEMPORARY', 'TEMPORARY', 'Temporary', 8, 'A'),
       ('ADDR_TYPE_OFFICE', 'OFFICE', 'Office', 9, 'A'),
       ('ADDR_TYPE_OTHER', 'OTHER', 'Other', 10, 'A');
