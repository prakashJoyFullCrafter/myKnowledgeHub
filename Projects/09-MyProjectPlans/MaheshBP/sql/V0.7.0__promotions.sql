CREATE TABLE promotion_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    type_key    character varying(50)  NOT NULL UNIQUE,
    name        character varying(150) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE campaign_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    type_key    character varying(50)  NOT NULL UNIQUE,
    name        character varying(150) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);

CREATE TABLE loyalty_transaction_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    type_key    character varying(30)  NOT NULL UNIQUE,
    name        character varying(100) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);
CREATE TABLE wallet_transaction_types
(
    id          SERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    type_key    character varying(30)  NOT NULL UNIQUE,
    name        character varying(100) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);
CREATE TABLE promotions
(
    id                BIGSERIAL PRIMARY KEY,
    internal_id       character varying(200) NOT NULL UNIQUE,
    tenant_id         BIGINT                 NOT NULL REFERENCES tenants (id),
    branch_id         BIGINT REFERENCES branches (id),
    promotion_type_id INT                    NOT NULL REFERENCES promotion_types (id),
    name              character varying(200) NOT NULL,
    description       TEXT,
    discount_value    NUMERIC(12, 2),
    discount_type     character varying(10) CHECK (discount_type IN ('flat', 'percent')),
    min_booking_value NUMERIC(12, 2),
    valid_from        TIMESTAMPTZ,
    valid_until       TIMESTAMPTZ,
    usage_limit       INT,
    usage_count       INT                    NOT NULL DEFAULT 0,
    status            character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by        BIGINT,
    updated_by        BIGINT,
    version           INT                    NOT NULL DEFAULT 1
);
CREATE TABLE promo_codes
(
    id           BIGSERIAL PRIMARY KEY,
    internal_id  character varying(200) NOT NULL UNIQUE,
    promotion_id BIGINT                 NOT NULL REFERENCES promotions (id),
    code         character varying(50)  NOT NULL UNIQUE,
    usage_limit  INT,
    usage_count  INT                    NOT NULL DEFAULT 0,
    status       character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by   BIGINT,
    updated_by   BIGINT,
    version      INT                    NOT NULL DEFAULT 1
);

CREATE TABLE promo_redemptions
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    promo_code_id    BIGINT                 NOT NULL REFERENCES promo_codes (id),
    appointment_id   BIGINT                 NOT NULL REFERENCES appointments (id),
    customer_id      BIGINT                 NOT NULL REFERENCES users (id),
    discount_applied NUMERIC(12, 2)         NOT NULL,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE campaigns
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    campaign_type_id INT                    NOT NULL REFERENCES campaign_types (id),
    name             character varying(200) NOT NULL,
    description      TEXT,
    start_date       DATE,
    end_date         DATE,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);

CREATE TABLE referrals
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    referrer_id     BIGINT                 NOT NULL REFERENCES users (id),
    referred_id     BIGINT                 NOT NULL REFERENCES users (id),
    tenant_id       BIGINT                 NOT NULL REFERENCES tenants (id),
    referral_status character varying(20)  NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'qualified', 'rewarded', 'expired')),
    reward_amount   NUMERIC(12, 2),
    qualified_at    TIMESTAMPTZ,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1

);

CREATE TABLE membership_plans
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    name             character varying(150) NOT NULL,
    description      TEXT,
    price            NUMERIC(12, 2)         NOT NULL,
    billing_interval character varying(10)  NOT NULL DEFAULT 'monthly'
        CHECK (billing_interval IN ('monthly', 'annually')),
    currency_id      INT                    NOT NULL REFERENCES currencies (id),
    benefits         JSONB                  NOT NULL DEFAULT '{}',
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);
);

CREATE TABLE memberships
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    name        character varying(150) NOT NULL,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);
);

CREATE TABLE customer_memberships
(
    id                 BIGSERIAL PRIMARY KEY,
    internal_id        character varying(200) NOT NULL UNIQUE,
    customer_id        BIGINT                 NOT NULL REFERENCES users (id),
    membership_plan_id BIGINT                 NOT NULL REFERENCES membership_plans (id),
    status             character varying(20)  NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'expired', 'cancelled', 'suspended')),
    started_at         DATE                   NOT NULL,
    expires_at         DATE,
    status             character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by         BIGINT,
    updated_by         BIGINT,
    version            INT                    NOT NULL DEFAULT 1
);
);

CREATE TABLE loyalty_accounts
(
    id              BIGSERIAL PRIMARY KEY,
    internal_id     character varying(200) NOT NULL UNIQUE,
    customer_id     BIGINT                 NOT NULL REFERENCES users (id),
    tenant_id       BIGINT                 NOT NULL REFERENCES tenants (id),
    points_balance  INT                    NOT NULL DEFAULT 0,
    lifetime_points INT                    NOT NULL DEFAULT 0,
    status          character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,
    version         INT                    NOT NULL DEFAULT 1
);
,
    UNIQUE (customer_id, tenant_id)
);

CREATE TABLE loyalty_transactions
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    loyalty_account_id  BIGINT                 NOT NULL REFERENCES loyalty_accounts (id),
    transaction_type_id INT                    NOT NULL REFERENCES loyalty_transaction_types (id),
    points              INT                    NOT NULL,
    reference_type      character varying(30),
    reference_id        BIGINT,
    expires_at          TIMESTAMPTZ,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE wallets
(
    id          BIGSERIAL PRIMARY KEY,
    internal_id character varying(200) NOT NULL UNIQUE,
    customer_id BIGINT                 NOT NULL REFERENCES users (id),
    tenant_id   BIGINT                 NOT NULL REFERENCES tenants (id),
    currency_id INT                    NOT NULL REFERENCES currencies (id),
    balance     NUMERIC(12, 2)         NOT NULL DEFAULT 0,
    status      character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by  BIGINT,
    updated_by  BIGINT,
    version     INT                    NOT NULL DEFAULT 1
);
CREATE TABLE wallet_transactions
(
    id                  BIGSERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    wallet_id           BIGINT                 NOT NULL REFERENCES wallets (id),
    transaction_type_id INT                    NOT NULL REFERENCES wallet_transaction_types (id),
    amount              NUMERIC(12, 2)         NOT NULL,
    reference_type      character varying(30),
    reference_id        BIGINT,
    description         TEXT,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

CREATE TABLE gift_cards
(
    id               BIGSERIAL PRIMARY KEY,
    internal_id      character varying(200) NOT NULL UNIQUE,
    tenant_id        BIGINT                 NOT NULL REFERENCES tenants (id),
    code             character varying(50)  NOT NULL UNIQUE,
    currency_id      INT                    NOT NULL REFERENCES currencies (id),
    initial_value    NUMERIC(12, 2)         NOT NULL,
    remaining_value  NUMERIC(12, 2)         NOT NULL,
    purchased_by     BIGINT REFERENCES users (id),
    redeemed_by      BIGINT REFERENCES users (id),
    gift_card_status character varying(20)  NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'redeemed', 'expired', 'cancelled')),
    expires_at       DATE,
    status           character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by       BIGINT,
    updated_by       BIGINT,
    version          INT                    NOT NULL DEFAULT 1
);