set
search_path to core;

CREATE TABLE timezones
(
    id           SERIAL PRIMARY KEY,
    internal_id  character varying(200) NOT NULL UNIQUE,
    timezone_key character varying(100) NOT NULL UNIQUE,
    label        character varying(150) NOT NULL,
    utc_offset   character varying(10)  NOT NULL,
    status       character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by   BIGINT,
    updated_by   BIGINT,
    version      INT                    NOT NULL DEFAULT 1
);

CREATE TABLE countries
(
    id                   SERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    country_code2        CHAR(2)                NOT NULL UNIQUE,
    country_code3        CHAR(3)                NOT NULL UNIQUE,
    country_code_numeric INT                    NOT NULL UNIQUE,
    name                 character varying(150) NOT NULL,
    is_supported         BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order        INT                    NOT NULL DEFAULT 0,
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1
);

CREATE TABLE country_administrative_divisions_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    name        character varying(100) NOT NULL UNIQUE,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
)
CREATE TABLE country_administrative_divisions_levels
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    name        character varying(100) NOT NULL UNIQUE,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
)

CREATE TABLE country_administrative_divisions
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    code        character varying(20)  NOT NULL UNIQUE,
    country_id  INT                    NOT NULL REFERENCES countries (id),
    type_id     INT                    NOT NULL REFERENCES country_administrative_divisions_types (id),
    level_id    INT                    NOT NULL REFERENCES country_administrative_divisions_levels (id),
    parent_id   INT REFERENCES country_administrative_divisions (id),
    name        character varying(150) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    CONSTRAINT country_administrative_divisions_unique_code UNIQUE (code, country_id, type_id, level_id)
);


CREATE TABLE cities
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    country_id  INT                    NOT NULL REFERENCES countries (id),
    state_id    INT REFERENCES country_administrative_divisions (id),
    name        character varying(150) NOT NULL,
    latitude    NUMERIC(10, 8),
    longitude   NUMERIC(11, 8),
    timezone_id INT REFERENCES timezones (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE localities
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    country_id  INT                    NOT NULL REFERENCES countries (id),
    state_id    INT REFERENCES country_administrative_divisions (id),
    city_id     INT                    NOT NULL REFERENCES cities (id),
    latitude    NUMERIC(10, 8),
    longitude   NUMERIC(11, 8),
    name        character varying(150) NOT NULL,
    timezone_id INT REFERENCES timezones (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE postal_codes
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    country_id  INT                    NOT NULL REFERENCES countries (id),
    city_id     INT REFERENCES cities (id),
    locality_id INT REFERENCES localities (id),
    postal_code character varying(20)  NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE address_types
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    type_key      character varying(50)  NOT NULL UNIQUE,
    label         character varying(100) NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE country_calling_codes
(
    id           SERIAL PRIMARY KEY,
    internal_id  character varying(200) NOT NULL UNIQUE, ,
    country_id   INT                    NOT NULL REFERENCES countries (id),
    calling_code character varying(10)  NOT NULL,
    status       character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by   BIGINT,
    updated_by   BIGINT,
    version      INT                    NOT NULL DEFAULT 1
);


-- ============================================================
-- DOMAIN 2: LANGUAGE AND LOCALE  (master → SERIAL)
-- ============================================================

CREATE TABLE languages
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    language_code character varying(10)  NOT NULL UNIQUE,
    name          character varying(100) NOT NULL,
    native_name   character varying(100) NOT NULL,
    direction     character varying(3)   NOT NULL DEFAULT 'ltr' CHECK (direction IN ('ltr', 'rtl')),
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE locales
(
    id                SERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    locale_code       character varying(20)  NOT NULL UNIQUE,
    language_id       INT                    NOT NULL REFERENCES languages (id),
    country_id        INT REFERENCES countries (id),
    date_format       character varying(30)  NOT NULL DEFAULT 'DD/MM/YYYY',
    time_format       character varying(3)   NOT NULL DEFAULT '12h' CHECK (time_format IN ('12h', '24h')),
    first_day_of_week SMALLINT               NOT NULL DEFAULT 1 CHECK (first_day_of_week BETWEEN 0 AND 6),
    is_active         BOOLEAN                NOT NULL DEFAULT TRUE,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);

CREATE TABLE currencies
(
    id              SERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    currency_code   character varying(10)  NOT NULL UNIQUE,
    name            character varying(100) NOT NULL,
    symbol          character varying(10)  NOT NULL,
    symbol_position character varying(6)   NOT NULL DEFAULT 'before' CHECK (symbol_position IN ('before', 'after')),
    decimal_places  SMALLINT               NOT NULL DEFAULT 2,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE country_currency_mappings
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    country_id  INT                    NOT NULL REFERENCES countries (id),
    currency_id INT                    NOT NULL REFERENCES currencies (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    unique (country_id, currency_id)
)

CREATE TABLE currency_exchange_rates
(
    id               SERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    from_currency_id INT                    NOT NULL REFERENCES currencies (id),
    to_currency_id   INT                    NOT NULL REFERENCES currencies (id),
    rate             NUMERIC(18, 8)         NOT NULL,
    effective_date   DATE                   NOT NULL,
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);

