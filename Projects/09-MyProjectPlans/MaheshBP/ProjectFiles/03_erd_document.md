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
- branch_home_service_zones *(defines the delivery zone for home service per branch: radius or area list)*

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
- service_home_service_config *(per-service home service enable flag and surcharge)*

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
- staff_home_service_eligibility *(flag indicating whether a staff member performs home visits)*

### Booking
- appointments *(includes: service_location enum [in_store | home_service], home_address_id where applicable)*
- appointment_services
- appointment_staff_assignments
- appointment_status_history *(statuses: pending, confirmed, checked_in, in_progress, completed, no_show, cancelled, late_cancelled)*
- appointment_notes
- appointment_reschedule_history
- appointment_cancellations *(records reason, cancellation time, and whether late cancellation fee applies)*
- appointment_checkins
- slot_holds *(short-lived lock record created when a customer selects a slot; expires if booking is not confirmed within TTL)*
- waitlists
- queue_tokens *(walk-in queue: token number, issue time, estimated wait, status)*
- group_bookings *(parent record linking multiple appointments in a single group reservation)*
- group_booking_members *(each row represents one person in the group: linked appointment, assigned staff, chosen service)*

### Cancellation and No-Show Policy
- cancellation_policies *(merchant-defined: free window duration, late fee type, late fee value)*
- no_show_policies *(merchant-defined: fee type, fee value, charge mode [auto | manual])*
- deposit_rules *(per service or per merchant: deposit amount type, deposit value, refund rules by notice period)*
- cancellation_fee_charges *(records fee charged against a specific cancellation)*
- no_show_fee_charges *(records fee charged against a specific no-show)*

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
- payments *(supports deposit payments and balance payments as separate records linked to the same appointment)*
- payment_transactions
- refunds
- invoices
- invoice_items
- tax_rules
- tips

### Commercial and Settlement
- platform_subscription_plans *(merchant-facing plan tiers and pricing)*
- merchant_subscriptions
- commission_rules *(platform commission rate per transaction, configurable by merchant tier or service category)*
- platform_fee_charges *(records each commission or platform fee deducted from a merchant transaction)*
- promotion_placement_orders *(records paid placement purchases by merchants: featured listing, promoted slot)*
- settlements *(periodic settlement records per merchant: gross revenue, deductions, net payable)*
- settlement_items *(line items within a settlement: bookings, commissions, fees, refunds)*
- payout_batches *(batched payout instructions sent to the payment provider)*

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
- disputes
- complaints
- support_tickets
- audit_logs
- platform_settings

---

## Main Relationships
- One tenant has many businesses
- One business has many branches
- One branch has many staff members
- One branch offers many services
- One branch has many branch_operating_hours rows (one per day of week) and many branch_closures rows (ad-hoc dates)
- One branch may have one or more branch_home_service_zones defining delivery coverage
- One staff member has many staff_working_hours rows; these must fall within the branch's operating hours
- One customer can have many appointments
- One appointment belongs to one branch and has a service_location flag (in_store or home_service)
- One appointment can include many appointment_services
- One appointment can map to one or more staff assignments
- One appointment can have one or more payment records (deposit + balance)
- One appointment can have one no_show_record and one cancellation_fee_charge where applicable
- One slot selection creates one slot_hold; confirmed booking removes the hold
- One group_booking has many group_booking_members, each linked to one appointment
- One branch can have many reviews
- One branch can have many active queue_tokens at a time (walk-in queue)
- One merchant_subscription links one tenant to one platform_subscription_plan
- One appointment transaction can generate one platform_fee_charge via commission_rules
- One settlement covers many settlement_items for a given merchant and period

---

## PostgreSQL Design Notes
- Use UUID primary keys
- Add created_at and updated_at to major tables
- Use deleted_at where soft delete is needed
- Use JSONB for flexible settings and metadata
- Use PostGIS for location-based discovery and home service zone matching
- Add indexes on:
  - geolocation columns
  - foreign keys
  - booking date/time
  - service lookup columns
  - status columns
  - slot_holds expiry timestamp (for TTL cleanup jobs)
  - group_booking_id on group_booking_members

---

## Design Notes

### Slot Generation Strategy
The slot engine can be implemented in two modes. This decision must be made before Phase 4 development begins, as it affects schema, caching infrastructure, and the complexity of the booking API.

**Option A — On-demand computation (recommended for MVP)**
Slots are calculated in real time when a customer queries availability. The engine intersects branch_operating_hours, staff_working_hours, staff_breaks, staff_leaves, and confirmed appointments, then subtracts buffer time from service_duration_rules. Results are not persisted. A slot_hold record is created when a customer selects a slot to prevent race conditions during the confirmation window (TTL: 5 minutes). Advantages: no cache invalidation complexity, always accurate. Disadvantage: compute cost at scale, mitigated with query-level caching (Redis) on the results.

**Option B — Pre-generated slot cache**
Slots are pre-computed and stored in an availability_cache table whenever schedule-affecting data changes (staff schedule, service update, new booking, cancellation). Queries are fast reads. Disadvantage: cache invalidation is complex and error-prone; stale slots cause double-booking if invalidation is missed. Not recommended for MVP.

**Decision: implement Option A with Redis caching on the query result keyed by (branch_id, staff_id, date). Invalidate cache on any schedule-affecting write.**

### Slot Concurrency Control
The slot_holds table implements optimistic locking for the booking flow. A unique constraint on (branch_id, staff_id, slot_start) on confirmed appointments prevents double-booking. A hold is created on slot selection and expires after 5 minutes if not confirmed. A background job cleans up expired holds every minute.

### Staff Hours vs Branch Hours
staff_working_hours defines when a staff member is scheduled. The slot engine must intersect staff_working_hours with branch_operating_hours and subtract staff_breaks, staff_leaves, and confirmed appointments. Staff cannot be booked outside branch operating hours regardless of their own schedule entries. For home service appointments, staff_home_service_eligibility must be true.

### Cancellation Policy Enforcement
When a cancellation is submitted, the system compares the cancellation timestamp against the appointment start time and the merchant's cancellation_policy free_window. If the cancellation is within the penalty window, a cancellation_fee_charge record is created and the fee is automatically charged to the customer's payment method on file (or deducted from deposit).

### Group Booking Slot Logic
A group booking reserves one slot per member. Each member maps to one staff member. The slot engine must find a time window where all required staff are simultaneously available. For large groups this is a combinatorial problem; the MVP should cap group size (suggested: 10 members) and search greedily for the first available window rather than optimising across all possibilities.

### Home Service Slot Logic
Home service slots are generated from staff_working_hours of home-service-eligible staff only. The customer's address must fall within a branch_home_service_zone polygon or radius (validated using PostGIS). Home service slots do not share availability with in-store slots — a staff member assigned to a home service appointment is blocked for the service duration plus any configured travel buffer time.

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
- branch_home_service_zones
- staff
- staff_working_hours
- staff_availability_overrides
- staff_home_service_eligibility
- staff_services
- service_categories
- services
- branch_services
- service_pricing
- service_duration_rules
- service_home_service_config
- slot_holds
- appointments
- appointment_services
- appointment_staff_assignments
- appointment_status_history
- appointment_cancellations
- appointment_checkins
- group_bookings
- group_booking_members
- cancellation_policies
- no_show_policies
- deposit_rules
- cancellation_fee_charges
- no_show_fee_charges
- queue_tokens
- payments
- reviews
- favorites
- notifications
- notification_templates
- no_show_records
- subscription_plans
- tenant_subscriptions
- commission_rules
- platform_fee_charges
- settlements
- settlement_items
