# Scope Document

## Project Objective
Develop a SaaS platform for beauty and grooming businesses where customers can discover the nearest available service providers and book appointments, while merchants manage their business operations from a centralized dashboard.

Supported businesses include:
- beauty parlours
- barbershops
- salons
- spas
- nail studios
- grooming studios
- makeup artists
- similar service businesses

---

## Business Goals
- Make discovery of nearby service providers easy
- Increase booking conversion with real-time availability
- Give merchants a complete operational platform
- Create a scalable SaaS business model with subscriptions and future upsell modules

---

## In Scope

### Customer Scope
- User registration and authentication
- Location-based branch discovery
- Search and filter
- Shop and service profile pages (including cancellation policy display)
- Appointment booking with slot concurrency protection
- Group booking (multiple seats, multiple staff, service per person)
- In-store vs. home service selection in the booking flow (where merchant has enabled home service)
- Appointment rescheduling and cancellation (subject to merchant cancellation policy)
- Late cancellation fee enforcement
- Deposit payment at time of booking (where required by merchant)
- No-show fee charge
- Walk-in queue check-in (QR code, live wait time, turn notification)
- Notifications and reminders
- Reviews and ratings
- Basic online payment and pay-at-shop support
- Repeat last booking shortcut

### Merchant Scope
- Merchant registration
- Business and branch setup
- Ad-hoc branch closure management
- Staff setup with per-staff availability toggle and home-service eligibility flag
- Service and price setup
- Home service configuration per branch and per service (zone, surcharge, eligible staff)
- Working hours, holidays, closures
- Booking calendar (including group bookings and home service appointments)
- Cancellation policy configuration (free window, late fee, deposit rules)
- No-show penalty configuration (flat or percentage, auto or manual charge)
- Walk-in queue management (issue tokens, call next, display wait time)
- Appointment status handling including no-show marking and fee trigger
- Basic reporting including no-show rates, cancellation rates, and home service revenue
- Customer and service data import (CSV upload)

### Admin Scope
- Merchant approval workflow
- Platform settings
- Subscription and commercial plan management
- Complaint and dispute handling (including fee disputes)
- Review moderation
- Basic platform reporting
- Commission and platform fee rule configuration

---

## Out of Scope for MVP
- Full POS
- Inventory module
- Advanced loyalty engine
- Gift cards
- Advanced deposit flows (percentage-based, partial refund tiers)
- Franchise support
- White-label delivery
- Advanced BI analytics
- Multi-language / locale support (deferred to Phase 2)
- Advanced home service routing or multi-stop optimisation
- Advanced group booking event packages
- Real-time in-app chat between customer and stylist
- Social media-style activity feeds or content discovery
- Marketplace-side product sales (retail products sold through the platform)
- Third-party marketplace integrations (e.g. Google Reserve, Meta booking)

---

## Functional Scope Summary

### Customer Journey
1. Register or log in
2. Share location
3. Find nearby shops (filter by home service if needed)
4. Select service, location type (in-store or home), date, and slot
   - 4a. Group booking: select party size, assign services per person
   - 4b. Home service: enter address, confirm zone, select home-service slot
   - 4c. Repeat last booking shortcut for returning customers
5. Review cancellation policy and deposit requirement
6. Confirm booking and pay deposit (if required) or choose pay-at-shop / pay-in-full
7. Receive confirmation and reminders
8. Attend appointment (check in via QR for walk-ins)
9. Pay remaining balance if deposit was taken
10. Leave review after appointment

### Merchant Journey
1. Register merchant account
2. Submit verification details
3. Add business and branches
4. Configure cancellation policy, no-show penalty, and deposit rules
5. Import or manually add staff and services
6. Configure schedule, pricing, home service zones, and ad-hoc closures
7. Receive and manage bookings (including group and home service)
8. Manage walk-in queue on the day
9. Mark no-shows, trigger penalties, and follow up with customers

### Admin Journey
1. Review merchant registration
2. Approve business
3. Manage categories and platform settings
4. Configure commission and platform fee rules
5. Monitor platform activity
6. Resolve disputes and complaints (including fee disputes)

---

## Non-Functional Scope
- Role-based access control
- Tenant data isolation
- Secure authentication
- Slot concurrency control (optimistic lock / TTL hold to prevent double-booking)
- Backup and recovery
- Monitoring and logging
- Scalable design for many merchants and branches
- Fast search and booking operations
- Accessibility baseline (WCAG 2.1 AA) for customer-facing web and mobile apps

---

## Success Criteria
- Customers can discover and book nearby businesses for in-store or home service
- Group bookings can be completed end-to-end for parties of at least four
- Cancellation policies are enforced automatically with no manual merchant intervention
- No-show fees are captured and settled correctly
- Merchants can independently configure and operate their business
- Walk-in queue flow works end-to-end without double-assignment
- No-show tracking is captured and surfaced in reports
- Admin can control merchant approvals, fee rules, and platform basics
- MVP supports real production usage and can grow into Phase 2 modules
