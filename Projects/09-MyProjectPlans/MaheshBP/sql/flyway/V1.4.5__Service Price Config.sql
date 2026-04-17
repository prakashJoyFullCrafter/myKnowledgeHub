set
search_path to core;

CREATE TABLE service_price_rules
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200)   NOT NULL UNIQUE,
    tenant_id          BIGINT         NOT NULL REFERENCES tenants (id),
    pricing_scope_id   INT            NOT NULL REFERENCES m_pricing_scope (id),
    business_id        BIGINT REFERENCES businesses (id),
    branch_id          BIGINT REFERENCES branches (id),
    service_id         BIGINT REFERENCES service_master (id),
    service_variant_id BIGINT REFERENCES service_variants (id),
    service_addon_id   BIGINT REFERENCES service_addons (id),
    business_tier_id   INT REFERENCES m_business_tier (id),
    customer_tier_id   INT REFERENCES m_customer_tier (id),
    price              NUMERIC(12, 2) NOT NULL,
    currency_id        INT            NOT NULL REFERENCES m_currency (id),
    valid_from         DATE           NOT NULL DEFAULT CURRENT_DATE,
    valid_until        DATE, -- NULL = open-ended
    priority           INT            NOT NULL DEFAULT 0,
    status             VARCHAR(1)     NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT            NOT NULL DEFAULT 1,
    CONSTRAINT chk_spr_one_target CHECK (
        (service_id IS NOT NULL):: int
        + (service_variant_id IS NOT NULL):: int
        + (service_addon_id IS NOT NULL):: int = 1
) ,

    -- Scope reference columns must match the scope
    CONSTRAINT chk_spr_scope_refs CHECK (
        (pricing_scope_id = 1 AND business_tier_id IS NULL AND business_id IS NULL AND branch_id IS NULL)  -- TENANT
     OR (pricing_scope_id = 2 AND business_tier_id IS NOT NULL AND business_id IS NULL AND branch_id IS NULL) -- BUSINESS_TIER
     OR (pricing_scope_id = 3 AND business_id IS NOT NULL AND business_tier_id IS NULL AND branch_id IS NULL) -- BUSINESS
     OR (pricing_scope_id = 4 AND branch_id IS NOT NULL AND business_tier_id IS NULL AND business_id IS NULL) -- BRANCH
    )
);
CREATE INDEX idx_spr_resolve ON service_price_rules
    (tenant_id, service_id, pricing_scope_id, customer_tier_id, valid_from, valid_until) WHERE status = 'A';
CREATE INDEX idx_spr_resolve_variant ON service_price_rules
    (tenant_id, service_variant_id, pricing_scope_id, customer_tier_id, valid_from,
     valid_until) WHERE status = 'A' AND service_variant_id IS NOT NULL;
CREATE INDEX idx_spr_branch ON service_price_rules (branch_id) WHERE branch_id IS NOT NULL;
CREATE INDEX idx_spr_business ON service_price_rules (business_id) WHERE business_id IS NOT NULL;
CREATE INDEX idx_spr_bustier ON service_price_rules (business_tier_id) WHERE business_tier_id IS NOT NULL;