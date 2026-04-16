# Development Plan

## Goal
Deliver a production-ready MVP for a beauty services SaaS platform in structured phases, followed by a second phase for advanced capabilities.

---

## Phase 1: Discovery and Product Definition
- Finalize business scope
- Identify personas and user roles
- Confirm MVP boundaries
- Define release goals and success metrics
- Document non-functional requirements
- Define accessibility baseline (WCAG 2.1 AA) requirements
- Produce commercial and billing design document (revenue streams, commission model, settlement logic, subscription tiers) — this must be completed before Phase 2 architecture begins as it affects the schema, merchant portal, and settlement engine

### Deliverables
- feature baseline
- scope approval
- MVP definition
- success metrics
- NFR document (including accessibility and concurrency requirements)
- commercial and billing design document

---

## Phase 2: Architecture and UX
- Define solution architecture
- Finalize PostgreSQL ERD
- Decide slot generation strategy (on-demand with Redis vs. pre-generated cache) and document the decision
- Define staff hours vs branch hours intersection rules for slot engine
- Define group booking slot search algorithm and party size cap
- Define home service zone matching approach (PostGIS radius vs. polygon)
- Define cancellation policy enforcement flow (fee calculation, auto-charge trigger)
- Define settlement and commission calculation model
- Define APIs
- Create customer wireframes (including group booking flow and home service address entry)
- Create merchant dashboard wireframes (walk-in queue, group calendar view, policy configuration)
- Create admin dashboard wireframes

### Deliverables
- architecture document
- ERD
- slot engine design document (strategy decision + group booking algorithm)
- home service zone design note
- cancellation and no-show enforcement flow document
- settlement and commission design document
- API specification
- UX wireframes

---

## Phase 3: Foundation Setup
- Create repositories and branching strategy
- Set up environments
- Build CI/CD pipelines
- Implement authentication
- Implement role-based access control
- Implement tenant foundation
- **Spike: slot generation engine prototype** — validate the intersection of branch hours, staff hours, breaks, leaves, and buffer time before catalog and booking modules are built on top of this logic
- Set up Redis caching layer for slot query results
- Add logging and monitoring

### Deliverables
- working dev environment
- auth module
- tenancy base
- deployment pipeline
- observability setup
- Redis caching setup
- slot engine spike result and decision record

---

## Phase 4: Merchant and Catalog Modules
- Merchant registration and verification
- Business and branch setup
- Ad-hoc branch closure management
- Staff setup including per-staff availability toggle and home service eligibility flag
- Service category and service setup
- Pricing and duration rules (including buffer time between appointments)
- Home service configuration per branch and per service (zone, surcharge, eligible staff)
- Cancellation policy configuration per merchant
- No-show penalty configuration per merchant
- Deposit rules configuration per service
- Working hours and holiday configuration
- Walk-in queue token configuration per branch
- Media upload support
- Customer and service data import (CSV upload for existing merchants)

### Deliverables
- merchant onboarding module
- branch management (hours, holidays, ad-hoc closures, home service zones)
- staff management (schedule, availability toggle, home service eligibility)
- service catalog (including home service config)
- cancellation policy and no-show penalty configuration module
- deposit rules configuration
- pricing and schedule management
- data import tool

---

## Phase 5: Customer Discovery and Booking
- Geolocation integration
- Nearby shop discovery (including home service filter)
- Search filters
- Shop profile pages (with cancellation policy display)
- Slot generation engine (full implementation based on Phase 3 spike)
  - Branch hours and staff hours intersection
  - Buffer time between appointments
  - Multi-service back-to-back booking
  - Group booking slot search (simultaneous availability across multiple staff)
  - Home service slot generation (eligible staff only, PostGIS zone check)
  - Slot hold on selection (TTL-based concurrency lock)
- Appointment booking flow
  - In-store vs. home service location selection
  - Home service address entry and zone validation
  - Group booking seat and service assignment per person
  - Cancellation policy acknowledgement at confirmation step
  - Deposit payment capture where required
- Booking lifecycle management (pending, confirmed, checked_in, in_progress, completed, no_show, cancelled, late_cancelled)
- Cancellation flow with late fee enforcement
- Walk-in queue check-in via QR code and live wait time display
- Notifications and reminders
- Repeat last booking shortcut

### Deliverables
- customer marketplace flow
- slot engine (full: single, group, home service)
- home service booking flow (address entry, zone check, eligible staff slots)
- group booking flow
- cancellation policy enforcement at cancellation time
- deposit capture at booking time
- walk-in queue customer flow
- booking APIs
- booking reminders
- no-show and late-cancellation status handling

---

## Phase 6: Payments, CRM, and Settlement
- Pay-at-shop support
- Online payment integration
- Deposit and balance payment flows
- Automatic late cancellation fee charge
- No-show fee charge (auto and manual modes)
- Payment transactions and refunds
- Ratings and reviews
- Favorites
- Promotions and promo codes
- No-show tracking and reporting per customer and per branch
- Merchant walk-in queue management UI (issue, call next, close token)
- Commission calculation on completed transactions
- Settlement report generation per merchant per period
- Payout batch creation

### Deliverables
- checkout flow (deposit + balance)
- cancellation fee and no-show fee charge flows
- payment integration
- review module
- promotions MVP
- no-show and cancellation reports
- merchant queue management dashboard
- settlement engine (commission deduction, settlement record, payout batch)

---

## Phase 7: Admin, QA, and UAT
- Merchant approval tools
- Master data management
- Commission and platform fee rule management in admin console
- Complaint and dispute handling (including fee dispute resolution)
- Platform dashboards
- Unit and integration testing
- **Slot engine stress test** — simulate concurrent booking requests to confirm no double-booking under load, including group booking contention scenarios
- Security validation
- Performance testing (search, booking, and settlement APIs under peak load)
- Accessibility audit (WCAG 2.1 AA) on customer-facing flows
- UAT and bug fixing

### Deliverables
- admin console (including commission and fee rule management)
- slot engine stress test report
- QA sign-off
- accessibility audit report
- UAT sign-off
- release checklist

---

## Phase 8: Go-Live and Stabilization
- Production deployment
- Smoke testing
- Monitoring and alerting
- Hypercare support
- Priority fixes

### Deliverables
- live deployment
- support runbook
- hotfix plan
- post-launch stabilization report

---

## Phase 9: Phase 2 Enhancements
- Memberships
- Loyalty and wallet
- Gift cards
- Advanced deposit and partial payment flows
- POS and inventory
- Advanced home service (routing optimisation, multi-stop, travel fee calculation)
- Advanced group booking (event packages, group-specific pricing)
- Advanced analytics
- Multi-language and locale support
- Multi-branch intelligence
- White-label support

---

## Suggested Team
- Product Manager
- Business Analyst
- Solution Architect
- UX/UI Designer
- Backend Engineer
- Frontend Web Engineer
- Mobile Engineer
- QA Engineer
- DevOps Engineer

---

## Key Risks
- Complex availability logic (slot engine intersection of branch hours, staff hours, breaks, leaves, buffer time, and multi-service bookings)
- Group booking slot search complexity — combinatorial problem for large parties; must cap party size and set algorithm expectations early
- Home service zone validation dependency on PostGIS — validate in Phase 3 spike, not Phase 5
- Slot concurrency bugs causing double-bookings under load
- Cancellation fee and no-show charge disputes requiring admin intervention — resolution flow must be designed before Phase 6
- Settlement engine complexity — commission rules, refunds, and fee disputes all affect the settled amount; design this before Phase 6
- Commercial/billing design not completed before architecture — if the billing document is not ready before Phase 2, the ERD and merchant portal will need expensive rework
- Delays in payment or map integration
- Weak merchant onboarding data quality — import tool must handle messy CSV data gracefully
- Tenant isolation mistakes
- Underestimating QA and UAT effort
- Accessibility gaps discovered late in the cycle if not built in from Phase 3

---

## Recommended Milestones
1. Scope and commercial/billing design approved
2. Architecture, slot engine strategy, and ERD approved
3. Foundation complete (including slot engine spike and Redis setup)
4. Merchant modules complete (including policy configuration and home service setup)
5. Booking flow complete (single, group, home service, cancellation enforcement, deposit capture)
6. Payments, CRM, and settlement complete
7. Slot engine stress test passed
8. UAT sign-off
9. Production go-live
10. Hypercare complete
