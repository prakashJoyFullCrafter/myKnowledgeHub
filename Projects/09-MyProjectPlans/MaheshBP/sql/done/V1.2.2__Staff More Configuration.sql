CREATE TABLE staff_working_hours
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    staff_id    BIGINT                 NOT NULL REFERENCES staff_profiles (id),
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    day_of_week SMALLINT               NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    start_time  TIME                   NOT NULL,
    end_time    TIME                   NOT NULL,
    is_day_off  BOOLEAN                NOT NULL DEFAULT FALSE,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT REFERENCES security.users (id),
    updated_by  BIGINT REFERENCES security.users (id),
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (staff_id, branch_id, day_of_week)
);

CREATE TABLE staff_availability_overrides
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    staff_id              BIGINT                 NOT NULL REFERENCES staff_profiles (id),
    branch_id             BIGINT                 NOT NULL REFERENCES branches (id),
    is_accepting_bookings BOOLEAN                NOT NULL DEFAULT TRUE,
    override_from         TIMESTAMPTZ,
    override_until        TIMESTAMPTZ,
    reason                character varying(255),
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT REFERENCES security.users (id),
    updated_by            BIGINT REFERENCES security.users (id),
    version               INT                    NOT NULL DEFAULT 1
);


CREATE TABLE staff_breaks
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    staff_id      BIGINT                 NOT NULL REFERENCES staff_profiles (id),
    branch_id     BIGINT                 NOT NULL REFERENCES branches (id),
    break_type_id INT REFERENCES break_types (id),
    break_date    DATE                   NOT NULL,
    start_time    TIME                   NOT NULL,
    end_time      TIME                   NOT NULL,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version       INT                    NOT NULL DEFAULT 1
);


CREATE TABLE staff_leaves
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    staff_id      BIGINT                 NOT NULL REFERENCES staff_profiles (id),
    leave_type_id INT                    NOT NULL REFERENCES leave_types (id),
    start_date    DATE                   NOT NULL,
    end_date      DATE                   NOT NULL,
    reason        TEXT,
    approved_by   BIGINT REFERENCES security.users (id),
    leave_status  character varying(20)  NOT NULL DEFAULT 'pending'
        CHECK (leave_status IN ('pending', 'approved', 'rejected', 'cancelled')),
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT REFERENCES security.users (id),
    updated_by    BIGINT REFERENCES security.users (id),
    version       INT                    NOT NULL DEFAULT 1
);


CREATE TABLE staff_home_service_eligibility
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    staff_id        BIGINT                 NOT NULL UNIQUE REFERENCES staff_profiles (id),
    is_eligible     BOOLEAN                NOT NULL DEFAULT FALSE,
    max_distance_km NUMERIC(8, 2),
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT REFERENCES security.users (id),
    updated_by      BIGINT REFERENCES security.users (id),
    version         INT                    NOT NULL DEFAULT 1
);
