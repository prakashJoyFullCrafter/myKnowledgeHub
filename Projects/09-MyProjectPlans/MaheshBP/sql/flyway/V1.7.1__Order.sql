-- =========================================================
-- Orders
-- Unified order that can contain services AND products.
-- Anchored on a visit (which may or may not have a booking).
-- Supports split bill via visit_attendee_id (one visit can
-- have multiple orders, each for a different attendee).
-- =========================================================
CREATE SCHEMA IF NOT EXISTS sales;
SET
search_path TO sales;

-- ---------------------------------------------------------
-- order_main
-- ---------------------------------------------------------
CREATE TABLE order_main
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_code         character varying(50)  NOT NULL UNIQUE,
    order_number          character varying(50)  NOT NULL,    -- human-readable, unique per tenant
    tenant_id             BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id           BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id             BIGINT                 NOT NULL REFERENCES core.branches (id),

    -- Source context
    visit_id              BIGINT REFERENCES visit.visits (id),
    visit_attendee_id     BIGINT REFERENCES visit.visit_attendees (id),   -- for split bill
    booking_id            BIGINT REFERENCES booking.booking_main (id),

    -- Customer on the bill
    customer_account_id   BIGINT REFERENCES security.customer_accounts (id),
    bill_to_name          character varying(200),
    bill_to_phone         character varying(30),
    bill_to_email         character varying(150),
    bill_to_tax_reg_no    character varying(50),

    -- Order context
    booking_channel_id    INT                    NOT NULL REFERENCES core.m_booking_channel (id),
    order_status_id       INT                    NOT NULL REFERENCES core.m_order_status (id),

    -- Money (denormalized rollups from lines/taxes/payments)
    currency_id           INT                    NOT NULL REFERENCES core.m_currency (id),
    subtotal_amount       NUMERIC(14, 2)         NOT NULL DEFAULT 0,   -- sum of line totals pre-tax, pre-discount
    line_discount_amount  NUMERIC(14, 2)         NOT NULL DEFAULT 0,   -- sum of discounts on individual lines
    order_discount_amount NUMERIC(14, 2)         NOT NULL DEFAULT 0,   -- order-level discounts
    tax_amount            NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    surcharge_amount      NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    tip_amount            NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    rounding_amount       NUMERIC(8, 2)          NOT NULL DEFAULT 0,
    total_amount          NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    -- Payment rollup (matches booking_main style)
    payment_status_id     INT                    NOT NULL REFERENCES core.m_payment_status (id),
    deposit_amount        NUMERIC(14, 2)         NOT NULL DEFAULT 0,   -- pre-service advance held
    amount_paid           NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    amount_refunded       NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    amount_due            NUMERIC(14, 2)         NOT NULL DEFAULT 0,

    -- Lifecycle timestamps
    opened_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    service_started_at    TIMESTAMPTZ,
    service_completed_at  TIMESTAMPTZ,
    billed_at             TIMESTAMPTZ,
    closed_at             TIMESTAMPTZ,
    voided_at             TIMESTAMPTZ,
    void_reason           character varying(255),

    -- Notes
    customer_notes        TEXT,
    internal_notes        TEXT,

    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               BIGINT                 NOT NULL DEFAULT 1,

    CHECK (amount_paid >= 0 AND amount_refunded >= 0 AND deposit_amount >= 0),
    CHECK (total_amount >= 0),
    CHECK (amount_due = total_amount - amount_paid + amount_refunded),
    UNIQUE (tenant_id, order_number)
);
CREATE INDEX idx_order_branch_opened ON order_main (branch_id, opened_at DESC);
CREATE INDEX idx_order_customer ON order_main (customer_account_id, opened_at DESC)
    WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_order_visit ON order_main (visit_id) WHERE visit_id IS NOT NULL;
CREATE INDEX idx_order_booking ON order_main (booking_id) WHERE booking_id IS NOT NULL;
CREATE INDEX idx_order_status ON order_main (order_status_id) WHERE status = 'A';
CREATE INDEX idx_order_payment_status ON order_main (payment_status_id) WHERE status = 'A';
CREATE INDEX idx_order_open ON order_main (branch_id, order_status_id) WHERE status = 'A';

-- ---------------------------------------------------------
-- order_line
-- A single line: service, service variant, service addon,
-- product, product variant, surcharge, discount or tip.
-- item_type discriminator picks which FK is populated.
-- ---------------------------------------------------------
CREATE TABLE order_line
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_code          character varying(50)  NOT NULL UNIQUE,
    tenant_id              BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id            BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id              BIGINT                 NOT NULL REFERENCES core.branches (id),
    order_id               BIGINT                 NOT NULL REFERENCES order_main (id) ON DELETE CASCADE,
    line_seq               INT                    NOT NULL,

    -- What this line represents
    line_type_id           INT                    NOT NULL REFERENCES core.m_order_line_type (id),

    -- Polymorphic references (exactly one set populated based on line_type)
    service_id             BIGINT REFERENCES core.service_master (id),
    service_variant_id     BIGINT REFERENCES core.service_variants (id),
    service_addon_id       BIGINT REFERENCES core.service_addons (id),
    service_bundle_id      BIGINT REFERENCES core.service_bundles (id),
    product_id             BIGINT REFERENCES core.product_master (id),
    product_variant_id     BIGINT REFERENCES core.product_variants (id),

    -- Parent linkage (addon attached to a service line, product consumed for a service line)
    parent_line_id         BIGINT REFERENCES order_line (id) ON DELETE CASCADE,

    -- Optional link back to the source booking line (when this order came from an appointment)
    booking_line_id        BIGINT REFERENCES booking.booking_line (id),

    -- Snapshot of the name at time of billing (immutable even if master changes)
    name_snapshot          character varying(200) NOT NULL,
    description_snapshot   TEXT,
    uom_id                 INT REFERENCES core.m_uom (id),
    hsn_code               character varying(30),

    -- Pricing
    quantity               NUMERIC(12, 3)         NOT NULL DEFAULT 1 CHECK (quantity <> 0),
    unit_price             NUMERIC(12, 2)         NOT NULL,
    gross_amount           NUMERIC(14, 2)         NOT NULL,     -- quantity * unit_price
    -- Discount applied to this line
    discount_type          character varying(10) CHECK (discount_type IS NULL OR discount_type IN ('percent', 'flat')),
    discount_value         NUMERIC(12, 4),
    discount_amount        NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    taxable_amount         NUMERIC(14, 2)         NOT NULL,     -- gross - discount
    tax_amount             NUMERIC(14, 2)         NOT NULL DEFAULT 0,
    line_total             NUMERIC(14, 2)         NOT NULL,     -- taxable + tax (or - for discount lines)

    -- Pricing metadata
    price_rule_id          BIGINT,
    customer_tier_id       INT REFERENCES core.m_customer_tier (id),
    tier_discount_percent  NUMERIC(5, 2)          NOT NULL DEFAULT 0,

    -- For products: cost snapshot for margin/COGS
    cost_price             NUMERIC(12, 2),
    stock_movement_id      BIGINT REFERENCES core.stock_movements (id),  -- set when inventory decremented

    -- For services: delivery
    assigned_staff_id      BIGINT REFERENCES security.tenant_staff_users (id),
    service_duration_minutes INT,
    service_started_at     TIMESTAMPTZ,
    service_completed_at   TIMESTAMPTZ,
    line_status_id         INT REFERENCES core.m_order_status (id),

    notes                  TEXT,
    status                 character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT,
    updated_by             BIGINT,
    version                BIGINT                 NOT NULL DEFAULT 1,

    -- Exactly one catalogue reference (or none for surcharge/discount/tip lines)
    CHECK (
        (service_id IS NOT NULL)::int
        + (service_variant_id IS NOT NULL)::int
        + (service_addon_id IS NOT NULL)::int
        + (service_bundle_id IS NOT NULL)::int
        + (product_id IS NOT NULL)::int
        + (product_variant_id IS NOT NULL)::int <= 1
),
    UNIQUE (order_id, line_seq)
);
CREATE INDEX idx_order_line_order ON order_line (order_id, line_seq);
CREATE INDEX idx_order_line_service ON order_line (service_id) WHERE service_id IS NOT NULL;
CREATE INDEX idx_order_line_product ON order_line (product_id) WHERE product_id IS NOT NULL;
CREATE INDEX idx_order_line_staff ON order_line (assigned_staff_id) WHERE assigned_staff_id IS NOT NULL;
CREATE INDEX idx_order_line_booking_line ON order_line (booking_line_id) WHERE booking_line_id IS NOT NULL;

-- ---------------------------------------------------------
-- order_line_tax
-- Per-tax breakdown for each line (supports CGST+SGST, VAT, etc.)
-- ---------------------------------------------------------
CREATE TABLE order_line_tax
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT                 NOT NULL REFERENCES core.tenants (id),
    order_id       BIGINT                 NOT NULL REFERENCES order_main (id) ON DELETE CASCADE,
    order_line_id  BIGINT                 NOT NULL REFERENCES order_line (id) ON DELETE CASCADE,
    tax_type_id    INT                    NOT NULL REFERENCES core.m_tax_type (id),
    tax_rate_id    BIGINT REFERENCES core.tax_rates (id),
    tax_name       character varying(100) NOT NULL,
    rate_percent   NUMERIC(6, 3)          NOT NULL,
    is_inclusive   BOOLEAN                NOT NULL DEFAULT FALSE,
    taxable_amount NUMERIC(14, 2)         NOT NULL,
    tax_amount     NUMERIC(14, 2)         NOT NULL,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_order_line_tax_line ON order_line_tax (order_line_id);
CREATE INDEX idx_order_line_tax_order ON order_line_tax (order_id);

-- ---------------------------------------------------------
-- order_discounts
-- Order-level discounts (coupon, manager override, loyalty, etc.)
-- ---------------------------------------------------------
CREATE TABLE order_discounts
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES core.tenants (id),
    order_id          BIGINT                 NOT NULL REFERENCES order_main (id) ON DELETE CASCADE,
    discount_code     character varying(80),
    discount_name     character varying(150) NOT NULL,
    discount_type     character varying(10)  NOT NULL CHECK (discount_type IN ('percent', 'flat')),
    discount_value    NUMERIC(12, 4)         NOT NULL,
    discount_amount   NUMERIC(14, 2)         NOT NULL,
    reason            character varying(255),
    approved_by       BIGINT,
    approved_at       TIMESTAMPTZ,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_order_discounts_order ON order_discounts (order_id);

-- ---------------------------------------------------------
-- order_line_staff
-- Staff attribution per line (for commission) — supports
-- multiple staff splitting a single service.
-- ---------------------------------------------------------
CREATE TABLE order_line_staff
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES core.tenants (id),
    order_id          BIGINT                 NOT NULL REFERENCES order_main (id) ON DELETE CASCADE,
    order_line_id     BIGINT                 NOT NULL REFERENCES order_line (id) ON DELETE CASCADE,
    staff_id          BIGINT                 NOT NULL REFERENCES security.tenant_staff_users (id),
    -- Share of this line (0..1). Multiple rows per line should sum to 1.0.
    allocation_share  NUMERIC(5, 4)          NOT NULL DEFAULT 1.0 CHECK (allocation_share > 0 AND allocation_share <= 1),
    is_primary        BOOLEAN                NOT NULL DEFAULT TRUE,
    -- Commission snapshot at time of sale
    commission_type   character varying(10) CHECK (commission_type IS NULL OR commission_type IN ('percent', 'flat')),
    commission_value  NUMERIC(8, 4),
    commission_base   NUMERIC(14, 2),    -- base amount the commission was computed on
    commission_amount NUMERIC(14, 2),
    staff_commission_rule_id BIGINT REFERENCES core.staff_commissions (id),
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1,
    UNIQUE (order_line_id, staff_id)
);
CREATE INDEX idx_order_line_staff_staff ON order_line_staff (staff_id);
CREATE INDEX idx_order_line_staff_line ON order_line_staff (order_line_id);

-- ---------------------------------------------------------
-- order_status_history
-- ---------------------------------------------------------
CREATE TABLE order_status_history
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT                 NOT NULL REFERENCES core.tenants (id),
    order_id       BIGINT                 NOT NULL REFERENCES order_main (id) ON DELETE CASCADE,
    from_status_id INT REFERENCES core.m_order_status (id),
    to_status_id   INT                    NOT NULL REFERENCES core.m_order_status (id),
    changed_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    changed_by     BIGINT,
    reason         character varying(255),
    notes          TEXT,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_osh_order ON order_status_history (order_id, changed_at DESC);