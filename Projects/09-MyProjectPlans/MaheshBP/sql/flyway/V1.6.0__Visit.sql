-- =========================================================
-- Visit / Front-Desk Registration
-- A `visit` is a customer's physical presence at a branch.
-- It may be linked to a booking (appointment arrival) or
-- created ad-hoc (walk-in). It is the anchor for the order.
-- =========================================================
CREATE SCHEMA IF NOT EXISTS visit;
SET
search_path TO visit;

-- ---------------------------------------------------------
-- visits
-- One row per customer arrival at a branch. 1 booking -> 1 visit;
-- walk-ins create a visit with no booking_id.
-- ---------------------------------------------------------
CREATE TABLE visits
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_code         character varying(50)  NOT NULL UNIQUE,
    visit_number          character varying(50),           -- customer-visible (e.g. token number)
    tenant_id             BIGINT                 NOT NULL REFERENCES core.tenants (id),
    business_id           BIGINT                 NOT NULL REFERENCES core.businesses (id),
    branch_id             BIGINT                 NOT NULL REFERENCES core.branches (id),

    -- Link to appointment (nullable for walk-ins)
    booking_id            BIGINT REFERENCES booking.booking_main (id),

    -- Customer identification
    customer_account_id   BIGINT REFERENCES security.customer_accounts (id),
    -- Guest walk-in (no account yet) — captured inline
    guest_name            character varying(200),
    guest_phone           character varying(30),
    guest_email           character varying(150),
    guest_gender_id       INT REFERENCES core.m_gender (id),

    -- How the customer arrived
    booking_channel_id    INT                    NOT NULL REFERENCES core.m_booking_channel (id),
    service_mode_id       INT                    NOT NULL REFERENCES core.m_service_mode (id),

    -- Headcount (supports group visits where one visit covers multiple attendees)
    party_size            INT                    NOT NULL DEFAULT 1 CHECK (party_size >= 1),

    -- Lifecycle
    visit_status_id       INT                    NOT NULL REFERENCES core.m_visit_status (id),
    registered_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    seated_at             TIMESTAMPTZ,
    service_started_at    TIMESTAMPTZ,
    service_ended_at      TIMESTAMPTZ,
    billed_at             TIMESTAMPTZ,
    closed_at             TIMESTAMPTZ,

    -- Assigned receptionist/greeter
    registered_by_staff_id BIGINT REFERENCES security.tenant_staff_users (id),

    -- Loose notes from the front desk
    customer_notes        TEXT,
    internal_notes        TEXT,

    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               BIGINT                 NOT NULL DEFAULT 1,

    -- Customer identity integrity: either a registered customer OR guest details
    CHECK (customer_account_id IS NOT NULL OR guest_phone IS NOT NULL OR guest_name IS NOT NULL),
    -- One visit per booking (at most)
    UNIQUE (booking_id)
);
CREATE INDEX idx_visits_branch_registered ON visits (branch_id, registered_at DESC);
CREATE INDEX idx_visits_customer ON visits (customer_account_id, registered_at DESC) WHERE customer_account_id IS NOT NULL;
CREATE INDEX idx_visits_status ON visits (branch_id, visit_status_id) WHERE status = 'A';
CREATE INDEX idx_visits_booking ON visits (booking_id) WHERE booking_id IS NOT NULL;
CREATE INDEX idx_visits_guest_phone ON visits (tenant_id, guest_phone) WHERE guest_phone IS NOT NULL;

-- ---------------------------------------------------------
-- visit_attendees
-- For group visits: lists each person on the visit.
-- Each attendee can be billed separately (split bill) via
-- order_main.visit_attendee_id.
-- ---------------------------------------------------------
CREATE TABLE visit_attendees
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES core.tenants (id),
    visit_id            BIGINT                 NOT NULL REFERENCES visits (id) ON DELETE CASCADE,
    attendee_seq        INT                    NOT NULL,
    -- Attendee can be a registered customer or a guest
    customer_account_id BIGINT REFERENCES security.customer_accounts (id),
    guest_name          character varying(200),
    guest_phone         character varying(30),
    is_primary          BOOLEAN                NOT NULL DEFAULT FALSE,
    -- Billing preference for this attendee
    pays_own_bill       BOOLEAN                NOT NULL DEFAULT FALSE,
    notes               TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,
    CHECK (customer_account_id IS NOT NULL OR guest_name IS NOT NULL),
    UNIQUE (visit_id, attendee_seq)
);
CREATE INDEX idx_visit_attendees_visit ON visit_attendees (visit_id);

-- ---------------------------------------------------------
-- visit_status_history
-- Audit trail for visit status changes.
-- ---------------------------------------------------------
CREATE TABLE visit_status_history
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    tenant_id       BIGINT                 NOT NULL REFERENCES core.tenants (id),
    visit_id        BIGINT                 NOT NULL REFERENCES visits (id) ON DELETE CASCADE,
    from_status_id  INT REFERENCES core.m_visit_status (id),
    to_status_id    INT                    NOT NULL REFERENCES core.m_visit_status (id),
    changed_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    changed_by      BIGINT,
    reason          character varying(255),
    notes           TEXT,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_vsh_visit ON visit_status_history (visit_id, changed_at DESC);