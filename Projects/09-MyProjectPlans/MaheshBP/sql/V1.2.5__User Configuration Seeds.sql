INSERT INTO security.auth_providers (internal_id, provider_key, name, status, created_at, updated_at, version)
VALUES ('AUTH-PRV-001', 'GOOGLE', 'Google', 'A', NOW(), NOW(), 1),
       ('AUTH-PRV-002', 'APPLE', 'Apple', 'A', NOW(), NOW(), 1),
       ('AUTH-PRV-003', 'FACEBOOK', 'Facebook', 'A', NOW(), NOW(), 1),
       ('AUTH-PRV-004', 'PHONE_OTP', 'Phone OTP', 'A', NOW(), NOW(), 1),
       ('AUTH-PRV-005', 'EMAIL_OTP', 'Email OTP', 'A', NOW(), NOW(), 1);
INSERT INTO security.roles (internal_id, role_key, name, user_type)
VALUES ('ROLE-007', 'PLATFORM_ADMIN', 'Platform Admin', 'PLATFORM_ADMIN'),
       ('ROLE-008', 'PLATFORM_SUPPORT', 'Platform Support', 'PLATFORM_ADMIN'),
       ('ROLE-009', 'PLATFORM_FINANCE', 'Platform Finance', 'PLATFORM_ADMIN'),
       ('ROLE-010', 'MERCHANT_FINANCE', 'Merchant Finance', 'MERCHANT_OWNER'),
       ('ROLE-011', 'BRANCH_RECEPTIONIST', 'Branch Receptionist', 'BRANCH_MANAGER'),
       ('ROLE-012', 'CUSTOMER', 'Customer', 'CUSTOMER');

INSERT INTO security.permissions (internal_id, permission_key, name, domain, created_at, updated_at, version)
VALUES

    -- DOMAIN: PLATFORM
    ('PERM-001', 'PLATFORM.DASHBOARD.VIEW', 'View Platform Dashboard', 'PLATFORM', NOW(), NOW(), 1),
    ('PERM-002', 'PLATFORM.SETTINGS.VIEW', 'View Platform Settings', 'PLATFORM', NOW(), NOW(), 1),
    ('PERM-003', 'PLATFORM.SETTINGS.MANAGE', 'Manage Platform Settings', 'PLATFORM', NOW(), NOW(), 1),
    ('PERM-004', 'PLATFORM.TENANTS.VIEW', 'View All Tenants', 'PLATFORM', NOW(), NOW(), 1),
    ('PERM-005', 'PLATFORM.TENANTS.MANAGE', 'Manage Tenants', 'PLATFORM', NOW(), NOW(), 1),
    ('PERM-006', 'PLATFORM.AUDIT.VIEW', 'View Audit Logs', 'PLATFORM', NOW(), NOW(), 1),

    -- DOMAIN: MERCHANT APPLICATIONS
    ('PERM-007', 'MERCHANT.APPLICATION.VIEW', 'View Merchant Applications', 'MERCHANT_APPLICATION', NOW(), NOW(), 1),
    ('PERM-008', 'MERCHANT.APPLICATION.APPROVE', 'Approve Merchant Applications', 'MERCHANT_APPLICATION', NOW(), NOW(),
     1),
    ('PERM-009', 'MERCHANT.APPLICATION.REJECT', 'Reject Merchant Applications', 'MERCHANT_APPLICATION', NOW(), NOW(),
     1),

    -- DOMAIN: FINANCE (PLATFORM)
    ('PERM-010', 'FINANCE.SETTLEMENTS.VIEW', 'View Settlements', 'FINANCE', NOW(), NOW(), 1),
    ('PERM-011', 'FINANCE.SETTLEMENTS.MANAGE', 'Manage Settlements', 'FINANCE', NOW(), NOW(), 1),
    ('PERM-012', 'FINANCE.PAYOUTS.VIEW', 'View Payouts', 'FINANCE', NOW(), NOW(), 1),
    ('PERM-013', 'FINANCE.PAYOUTS.MANAGE', 'Manage Payouts', 'FINANCE', NOW(), NOW(), 1),
    ('PERM-014', 'FINANCE.INVOICES.VIEW', 'View Invoices', 'FINANCE', NOW(), NOW(), 1),
    ('PERM-015', 'FINANCE.REPORTS.VIEW', 'View Financial Reports', 'FINANCE', NOW(), NOW(), 1),

    -- DOMAIN: SUPPORT
    ('PERM-016', 'SUPPORT.TICKETS.VIEW', 'View Support Tickets', 'SUPPORT', NOW(), NOW(), 1),
    ('PERM-017', 'SUPPORT.TICKETS.MANAGE', 'Manage Support Tickets', 'SUPPORT', NOW(), NOW(), 1),
    ('PERM-018', 'SUPPORT.DISPUTES.VIEW', 'View Disputes', 'SUPPORT', NOW(), NOW(), 1),
    ('PERM-019', 'SUPPORT.DISPUTES.MANAGE', 'Manage Disputes', 'SUPPORT', NOW(), NOW(), 1),
    ('PERM-020', 'SUPPORT.COMPLAINTS.VIEW', 'View Complaints', 'SUPPORT', NOW(), NOW(), 1),
    ('PERM-021', 'SUPPORT.COMPLAINTS.MANAGE', 'Manage Complaints', 'SUPPORT', NOW(), NOW(), 1),
    ('PERM-022', 'SUPPORT.REVIEWS.MODERATE', 'Moderate Reviews', 'SUPPORT', NOW(), NOW(), 1),

    -- DOMAIN: BUSINESS
    ('PERM-023', 'BUSINESS.PROFILE.VIEW', 'View Business Profile', 'BUSINESS', NOW(), NOW(), 1),
    ('PERM-024', 'BUSINESS.PROFILE.MANAGE', 'Manage Business Profile', 'BUSINESS', NOW(), NOW(), 1),
    ('PERM-025', 'BUSINESS.BRANCHES.VIEW', 'View Branches', 'BUSINESS', NOW(), NOW(), 1),
    ('PERM-026', 'BUSINESS.BRANCHES.MANAGE', 'Manage Branches', 'BUSINESS', NOW(), NOW(), 1),
    ('PERM-027', 'BUSINESS.SUBSCRIPTION.VIEW', 'View Subscription', 'BUSINESS', NOW(), NOW(), 1),
    ('PERM-028', 'BUSINESS.SUBSCRIPTION.MANAGE', 'Manage Subscription', 'BUSINESS', NOW(), NOW(), 1),
    ('PERM-029', 'BUSINESS.REPORTS.VIEW', 'View Business Reports', 'BUSINESS', NOW(), NOW(), 1),

    -- DOMAIN: BRANCH
    ('PERM-030', 'BRANCH.PROFILE.VIEW', 'View Branch Profile', 'BRANCH', NOW(), NOW(), 1),
    ('PERM-031', 'BRANCH.PROFILE.MANAGE', 'Manage Branch Profile', 'BRANCH', NOW(), NOW(), 1),
    ('PERM-032', 'BRANCH.SCHEDULE.VIEW', 'View Branch Schedule', 'BRANCH', NOW(), NOW(), 1),
    ('PERM-033', 'BRANCH.SCHEDULE.MANAGE', 'Manage Branch Schedule', 'BRANCH', NOW(), NOW(), 1),
    ('PERM-034', 'BRANCH.HOLIDAYS.MANAGE', 'Manage Branch Holidays', 'BRANCH', NOW(), NOW(), 1),
    ('PERM-035', 'BRANCH.REPORTS.VIEW', 'View Branch Reports', 'BRANCH', NOW(), NOW(), 1),

    -- DOMAIN: STAFF
    ('PERM-036', 'STAFF.VIEW', 'View Staff', 'STAFF', NOW(), NOW(), 1),
    ('PERM-037', 'STAFF.MANAGE', 'Manage Staff', 'STAFF', NOW(), NOW(), 1),
    ('PERM-038', 'STAFF.SCHEDULE.VIEW', 'View Staff Schedule', 'STAFF', NOW(), NOW(), 1),
    ('PERM-039', 'STAFF.SCHEDULE.MANAGE', 'Manage Staff Schedule', 'STAFF', NOW(), NOW(), 1),
    ('PERM-040', 'STAFF.LEAVES.VIEW', 'View Staff Leaves', 'STAFF', NOW(), NOW(), 1),
    ('PERM-041', 'STAFF.LEAVES.MANAGE', 'Manage Staff Leaves', 'STAFF', NOW(), NOW(), 1),
    ('PERM-042', 'STAFF.OWN.SCHEDULE.VIEW', 'View Own Schedule', 'STAFF', NOW(), NOW(), 1),
    ('PERM-043', 'STAFF.OWN.APPOINTMENTS.VIEW', 'View Own Appointments', 'STAFF', NOW(), NOW(), 1),
    ('PERM-044', 'STAFF.OWN.AVAILABILITY.MANAGE', 'Manage Own Availability', 'STAFF', NOW(), NOW(), 1),

    -- DOMAIN: SERVICES
    ('PERM-045', 'SERVICES.VIEW', 'View Services', 'SERVICES', NOW(), NOW(), 1),
    ('PERM-046', 'SERVICES.MANAGE', 'Manage Services', 'SERVICES', NOW(), NOW(), 1),
    ('PERM-047', 'SERVICES.PRICING.VIEW', 'View Service Pricing', 'SERVICES', NOW(), NOW(), 1),
    ('PERM-048', 'SERVICES.PRICING.MANAGE', 'Manage Service Pricing', 'SERVICES', NOW(), NOW(), 1),

    -- DOMAIN: APPOINTMENTS
    ('PERM-049', 'APPOINTMENTS.VIEW', 'View Appointments', 'APPOINTMENTS', NOW(), NOW(), 1),
    ('PERM-050', 'APPOINTMENTS.MANAGE', 'Manage Appointments', 'APPOINTMENTS', NOW(), NOW(), 1),
    ('PERM-051', 'APPOINTMENTS.CHECKIN', 'Check In Appointments', 'APPOINTMENTS', NOW(), NOW(), 1),
    ('PERM-052', 'APPOINTMENTS.CANCEL', 'Cancel Appointments', 'APPOINTMENTS', NOW(), NOW(), 1),
    ('PERM-053', 'APPOINTMENTS.RESCHEDULE', 'Reschedule Appointments', 'APPOINTMENTS', NOW(), NOW(), 1),
    ('PERM-054', 'APPOINTMENTS.NOSHOW.MARK', 'Mark No Show', 'APPOINTMENTS', NOW(), NOW(), 1),
    ('PERM-055', 'APPOINTMENTS.WALKIN.MANAGE', 'Manage Walk-ins', 'APPOINTMENTS', NOW(), NOW(), 1),
    ('PERM-056', 'APPOINTMENTS.QUEUE.MANAGE', 'Manage Queue Tokens', 'APPOINTMENTS', NOW(), NOW(), 1),

    -- DOMAIN: CUSTOMERS
    ('PERM-057', 'CUSTOMERS.VIEW', 'View Customers', 'CUSTOMERS', NOW(), NOW(), 1),
    ('PERM-058', 'CUSTOMERS.NOTES.MANAGE', 'Manage Customer Notes', 'CUSTOMERS', NOW(), NOW(), 1),
    ('PERM-059', 'CUSTOMERS.TAGS.MANAGE', 'Manage Customer Tags', 'CUSTOMERS', NOW(), NOW(), 1),

    -- DOMAIN: PAYMENTS
    ('PERM-060', 'PAYMENTS.VIEW', 'View Payments', 'PAYMENTS', NOW(), NOW(), 1),
    ('PERM-061', 'PAYMENTS.REFUND', 'Process Refunds', 'PAYMENTS', NOW(), NOW(), 1),

    -- DOMAIN: PROMOTIONS
    ('PERM-062', 'PROMOTIONS.VIEW', 'View Promotions', 'PROMOTIONS', NOW(), NOW(), 1),
    ('PERM-063', 'PROMOTIONS.MANAGE', 'Manage Promotions', 'PROMOTIONS', NOW(), NOW(), 1),

    -- DOMAIN: CUSTOMER SELF
    ('PERM-064', 'CUSTOMER.BOOKING.CREATE', 'Create Booking', 'CUSTOMER', NOW(), NOW(), 1),
    ('PERM-065', 'CUSTOMER.BOOKING.CANCEL', 'Cancel Own Booking', 'CUSTOMER', NOW(), NOW(), 1),
    ('PERM-066', 'CUSTOMER.BOOKING.RESCHEDULE', 'Reschedule Own Booking', 'CUSTOMER', NOW(), NOW(), 1),
    ('PERM-067', 'CUSTOMER.BOOKING.VIEW', 'View Own Bookings', 'CUSTOMER', NOW(), NOW(), 1),
    ('PERM-068', 'CUSTOMER.PROFILE.MANAGE', 'Manage Own Profile', 'CUSTOMER', NOW(), NOW(), 1),
    ('PERM-069', 'CUSTOMER.REVIEWS.MANAGE', 'Write and Manage Own Reviews', 'CUSTOMER', NOW(), NOW(), 1),
    ('PERM-070', 'CUSTOMER.FAVORITES.MANAGE', 'Manage Favorites', 'CUSTOMER', NOW(), NOW(), 1);



INSERT INTO security.role_permissions (internal_id, role_id, permission_id, created_at, updated_at, version)
SELECT 'RP-' || LPAD(ROW_NUMBER() OVER ()::TEXT, 4, '0'),
       r.id,
       p.id,
       NOW(),
       NOW(),
       1
FROM (VALUES

          -- PLATFORM_ADMIN → everything
          ('PLATFORM_ADMIN', 'PLATFORM.DASHBOARD.VIEW'),
          ('PLATFORM_ADMIN', 'PLATFORM.SETTINGS.VIEW'),
          ('PLATFORM_ADMIN', 'PLATFORM.SETTINGS.MANAGE'),
          ('PLATFORM_ADMIN', 'PLATFORM.TENANTS.VIEW'),
          ('PLATFORM_ADMIN', 'PLATFORM.TENANTS.MANAGE'),
          ('PLATFORM_ADMIN', 'PLATFORM.AUDIT.VIEW'),
          ('PLATFORM_ADMIN', 'MERCHANT.APPLICATION.VIEW'),
          ('PLATFORM_ADMIN', 'MERCHANT.APPLICATION.APPROVE'),
          ('PLATFORM_ADMIN', 'MERCHANT.APPLICATION.REJECT'),
          ('PLATFORM_ADMIN', 'FINANCE.SETTLEMENTS.VIEW'),
          ('PLATFORM_ADMIN', 'FINANCE.SETTLEMENTS.MANAGE'),
          ('PLATFORM_ADMIN', 'FINANCE.PAYOUTS.VIEW'),
          ('PLATFORM_ADMIN', 'FINANCE.PAYOUTS.MANAGE'),
          ('PLATFORM_ADMIN', 'FINANCE.INVOICES.VIEW'),
          ('PLATFORM_ADMIN', 'FINANCE.REPORTS.VIEW'),
          ('PLATFORM_ADMIN', 'SUPPORT.TICKETS.VIEW'),
          ('PLATFORM_ADMIN', 'SUPPORT.TICKETS.MANAGE'),
          ('PLATFORM_ADMIN', 'SUPPORT.DISPUTES.VIEW'),
          ('PLATFORM_ADMIN', 'SUPPORT.DISPUTES.MANAGE'),
          ('PLATFORM_ADMIN', 'SUPPORT.COMPLAINTS.VIEW'),
          ('PLATFORM_ADMIN', 'SUPPORT.COMPLAINTS.MANAGE'),
          ('PLATFORM_ADMIN', 'SUPPORT.REVIEWS.MODERATE'),

          -- PLATFORM_SUPPORT → read only
          ('PLATFORM_SUPPORT', 'PLATFORM.DASHBOARD.VIEW'),
          ('PLATFORM_SUPPORT', 'PLATFORM.TENANTS.VIEW'),
          ('PLATFORM_SUPPORT', 'SUPPORT.TICKETS.VIEW'),
          ('PLATFORM_SUPPORT', 'SUPPORT.TICKETS.MANAGE'),
          ('PLATFORM_SUPPORT', 'SUPPORT.DISPUTES.VIEW'),
          ('PLATFORM_SUPPORT', 'SUPPORT.COMPLAINTS.VIEW'),
          ('PLATFORM_SUPPORT', 'MERCHANT.APPLICATION.VIEW'),

          -- PLATFORM_FINANCE → financial only
          ('PLATFORM_FINANCE', 'FINANCE.SETTLEMENTS.VIEW'),
          ('PLATFORM_FINANCE', 'FINANCE.SETTLEMENTS.MANAGE'),
          ('PLATFORM_FINANCE', 'FINANCE.PAYOUTS.VIEW'),
          ('PLATFORM_FINANCE', 'FINANCE.PAYOUTS.MANAGE'),
          ('PLATFORM_FINANCE', 'FINANCE.INVOICES.VIEW'),
          ('PLATFORM_FINANCE', 'FINANCE.REPORTS.VIEW'),

          -- MERCHANT_OWNER → full tenant access
          ('MERCHANT_OWNER', 'BUSINESS.PROFILE.VIEW'),
          ('MERCHANT_OWNER', 'BUSINESS.PROFILE.MANAGE'),
          ('MERCHANT_OWNER', 'BUSINESS.BRANCHES.VIEW'),
          ('MERCHANT_OWNER', 'BUSINESS.BRANCHES.MANAGE'),
          ('MERCHANT_OWNER', 'BUSINESS.SUBSCRIPTION.VIEW'),
          ('MERCHANT_OWNER', 'BUSINESS.SUBSCRIPTION.MANAGE'),
          ('MERCHANT_OWNER', 'BUSINESS.REPORTS.VIEW'),
          ('MERCHANT_OWNER', 'BRANCH.PROFILE.VIEW'),
          ('MERCHANT_OWNER', 'BRANCH.PROFILE.MANAGE'),
          ('MERCHANT_OWNER', 'BRANCH.SCHEDULE.VIEW'),
          ('MERCHANT_OWNER', 'BRANCH.SCHEDULE.MANAGE'),
          ('MERCHANT_OWNER', 'BRANCH.HOLIDAYS.MANAGE'),
          ('MERCHANT_OWNER', 'BRANCH.REPORTS.VIEW'),
          ('MERCHANT_OWNER', 'STAFF.VIEW'),
          ('MERCHANT_OWNER', 'STAFF.MANAGE'),
          ('MERCHANT_OWNER', 'STAFF.SCHEDULE.VIEW'),
          ('MERCHANT_OWNER', 'STAFF.SCHEDULE.MANAGE'),
          ('MERCHANT_OWNER', 'STAFF.LEAVES.VIEW'),
          ('MERCHANT_OWNER', 'STAFF.LEAVES.MANAGE'),
          ('MERCHANT_OWNER', 'SERVICES.VIEW'),
          ('MERCHANT_OWNER', 'SERVICES.MANAGE'),
          ('MERCHANT_OWNER', 'SERVICES.PRICING.VIEW'),
          ('MERCHANT_OWNER', 'SERVICES.PRICING.MANAGE'),
          ('MERCHANT_OWNER', 'APPOINTMENTS.VIEW'),
          ('MERCHANT_OWNER', 'APPOINTMENTS.MANAGE'),
          ('MERCHANT_OWNER', 'APPOINTMENTS.CHECKIN'),
          ('MERCHANT_OWNER', 'APPOINTMENTS.CANCEL'),
          ('MERCHANT_OWNER', 'APPOINTMENTS.RESCHEDULE'),
          ('MERCHANT_OWNER', 'APPOINTMENTS.NOSHOW.MARK'),
          ('MERCHANT_OWNER', 'APPOINTMENTS.WALKIN.MANAGE'),
          ('MERCHANT_OWNER', 'APPOINTMENTS.QUEUE.MANAGE'),
          ('MERCHANT_OWNER', 'CUSTOMERS.VIEW'),
          ('MERCHANT_OWNER', 'CUSTOMERS.NOTES.MANAGE'),
          ('MERCHANT_OWNER', 'CUSTOMERS.TAGS.MANAGE'),
          ('MERCHANT_OWNER', 'PAYMENTS.VIEW'),
          ('MERCHANT_OWNER', 'PAYMENTS.REFUND'),
          ('MERCHANT_OWNER', 'PROMOTIONS.VIEW'),
          ('MERCHANT_OWNER', 'PROMOTIONS.MANAGE'),

          -- MERCHANT_FINANCE → financial only at tenant level
          ('MERCHANT_FINANCE', 'BUSINESS.REPORTS.VIEW'),
          ('MERCHANT_FINANCE', 'FINANCE.INVOICES.VIEW'),
          ('MERCHANT_FINANCE', 'PAYMENTS.VIEW'),
          ('MERCHANT_FINANCE', 'BRANCH.REPORTS.VIEW'),

          -- BRANCH_MANAGER → full branch access
          ('BRANCH_MANAGER', 'BRANCH.PROFILE.VIEW'),
          ('BRANCH_MANAGER', 'BRANCH.PROFILE.MANAGE'),
          ('BRANCH_MANAGER', 'BRANCH.SCHEDULE.VIEW'),
          ('BRANCH_MANAGER', 'BRANCH.SCHEDULE.MANAGE'),
          ('BRANCH_MANAGER', 'BRANCH.HOLIDAYS.MANAGE'),
          ('BRANCH_MANAGER', 'BRANCH.REPORTS.VIEW'),
          ('BRANCH_MANAGER', 'STAFF.VIEW'),
          ('BRANCH_MANAGER', 'STAFF.MANAGE'),
          ('BRANCH_MANAGER', 'STAFF.SCHEDULE.VIEW'),
          ('BRANCH_MANAGER', 'STAFF.SCHEDULE.MANAGE'),
          ('BRANCH_MANAGER', 'STAFF.LEAVES.VIEW'),
          ('BRANCH_MANAGER', 'STAFF.LEAVES.MANAGE'),
          ('BRANCH_MANAGER', 'SERVICES.VIEW'),
          ('BRANCH_MANAGER', 'SERVICES.PRICING.VIEW'),
          ('BRANCH_MANAGER', 'APPOINTMENTS.VIEW'),
          ('BRANCH_MANAGER', 'APPOINTMENTS.MANAGE'),
          ('BRANCH_MANAGER', 'APPOINTMENTS.CHECKIN'),
          ('BRANCH_MANAGER', 'APPOINTMENTS.CANCEL'),
          ('BRANCH_MANAGER', 'APPOINTMENTS.RESCHEDULE'),
          ('BRANCH_MANAGER', 'APPOINTMENTS.NOSHOW.MARK'),
          ('BRANCH_MANAGER', 'APPOINTMENTS.WALKIN.MANAGE'),
          ('BRANCH_MANAGER', 'APPOINTMENTS.QUEUE.MANAGE'),
          ('BRANCH_MANAGER', 'CUSTOMERS.VIEW'),
          ('BRANCH_MANAGER', 'CUSTOMERS.NOTES.MANAGE'),
          ('BRANCH_MANAGER', 'CUSTOMERS.TAGS.MANAGE'),
          ('BRANCH_MANAGER', 'PAYMENTS.VIEW'),
          ('BRANCH_MANAGER', 'PROMOTIONS.VIEW'),

          -- BRANCH_RECEPTIONIST → front desk only
          ('BRANCH_RECEPTIONIST', 'BRANCH.SCHEDULE.VIEW'),
          ('BRANCH_RECEPTIONIST', 'SERVICES.VIEW'),
          ('BRANCH_RECEPTIONIST', 'APPOINTMENTS.VIEW'),
          ('BRANCH_RECEPTIONIST', 'APPOINTMENTS.CHECKIN'),
          ('BRANCH_RECEPTIONIST', 'APPOINTMENTS.CANCEL'),
          ('BRANCH_RECEPTIONIST', 'APPOINTMENTS.RESCHEDULE'),
          ('BRANCH_RECEPTIONIST', 'APPOINTMENTS.WALKIN.MANAGE'),
          ('BRANCH_RECEPTIONIST', 'APPOINTMENTS.QUEUE.MANAGE'),
          ('BRANCH_RECEPTIONIST', 'CUSTOMERS.VIEW'),
          ('BRANCH_RECEPTIONIST', 'PAYMENTS.VIEW'),

          -- STAFF_SENIOR → own schedule + appointments + availability
          ('STAFF_SENIOR', 'STAFF.OWN.SCHEDULE.VIEW'),
          ('STAFF_SENIOR', 'STAFF.OWN.APPOINTMENTS.VIEW'),
          ('STAFF_SENIOR', 'STAFF.OWN.AVAILABILITY.MANAGE'),
          ('STAFF_SENIOR', 'STAFF.LEAVES.VIEW'),
          ('STAFF_SENIOR', 'SERVICES.VIEW'),
          ('STAFF_SENIOR', 'APPOINTMENTS.VIEW'),
          ('STAFF_SENIOR', 'APPOINTMENTS.CHECKIN'),
          ('STAFF_SENIOR', 'APPOINTMENTS.NOSHOW.MARK'),
          ('STAFF_SENIOR', 'CUSTOMERS.VIEW'),

          -- STAFF_JUNIOR → view only own schedule and appointments
          ('STAFF_JUNIOR', 'STAFF.OWN.SCHEDULE.VIEW'),
          ('STAFF_JUNIOR', 'STAFF.OWN.APPOINTMENTS.VIEW'),
          ('STAFF_JUNIOR', 'SERVICES.VIEW'),

          -- CUSTOMER → self service only
          ('CUSTOMER', 'CUSTOMER.BOOKING.CREATE'),
          ('CUSTOMER', 'CUSTOMER.BOOKING.CANCEL'),
          ('CUSTOMER', 'CUSTOMER.BOOKING.RESCHEDULE'),
          ('CUSTOMER', 'CUSTOMER.BOOKING.VIEW'),
          ('CUSTOMER', 'CUSTOMER.PROFILE.MANAGE'),
          ('CUSTOMER', 'CUSTOMER.REVIEWS.MANAGE'),
          ('CUSTOMER', 'CUSTOMER.FAVORITES.MANAGE')) AS mapping(role_key, permission_key)
         JOIN roles r ON r.role_key = mapping.role_key
         JOIN permissions p ON p.permission_key = mapping.permission_key;
