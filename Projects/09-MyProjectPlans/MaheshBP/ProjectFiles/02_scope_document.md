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
- Shop and service profile pages
- Appointment booking with slot concurrency protection
- Appointment rescheduling and cancellation
- Walk-in queue check-in (QR code, live wait time, turn notification)
- Notifications and reminders
- Reviews and ratings
- Basic online payment and pay-at-shop support
- Repeat last booking shortcut

### Merchant Scope
- Merchant registration
- Business and branch setup
- Ad-hoc branch closure management (one-off closures outside regular holidays)
- Staff setup with per-staff availability toggle
- Service and price setup
- Working hours, holidays, closures
- Booking calendar
- Walk-in queue management (issue tokens, call next, display wait time)
- Appointment status handling including no-show marking
- Basic reporting including no-show and cancellation rates
- Customer and service data import (CSV upload)

### Admin Scope
- Merchant approval workflow
- Platform settings
- Subscription basics
- Complaint and dispute handling
- Review moderation
- Basic platform reporting

---

## Out of Scope for MVP
- Full POS
- Inventory module
- Advanced loyalty engine
- Gift cards
- Deposit and partial payment
- Franchise support
- White-label delivery
- Advanced BI analytics
- Multi-language / locale support (deferred to Phase 2)

---

## Functional Scope Summary

### Customer Journey
1. Register or log in
2. Share location
3. Find nearby shops
4. Select service and slot (or join walk-in queue)
4a. Use "Repeat last booking" for returning customers
5. Confirm booking
6. Make payment or choose pay-at-shop
7. Receive reminders
8. Attend appointment (check in via QR for walk-ins)
9. Leave review after appointment

### Merchant Journey
1. Register merchant account
2. Submit verification details
3. Add business and branches
4. Import or manually add staff and services
5. Configure schedule, pricing, and ad-hoc closures
6. Receive and manage bookings
7. Manage walk-in queue on the day
8. Mark no-shows and follow up with customers

### Admin Journey
1. Review merchant registration
2. Approve business
3. Manage categories and settings
4. Monitor platform activity
5. Resolve disputes and complaints

---

## Non-Functional Scope
- Role-based access control
- Tenant data isolation
- Secure authentication
- Slot concurrency control (optimistic lock or hold mechanism to prevent double-booking)
- Backup and recovery
- Monitoring and logging
- Scalable design for many merchants and branches
- Fast search and booking operations
- Accessibility baseline (WCAG 2.1 AA) for customer-facing web and mobile apps

---

## Success Criteria
- Customers can discover and book nearby businesses
- Merchants can independently configure and operate their business
- Walk-in queue flow works end-to-end without double-assignment
- No-show tracking is captured and surfaced in reports
- Admin can control merchant approvals and platform basics
- MVP supports real production usage and can grow into Phase 2 modules
