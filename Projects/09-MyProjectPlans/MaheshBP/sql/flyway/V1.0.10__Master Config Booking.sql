CREATE SCHEMA booking;

set search_path to booking;

CREATE TABLE m_booking_channel
(
    id            SERIAL PRIMARY KEY,
    internal_code VARCHAR(50)  NOT NULL UNIQUE,
    channel_key   VARCHAR(30)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    description   TEXT,
    icon_key      VARCHAR(50),
    display_order INT          NOT NULL DEFAULT 0,
    status        CHAR(1)      NOT NULL DEFAULT 'A' CHECK (status IN ('A','I')),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE m_service_mode
(
    id            SERIAL PRIMARY KEY,
    internal_code VARCHAR(50)  NOT NULL UNIQUE,
    mode_key      VARCHAR(30)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    description   TEXT,
    icon_key      VARCHAR(50),
    requires_address BOOLEAN   NOT NULL DEFAULT FALSE,   -- TRUE for HOME_SERVICE
    display_order INT          NOT NULL DEFAULT 0,
    status        CHAR(1)      NOT NULL DEFAULT 'A' CHECK (status IN ('A','I')),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE m_booking_status
(
    id            SERIAL PRIMARY KEY,
    internal_code VARCHAR(50)  NOT NULL UNIQUE,
    status_key    VARCHAR(30)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    description   TEXT,
    color_hex     VARCHAR(7),                             -- for UI badges (#RRGGBB)
    is_terminal   BOOLEAN      NOT NULL DEFAULT FALSE,    -- TRUE = no further transitions (COMPLETED, NO_SHOW, CANCELLED)
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,     -- TRUE = booking is "live" in calendars
    display_order INT          NOT NULL DEFAULT 0,
    status        CHAR(1)      NOT NULL DEFAULT 'A' CHECK (status IN ('A','I')),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE m_cancellation_source
(
    id            SERIAL PRIMARY KEY,
    internal_code VARCHAR(50)  NOT NULL UNIQUE,
    source_key    VARCHAR(30)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    description   TEXT,
    display_order INT          NOT NULL DEFAULT 0,
    status        CHAR(1)      NOT NULL DEFAULT 'A' CHECK (status IN ('A','I')),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE m_payment_status
(
    id            SERIAL PRIMARY KEY,
    internal_code VARCHAR(50)  NOT NULL UNIQUE,
    status_key    VARCHAR(30)  NOT NULL UNIQUE,
    label         VARCHAR(100) NOT NULL,
    description   TEXT,
    color_hex     VARCHAR(7),
    is_settled    BOOLEAN      NOT NULL DEFAULT FALSE,    -- TRUE = PAID or REFUNDED (terminal for accounting)
    display_order INT          NOT NULL DEFAULT 0,
    status        CHAR(1)      NOT NULL DEFAULT 'A' CHECK (status IN ('A','I')),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE m_booking_status_transitions
(
    id             SERIAL PRIMARY KEY,
    internal_code  VARCHAR(50) NOT NULL UNIQUE,
    from_status_id INT         NOT NULL REFERENCES m_booking_status (id),
    to_status_id   INT         NOT NULL REFERENCES m_booking_status (id),
    description    VARCHAR(255),
    status         CHAR(1)     NOT NULL DEFAULT 'A' CHECK (status IN ('A','I')),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT         NOT NULL DEFAULT 1,
    UNIQUE (from_status_id, to_status_id),
    CHECK (from_status_id <> to_status_id)
);