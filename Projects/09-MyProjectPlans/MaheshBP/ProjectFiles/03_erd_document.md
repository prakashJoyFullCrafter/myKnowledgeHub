# ERD Document

## ERD Objective
Define the core entities and relationships for a PostgreSQL-based multi-tenant SaaS platform for beauty, salon, barber, spa, and related service businesses.

---

## Core Domains

### Tenant and Subscription
- tenants
- subscription_plans
- tenant_subscriptions
- tenant_settings
- tenant_modules

### User and Access
- users
- user_profiles
- roles
- permissions
- role_permissions
- user_roles
- user_addresses
- user_devices
- user_notification_preferences

### Merchant Structure
- businesses
- business_types
- branches
- branch_addresses
- branch_operating_hours
- branch_holidays
- branch_closures *(supports ad-hoc one-off closures in addition to recurring holidays)*
- branch_service_areas

### Catalog and Services
- service_categories
- services
- service_variants
- service_addons
- service_bundles
- branch_services
- service_pricing
- service_duration_rules *(includes buffer time between appointments)*
- service_availability_rules

### Staff
- staff
- staff_profiles
- staff_branch_assignments
- staff_services
- staff_working_hours *(subordinate to branch_operating_hours; staff cannot be scheduled outside branch hours)*
- staff_availability_overrides *(per-staff on/off toggle for pausing new bookings)*
- staff_breaks
- staff_leaves
- staff_commissions

### Booking
- appointments
- appointment_services
- appointment_staff_assignments
- appointment_status_history *(statuses include: pending, confirmed, checked_in, completed, no_show, cancelled)*
- appointment_notes
- appointment_reschedule_history
- appointment_cancellations
- appointment_checkins
- slot_holds *(short-lived lock record created when a customer selects a slot; expires if booking is not confirmed within TTL)*
- waitlists
- queue_tokens *(walk-in queue management: token number, issue time, estimated wait, status)*

### Notifications
- notifications
- notification_templates
- notification_logs

*(Note: user_devices and user_notification_preferences are in the User and Access domain above and feed into this domain.)*

### Customer Engagement
- favorites
- reviews
- review_replies
- ratings_summary
- customer_notes
- customer_tags
- no_show_records *(linked to appointment; contributes to per-customer no-show count visible to merchants)*

### Payments
- payment_methods
- payments
- payment_transactions
- refunds
- invoices
- invoice_items
- tax_rules
- tips

### Promotions and Loyalty
- promotions
- promo_codes
- promo_redemptions
- campaigns
- referrals
- memberships
- membership_plans
- customer_memberships
- loyalty_accounts
- loyalty_transactions
- wallets
- wallet_transactions
- gift_cards

### Admin and Compliance
- merchant_applications
- kyc_documents
- verification_status_history
- settlements
- settlement_items
- disputes
- complaints
- support_tickets
- audit_logs
- platform_settings
- platform_fees
- commission_rules

---

## Main Relationships
- One tenant has many businesses
- One business has many branches
- One branch has many staff members
- One branch offers many services
- One branch has many branch_operating_hours rows (one per day of week) and many branch_closures rows (ad-hoc dates)
- One staff member has many staff_working_hours rows; these must fall within the branch's operating hours
- One customer can have many appointments
- One appointment belongs to one branch
- One appointment can include many appointment_services
- One appointment can map to one or more staff assignments
- One appointment can have one payment record
- One appointment can have one no_show_record
- One slot selection creates one slot_hold; confirmed booking removes the hold
- One branch can have many reviews
- One branch can have many active queue_tokens at a time (walk-in queue)

---

## PostgreSQL Design Notes
- Use UUID primary keys
- Add created_at and updated_at to major tables
- Use deleted_at where soft delete is needed
- Use JSONB for flexible settings and metadata
- Use PostGIS for location-based discovery
- Add indexes on:
  - geolocation columns
  - foreign keys
  - booking date/time
  - service lookup columns
  - status columns
  - slot_holds expiry timestamp (for TTL cleanup jobs)

### Slot Concurrency Design Note
The `slot_holds` table implements optimistic locking for the booking flow. When a customer selects a slot, a hold record is inserted with a short TTL (e.g. 5 minutes). If the booking is confirmed, the hold is converted to a confirmed appointment. If TTL expires without confirmation, the slot is released. A unique constraint on (branch_id, staff_id, slot_start) prevents two confirmed appointments from occupying the same slot.

### Staff Hours vs Branch Hours
`staff_working_hours` defines when a staff member is scheduled. The slot generation engine must intersect staff_working_hours with branch_operating_hours and subtract staff_breaks, staff_leaves, and any existing confirmed appointments. Staff cannot be booked outside branch operating hours regardless of their own schedule entries.

---

## Recommended MVP Entity Set
- users
- user_profiles
- roles
- businesses
- branches
- branch_addresses
- branch_operating_hours
- branch_closures
- staff
- staff_working_hours
- staff_availability_overrides
- staff_services
- service_categories
- services
- branch_services
- service_pricing
- service_duration_rules
- slot_holds
- appointments
- appointment_services
- appointment_status_history
- appointment_checkins
- queue_tokens
- payments
- reviews
- favorites
- notifications
- notification_templates
- no_show_records
- subscription_plans
- tenant_subscriptions
