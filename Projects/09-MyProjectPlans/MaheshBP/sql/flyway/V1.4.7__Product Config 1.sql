set
search_path to core;

CREATE TABLE suppliers
(
    id             BIGSERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    tenant_id      BIGINT                 NOT NULL REFERENCES tenants (id),
    code           character varying(50)  NOT NULL,
    name           character varying(200) NOT NULL,
    contact_person character varying(150),
    phone          character varying(30),
    email          character varying(150),
    address_line1  character varying(255),
    address_line2  character varying(255),
    city_id        INT REFERENCES m_city (id),
    country_id     INT REFERENCES m_country (id),
    tax_reg_no     character varying(50),
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, code)
);
CREATE INDEX idx_suppliers_tenant ON suppliers (tenant_id) WHERE status = 'A';

CREATE TABLE product_master
(
    id                  BIGINT REFERENCES item_master (id) PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    item_code           character varying(25)  NOT NULL UNIQUE,
    tenant_id           BIGINT                 NOT NULL REFERENCES tenants (id),
    category_id         INT REFERENCES m_product_category (id),
    default_supplier_id BIGINT REFERENCES suppliers (id),
    default_uom_id      INT                    NOT NULL REFERENCES m_uom (id),
    brand               character varying(100),
    name                character varying(200) NOT NULL,
    description         TEXT,
    sku                 character varying(80),
    hsn_code            character varying(30),
    -- Classification
    is_retail           BOOLEAN                NOT NULL DEFAULT TRUE,  -- can be sold to customer
    is_consumable       BOOLEAN                NOT NULL DEFAULT FALSE, -- consumed during service
    is_stock_tracked    BOOLEAN                NOT NULL DEFAULT TRUE,
    is_serialized       BOOLEAN                NOT NULL DEFAULT FALSE,
    -- Default pricing
    cost_price          NUMERIC(12, 2),
    base_price          NUMERIC(12, 2),
    mrp                 NUMERIC(12, 2),
    currency_id         INT REFERENCES m_currency (id),
    -- Stock thresholds (defaults; can be overridden at branch)
    reorder_level       NUMERIC(12, 3),
    reorder_quantity    NUMERIC(12, 3),
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1,
    CHECK (cost_price IS NULL OR cost_price >= 0),
    CHECK (base_price IS NULL OR base_price >= 0),
    CHECK (mrp IS NULL OR mrp >= 0)
);
CREATE INDEX idx_product_master_tenant ON product_master (tenant_id) WHERE status = 'A';
CREATE INDEX idx_product_master_category ON product_master (category_id) WHERE status = 'A';

CREATE TABLE product_variants
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    product_id  BIGINT                 NOT NULL REFERENCES product_master (id) ON DELETE CASCADE,
    variant_sku character varying(80),
    name        character varying(200) NOT NULL,
    attributes  JSONB                  NOT NULL DEFAULT '{}'::jsonb,
    -- Variant-level pricing override (null = use product_master)
    cost_price  NUMERIC(12, 2),
    base_price  NUMERIC(12, 2),
    mrp         NUMERIC(12, 2),
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);
CREATE INDEX idx_product_variants_product ON product_variants (product_id) WHERE status = 'A';


CREATE TABLE product_barcodes
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES tenants (id),
    product_id         BIGINT                 NOT NULL REFERENCES product_master (id) ON DELETE CASCADE,
    product_variant_id BIGINT REFERENCES product_variants (id) ON DELETE CASCADE,
    barcode            character varying(100) NOT NULL,
    barcode_type       character varying(30)  NOT NULL DEFAULT 'EAN13'
        CHECK (barcode_type IN ('EAN13', 'EAN8', 'UPC_A', 'UPC_E', 'CODE128', 'CODE39', 'QR', 'CUSTOM')),
    is_primary         BOOLEAN                NOT NULL DEFAULT FALSE,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1,
    UNIQUE (tenant_id, barcode)
);
CREATE INDEX idx_product_barcodes_product ON product_barcodes (product_id);

CREATE TABLE product_media
(
    id            BIGSERIAL PRIMARY KEY,
    internal_id   character varying(200) NOT NULL UNIQUE,
    tenant_id     BIGINT                 NOT NULL REFERENCES tenants (id),
    product_id    BIGINT                 NOT NULL REFERENCES product_master (id) ON DELETE CASCADE,
    media_type_id INT                    NOT NULL REFERENCES m_media_type (id),
    url           TEXT                   NOT NULL,
    alt_text      character varying(255),
    is_primary    BOOLEAN                NOT NULL DEFAULT FALSE,
    display_order INT                    NOT NULL DEFAULT 0,
    status        character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by    BIGINT,
    updated_by    BIGINT,
    version       INT                    NOT NULL DEFAULT 1
);


CREATE TABLE product_price_rules
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        VARCHAR(200)   NOT NULL UNIQUE,
    tenant_id          BIGINT         NOT NULL REFERENCES tenants (id),
    pricing_scope_id   INT            NOT NULL REFERENCES m_pricing_scope (id),
    business_id        BIGINT REFERENCES businesses (id),
    branch_id          BIGINT REFERENCES branches (id),
    product_id         BIGINT REFERENCES product_master (id),
    product_variant_id BIGINT REFERENCES product_variants (id),
    customer_tier_id   INT REFERENCES m_customer_tier (id),
    price              NUMERIC(12, 2) NOT NULL,
    currency_id        INT            NOT NULL REFERENCES m_currency (id),
    valid_from         DATE           NOT NULL DEFAULT CURRENT_DATE,
    valid_until        DATE,
    priority           INT            NOT NULL DEFAULT 0,
    status             VARCHAR(1)     NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT            NOT NULL DEFAULT 1,
    CONSTRAINT chk_ppr_one_target CHECK (
        (product_id IS NOT NULL)::int
        + (product_variant_id IS NOT NULL)::int = 1
)
    );
CREATE INDEX idx_ppr_resolve ON product_price_rules
    (tenant_id, product_id, pricing_scope_id, customer_tier_id, valid_from, valid_until)
    WHERE status = 'A';

CREATE TABLE branch_products
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    tenant_id          BIGINT                 NOT NULL REFERENCES tenants (id),
    business_id        BIGINT                 NOT NULL REFERENCES businesses (id),
    branch_id          BIGINT                 NOT NULL REFERENCES branches (id),
    product_id         BIGINT                 NOT NULL REFERENCES product_master (id),
    is_sellable        BOOLEAN                NOT NULL DEFAULT TRUE,
    -- Branch-specific reorder levels (override product defaults)
    reorder_level      NUMERIC(12, 3),
    reorder_quantity   NUMERIC(12, 3),
    -- Branch-specific price override
    price_override     NUMERIC(12, 2),
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1,
    UNIQUE (branch_id, product_id)
);
CREATE INDEX idx_branch_products_branch ON branch_products (branch_id) WHERE status = 'A';