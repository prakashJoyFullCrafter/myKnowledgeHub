-- ============================================================
-- DOMAIN 13: COMMERCIAL AND SETTLEMENT
-- ============================================================

CREATE TABLE placement_products
(
    id             SERIAL PRIMARY KEY,
    internal_id    character varying(200) NOT NULL UNIQUE,
    placement_type character varying(50)            NOT NULL,
    name           character varying(150)           NOT NULL,
    description    TEXT,
    duration_days  INT                    NOT NULL,
    price          NUMERIC(12, 2)         NOT NULL,
    currency_id    INT                    NOT NULL REFERENCES currencies (id),
    is_active      BOOLEAN                NOT NULL DEFAULT TRUE,
    display_order  INT                    NOT NULL DEFAULT 0,
    status         character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by     BIGINT,
    updated_by     BIGINT,
    version        INT                    NOT NULL DEFAULT 1
);

CREATE TABLE commission_rules
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    tenant_id       BIGINT REFERENCES tenants (id),
    fee_type        character varying(30)            NOT NULL
        CHECK (fee_type IN ('booking', 'cancellation_fee', 'no_show_fee', 'placement')),
    rate            NUMERIC(6, 4)          NOT NULL,
    effective_from  DATE,
    effective_until DATE,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE platform_fee_charges
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    tenant_id       BIGINT                 NOT NULL REFERENCES tenants (id),
    appointment_id  BIGINT REFERENCES appointments (id),
    payment_id      BIGINT REFERENCES payments (id),
    fee_type        character varying(30)            NOT NULL,
    gross_amount    NUMERIC(12, 2)         NOT NULL,
    commission_rate NUMERIC(6, 4)          NOT NULL,
    fee_amount      NUMERIC(12, 2)         NOT NULL,
    currency_id     INT                    NOT NULL REFERENCES currencies (id),
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);

CREATE TABLE promotion_placement_orders
(
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    tenant_id            BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id            BIGINT REFERENCES branches (id),
    service_id           BIGINT REFERENCES services (id),
    placement_product_id INT                    NOT NULL REFERENCES placement_products (id),
    amount_paid          NUMERIC(12, 2)         NOT NULL,
    currency_id          INT                    NOT NULL REFERENCES currencies (id),
    start_date           DATE                   NOT NULL,
    end_date             DATE                   NOT NULL,
    ppo_status           character varying(20)            NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'active', 'completed', 'cancelled')),
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1
);

CREATE TABLE settlements
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    period_start      DATE                   NOT NULL,
    period_end        DATE                   NOT NULL,
    currency_id       INT                    NOT NULL REFERENCES currencies (id),
    gross_amount      NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    commission_total  NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    refunds_total     NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    disputes_held     NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    net_amount        NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    settlement_status character varying(20)            NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'under_review', 'approved', 'paid', 'failed')),
    approved_by       BIGINT REFERENCES users (id),
    approved_at       TIMESTAMPTZ,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);

CREATE TABLE settlement_items
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    settlement_id    BIGINT                 NOT NULL REFERENCES settlements (id),
    reference_type   character varying(30)            NOT NULL
        CHECK (reference_type IN
               ('appointment', 'refund', 'cancellation_fee', 'no_show_fee', 'placement', 'adjustment')),
    reference_id     BIGINT                 NOT NULL,
    gross_amount     NUMERIC(12, 2)         NOT NULL,
    deduction_amount NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    net_amount       NUMERIC(12, 2)         NOT NULL,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE payout_batches
(
    id                    BIGSERIAL PRIMARY KEY,
    internal_id           character varying(200) NOT NULL UNIQUE,
    settlement_ids        JSONB                  NOT NULL DEFAULT '[]',
    provider_batch_id     character varying(255),
    payout_batches_status character varying(20)            NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'initiated', 'confirmed', 'failed')),
    total_amount          NUMERIC(12, 2)         NOT NULL,
    currency_id           INT                    NOT NULL REFERENCES currencies (id),
    initiated_at          TIMESTAMPTZ,
    confirmed_at          TIMESTAMPTZ,
    status                character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by            BIGINT,
    updated_by            BIGINT,
    version               INT                    NOT NULL DEFAULT 1
);

CREATE TABLE merchant_subscriptions
(
    id                   BIGSERIAL PRIMARY KEY,
    internal_id          character varying(200) NOT NULL UNIQUE,
    tenant_id            BIGINT                 NOT NULL REFERENCES tenants (id),
    plan_id              INT                    NOT NULL REFERENCES subscription_plans (id),
    status               character varying(30)            NOT NULL DEFAULT 'trial'
        CHECK (status IN ('trial', 'active', 'grace', 'suspended', 'cancelled', 'expired')),
    billing_interval     character varying(10)            NOT NULL DEFAULT 'monthly'
        CHECK (billing_interval IN ('monthly', 'annually')),
    current_period_start DATE                   NOT NULL,
    current_period_end   DATE                   NOT NULL,
    trial_ends_at        TIMESTAMPTZ,
    cancelled_at         TIMESTAMPTZ,
    status               character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by           BIGINT,
    updated_by           BIGINT,
    version              INT                    NOT NULL DEFAULT 1
);

