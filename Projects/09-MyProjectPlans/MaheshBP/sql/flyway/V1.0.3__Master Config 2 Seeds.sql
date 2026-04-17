set
search_path to core;
INSERT INTO m_device_type (internal_id, name, display_order, status, created_at, updated_at, version)
VALUES ('DEV-TYPE-001', 'Mobile', 1, 'A', NOW(), NOW(), 1),
       ('DEV-TYPE-002', 'Tablet', 2, 'A', NOW(), NOW(), 1),
       ('DEV-TYPE-003', 'Desktop', 3, 'A', NOW(), NOW(), 1);

-- browser_types
INSERT INTO m_browser_type (internal_id, name, display_order, status, created_at, updated_at, version)
VALUES ('BROW-TYPE-001', 'Chrome', 1, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-002', 'Safari', 2, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-003', 'Firefox', 3, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-004', 'Edge', 4, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-005', 'Opera', 5, 'A', NOW(), NOW(), 1),
       ('BROW-TYPE-006', 'Other', 6, 'A', NOW(), NOW(), 1);

-- os_types
INSERT INTO m_os_type (internal_id, name, display_order, status, created_at, updated_at, version)
VALUES ('OS-TYPE-001', 'iOS', 1, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-002', 'Android', 2, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-003', 'Windows', 3, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-004', 'macOS', 4, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-005', 'Linux', 5, 'A', NOW(), NOW(), 1),
       ('OS-TYPE-006', 'Other', 6, 'A', NOW(), NOW(), 1);

INSERT INTO m_media_type (internal_id, type_key, name, allowed_extensions, max_size_mb, created_at, updated_at, version)
VALUES
    ('MED-TYP-001', 'IMAGE',     'Image',     '["jpg","jpeg","png","webp","heic"]', 5,   NOW(), NOW(), 1),
    ('MED-TYP-002', 'VIDEO',     'Video',     '["mp4","mov","avi"]',               50,  NOW(), NOW(), 1),
    ('MED-TYP-003', 'DOCUMENT',  'Document',  '["pdf","doc","docx"]',              10,  NOW(), NOW(), 1),
    ('MED-TYP-004', 'AVATAR',    'Avatar',    '["jpg","jpeg","png","webp"]',       2,   NOW(), NOW(), 1),
    ('MED-TYP-005', 'LOGO',      'Logo',      '["jpg","jpeg","png","webp","svg"]', 2,   NOW(), NOW(), 1),
    ('MED-TYP-006', 'BANNER',    'Banner',    '["jpg","jpeg","png","webp"]',       3,   NOW(), NOW(), 1),
    ('MED-TYP-007', 'KYC',       'KYC Document', '["jpg","jpeg","png","pdf"]',    10,  NOW(), NOW(), 1),
    ('MED-TYP-008', 'PORTFOLIO', 'Portfolio', '["jpg","jpeg","png","webp"]',       5,   NOW(), NOW(), 1);


