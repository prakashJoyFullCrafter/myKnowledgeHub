set
search_path to core;

CREATE TABLE m_customer_tier
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

CREATE TABLE m_module
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    module_key    character varying(100) NOT NULL,
    setting_key   character varying(100) NOT NULL,
    setting_value TEXT,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1,
    UNIQUE (module_key, setting_key)
);

CREATE TABLE m_subscription_plan
(
    id                    SERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    plan_key              character varying(50)  NOT NULL UNIQUE,
    name                  character varying(100) NOT NULL,
    description           TEXT,
    price_monthly         NUMERIC(12, 2),
    price_annually        NUMERIC(12, 2),
    currency_id           INT                    NOT NULL REFERENCES m_currency (id),
    branch_limit          INT,
    staff_limit           INT,
    booking_limit_monthly INT,
    commission_rate       NUMERIC(5, 4)          NOT NULL DEFAULT 0.06,
    feature_flags         JSONB                  NOT NULL DEFAULT '{}',
    display_order         INT                    NOT NULL DEFAULT 0,
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1
);


CREATE TABLE m_business_type
(
    id                            SERIAL PRIMARY KEY,
    internal_id                   character varying(200) NOT NULL UNIQUE,
    type_key                      character varying(50)  NOT NULL UNIQUE,
    label                         character varying(100) NOT NULL,
    icon_key                      character varying(50),
    description                   TEXT,
    default_service_category_keys JSONB                  NOT NULL DEFAULT '[]',
    display_order                 INT                    NOT NULL DEFAULT 0,
    status                        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at                    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at                    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by                    BIGINT,
    updated_by                    BIGINT,
    version                       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE m_business_type_translation
(
    id               SERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    business_type_id INT                    NOT NULL REFERENCES m_business_type (id),
    language_id      INT                    NOT NULL REFERENCES m_language (id),
    label            character varying(100) NOT NULL,
    description      TEXT,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1,
    UNIQUE (business_type_id, language_id)
);


CREATE TABLE m_break_type
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

CREATE TABLE m_gender
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

CREATE TABLE m_leave_type
(
    id                SERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    name              character varying(100) NOT NULL,
    is_paid           BOOLEAN                NOT NULL DEFAULT TRUE,
    days_allowed      integer,
    carry_forward     BOOLEAN                NOT NULL DEFAULT FALSE,
    requires_approval BOOLEAN                NOT NULL DEFAULT FALSE,
    applicable_to_all BOOLEAN                NOT NULL DEFAULT FALSE,
    applicable_gender int references m_gender (id),
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);