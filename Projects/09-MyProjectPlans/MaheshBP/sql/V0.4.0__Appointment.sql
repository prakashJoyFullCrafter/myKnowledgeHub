set
search_oath to appointment;

-- ============================================================
-- DOMAIN 8: CANCELLATION AND NO-SHOW POLICY
-- ============================================================

CREATE TABLE cancellation_reasons
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    reason_key    character varying(50)  NOT NULL UNIQUE,
    label         character varying(150) NOT NULL,
    actor         character varying(20)  NOT NULL CHECK (actor IN ('customer', 'merchant', 'system')),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users (id),
    updated_by    BIGINT REFERENCES users (id),
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE reschedule_reasons
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    reason_key    character varying(50)  NOT NULL UNIQUE,
    label         character varying(150) NOT NULL,
    actor         character varying(20)  NOT NULL CHECK (actor IN ('customer', 'merchant', 'system')),
    is_active     BOOLEAN                NOT NULL DEFAULT TRUE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users (id),
    updated_by    BIGINT REFERENCES users (id),
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE no_show_reasons
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    reason_key    character varying(50)  NOT NULL UNIQUE,
    label         character varying(150) NOT NULL,
    is_active     BOOLEAN                NOT NULL DEFAULT TRUE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES users (id),
    updated_by    BIGINT REFERENCES users (id),
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE cancellation_policies
(
    id                      BIGSERIAL PRIMARY KEY,
    internal_id             character varying(200) NOT NULL UNIQUE,
    branch_id               BIGINT                 NOT NULL REFERENCES branches (id),
    free_cancellation_hours INT                    NOT NULL DEFAULT 24,
    late_fee_type           character varying(10)  NOT NULL DEFAULT 'flat'
        CHECK (late_fee_type IN ('flat', 'percent')),
    late_fee_value          NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    policy_text             TEXT,
    status                  character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by              BIGINT REFERENCES users (id),
    updated_by              BIGINT REFERENCES users (id),
    version                 INT                    NOT NULL DEFAULT 1
);

CREATE TABLE no_show_policies
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    fee_type    character varying(10)  NOT NULL DEFAULT 'flat'
        CHECK (fee_type IN ('flat', 'percent')),
    fee_value   NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    charge_mode character varying(10)  NOT NULL DEFAULT 'manual'
        CHECK (charge_mode IN ('auto', 'manual')),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT REFERENCES users (id),
    updated_by  BIGINT REFERENCES users (id),
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE deposit_rules
(
    id                         BIGSERIAL PRIMARY KEY,
    internal_id                character varying(200) NOT NULL UNIQUE,
    branch_service_id          BIGINT REFERENCES branch_services (id),
    branch_id                  BIGINT REFERENCES branches (id),
    deposit_type               character varying(10)  NOT NULL DEFAULT 'flat'
        CHECK (deposit_type IN ('flat', 'percent')),
    deposit_value              NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    refund_policy_text         TEXT,
    full_refund_until_hours    INT,
    partial_refund_percent     NUMERIC(5, 2),
    partial_refund_until_hours INT,
    status                     character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at                 TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at                 TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by                 BIGINT REFERENCES users (id),
    updated_by                 BIGINT REFERENCES users (id),
    version                    INT                    NOT NULL DEFAULT 1
);


-- ============================================================
-- DOMAIN 9: BOOKING
-- ============================================================

CREATE TABLE appointment_statuses
(
    id                  SERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    status_key          character varying(50)  NOT NULL UNIQUE,
    label               character varying(100) NOT NULL,
    color_hex           character varying(7),
    is_terminal         BOOLEAN                NOT NULL DEFAULT FALSE,
    is_customer_visible BOOLEAN                NOT NULL DEFAULT TRUE,
    display_order       INT                    NOT NULL DEFAULT 0,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users (id),
    updated_by          BIGINT REFERENCES users (id),
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE appointment_status_transitions
(
    id             SERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    from_status_id INT                    NOT NULL REFERENCES appointment_statuses (id),
    to_status_id   INT                    NOT NULL REFERENCES appointment_statuses (id),
    actor          character varying(20)  NOT NULL CHECK (actor IN ('customer', 'merchant', 'system')),
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users (id),
    updated_by     BIGINT REFERENCES users (id),
    version        INT                    NOT NULL DEFAULT 1,
    UNIQUE (from_status_id, to_status_id, actor)
);

CREATE TABLE group_bookings
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id        BIGINT                 NOT NULL REFERENCES branches (id),
    lead_customer_id BIGINT                 NOT NULL REFERENCES users (id),
    group_name       character varying(200),
    party_size       INT                    NOT NULL DEFAULT 1,
    booking_date     DATE                   NOT NULL,
    status_key       character varying(50)  NOT NULL DEFAULT 'pending',
    notes            TEXT,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users (id),
    updated_by       BIGINT REFERENCES users (id),
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE appointments
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id        BIGINT                 NOT NULL REFERENCES branches (id),
    customer_id      BIGINT                 NOT NULL REFERENCES users (id),
    group_booking_id BIGINT REFERENCES group_bookings (id),
    status_id        INT                    NOT NULL REFERENCES appointment_statuses (id),
    service_location character varying(15)  NOT NULL DEFAULT 'in_store'
        CHECK (service_location IN ('in_store', 'home_service')),
    home_address_id  BIGINT REFERENCES user_addresses (id),
    appointment_date DATE                   NOT NULL,
    start_time       TIME                   NOT NULL,
    end_time         TIME                   NOT NULL,
    total_amount     NUMERIC(12, 2),
    currency_id      INT REFERENCES currencies (id),
    notes            TEXT,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users (id),
    updated_by       BIGINT REFERENCES users (id),
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE group_booking_members
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    group_booking_id BIGINT                 NOT NULL REFERENCES group_bookings (id),
    appointment_id   BIGINT                 NOT NULL REFERENCES appointments (id),
    customer_name    character varying(150),
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT REFERENCES users (id),
    updated_by       BIGINT REFERENCES users (id),
    version          INT                    NOT NULL DEFAULT 1,
    UNIQUE (group_booking_id, appointment_id)
);

CREATE TABLE appointment_services
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    appointment_id     BIGINT                 NOT NULL REFERENCES appointments (id),
    branch_service_id  BIGINT                 NOT NULL REFERENCES branch_services (id),
    service_variant_id BIGINT REFERENCES service_variants (id),
    duration_minutes   INT                    NOT NULL,
    price              NUMERIC(12, 2)         NOT NULL,
    sequence_order     INT                    NOT NULL DEFAULT 1,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users (id),
    updated_by         BIGINT REFERENCES users (id),
    version            INT                    NOT NULL DEFAULT 1
);

CREATE TABLE appointment_staff_assignments
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            character varying(200) NOT NULL UNIQUE,
    appointment_id         BIGINT                 NOT NULL REFERENCES appointments (id),
    appointment_service_id BIGINT REFERENCES appointment_services (id),
    staff_id               BIGINT                 NOT NULL REFERENCES staff (id),
    is_primary             BOOLEAN                NOT NULL DEFAULT TRUE,
    status                 character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users (id),
    updated_by             BIGINT REFERENCES users (id),
    version                INT                    NOT NULL DEFAULT 1
);

CREATE TABLE appointment_status_history
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    appointment_id  BIGINT                 NOT NULL REFERENCES appointments (id),
    status_id       INT                    NOT NULL REFERENCES appointment_statuses (id),
    changed_by      BIGINT REFERENCES users (id),
    changed_by_role character varying(30),
    reason          TEXT,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users (id),
    updated_by      BIGINT REFERENCES users (id),
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE appointment_notes
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    appointment_id BIGINT                 NOT NULL REFERENCES appointments (id),
    author_id      BIGINT                 NOT NULL REFERENCES users (id),
    note           TEXT                   NOT NULL,
    is_internal    BOOLEAN                NOT NULL DEFAULT TRUE,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users (id),
    updated_by     BIGINT REFERENCES users (id),
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE appointment_reschedule_history
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    appointment_id      BIGINT                 NOT NULL REFERENCES appointments (id),
    previous_date       DATE                   NOT NULL,
    previous_start_time TIME                   NOT NULL,
    new_date            DATE                   NOT NULL,
    new_start_time      TIME                   NOT NULL,
    reason_id           INT REFERENCES reschedule_reasons (id),
    rescheduled_by      BIGINT REFERENCES users (id),
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT REFERENCES users (id),
    updated_by          BIGINT REFERENCES users (id),
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE appointment_cancellations
(
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    appointment_id       BIGINT                 NOT NULL UNIQUE REFERENCES appointments (id),
    reason_id            INT REFERENCES cancellation_reasons (id),
    cancelled_by         BIGINT REFERENCES users (id),
    cancelled_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    is_late_cancellation BOOLEAN                NOT NULL DEFAULT FALSE,
    late_fee_applicable  NUMERIC(12, 2),
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT REFERENCES users (id),
    updated_by           BIGINT REFERENCES users (id),
    version              INT                    NOT NULL DEFAULT 1
);

CREATE TABLE appointment_checkins
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    appointment_id  BIGINT                 NOT NULL UNIQUE REFERENCES appointments (id),
    checked_in_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    check_in_method character varying(20)  NOT NULL DEFAULT 'manual'
        CHECK (check_in_method IN ('qr', 'manual', 'app')),
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES users (id),
    updated_by      BIGINT REFERENCES users (id),
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE slot_holds
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    branch_id         BIGINT                 NOT NULL REFERENCES branches (id),
    staff_id          BIGINT                 NOT NULL REFERENCES staff (id),
    branch_service_id BIGINT                 NOT NULL REFERENCES branch_services (id),
    customer_id       BIGINT                 NOT NULL REFERENCES users (id),
    slot_date         DATE                   NOT NULL,
    slot_start        TIME                   NOT NULL,
    slot_end          TIME                   NOT NULL,
    expires_at        TIMESTAMPTZ            NOT NULL,
    is_converted      BOOLEAN                NOT NULL DEFAULT FALSE,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT REFERENCES users (id),
    updated_by        BIGINT REFERENCES users (id),
    version           INT                    NOT NULL DEFAULT 1
);

CREATE TABLE waitlists
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    branch_id          BIGINT                 NOT NULL REFERENCES branches (id),
    customer_id        BIGINT                 NOT NULL REFERENCES users (id),
    branch_service_id  BIGINT                 NOT NULL REFERENCES branch_services (id),
    preferred_date     DATE,
    preferred_staff_id BIGINT REFERENCES staff (id),
    status             character varying(20)  NOT NULL DEFAULT 'waiting'
        CHECK (status IN ('waiting', 'notified', 'booked', 'expired', 'cancelled')),
    notified_at        TIMESTAMPTZ,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT REFERENCES users (id),
    updated_by         BIGINT REFERENCES users (id),
    version            INT                    NOT NULL DEFAULT 1
);

CREATE TABLE queue_tokens
(
    id                     BIGSERIAL PRIMARY KEY,
    internal_id            character varying(200) NOT NULL UNIQUE,
    branch_id              BIGINT                 NOT NULL REFERENCES branches (id),
    customer_id            BIGINT REFERENCES users (id),
    token_number           INT                    NOT NULL,
    token_date             DATE                   NOT NULL,
    branch_service_id      BIGINT REFERENCES branch_services (id),
    estimated_wait_minutes INT,
    status                 character varying(20)  NOT NULL DEFAULT 'waiting'
        CHECK (status IN ('waiting', 'called', 'in_service', 'completed', 'cancelled', 'no_show')),
    issued_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    called_at              TIMESTAMPTZ,
    completed_at           TIMESTAMPTZ,
    status                 character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by             BIGINT REFERENCES users (id),
    updated_by             BIGINT REFERENCES users (id),
    version                INT                    NOT NULL DEFAULT 1
);

CREATE TABLE cancellation_fee_charges
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    appointment_id BIGINT                 NOT NULL REFERENCES appointments (id),
    amount         NUMERIC(12, 2)         NOT NULL,
    currency_id    INT                    NOT NULL REFERENCES currencies (id),
    charge_status  character varying(20)  NOT NULL DEFAULT 'pending'
        CHECK (charge_status IN ('pending', 'charged', 'waived', 'failed')),
    charged_at     TIMESTAMPTZ,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users (id),
    updated_by     BIGINT REFERENCES users (id),
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE no_show_fee_charges
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    appointment_id BIGINT                 NOT NULL REFERENCES appointments (id),
    reason_id      INT REFERENCES no_show_reasons (id),
    amount         NUMERIC(12, 2)         NOT NULL,
    currency_id    INT                    NOT NULL REFERENCES currencies (id),
    charge_status  character varying(20)  NOT NULL DEFAULT 'pending'
        CHECK (charge_status IN ('pending', 'charged', 'waived', 'failed')),
    charged_at     TIMESTAMPTZ,

    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users (id),
    updated_by     BIGINT REFERENCES users (id),
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE no_show_records
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    appointment_id BIGINT                 NOT NULL UNIQUE REFERENCES appointments (id),
    customer_id    BIGINT                 NOT NULL REFERENCES users (id),
    branch_id      BIGINT                 NOT NULL REFERENCES branches (id),
    marked_by      BIGINT REFERENCES users (id),
    marked_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT REFERENCES users (id),
    updated_by     BIGINT REFERENCES users (id),
    version        INT                    NOT NULL DEFAULT 1
);

