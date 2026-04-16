INSERT INTO break_types (internal_id, name, status, created_at, updated_at, version)
VALUES ('BRK-TYP-001', 'Lunch Break', 'A', NOW(), NOW(), 1),
       ('BRK-TYP-002', 'Prayer Break', 'A', NOW(), NOW(), 1),
       ('BRK-TYP-003', 'Short Break', 'A', NOW(), NOW(), 1),
       ('BRK-TYP-004', 'Personal Break', 'A', NOW(), NOW(), 1),
       ('BRK-TYP-005', 'Training Break', 'A', NOW(), NOW(), 1);

INSERT INTO genders (internal_id, gender_key, label, display_order, status, created_at, updated_at, version)
VALUES ('GEN-001', 'MALE', 'Male', 1, 'A', NOW(), NOW(), 1),
       ('GEN-002', 'FEMALE', 'Female', 2, 'A', NOW(), NOW(), 1),
       ('GEN-003', 'OTHER', 'Other', 3, 'A', NOW(), NOW(), 1),
       ('GEN-004', 'PREFER_NOT_SAY', 'Prefer Not to Say', 4, 'A', NOW(), NOW(), 1);

INSERT INTO leave_types
(internal_id, name, is_paid, days_allowed, carry_forward, requires_approval, applicable_to_all)
VALUES ('LVT-001', 'Annual Leave', TRUE, 30, TRUE, TRUE, FALSE),
       ('LVT-002', 'Sick Leave', TRUE, 15, FALSE, FALSE, FALSE),
       ('LVT-003', 'Unpaid Leave', FALSE, NULL, FALSE, TRUE, FALSE),
       ('LVT-004', 'Maternity Leave', TRUE, 90, FALSE, TRUE, FALSE),
       ('LVT-005', 'Paternity Leave', TRUE, 7, FALSE, TRUE, FALSE),
       ('LVT-006', 'Emergency Leave', TRUE, 3, FALSE, FALSE, FALSE);
