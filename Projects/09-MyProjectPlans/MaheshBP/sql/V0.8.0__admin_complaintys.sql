-- ============================================================
-- DOMAIN 15: ADMIN AND COMPLIANCE
-- ============================================================

CREATE TABLE verification_statuses
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(50)            NOT NULL UNIQUE,
    label         character varying(100)           NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE kyc_document_types
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    type_key      character varying(50)            NOT NULL UNIQUE,
    label         character varying(150)           NOT NULL,
    required_for  character varying(20)            NOT NULL CHECK (required_for IN ('individual', 'business', 'both')),
    is_required   BOOLEAN                NOT NULL DEFAULT TRUE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE merchant_suspension_reasons
(
    id                  SERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    reason_key          character varying(50)            NOT NULL UNIQUE,
    label               character varying(150)           NOT NULL,
    is_system_generated BOOLEAN                NOT NULL DEFAULT FALSE,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE dispute_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    type_key    character varying(50)            NOT NULL UNIQUE,
    label       character varying(150)           NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE dispute_statuses
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(30)            NOT NULL UNIQUE,
    label         character varying(100)           NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE complaint_categories
(
    id               SERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    category_key     character varying(50)            NOT NULL UNIQUE,
    label            character varying(150)           NOT NULL,
    escalation_level SMALLINT               NOT NULL DEFAULT 1,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE support_ticket_statuses
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    status_key    character varying(30)            NOT NULL UNIQUE,
    label         character varying(100)           NOT NULL,
    is_terminal   BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE support_ticket_priorities
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    priority_key  character varying(20)            NOT NULL UNIQUE,
    label         character varying(50)            NOT NULL,
    sla_hours     INT                    NOT NULL,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE system_event_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    event_key   character varying(100)           NOT NULL UNIQUE,
    label       character varying(150)           NOT NULL,
    domain      character varying(50),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE merchant_applications
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id      BIGINT REFERENCES businesses (id),
    status_id        INT                    NOT NULL REFERENCES verification_statuses (id),
    submitted_at     TIMESTAMPTZ,
    reviewed_by      BIGINT REFERENCES users (id),
    reviewed_at      TIMESTAMPTZ,
    rejection_reason TEXT,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE kyc_documents
(
    id                      BIGSERIAL PRIMARY KEY,
    internal_id             character varying(200) NOT NULL UNIQUE,
    merchant_application_id BIGINT                 NOT NULL REFERENCES merchant_applications (id),
    document_type_id        INT                    NOT NULL REFERENCES kyc_document_types (id),
    file_url                TEXT                   NOT NULL,
    status                  character varying(20)            NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'verified', 'rejected')),
    verified_by             BIGINT REFERENCES users (id),
    verified_at             TIMESTAMPTZ,
    rejection_reason        TEXT,
    status                  character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by              BIGINT,
    updated_by              BIGINT,
    version                 INT                    NOT NULL DEFAULT 1
);

CREATE TABLE verification_status_history
(
    id                      BIGSERIAL PRIMARY KEY,
    internal_id             character varying(200) NOT NULL UNIQUE,
    merchant_application_id BIGINT                 NOT NULL REFERENCES merchant_applications (id),
    status_id               INT                    NOT NULL REFERENCES verification_statuses (id),
    changed_by              BIGINT REFERENCES users (id),
    notes                   TEXT,
    status                  character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by              BIGINT,
    updated_by              BIGINT,
    version                 INT                    NOT NULL DEFAULT 1
);

CREATE TABLE disputes
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    tenant_id       BIGINT                 NOT NULL REFERENCES tenants (id),
    appointment_id  BIGINT REFERENCES appointments (id),
    raised_by       BIGINT                 NOT NULL REFERENCES users (id),
    dispute_type_id INT                    NOT NULL REFERENCES dispute_types (id),
    status_id       INT                    NOT NULL REFERENCES dispute_statuses (id),
    description     TEXT                   NOT NULL,
    resolution      TEXT,
    resolved_by     BIGINT REFERENCES users (id),
    resolved_at     TIMESTAMPTZ,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE complaints
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT REFERENCES tenants (id),
    raised_by   BIGINT                 NOT NULL REFERENCES users (id),
    category_id INT REFERENCES complaint_categories (id),
    subject     character varying(255)           NOT NULL,
    description TEXT                   NOT NULL,
    status      character varying(20)            NOT NULL DEFAULT 'open'
        CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
    resolved_by BIGINT REFERENCES users (id),
    resolved_at TIMESTAMPTZ,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE support_tickets
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT REFERENCES tenants (id),
    raised_by      BIGINT                 NOT NULL REFERENCES users (id),
    assigned_to    BIGINT REFERENCES users (id),
    status_id      INT                    NOT NULL REFERENCES support_ticket_statuses (id),
    priority_id    INT REFERENCES support_ticket_priorities (id),
    subject        character varying(255)           NOT NULL,
    description    TEXT                   NOT NULL,
    reference_type character varying(30),
    reference_id   BIGINT,
    resolved_at    TIMESTAMPTZ,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE audit_logs
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT REFERENCES tenants (id),
    actor_id      BIGINT REFERENCES users (id),
    event_type_id INT REFERENCES system_event_types (id),
    entity_type   character varying(50)            NOT NULL,
    entity_id     BIGINT                 NOT NULL,
    old_values    JSONB,
    new_values    JSONB,
    ip_address    INET,
    user_agent    TEXT,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE platform_settings
(
    id            SERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    setting_key   character varying(100)           NOT NULL UNIQUE,
    setting_value TEXT,
    description   TEXT,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);

CREATE TABLE platform_settings_translations
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    setting_key character varying(100)           NOT NULL,
    language_id INT                    NOT NULL REFERENCES languages (id),
    label       character varying(150)           NOT NULL,
    description TEXT,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (setting_key, language_id)
);

