set
search_path to core;

CREATE TABLE availability_template
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200) NOT NULL UNIQUE,
    tenant_id          BIGINT       NOT NULL REFERENCES tenants (id),
    business_id        BIGINT       NOT NULL REFERENCES businesses (id),
    branch_id          BIGINT       NOT NULL REFERENCES branches (id),
    name               VARCHAR(150) NOT NULL,
    description        TEXT,
    timezone_id        INT          NOT NULL REFERENCES m_timezone (id),
    slot_duration_mins INT          NOT NULL DEFAULT 30 CHECK (slot_duration_mins > 0),
    is_default         BOOLEAN      NOT NULL DEFAULT FALSE,
    status             VARCHAR(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT          NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, business_id, branch_id, name)
);


CREATE TABLE availability_template_slots
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id VARCHAR(200) NOT NULL UNIQUE,
    tenant_id   BIGINT       NOT NULL REFERENCES tenants (id),
    business_id BIGINT       NOT NULL REFERENCES businesses (id),
    branch_id   BIGINT       NOT NULL REFERENCES branches (id),
    template_id BIGINT       NOT NULL REFERENCES availability_template (id) ON DELETE CASCADE,
    day_of_week SMALLINT     NOT NULL CHECK (day_of_week BETWEEN 0 AND 7),
    start_time  TIME         NOT NULL,
    end_time    TIME         NOT NULL,
    status      VARCHAR(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT          NOT NULL DEFAULT 1,
    CHECK (end_time > start_time),
    UNIQUE (template_id, day_of_week, start_time)
);

-- =========================================================
-- 1b. staff_availability_template_assignments
--     Which staff follows which template, in what date range
-- =========================================================
CREATE TABLE staff_availability_template_assignments
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT       NOT NULL REFERENCES tenants (id),
    business_id    BIGINT       NOT NULL REFERENCES businesses (id),
    branch_id      BIGINT       NOT NULL REFERENCES branches (id),
    staff_id       BIGINT       NOT NULL REFERENCES security.tenant_staff_users (id),
    template_id    BIGINT       NOT NULL REFERENCES availability_template (id),
    effective_from DATE         NOT NULL,
    effective_to   DATE,
    status         VARCHAR(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT          NOT NULL DEFAULT 1,
    CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

CREATE INDEX idx_staff_tmpl_assign_lookup
    ON staff_availability_template_assignments (staff_id, branch_id, effective_from, effective_to) WHERE status = 'A';


-- =========================================================
-- 2. availability_exception
--    One-off overrides for a specific date: extra shift,
--    modified hours, or availability change
-- =========================================================
CREATE TABLE availability_exception
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    VARCHAR(200) NOT NULL UNIQUE,
    tenant_id      BIGINT       NOT NULL REFERENCES tenants (id),
    business_id    BIGINT       NOT NULL REFERENCES businesses (id),
    branch_id      BIGINT       NOT NULL REFERENCES branches (id),
    staff_id       BIGINT       NOT NULL REFERENCES security.tenant_staff_users (id),
    exception_date DATE         NOT NULL,
    exception_type VARCHAR(20)  NOT NULL
        CHECK (exception_type IN ('ADD', 'REPLACE', 'REMOVE')),
    start_time     TIME,
    end_time       TIME,
    reason         VARCHAR(255),
    status         VARCHAR(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT          NOT NULL DEFAULT 1,
    CHECK (
        (exception_type = 'REMOVE' AND start_time IS NULL AND end_time IS NULL)
            OR (exception_type IN ('ADD', 'REPLACE') AND start_time IS NOT NULL AND end_time IS NOT NULL AND
                end_time > start_time)
        )
);

CREATE INDEX idx_availability_exception_lookup
    ON availability_exception (staff_id, branch_id, exception_date) WHERE status = 'A';


-- =========================================================
-- 3. time_off
--    Scheduling-level block: staff unavailable for bookings
-- =========================================================
CREATE TABLE time_off
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     VARCHAR(200) NOT NULL UNIQUE,
    tenant_id       BIGINT       NOT NULL REFERENCES tenants (id),
    business_id     BIGINT       NOT NULL REFERENCES businesses (id),
    branch_id       BIGINT       NOT NULL REFERENCES branches (id),
    staff_id        BIGINT       NOT NULL REFERENCES security.tenant_staff_users (id),
    leave_id        BIGINT REFERENCES staff_leaves (id),
    time_off_type   VARCHAR(20)  NOT NULL DEFAULT 'PERSONAL'
        CHECK (time_off_type IN ('LEAVE', 'SICK', 'PERSONAL', 'HOLIDAY', 'TRAINING', 'OTHER')),
    is_all_day      BOOLEAN      NOT NULL DEFAULT TRUE,
    start_at        TIMESTAMPTZ  NOT NULL,
    end_at          TIMESTAMPTZ  NOT NULL,
    reason          VARCHAR(255),
    approval_status VARCHAR(20)  NOT NULL DEFAULT 'approved'
        CHECK (approval_status IN ('pending', 'approved', 'rejected', 'cancelled')),
    approved_by     BIGINT REFERENCES security.tenant_staff_users (id),
    approved_at     TIMESTAMPTZ,
    status          VARCHAR(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT          NOT NULL DEFAULT 1,
    CHECK (end_at > start_at)
);

CREATE INDEX idx_time_off_lookup
    ON time_off (staff_id, start_at, end_at) WHERE status = 'A' AND approval_status = 'approved';

CREATE INDEX idx_time_off_branch
    ON time_off (branch_id, start_at, end_at) WHERE branch_id IS NOT NULL AND status = 'A' AND approval_status = 'approved';