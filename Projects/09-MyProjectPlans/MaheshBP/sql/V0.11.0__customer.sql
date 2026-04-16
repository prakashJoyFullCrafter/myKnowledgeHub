-- ============================================================
-- DOMAIN 11: CUSTOMER ENGAGEMENT
-- ============================================================

CREATE TABLE favorites
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    user_id     BIGINT                 NOT NULL REFERENCES users (id),
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
        UNIQUE (user_id, branch_id)
);

CREATE TABLE reviews
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    appointment_id     BIGINT                 NOT NULL UNIQUE REFERENCES appointments (id),
    customer_id        BIGINT                 NOT NULL REFERENCES users (id),
    branch_id          BIGINT                 NOT NULL REFERENCES branches (id),
    staff_id           BIGINT REFERENCES staff (id),
    overall_rating     SMALLINT               NOT NULL CHECK (overall_rating BETWEEN 1 AND 5),
    cleanliness_rating SMALLINT CHECK (cleanliness_rating BETWEEN 1 AND 5),
    staff_rating       SMALLINT CHECK (staff_rating BETWEEN 1 AND 5),
    value_rating       SMALLINT CHECK (value_rating BETWEEN 1 AND 5),
    review_text        TEXT,
    is_published       BOOLEAN                NOT NULL DEFAULT FALSE,
    moderated_at       TIMESTAMPTZ,
    moderated_by       BIGINT REFERENCES users (id),
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
);

CREATE TABLE review_replies
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    review_id   BIGINT                 NOT NULL UNIQUE REFERENCES reviews (id),
    replied_by  BIGINT                 NOT NULL REFERENCES users (id),
    reply_text  TEXT                   NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE ratings_summary
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    branch_id           BIGINT                 NOT NULL UNIQUE REFERENCES branches (id),
    total_reviews       INT                    NOT NULL DEFAULT 0,
    average_overall     NUMERIC(3, 2)          NOT NULL DEFAULT 0,
    average_cleanliness NUMERIC(3, 2),
    average_staff       NUMERIC(3, 2),
    average_value       NUMERIC(3, 2),
    last_updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE customer_notes
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    customer_id BIGINT                 NOT NULL REFERENCES users (id),
    note        TEXT                   NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE customer_tags
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    customer_id BIGINT                 NOT NULL REFERENCES users (id),
    tag         character varying(50)            NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_id, customer_id, tag)
);

