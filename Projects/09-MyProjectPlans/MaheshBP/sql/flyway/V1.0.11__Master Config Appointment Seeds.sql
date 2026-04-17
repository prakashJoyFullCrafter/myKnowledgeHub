set
search_path to booking;

-- =========================================================
-- m_booking_channel
-- =========================================================
INSERT INTO m_booking_channel
(internal_code, channel_key, label, description, icon_key, display_order, status, created_at, updated_at, version)
VALUES ('BKG-CHN-001', 'ONLINE', 'Online', 'Booked through customer app or website', 'icon_online', 1, 'A', NOW(),
        NOW(), 1),
       ('BKG-CHN-002', 'WALK_IN', 'Walk-in', 'Customer arrived without prior booking', 'icon_walkin', 2, 'A', NOW(),
        NOW(), 1),
       ('BKG-CHN-003', 'PHONE', 'Phone', 'Booked over the phone by reception', 'icon_phone', 3, 'A', NOW(), NOW(), 1),
       ('BKG-CHN-004', 'ADMIN', 'Admin', 'Created by staff through admin panel', 'icon_admin', 4, 'A', NOW(), NOW(), 1),
       ('BKG-CHN-005', 'IMPORT', 'Imported', 'Migrated from legacy or external system', 'icon_import', 5, 'A', NOW(),
        NOW(), 1);


-- =========================================================
-- m_service_mode
-- =========================================================
INSERT INTO m_service_mode
(internal_code, mode_key, label, description, icon_key, requires_address, display_order, status, created_at, updated_at,
 version)
VALUES ('SVC-MOD-001', 'IN_STORE', 'In-store', 'Customer visits the branch', 'icon_store', FALSE, 1, 'A', NOW(), NOW(),
        1),
       ('SVC-MOD-002', 'HOME_SERVICE', 'Home Service', 'Service delivered at customer location', 'icon_home', TRUE, 2,
        'A', NOW(), NOW(), 1),
       ('SVC-MOD-003', 'TELEHEALTH', 'Telehealth', 'Virtual consultation over video', 'icon_video', FALSE, 3, 'A',
        NOW(), NOW(), 1);


-- =========================================================
-- m_booking_status
-- =========================================================
INSERT INTO m_booking_status
(internal_code, status_key, label, description, color_hex, is_terminal, is_active, display_order, status, created_at,
 updated_at, version)
VALUES ('BKG-STS-001', 'DRAFT', 'Draft', 'Booking being composed, not yet confirmed', '#9E9E9E', FALSE, FALSE, 1, 'A',
        NOW(), NOW(), 1),
       ('BKG-STS-002', 'CONFIRMED', 'Confirmed', 'Booking confirmed, awaiting customer arrival', '#2196F3', FALSE, TRUE,
        2, 'A', NOW(), NOW(), 1),
       ('BKG-STS-003', 'CHECKED_IN', 'Checked-in', 'Customer has arrived at the branch', '#00BCD4', FALSE, TRUE, 3, 'A',
        NOW(), NOW(), 1),
       ('BKG-STS-004', 'IN_PROGRESS', 'In Progress', 'Service currently being delivered', '#FFC107', FALSE, TRUE, 4,
        'A', NOW(), NOW(), 1),
       ('BKG-STS-005', 'COMPLETED', 'Completed', 'All services delivered successfully', '#4CAF50', TRUE, FALSE, 5, 'A',
        NOW(), NOW(), 1),
       ('BKG-STS-006', 'NO_SHOW', 'No Show', 'Customer did not arrive for the booking', '#FF5722', TRUE, FALSE, 6, 'A',
        NOW(), NOW(), 1),
       ('BKG-STS-007', 'CANCELLED', 'Cancelled', 'Booking cancelled before service delivery', '#F44336', TRUE, FALSE, 7,
        'A', NOW(), NOW(), 1);


-- =========================================================
-- m_cancellation_source
-- =========================================================
INSERT INTO m_cancellation_source
(internal_code, source_key, label, description, display_order, status, created_at, updated_at, version)
VALUES ('CNL-SRC-001', 'CUSTOMER', 'Customer', 'Cancelled by the customer', 1, 'A', NOW(), NOW(), 1),
       ('CNL-SRC-002', 'STAFF', 'Staff', 'Cancelled by branch staff or manager', 2, 'A', NOW(), NOW(), 1),
       ('CNL-SRC-003', 'SYSTEM', 'System', 'Cancelled automatically (expired, payment failed, etc.)', 3, 'A', NOW(),
        NOW(), 1);


-- =========================================================
-- m_payment_status
-- =========================================================
INSERT INTO m_payment_status
(internal_code, status_key, label, description, color_hex, is_settled, display_order, status, created_at, updated_at,
 version)
VALUES ('PAY-STS-001', 'UNPAID', 'Unpaid', 'No payment received yet', '#9E9E9E', FALSE, 1, 'A', NOW(), NOW(), 1),
       ('PAY-STS-002', 'PARTIAL', 'Partial', 'Partial payment received (deposit or advance)', '#FFC107', FALSE, 2, 'A',
        NOW(), NOW(), 1),
       ('PAY-STS-003', 'PAID', 'Paid', 'Full payment received and cleared', '#4CAF50', TRUE, 3, 'A', NOW(), NOW(), 1),
       ('PAY-STS-004', 'REFUNDED', 'Refunded', 'Payment returned to customer', '#2196F3', TRUE, 4, 'A', NOW(), NOW(),
        1),
       ('PAY-STS-005', 'FAILED', 'Failed', 'Payment attempt failed or was declined', '#F44336', FALSE, 5, 'A', NOW(),
        NOW(), 1);


-- =========================================================
-- m_booking_status_transitions
--    Legal state machine edges
-- =========================================================
INSERT INTO m_booking_status_transitions
(internal_code, from_status_id, to_status_id, description, status, created_at, updated_at, version)
SELECT 'BKG-TRN-' || LPAD(ROW_NUMBER() OVER ()::TEXT, 3, '0'),
       f.id,
       t.id,
       mapping.description,
       'A',
       NOW(),
       NOW(),
       1
FROM (VALUES
          -- From DRAFT
          ('DRAFT', 'CONFIRMED', 'Customer confirms booking'),
          ('DRAFT', 'CANCELLED', 'Draft abandoned or expired'),

          -- From CONFIRMED
          ('CONFIRMED', 'CHECKED_IN', 'Customer arrives at branch'),
          ('CONFIRMED', 'CANCELLED', 'Booking cancelled before arrival'),
          ('CONFIRMED', 'NO_SHOW', 'Customer did not arrive'),

          -- From CHECKED_IN
          ('CHECKED_IN', 'IN_PROGRESS', 'Service delivery begins'),
          ('CHECKED_IN', 'CANCELLED', 'Cancelled after check-in'),

          -- From IN_PROGRESS
          ('IN_PROGRESS', 'COMPLETED', 'All services delivered'),
          ('IN_PROGRESS', 'CANCELLED', 'Cancelled mid-service')) AS mapping(from_key, to_key, description)
         JOIN m_booking_status f ON f.status_key = mapping.from_key
         JOIN m_booking_status t ON t.status_key = mapping.to_key;