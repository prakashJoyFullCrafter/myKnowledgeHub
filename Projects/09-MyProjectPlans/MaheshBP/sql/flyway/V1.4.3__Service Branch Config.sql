set
search_path to core;

CREATE TABLE branch_services
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id   BIGINT                 NOT NULL REFERENCES branches (id),
    service_id  BIGINT                 NOT NULL REFERENCES service_master (id),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_id, service_id)
);

