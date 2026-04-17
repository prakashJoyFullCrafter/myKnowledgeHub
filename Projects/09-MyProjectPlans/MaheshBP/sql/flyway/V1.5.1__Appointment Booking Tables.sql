-- =========================================================
-- SCHEMA
-- =========================================================
CREATE SCHEMA IF NOT EXISTS booking;
SET
search_path TO booking;

CREATE TABLE booking_main
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_code          character varying(50) NOT NULL UNIQUE,
    tenant_id              BIGINT                NOT NULL REFERENCES core.tenants (id),
    business_id            BIGINT                NOT NULL REFERENCES core.businesses (id),
    branch_id              BIGINT                NOT NULL REFERENCES core.branches (id),
    staff_id               BIGINT REFERENCES security.tenant_staff_users (id),
    customer_account_id    BIGINT REFERENCES security.customer_accounts (id),
    -- Scheduled window
    requested_start        TIMESTAMPTZ           NOT NULL,
    requested_end          TIMESTAMPTZ           NOT NULL,
    scheduled_start        TIMESTAMPTZ           NOT NULL,
    scheduled_end          TIMESTAMPTZ           NOT NULL,
    actual_start           TIMESTAMPTZ,
    actual_end             TIMESTAMPTZ,
    -- How/where booked
    booking_channel_id     INT                   NOT NULL REFERENCES m_booking_channel (id),
    service_mode_id        INT                   NOT NULL REFERENCES m_service_mode (id),
    -- Lifecycle
    booking_status_id      INT                   NOT NULL REFERENCES m_booking_status (id),
    confirmed_at           TIMESTAMPTZ,
    checked_in_at          TIMESTAMPTZ,
    completed_at           TIMESTAMPTZ,
    -- Cancellation
    cancelled_at           TIMESTAMPTZ,
    cancelled_by           BIGINT,
    cancellation_reason    character varying(255),
    cancellation_source_id INT REFERENCES m_cancellation_source (id),
    -- Money snapshots
    currency_id            INT                   NOT NULL REFERENCES core.m_currency (id),
    subtotal_amount        NUMERIC(12, 2)        NOT NULL DEFAULT 0,
    addon_amount           NUMERIC(12, 2)        NOT NULL DEFAULT 0,
    surcharge_amount       NUMERIC(12, 2)        NOT NULL DEFAULT 0,
    discount_amount        NUMERIC(12, 2)        NOT NULL DEFAULT 0,
    tax_amount             NUMERIC(12, 2)        NOT NULL DEFAULT 0,
    total_amount           NUMERIC(12, 2)        NOT NULL DEFAULT 0,

    -- Payment rollup
    payment_status_id      INT                   NOT NULL REFERENCES m_payment_status (id),
    amount_paid            NUMERIC(12, 2)        NOT NULL DEFAULT 0,
    amount_refunded        NUMERIC(12, 2)        NOT NULL DEFAULT 0,

    -- Notes
    customer_notes         TEXT,
    internal_notes         TEXT,

    -- Home-service address (required when service_mode.requires_address = TRUE)
    service_address_line1  character varying(255),
    service_address_line2  character varying(255),
    service_city_id        INT REFERENCES core.m_city (id),
    service_locality_id    INT REFERENCES core.m_locality (id),
    service_latitude       NUMERIC(10, 8),
    service_longitude      NUMERIC(11, 8),

    status                 CHAR(1)               NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ           NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ           NOT NULL DEFAULT NOW(),
    created_by             BIGINT,
    updated_by             BIGINT,
    version                BIGINT                NOT NULL DEFAULT 1,

    CHECK (scheduled_end > scheduled_start),
    CHECK (actual_end IS NULL OR actual_start IS NULL OR actual_end >= actual_start),
    CHECK (total_amount = subtotal_amount + addon_amount + surcharge_amount + tax_amount - discount_amount),
    CHECK (amount_paid >= 0 AND amount_refunded >= 0)
);

CREATE INDEX idx_booking_customer ON booking_main (customer_account_id, scheduled_start DESC);
CREATE INDEX idx_booking_bu_schedule ON booking_main (branch_id, scheduled_start);
CREATE INDEX idx_booking_status_schedule ON booking_main (booking_status_id, scheduled_start) WHERE status = 'A';
CREATE INDEX idx_booking_payment_status ON booking_main (payment_status_id) WHERE status = 'A';

CREATE TABLE booking_line
(
    id                       BIGSERIAL PRIMARY KEY,
    internal_code            character varying(50)  NOT NULL UNIQUE,
    booking_id               BIGINT                 NOT NULL REFERENCES booking_main (id) ON DELETE CASCADE,
    tenant_id                BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id              BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id                BIGINT                 NOT NULL REFERENCES core.branches (id),
    service_id               BIGINT                 NOT NULL REFERENCES core.service_master (id),
    service_variant_id       BIGINT REFERENCES core.service_variants (id),
    staff_id               BIGINT REFERENCES security.tenant_staff_users (id),
    service_name_snapshot    character varying(200) NOT NULL,
    service_duration_minutes INT                    NOT NULL,
    -- Scheduled window for this line
    scheduled_start          TIMESTAMPTZ            NOT NULL,
    scheduled_end            TIMESTAMPTZ            NOT NULL,
    actual_start             TIMESTAMPTZ,
    actual_end               TIMESTAMPTZ,
    -- Per-line status
    booking_status_id        INT                    NOT NULL REFERENCES m_booking_status (id),
    -- Price snapshot
    base_price               NUMERIC(12, 2)         NOT NULL,
    price_rule_id            BIGINT REFERENCES core.service_price_rules (id),
    tier_discount_percent    NUMERIC(5, 2)          NOT NULL DEFAULT 0,
    tier_discount_amount     NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    line_total               NUMERIC(12, 2)         NOT NULL,
    -- Commission snapshot
    commission_type          character varying(10) CHECK (commission_type IS NULL OR commission_type IN ('percent', 'flat')),
    commission_value         NUMERIC(8, 4),
    commission_amount        NUMERIC(12, 2),
    display_order            INT                    NOT NULL DEFAULT 0,
    notes                    TEXT,
    status                   CHAR(1)                NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at               TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by               BIGINT,
    updated_by               BIGINT,
    version                  BIGINT                 NOT NULL DEFAULT 1,
    CHECK (scheduled_end > scheduled_start),
    CHECK (line_total >= 0)
);

CREATE INDEX idx_booking_line_booking ON booking_line (booking_id);
CREATE INDEX idx_booking_line_resource ON booking_line (staff_id, scheduled_start, scheduled_end) WHERE status = 'A';
CREATE INDEX idx_booking_line_staff ON booking_line (staff_id, scheduled_start) WHERE staff_id IS NOT NULL AND status = 'A';

CREATE TABLE booking_line_addons
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_code          character varying(50)  NOT NULL UNIQUE,
    tenant_id              BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id            BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id              BIGINT                 NOT NULL REFERENCES core.branches (id),
    booking_line_id        BIGINT                 NOT NULL REFERENCES booking_line (id) ON DELETE CASCADE,
    service_addon_id       BIGINT                 NOT NULL REFERENCES core.service_addons (id),
    addon_name_snapshot    character varying(200) NOT NULL,
    quantity               INT                    NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price             NUMERIC(12, 2)         NOT NULL,
    duration_extra_minutes INT                    NOT NULL DEFAULT 0,
    line_total             NUMERIC(12, 2)         NOT NULL,
    status                 CHAR(1)                NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT,
    updated_by             BIGINT,
    version                BIGINT                 NOT NULL DEFAULT 1
);
CREATE INDEX idx_booking_addon_line ON booking_line_addons (booking_line_id);

CREATE TABLE booking_status_history
(
    id             BIGSERIAL PRIMARY KEY,
    internal_code  character varying(50) NOT NULL UNIQUE,
    tenant_id      BIGINT                NOT NULL REFERENCES core.tenants (id),
    business_id    BIGINT                NOT NULL REFERENCES core.businesses (id),
    branch_id      BIGINT                NOT NULL REFERENCES core.branches (id),
    booking_id     BIGINT                NOT NULL REFERENCES booking_main (id) ON DELETE CASCADE,
    from_status_id INT REFERENCES m_booking_status (id),
    to_status_id   INT                   NOT NULL REFERENCES m_booking_status (id),
    changed_by     BIGINT,
    change_reason  character varying(255),
    changed_at     TIMESTAMPTZ           NOT NULL DEFAULT NOW(),
    metadata       JSONB
);
CREATE INDEX idx_booking_status_history_booking ON booking_status_history (booking_id, changed_at DESC);

CREATE TABLE booking_reschedule_history
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_code       character varying(50) NOT NULL UNIQUE,
    tenant_id           BIGINT                NOT NULL REFERENCES core.tenants (id),
    business_id         BIGINT                NOT NULL REFERENCES core.businesses (id),
    branch_id           BIGINT                NOT NULL REFERENCES core.branches (id),
    booking_id          BIGINT                NOT NULL REFERENCES booking_main (id) ON DELETE CASCADE,
    booking_line_id     BIGINT REFERENCES booking_line (id),
    old_scheduled_start TIMESTAMPTZ           NOT NULL,
    old_scheduled_end   TIMESTAMPTZ           NOT NULL,
    new_scheduled_start TIMESTAMPTZ           NOT NULL,
    new_scheduled_end   TIMESTAMPTZ           NOT NULL,
    old_resource_id     BIGINT,
    new_resource_id     BIGINT,
    rescheduled_by      BIGINT,
    reschedule_reason   character varying(255),
    rescheduled_at      TIMESTAMPTZ           NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_reschedule_booking ON booking_reschedule_history (booking_id, rescheduled_at DESC);