set
search_path to core;


CREATE TABLE staff_commissions
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    staff_id          BIGINT                 NOT NULL REFERENCES security.tenant_staff_users  (id),
    branch_service_id BIGINT REFERENCES branch_services (id),
    commission_type   character varying(10)  NOT NULL DEFAULT 'percent'
        CHECK (commission_type IN ('percent', 'flat')),
    commission_value  NUMERIC(8, 4)          NOT NULL,
    valid_from        DATE,
    valid_until       DATE,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);
