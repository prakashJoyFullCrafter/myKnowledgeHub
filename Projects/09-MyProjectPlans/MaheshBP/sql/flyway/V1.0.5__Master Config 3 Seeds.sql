set
search_path to core;

INSERT INTO m_customer_tier (internal_id, name, status, created_at, updated_at, version)
VALUES ('CUST-TIER-001', 'Bronze', 'A', NOW(), NOW(), 1),
       ('CUST-TIER-002', 'Silver', 'A', NOW(), NOW(), 1),
       ('CUST-TIER-003', 'Gold', 'A', NOW(), NOW(), 1),
       ('CUST-TIER-004', 'Platinum', 'A', NOW(), NOW(), 1);

INSERT INTO m_subscription_plan (internal_id, plan_key, name, description, price_monthly, price_annually, currency_id,
                                branch_limit, staff_limit, booking_limit_monthly, commission_rate, feature_flags,
                                display_order, status, version)
VALUES ('SUB-PLN-001', 'STARTER', 'Starter', 'For small single-branch businesses', 49.00, 490.00, 1, 1, 5, 200, 0.08, '{
  "reports": false,
  "promotions": false,
  "api_access": false,
  "home_service": false,
  "advanced_analytics": false
}', 1, 'A', 1),
       ('SUB-PLN-002', 'GROWTH', 'Growth', 'For growing businesses with more branches', 99.00, 990.00, 1, 3, 15, 1000,
        0.06, '{
         "reports": true,
         "promotions": true,
         "api_access": false,
         "home_service": true,
         "advanced_analytics": false
       }', 2, 'A', 1),
       ('SUB-PLN-003', 'PRO', 'Pro', 'For established multi-branch operations', 199.00, 1990.00, 1, 10, 50, 5000, 0.04,
        '{
          "reports": true,
          "promotions": true,
          "api_access": true,
          "home_service": true,
          "advanced_analytics": true
        }', 3, 'A', 1),
       ('SUB-PLN-004', 'ENTERPRISE', 'Enterprise', 'For large chains and franchise operators', NULL, NULL, 1, NULL,
        NULL, NULL, 0.02, '{
         "reports": true,
         "promotions": true,
         "api_access": true,
         "home_service": true,
         "advanced_analytics": true
       }', 4, 'A', 1);

INSERT INTO m_business_type (internal_id, type_key, label, icon_key, description, default_service_category_keys,
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

INSERT INTO m_break_type (internal_id, name, status, created_at, updated_at, version)
VALUES ('BRK-TYP-001', 'Lunch Break', 'A', NOW(), NOW(), 1),
       ('BRK-TYP-002', 'Prayer Break', 'A', NOW(), NOW(), 1),
       ('BRK-TYP-003', 'Short Break', 'A', NOW(), NOW(), 1),
       ('BRK-TYP-004', 'Personal Break', 'A', NOW(), NOW(), 1),
       ('BRK-TYP-005', 'Training Break', 'A', NOW(), NOW(), 1);

INSERT INTO m_gender (internal_id, gender_key, label, display_order, status, created_at, updated_at, version)
VALUES ('GEN-001', 'MALE', 'Male', 1, 'A', NOW(), NOW(), 1),
       ('GEN-002', 'FEMALE', 'Female', 2, 'A', NOW(), NOW(), 1),
       ('GEN-003', 'OTHER', 'Other', 3, 'A', NOW(), NOW(), 1),
       ('GEN-004', 'PREFER_NOT_SAY', 'Prefer Not to Say', 4, 'A', NOW(), NOW(), 1);

INSERT INTO m_leave_type
(internal_id, name, is_paid, days_allowed, carry_forward, requires_approval, applicable_to_all)
VALUES ('LVT-001', 'Annual Leave', TRUE, 30, TRUE, TRUE, FALSE),
       ('LVT-002', 'Sick Leave', TRUE, 15, FALSE, FALSE, FALSE),
       ('LVT-003', 'Unpaid Leave', FALSE, NULL, FALSE, TRUE, FALSE),
       ('LVT-004', 'Maternity Leave', TRUE, 90, FALSE, TRUE, FALSE),
       ('LVT-005', 'Paternity Leave', TRUE, 7, FALSE, TRUE, FALSE),
       ('LVT-006', 'Emergency Leave', TRUE, 3, FALSE, FALSE, FALSE);
