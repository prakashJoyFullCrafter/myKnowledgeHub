# Commercial and Billing Design

## Purpose
This document defines the revenue model, billing structure, commission logic, and settlement engine for the platform. It must be finalised before architecture and ERD work begins, as the decisions here directly affect the schema design, the merchant portal, the payment integration, and the admin console.

---

## Revenue Streams

The platform operates four revenue streams:

### 1. Merchant Subscriptions
Merchants pay a recurring fee to use the platform. Subscription tiers determine access to features and operational limits (e.g. number of branches, staff seats, booking volume).

### 2. Transaction Commission
The platform takes a percentage of the booking value for each completed appointment processed through the online payment flow. Commission is deducted at settlement time, not at the point of payment.

### 3. Promoted Placements
Merchants can purchase featured placement in search results or category listings (e.g. "top of results in your area", "featured on homepage"). These are time-boxed purchases paid upfront.

### 4. Promotional Tools (Future)
Paid campaign boosts, featured review slots, and co-marketing placements. Deferred to Phase 2 but the schema must support them from day one.

---

## Subscription Plans

### Plan Tiers (suggested baseline — confirm with commercial team)

| Plan | Target | Branches | Staff Seats | Commission Rate | Features |
|------|--------|----------|-------------|-----------------|----------|
| Starter | Solo operators, single-chair | 1 | 3 | 8% | Core booking, basic reporting |
| Growth | Small shops | 3 | 15 | 6% | All MVP features |
| Pro | Multi-branch businesses | 10 | 50 | 4% | All MVP + priority support |
| Enterprise | Chains, franchises | Unlimited | Unlimited | Negotiated | Custom terms |

### Billing Rules
- Subscription billed monthly or annually (annual billed upfront with discount)
- Subscription billing is tenant-level (one subscription per merchant business, not per branch)
- Subscription status gates merchant portal access: expired or unpaid subscription = read-only mode, no new bookings accepted
- Free trial period configurable per plan (e.g. 14 days) — no commission charged during trial
- Plan upgrades take effect immediately; plan downgrades take effect at next billing cycle
- Failed payment triggers a grace period (suggested: 3 days) before access is restricted

### Schema Entities
- `subscription_plans` — plan definitions: name, price, billing_interval, branch_limit, staff_limit, commission_rate, feature_flags
- `merchant_subscriptions` — active subscription per merchant: plan_id, status, current_period_start, current_period_end, trial_ends_at
- `subscription_invoices` — monthly/annual invoice records per merchant subscription

---

## Transaction Commission

### How It Works
1. Customer completes a booking and pays online (full payment or deposit + balance).
2. The gross payment is received by the platform's payment provider.
3. At settlement time (see Settlement Cycle below), the platform deducts its commission from the merchant's gross revenue.
4. The net amount is paid out to the merchant.

### Commission Calculation
- Commission rate is determined by the merchant's active subscription plan.
- Commission applies to the booking service value only — tips, deposit amounts used as refunds, and cancellation fees are handled separately (see below).
- If a promo code reduces the booking value, commission is calculated on the post-discount value.
- Commission is not charged on pay-at-shop bookings (no online transaction to deduct from).

### Commission on Cancellation Fees and No-Show Fees
- Late cancellation fees and no-show fees collected online are subject to a platform handling fee (flat, e.g. 2%) rather than the full commission rate.
- Define this rate in `commission_rules` with a fee_type discriminator (booking | cancellation_fee | no_show_fee).

### Schema Entities
- `commission_rules` — rule definitions: merchant_id (nullable for platform default), fee_type, rate, effective_from, effective_to
- `platform_fee_charges` — one record per transaction: appointment_id, payment_id, fee_type, gross_amount, commission_rate, fee_amount

---

## Promoted Placements

### Types
- **Featured listing**: merchant branch appears at the top of category or location search results for a fixed period
- **Promoted service**: a specific service is highlighted in search results
- **Homepage feature**: merchant appears in a curated "featured near you" section

### Billing
- Purchased upfront by the merchant via the merchant portal
- Fixed price per placement type and duration (e.g. 7-day featured listing = fixed fee)
- Payment charged immediately at purchase
- Placement activates on the start date configured at purchase

### Schema Entities
- `placement_products` — available placement types: name, description, duration_days, price
- `promotion_placement_orders` — purchase records: merchant_id, placement_product_id, branch_id, service_id (nullable), start_date, end_date, amount_paid, status

---

## Deposits

### Relationship to Revenue
- A deposit is a partial payment collected from the customer at booking time and held by the platform until the appointment is completed.
- On completion, the deposit is counted as part of the booking revenue and commission is applied to the full booking value (deposit + balance).
- On cancellation with a full refund, the deposit is returned and no commission is charged.
- On late cancellation where the deposit is forfeited, the forfeited amount is treated as a cancellation fee and subject to the cancellation fee handling rate (not full commission).

### Schema Note
- Payments table must support a `payment_type` discriminator: deposit | balance | cancellation_fee | no_show_fee | placement
- Each appointment can have multiple payment records (one deposit + one balance payment)

---

## Settlement Cycle

### Overview
Merchants are not paid in real time. Collected payments are held by the platform and settled to merchants on a periodic cycle (suggested: weekly, with a configurable hold period for dispute protection).

### Settlement Calculation per Merchant per Period
```
Gross booking revenue collected
- Platform commission (per commission_rules)
- Disputed amounts (held pending resolution)
- Refunds issued in the period
+ Cancellation fees collected (minus handling fee)
+ No-show fees collected (minus handling fee)
= Net settlement amount
```

### Settlement Steps
1. Settlement job runs at the end of each settlement period (e.g. every Monday for the prior week).
2. A `settlements` record is created per merchant with period_start, period_end, gross_amount, total_deductions, net_amount, status = pending.
3. `settlement_items` are created for each contributing transaction (booking, refund, fee).
4. Settlement is reviewed (auto-approved for clean records; flagged for manual review if disputes exist).
5. Approved settlements generate a `payout_batch` record sent to the payment provider for bank transfer.
6. Settlement status updated to paid on confirmation from the payment provider.

### Schema Entities
- `settlements` — one per merchant per period: period_start, period_end, gross_amount, commission_total, refunds_total, net_amount, status
- `settlement_items` — line items: settlement_id, reference_type (appointment | refund | fee | placement), reference_id, amount, deduction_amount
- `payout_batches` — batched payout instructions: settlement_ids[], provider_batch_id, status, initiated_at, confirmed_at

### Dispute Hold
If a booking or fee is under dispute, its value is excluded from the current settlement and held until the dispute is resolved. Resolved disputes either release the held amount into the next settlement or trigger a refund.

---

## Admin Controls

The platform admin console must support:
- View and edit subscription plan definitions
- Override a merchant's subscription plan or commission rate (custom enterprise deals)
- View settlement history across all merchants
- Manually approve or reject flagged settlements
- Manage placement product catalogue and pricing
- View platform-level revenue reports (total GMV, total commissions collected, total payouts, net platform revenue)
- Resolve disputes that affect settlement amounts

---

## Key Decisions Required Before Development

The following must be confirmed by the commercial and product team before Phase 2 architecture begins:

1. **Commission rates per plan tier** — the table above is a suggested baseline, not final
2. **Settlement cycle frequency** — weekly is recommended; daily increases payout operations cost
3. **Dispute hold period** — how many days after an appointment can a customer raise a dispute
4. **Commission on pay-at-shop bookings** — current proposal is zero commission; confirm this is intentional
5. **Deposit handling rate on forfeiture** — should forfeited deposits attract full commission or a lower rate
6. **VAT / tax treatment** — does the platform charge merchants VAT on subscription and commission fees; this depends on the operating jurisdiction and must be resolved before the invoice schema is finalised
7. **Payout provider** — which payment provider handles merchant bank payouts (Stripe Connect, Razorpay, HyperPay, etc.); this affects the schema for payout_batches and the settlement status flow
