CREATE TABLE break_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    name        character varying(100) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE genders
(
    id            SERIAL PRIMARY KEY,
    internal_id   VARCHAR(200) NOT NULL UNIQUE,
    gender_key    VARCHAR(20)  NOT NULL UNIQUE,
    label         VARCHAR(50)  NOT NULL,
    display_order INT          NOT NULL DEFAULT 0,
    status        VARCHAR(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT          NOT NULL DEFAULT 1
);

CREATE TABLE leave_types
(
    id                SERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    name              character varying(100) NOT NULL,
    is_paid           BOOLEAN                NOT NULL DEFAULT TRUE,
    days_allowed      integer,
    carry_forward     BOOLEAN                NOT NULL DEFAULT FALSE,
    requires_approval BOOLEAN                NOT NULL DEFAULT FALSE,
    applicable_to_all BOOLEAN                NOT NULL DEFAULT FALSE,
    applicable_gender int references genders (id),
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);