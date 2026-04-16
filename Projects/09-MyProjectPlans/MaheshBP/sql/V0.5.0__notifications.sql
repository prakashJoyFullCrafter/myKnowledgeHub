CREATE TABLE communication_channels
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    channel_key VARCHAR(30)            NOT NULL UNIQUE,
    label       VARCHAR(100)           NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE notification_types
(
    id                       SERIAL PRIMARY KEY,
    internal_id              character varying(200) NOT NULL UNIQUE,
    type_key                 VARCHAR(100)           NOT NULL UNIQUE,
    label                    VARCHAR(150)           NOT NULL,
    trigger_event            VARCHAR(100),
    default_channel_key      VARCHAR(30),
    is_customer_configurable BOOLEAN                NOT NULL DEFAULT TRUE,
    status                   character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at               TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by               BIGINT,
    updated_by               BIGINT,
    version                  INT                    NOT NULL DEFAULT 1
);

CREATE TABLE notification_preference_options
(
    id                   SERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    notification_type_id INT                    NOT NULL REFERENCES notification_types (id),
    channel_id           INT                    NOT NULL REFERENCES communication_channels (id),
    default_enabled      BOOLEAN                NOT NULL DEFAULT TRUE,
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1,
    UNIQUE (notification_type_id, channel_id)
);

CREATE TABLE notification_templates
(
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    notification_type_id INT                    NOT NULL REFERENCES notification_types (id),
    channel_id           INT                    NOT NULL REFERENCES communication_channels (id),
    language_id          INT                    NOT NULL REFERENCES languages (id),
    tenant_id            BIGINT REFERENCES tenants (id),
    subject              VARCHAR(255),
    body                 TEXT                   NOT NULL,
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1
);

CREATE TABLE notification_template_translations
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    template_id BIGINT                 NOT NULL REFERENCES notification_templates (id),
    language_id INT                    NOT NULL REFERENCES languages (id),
    subject     VARCHAR(255),
    body        TEXT                   NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (template_id, language_id)
);

CREATE TABLE notifications
(
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    tenant_id            BIGINT REFERENCES tenants (id),
    user_id              BIGINT                 NOT NULL REFERENCES users (id),
    notification_type_id INT REFERENCES notification_types (id),
    channel_id           INT                    NOT NULL REFERENCES communication_channels (id),
    title                VARCHAR(255),
    body                 TEXT                   NOT NULL,
    reference_type       VARCHAR(50),
    reference_id         BIGINT,
    is_read              BOOLEAN                NOT NULL DEFAULT FALSE,
    read_at              TIMESTAMPTZ,
    scheduled_at         TIMESTAMPTZ,
    sent_at              TIMESTAMPTZ,
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1
);

CREATE TABLE notification_logs
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    notification_id     BIGINT                 NOT NULL REFERENCES notifications (id),
    status              VARCHAR(20)            NOT NULL
        CHECK (status IN ('queued', 'sent', 'delivered', 'failed', 'bounced')),
    provider_message_id VARCHAR(255),
    error_message       TEXT,
    attempted_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE in_app_messages
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    user_id     BIGINT                 NOT NULL REFERENCES users (id),
    title       VARCHAR(255)           NOT NULL,
    body        TEXT                   NOT NULL,
    action_url  TEXT,
    is_read     BOOLEAN                NOT NULL DEFAULT FALSE,
    read_at     TIMESTAMPTZ,
    expires_at  TIMESTAMPTZ,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

