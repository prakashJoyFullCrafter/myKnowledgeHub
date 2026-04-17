# Service Pricing Rules

## 1. Overview

The pricing system supports **three cascading scopes** (Tenant, Business, Branch), **customer-facing service tiers**, and **staff tier overrides**. Price resolution follows a strict fallback chain: the most specific scope wins.

---

## 2. Core Concepts

### 2.1 Pricing Scopes

| Scope | Level | Who Sets It | Purpose |
|-------|-------|-------------|---------|
| **TENANT** | Org-wide default | Merchant Owner | Base price for all businesses/branches under this tenant |
| **BUSINESS** | Per business | Merchant Owner | Override for a specific business (e.g., premium salon vs budget salon) |
| **BRANCH** | Per branch | Branch Manager / Owner | Override for a specific branch (e.g., downtown branch charges more) |

**Cascade rule:** BRANCH > BUSINESS > TENANT. The most specific scope that has an active pricing row wins. If no branch-level price exists, fall back to business, then tenant.

### 2.2 Service Tiers (Customer-Facing)

Customers are assigned a service tier based on their spend and booking history:

| Tier | Min Spend | Min Bookings | Discount % | Priority Booking |
|------|-----------|-------------|------------|-----------------|
| NORMAL | 0 | 0 | 0% | No |
| SILVER | 500 | 5 | 5% | No |
| GOLD | 1,500 | 15 | 10% | No |
| VIP | 3,000 | 30 | 15% | Yes |
| PREMIUM | 5,000 | 50 | 20% | Yes |

### 2.3 Customer Tiers

Simpler grouping used across the platform (reviews, notes, tags, branch-level discount mappings):

| Customer Tier | Mapped Service Tiers |
|---------------|---------------------|
| Bronze | NORMAL |
| Silver | SILVER |
| Gold | GOLD |
| Platinum | VIP, PREMIUM |

The mapping is stored in `service_tier_customer_tier_map`. A customer's `customer_tier` determines which `service_tier` they qualify for, which in turn determines their pricing row.

### 2.4 Staff Tiers

Price can vary based on the staff member performing the service:

| Staff Tier | Typical Price Impact |
|-----------|---------------------|
| Trainee | Lower than base |
| Junior | Slightly below base |
| Senior | At or above base |
| Master | Premium surcharge |
| Director | Highest |

Staff tier overrides are children of `service_pricing` rows. Each pricing row (at any scope) can have per-staff-tier price overrides.

---

## 3. Database Tables

### 3.1 `service_pricing` (Unified, all 3 scopes)

```
service_pricing
  id                 BIGSERIAL PK
  internal_id        VARCHAR(200) UNIQUE
  tenant_id          BIGINT NOT NULL -> tenants(id)
  business_id        BIGINT NULL     -> businesses(id)    -- NULL for TENANT scope
  branch_id          BIGINT NULL     -> branches(id)      -- NULL for TENANT/BUSINESS scope
  pricing_scope_id   INT NOT NULL    -> pricing_scope(id)  -- 1=TENANT, 2=BUSINESS, 3=BRANCH
  service_id         BIGINT NOT NULL -> services(id)
  branch_service_id  BIGINT NULL     -> branch_services(id) -- only at BRANCH scope
  service_tier_id    INT NULL        -> service_tiers(id)   -- NULL = base price for ALL customers
  pricing_type_id    INT NOT NULL    -> pricing_types(id)
  price              NUMERIC(12,2) NOT NULL
  currency_id        INT NOT NULL    -> currencies(id)
  valid_from         DATE NULL
  valid_until        DATE NULL
  status             VARCHAR(1) DEFAULT 'A'
```

**Scope constraints (enforced via CHECK):**

| Scope | business_id | branch_id | branch_service_id |
|-------|-------------|-----------|-------------------|
| TENANT (1) | NULL | NULL | NULL |
| BUSINESS (2) | SET | NULL | NULL |
| BRANCH (3) | SET | SET | optional |

**Uniqueness:** One active price per (tenant + service + scope + entity + service_tier). Enforced via partial unique indexes:

```sql
-- Only one active tenant-default per service per tier
CREATE UNIQUE INDEX uq_sp_tenant_scope
    ON service_pricing (tenant_id, service_id, COALESCE(service_tier_id, 0))
    WHERE pricing_scope_id = 1 AND status = 'A';

-- Only one active business-level per service per tier
CREATE UNIQUE INDEX uq_sp_business_scope
    ON service_pricing (tenant_id, business_id, service_id, COALESCE(service_tier_id, 0))
    WHERE pricing_scope_id = 2 AND status = 'A';

-- Only one active branch-level per service per tier
CREATE UNIQUE INDEX uq_sp_branch_scope
    ON service_pricing (tenant_id, branch_id, service_id, COALESCE(service_tier_id, 0))
    WHERE pricing_scope_id = 3 AND status = 'A';
```

### 3.2 `service_pricing_staff_tiers` (Staff tier overrides)

```
service_pricing_staff_tiers
  id                         BIGSERIAL PK
  internal_id                VARCHAR(200) UNIQUE
  service_pricing_id         BIGINT NOT NULL -> service_pricing(id)
  staff_tier_id              INT NOT NULL    -> staff_tiers(id)
  price                      NUMERIC(12,2) NOT NULL
  duration_override_minutes  INT NULL
  status                     VARCHAR(1) DEFAULT 'A'
  UNIQUE (service_pricing_id, staff_tier_id)
```

Since `service_pricing_id` points to a row that already carries its scope, staff tier overrides inherit the scope automatically. No separate scope column needed.

### 3.3 `service_tier_customer_tier_map`

```
service_tier_customer_tier_map
  id                SERIAL PK
  internal_id       VARCHAR(200) UNIQUE
  service_tier_id   INT NOT NULL -> service_tiers(id)
  customer_tier_id  INT NOT NULL -> customer_tiers(id)
  status            VARCHAR(1) DEFAULT 'A'
  UNIQUE (service_tier_id, customer_tier_id)
```

---

## 4. Price Resolution Algorithm

### Inputs at booking time

| Input | Source |
|-------|--------|
| `tenant_id` | Always known from branch |
| `business_id` | Derived from `branches.business_id` |
| `branch_id` | Selected by customer |
| `service_id` | Selected by customer |
| `staff_tier_id` | Derived from assigned staff member's tier |
| `customer_service_tier_id` | Derived from customer's tier via `service_tier_customer_tier_map` |

### Step 1: Resolve base price (cascading by scope)

```sql
SELECT sp.id AS pricing_id,
       sp.price,
       sp.pricing_type_id,
       sp.pricing_scope_id
FROM service_pricing sp
WHERE sp.tenant_id = :tenant_id
  AND sp.service_id = :service_id
  AND sp.status = 'A'
  -- Match either the customer's specific tier OR the base (NULL) tier
  AND (sp.service_tier_id IS NULL OR sp.service_tier_id = :customer_service_tier_id)
  -- Date validity
  AND (sp.valid_from IS NULL OR sp.valid_from <= CURRENT_DATE)
  AND (sp.valid_until IS NULL OR sp.valid_until >= CURRENT_DATE)
  -- Scope matching: try branch first, then business, then tenant
  AND (
      (sp.pricing_scope_id = 3 AND sp.branch_id = :branch_id)
   OR (sp.pricing_scope_id = 2 AND sp.business_id = :business_id)
   OR (sp.pricing_scope_id = 1)
  )
ORDER BY
    sp.pricing_scope_id DESC,            -- branch(3) > business(2) > tenant(1)
    sp.service_tier_id IS NULL ASC,      -- tier-specific price before generic base
    sp.valid_from DESC NULLS LAST        -- most recent date-bound first
LIMIT 1;
```

**Result:** One row — the most specific active price for this service + customer tier.

### Step 2: Resolve staff tier price override (cascading)

```sql
SELECT spst.price,
       spst.duration_override_minutes
FROM service_pricing sp
JOIN service_pricing_staff_tiers spst ON spst.service_pricing_id = sp.id
WHERE sp.tenant_id = :tenant_id
  AND sp.service_id = :service_id
  AND sp.status = 'A'
  AND spst.staff_tier_id = :staff_tier_id
  AND spst.status = 'A'
  AND (sp.service_tier_id IS NULL OR sp.service_tier_id = :customer_service_tier_id)
  AND (sp.valid_from IS NULL OR sp.valid_from <= CURRENT_DATE)
  AND (sp.valid_until IS NULL OR sp.valid_until >= CURRENT_DATE)
  AND (
      (sp.pricing_scope_id = 3 AND sp.branch_id = :branch_id)
   OR (sp.pricing_scope_id = 2 AND sp.business_id = :business_id)
   OR (sp.pricing_scope_id = 1)
  )
ORDER BY sp.pricing_scope_id DESC
LIMIT 1;
```

- If a staff tier override is found, use `spst.price` instead of base price from Step 1.
- If not found, use the base price from Step 1.
- If duration override exists, use it instead of `services.base_duration_minutes`.

### Step 3: Apply customer tier discount

```
resolved_price = price from Step 2 (or Step 1 if no staff override)
discount_percent = service_tiers.discount_percent for the customer's tier
final_price = resolved_price * (1 - discount_percent / 100)
```

### Step 4: Snapshot at booking time

The final resolved price is written to `appointment_services.price`. This is the **frozen snapshot** — even if pricing tables change later, the booked price stays the same.

---

## 5. Resolution Examples

### Example 1: Simple case — no overrides

**Setup:**
- Tenant-level price for "Haircut": 500 INR
- Customer tier: NORMAL (0% discount)
- Staff: Junior

**Resolution:**
1. Base price = 500 (tenant scope, only row available)
2. No staff tier override for Junior at tenant level
3. Discount = 0%
4. **Final price = 500 INR**

### Example 2: Branch override + staff tier

**Setup:**
- Tenant-level "Haircut": 500 INR
- Business-level "Haircut" for Premium Salon: 600 INR
- Branch-level "Haircut" for Downtown branch: 700 INR
- Branch-level staff tier override: Senior = 850 INR
- Customer tier: GOLD (10% discount)

**Resolution:**
1. Base price = 700 (branch scope wins over business and tenant)
2. Staff tier override: Senior at branch level = 850
3. Discount = 10% (GOLD tier)
4. **Final price = 850 * 0.90 = 765 INR**

### Example 3: Business-level with fallback staff tier

**Setup:**
- Tenant-level "Facial": 400 INR, with staff tier: Master = 600 INR
- Business-level "Facial" for Spa Chain: 500 INR (no staff tier overrides)
- No branch-level pricing
- Staff: Master
- Customer tier: SILVER (5% discount)

**Resolution:**
1. Base price = 500 (business scope wins over tenant)
2. Staff tier override: No Master override at business level. Fall back to tenant level: Master = 600
3. Discount = 5% (SILVER tier)
4. **Final price = 600 * 0.95 = 570 INR**

### Example 4: VIP customer with tier-specific pricing

**Setup:**
- Tenant-level "Massage" base (all customers): 800 INR
- Tenant-level "Massage" for VIP tier: 700 INR (special VIP price)
- Branch-level "Massage" base: 900 INR
- No branch-level VIP-specific pricing
- Customer tier: VIP (15% discount)

**Resolution:**
1. Candidates: Branch base (900, scope=3, tier=NULL) and Tenant VIP (700, scope=1, tier=VIP)
2. ORDER BY: scope DESC (branch=3 wins), then tier-specific before NULL
3. Branch base (900) wins because scope 3 > scope 1, even though tenant has a VIP-specific price
4. Discount = 15% (VIP tier)
5. **Final price = 900 * 0.85 = 765 INR**

> **Note:** If the branch wants to offer a VIP-specific price, it must define its own branch-level VIP pricing row. Scope specificity always takes precedence over tier specificity.

### Example 5: Time-bound promotional pricing

**Setup:**
- Tenant-level "Hair Colouring": 1200 INR (no date range)
- Branch-level "Hair Colouring": 1000 INR, valid_from = 2026-04-01, valid_until = 2026-04-30 (April promotion)
- Current date: 2026-04-17
- Customer tier: NORMAL
- Staff: Senior, no staff override

**Resolution:**
1. Branch promotional price (1000) is valid (within date range) and scope=3
2. Base price = 1000
3. No staff override, discount = 0%
4. **Final price = 1000 INR**

After April 30, the branch row becomes invalid (valid_until check fails), and the system falls back to tenant-level 1200 INR.

---

## 6. Pricing Type Behavior

The `pricing_type_id` on `service_pricing` indicates how the price should be **displayed** to the customer, not how it's calculated:

| Type Key | Label | Display Behavior |
|----------|-------|-----------------|
| FIXED | Fixed Price | Show exact price: "500 INR" |
| FROM_PRICE | Starting From | Show minimum: "From 500 INR" |
| PER_HOUR | Per Hour | Show hourly rate: "500 INR/hr" |
| PER_SESSION | Per Session | Show per session: "500 INR/session" |
| PACKAGE | Package Price | Show package: "1500 INR (3 sessions)" |
| FREE | Free | Show "Free" or "Complimentary" |

For billing purposes, `PER_HOUR` is multiplied by actual duration. `PACKAGE` is the total package price. All others are the direct price.

---

## 7. Service Hierarchy and Pricing Scope Mapping

```
Tenant (org)
  |
  +-- services (catalog definition, base_price as fallback)
  |     |
  |     +-- service_pricing [scope=TENANT]            -- tenant-wide default price
  |           +-- service_pricing_staff_tiers          -- staff tier overrides at tenant level
  |
  +-- Business (salon brand)
  |     |
  |     +-- business_services (which services this business offers)
  |     |
  |     +-- service_pricing [scope=BUSINESS]           -- business-level override
  |           +-- service_pricing_staff_tiers           -- staff tier overrides at business level
  |
  +-- Branch (physical location)
        |
        +-- branch_services (which services this branch offers)
        |
        +-- service_pricing [scope=BRANCH]             -- branch-level override
        |     +-- service_pricing_staff_tiers           -- staff tier overrides at branch level
        |
        +-- branch_service_addons                      -- addon price/duration at branch
        +-- service_duration_rules                     -- duration + buffer at branch
        +-- service_availability_rules                 -- day/time availability at branch
        +-- service_home_service_config                -- home service toggle + surcharge
```

---

## 8. Rules and Constraints

### 8.1 Scope Rules
- A tenant-level price requires: `business_id = NULL`, `branch_id = NULL`, `branch_service_id = NULL`
- A business-level price requires: `business_id IS NOT NULL`, `branch_id = NULL`, `branch_service_id = NULL`
- A branch-level price requires: `business_id IS NOT NULL`, `branch_id IS NOT NULL`
- These are enforced by CHECK constraints on `service_pricing`

### 8.2 Uniqueness Rules
- Only one active (`status = 'A'`) price per (tenant + service + scope + entity + service_tier)
- Only one staff tier override per (service_pricing row + staff_tier)
- Enforced via partial unique indexes

### 8.3 Fallback Rules
- If no price exists at any scope for a service, use `services.base_price` as the ultimate fallback
- If no staff tier override exists at the resolved scope, fall back to the next broader scope's staff tier override
- If no customer-tier-specific price exists, use the base price (service_tier_id = NULL row)

### 8.4 Date Validity Rules
- `valid_from` / `valid_until` are optional. NULL means "always valid"
- When both are set, the price is only active within that date range (inclusive)
- Expired prices are automatically skipped during resolution (no manual deactivation needed)
- Multiple date-ranged prices can coexist; the most recent `valid_from` wins

### 8.5 Currency Rules
- `service_pricing.currency_id` must match the tenant's `default_currency_id` or the branch's configured currency
- Multi-currency display is handled at the presentation layer using `currency_exchange_rates`

### 8.6 Snapshot Rule
- The resolved price at booking time is written to `appointment_services.price`
- This snapshot is immutable — pricing changes after booking do not affect existing appointments
- Refunds, cancellation fees, and no-show fees reference the snapshot price

---

## 9. Admin Operations

### Setting a tenant-wide default price
```sql
INSERT INTO service_pricing (internal_id, tenant_id, pricing_scope_id, service_id, pricing_type_id, price, currency_id)
VALUES ('SP-001', 1, 1, 10, 1, 500.00, 1);
-- scope=1 (TENANT), business_id/branch_id are NULL
```

### Overriding at business level
```sql
INSERT INTO service_pricing (internal_id, tenant_id, business_id, pricing_scope_id, service_id, pricing_type_id, price, currency_id)
VALUES ('SP-002', 1, 5, 2, 10, 1, 600.00, 1);
-- scope=2 (BUSINESS), branch_id is NULL
```

### Overriding at branch level
```sql
INSERT INTO service_pricing (internal_id, tenant_id, business_id, branch_id, branch_service_id, pricing_scope_id, service_id, pricing_type_id, price, currency_id)
VALUES ('SP-003', 1, 5, 12, 45, 3, 10, 1, 700.00, 1);
-- scope=3 (BRANCH)
```

### Setting tier-specific pricing
```sql
-- VIP customers get a special price at branch level
INSERT INTO service_pricing (internal_id, tenant_id, business_id, branch_id, branch_service_id, pricing_scope_id, service_id, service_tier_id, pricing_type_id, price, currency_id)
VALUES ('SP-004', 1, 5, 12, 45, 3, 10, 4, 1, 600.00, 1);
-- service_tier_id=4 (VIP)
```

### Adding staff tier overrides
```sql
-- Senior stylists charge more on top of branch base price (SP-003)
INSERT INTO service_pricing_staff_tiers (internal_id, service_pricing_id, staff_tier_id, price)
VALUES ('SPST-001', 3, 3, 850.00);
-- service_pricing_id=3 (branch base), staff_tier_id=3 (Senior)

-- Master stylists charge even more
INSERT INTO service_pricing_staff_tiers (internal_id, service_pricing_id, staff_tier_id, price, duration_override_minutes)
VALUES ('SPST-002', 3, 4, 1000.00, 45);
-- staff_tier_id=4 (Master), also takes 45 min instead of default 30
```

### Deactivating a price (soft delete)
```sql
UPDATE service_pricing SET status = 'I', updated_at = NOW() WHERE id = 3;
-- Branch price deactivated; system falls back to business or tenant level
```
