set
search_path to core;


CREATE TABLE businesses
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    tenant_id             BIGINT                 NOT NULL REFERENCES tenants (id),
    business_type_id      INT                    NOT NULL REFERENCES m_business_type (id),
    registered_country_id INT                    NOT NULL REFERENCES m_country (id),
    preferred_locale_id   INT REFERENCES m_locale (id),
    business_tier_id      INT NOT NULL REFERENCES m_business_tier (id),
    name                  character varying(200) NOT NULL,
    legal_name            character varying(200),
    description           TEXT,
    logo_url              TEXT,
    website_url           TEXT,
    deleted_at            TIMESTAMPTZ,
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, name)
);
