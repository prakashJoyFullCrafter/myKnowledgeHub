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

### Deliverables
- feature baseline
- scope approval
- MVP definition
- success metrics
- NFR document (including accessibility and concurrency requirements)

---

## Phase 2: Architecture and UX
- Define solution architecture
- Finalize PostgreSQL ERD
- Design slot concurrency model (slot_holds TTL approach vs. database-level locking)
- Define staff hours vs branch hours intersection rules for slot engine
- Define APIs
- Create customer wireframes
- Create merchant dashboard wireframes (including walk-in queue management screen)
- Create admin dashboard wireframes

### Deliverables
- architecture document
- ERD
- slot engine design document
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
- Add logging and monitoring

### Deliverables
- working dev environment
- auth module
- tenancy base
- deployment pipeline
- observability setup
- slot engine spike result and decision record

---

## Phase 4: Merchant and Catalog Modules
- Merchant registration and verification
- Business and branch setup
- Ad-hoc branch closure management
- Staff setup including per-staff availability toggle
- Service category and service setup
- Pricing and duration rules (including buffer time between appointments)
- Working hours and holiday configuration
- Walk-in queue token configuration per branch
- Media upload support
- Customer and service data import (CSV upload for existing merchants)

### Deliverables
- merchant onboarding module
- branch management (hours, holidays, ad-hoc closures)
- staff management (schedule, availability toggle)
- service catalog
- pricing and schedule management
- data import tool

---

## Phase 5: Customer Discovery and Booking
- Geolocation integration
- Nearby shop discovery
- Search filters
- Shop profile pages
- Slot generation engine (full implementation based on Phase 3 spike)
  - Branch hours and staff hours intersection
  - Buffer time between appointments
  - Multi-service back-to-back booking
  - Slot hold on selection (TTL-based concurrency lock)
- Appointment booking flow
- Booking lifecycle management (confirm, check-in, complete, no-show, cancel)
- Walk-in queue check-in via QR code and live wait time display
- Notifications and reminders
- Repeat last booking shortcut

### Deliverables
- customer marketplace flow
- slot engine (full)
- walk-in queue customer flow
- booking APIs
- booking reminders
- no-show status handling

---

## Phase 6: Payments and CRM
- Pay-at-shop support
- Online payment integration
- Payment transactions and refunds
- Ratings and reviews
- Favorites
- Promotions and promo codes
- No-show tracking and reporting per customer and per branch
- Merchant walk-in queue management UI (issue, call next, close token)

### Deliverables
- checkout flow
- payment integration
- review module
- promotions MVP
- no-show report
- merchant queue management dashboard

---

## Phase 7: Admin, QA, and UAT
- Merchant approval tools
- Master data management
- Complaint and dispute handling
- Platform dashboards
- Unit and integration testing
- **Slot engine stress test** — simulate concurrent booking requests before UAT to confirm no double-booking under load
- Security validation
- Performance testing (search and booking APIs under peak load)
- Accessibility audit (WCAG 2.1 AA) on customer-facing flows
- UAT and bug fixing

### Deliverables
- admin console
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
- Deposit and partial payment support
- POS and inventory
- Home service support
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
- Slot concurrency bugs causing double-bookings under load
- Delays in payment or map integration
- Weak merchant onboarding data quality — import tool must handle messy CSV data gracefully
- Tenant isolation mistakes
- Underestimating QA and UAT effort
- Accessibility gaps discovered late in the cycle if not built in from Phase 3

---

## Recommended Milestones
1. Scope approved
2. Architecture and slot engine design approved
3. Foundation complete (including slot engine spike)
4. Merchant modules complete
5. Booking flow complete (including walk-in queue and no-show handling)
6. Payments and CRM complete
7. Slot engine stress test passed
8. UAT sign-off
9. Production go-live
10. Hypercare complete
