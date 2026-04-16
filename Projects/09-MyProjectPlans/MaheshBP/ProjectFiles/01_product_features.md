# Product Features

## Overview
This platform is a multi-tenant SaaS solution for beauty parlours, barbershops, salons, spas, nail studios, makeup artists, and similar appointment-based service businesses.

It combines:
- a customer marketplace
- a merchant operations portal
- a platform administration console

---

## Customer Features

### Discovery and Search
- Find nearby shops using current location
- Search by shop name, category, service, or specialist
- Filter by:
  - distance
  - price
  - rating
  - open now
  - available now
  - home service available
  - offers
- Map view and list view
- Recommendations based on previous activity

### Shop Profiles
- Shop name, description, address, timings
- Service list with prices and duration
- Staff profiles and specialties
- Ratings and reviews
- Amenities and policies
- Cancellation policy displayed clearly before booking confirmation
- Photos and media gallery

### Booking
- Real-time slot availability with concurrency protection (slot hold on selection)
- Choose service, date, time, and preferred staff
- Multi-service booking (back-to-back services in a single appointment)
- Group booking (e.g. bridal parties): book multiple seats across multiple staff in a single flow; choose service per person in the group
- Service location selection at booking time: in-store or home service (where merchant has enabled home service)
  - If home service is selected: customer enters service address, confirms they are within the merchant's delivery zone, and sees home-service-specific slot availability
  - Home service slots are generated and displayed separately from in-store slots
- Reschedule and cancellation (subject to merchant cancellation policy)
  - Cancellation policy shown at point of booking and in confirmation message
  - Late cancellation fee charged automatically if cancellation falls within the policy window
- Waitlist support
- Repeat last booking (quick re-book from booking history)
- Walk-in queue check-in via QR code with live wait time display
- Notification when walk-in turn is approaching

### Payments
- Pay online
- Pay at shop
- Deposit payment at booking time (where merchant has enabled deposit requirement)
  - Deposit amount configurable per service or as a flat merchant-level setting
  - Remaining balance collected at shop or online on completion
- Apply promo codes
- View invoices and payment history
- Add tips
- Automatic late cancellation fee charge (where merchant policy applies)
- No-show fee charge (where merchant has configured a no-show penalty)

### Account and Engagement
- Registration and login
- Booking history
- Favorite shops
- Reviews and ratings
- Notifications and reminders
- No-show and cancellation history visible to customer

---

## Merchant Features

### Onboarding
- Register business
- Choose business type
- Add branches
- Submit verification details
- Import existing service menu and customer list (CSV / spreadsheet upload)

### Operations
- Manage branches and timing
- Set ad-hoc branch closures (e.g. one-off closure for renovation or event)
- Manage staff and schedules
- Toggle staff availability on/off (pause bookings for a specific staff member)
- Manage services and pricing
- Enable or disable home service per branch and per service
  - Configure home service zone (radius or postcode/area list)
  - Set home service surcharge (per service or flat fee)
  - Assign staff eligible to perform home service
- Manage appointments and walk-ins
- Walk-in queue management: issue queue tokens, display wait time, call next customer
- Block slots and holidays
- Upload photos and business media

### Cancellation and No-Show Policy Configuration
- Define cancellation policy per branch or per service:
  - Free cancellation window (e.g. cancel up to 24 hours before appointment)
  - Late cancellation fee (flat amount or percentage of service price)
- Define no-show penalty:
  - Flat fee or percentage of booking value
  - Auto-charge or manual-approval charge option
- Define deposit requirements:
  - Enable/disable deposit per service
  - Set deposit amount (flat or percentage)
  - Define deposit refund rules on cancellation (full refund / partial refund / no refund depending on notice given)
- Policy text is shown to customers at the time of booking and in confirmation

### Group Booking Management
- View group bookings as a coordinated block in the calendar
- Assign individual staff members to each person in the group
- Add or remove seats from an active group booking (subject to availability)
- Group-level cancellation or individual seat cancellation

### Customer Management
- View customer history
- Add notes and tags
- Mark appointments as no-show and trigger no-show penalty if configured
- Track no-show and late-cancellation history per customer
- Run promotions
- Support repeat customer engagement

### Reporting
- Booking reports
- Revenue reports (including deposits collected vs. outstanding balances)
- Popular services
- Peak hours
- Staff utilization
- No-show and cancellation rate reports
- Home service booking reports (volume, zone coverage, surcharge revenue)

---

## Platform Admin Features
- Merchant approval and verification
- Category and service master data management
- Subscription and plan management
- Complaint and dispute handling (including disputed cancellation fees and no-show charges)
- Review moderation
- Platform reporting
- Audit visibility
- Commission and fee rule management across all revenue streams

---

## MVP Feature Set
- User registration and login
- Merchant registration
- Branch management (including ad-hoc closures)
- Staff management (including availability toggle)
- Service and pricing setup
- Cancellation policy configuration per merchant
- No-show penalty configuration per merchant
- Deposit requirement configuration per service (basic flat-amount support)
- Location-based search
- Shop profile pages
- Slot-based appointment booking with concurrency hold
- Group booking (up to a configurable party size per merchant)
- In-store vs. home service location selection in the booking flow
- Walk-in queue token management
- Notifications
- Reviews
- No-show tracking and fee charge
- Basic admin dashboard
- Subscription baseline

---

## Phase 2 Feature Set
- Loyalty and wallet
- Memberships
- Gift cards
- Advanced deposit and partial payment flows
- POS and inventory
- Advanced home service (routing optimisation, multi-stop, travel fee calculation)
- Advanced group booking (event packages, group-specific pricing)
- Advanced analytics
- Multi-language and locale support
- White-label support
