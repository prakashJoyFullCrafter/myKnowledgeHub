-- =========================================================
-- Tenant & Branch accounting provisioning
--
-- provision_tenant_accounts(tenant_id)
--   : creates the standard account_group tree + shared
--     (non-branch) ledgers (taxes, suspense, capital, etc.)
--
-- provision_branch_accounts(branch_id)
--   : creates branch-specific ledgers (sale, purchase, cash,
--     stock, discount, etc.) and wires them to daybook roles.
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- Helper: create or fetch an account_group
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.ensure_account_group(
    p_tenant_id        BIGINT,
    p_primary_group_key character varying,
    p_code             character varying,
    p_name             character varying,
    p_parent_group_id  BIGINT DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
    v_primary_group_id INT;
    v_group_id BIGINT;
BEGIN
    SELECT id INTO v_primary_group_id
      FROM m_account_primary_group
     WHERE group_key = p_primary_group_key;

    IF v_primary_group_id IS NULL THEN
        RAISE EXCEPTION 'Unknown primary group key: %', p_primary_group_key;
    END IF;

    SELECT id INTO v_group_id
      FROM account_group
     WHERE tenant_id = p_tenant_id AND code = p_code;

    IF v_group_id IS NULL THEN
        INSERT INTO account_group
            (internal_id, tenant_id, primary_group_id, parent_group_id,
             code, name, is_system, status, version)
        VALUES
            (CONCAT('AG-', p_tenant_id, '-', p_code),
             p_tenant_id, v_primary_group_id, p_parent_group_id,
             p_code, p_name, TRUE, 'A', 1)
        RETURNING id INTO v_group_id;
    END IF;

    RETURN v_group_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- Helper: create or fetch an account_master
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.ensure_account_master(
    p_tenant_id        BIGINT,
    p_code             character varying,
    p_name             character varying,
    p_group_id         BIGINT,
    p_ledger_type      character varying,
    p_currency_id      INT,
    p_branch_id        BIGINT DEFAULT NULL,
    p_payment_method_id INT DEFAULT NULL,
    p_tax_type_id      INT DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
    v_account_id BIGINT;
    v_nature_id  INT;
    v_primary_group_id INT;
BEGIN
    SELECT pg.nature_id, pg.id INTO v_nature_id, v_primary_group_id
      FROM account_group g
      JOIN m_account_primary_group pg ON pg.id = g.primary_group_id
     WHERE g.id = p_group_id;

    SELECT id INTO v_account_id
      FROM account_master
     WHERE tenant_id = p_tenant_id AND code = p_code;

    IF v_account_id IS NULL THEN
        INSERT INTO account_master
            (internal_id, tenant_id, account_group_id, branch_id,
             code, name, nature_id, primary_group_id, ledger_type,
             currency_id, payment_method_id, tax_type_id,
             is_system, allow_manual_posting, status, version)
        VALUES
            (CONCAT('ACM-', p_tenant_id, '-', p_code),
             p_tenant_id, p_group_id, p_branch_id,
             p_code, p_name, v_nature_id, v_primary_group_id, p_ledger_type,
             p_currency_id, p_payment_method_id, p_tax_type_id,
             TRUE, FALSE, 'A', 1)
        RETURNING id INTO v_account_id;
    END IF;

    RETURN v_account_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- Helper: map a daybook role to an account
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.ensure_daybook_account_map(
    p_tenant_id   BIGINT,
    p_branch_id   BIGINT,
    p_daybook_key character varying,
    p_role_key    character varying,
    p_account_id  BIGINT
) RETURNS VOID AS $$
DECLARE
    v_daybook_id INT;
BEGIN
    SELECT id INTO v_daybook_id FROM m_daybook WHERE daybook_key = p_daybook_key;
    IF v_daybook_id IS NULL THEN
        RAISE EXCEPTION 'Unknown daybook key: %', p_daybook_key;
    END IF;

    INSERT INTO daybook_account_map
        (internal_id, tenant_id, branch_id, daybook_id, role_key, account_id, status, version)
    VALUES
        (CONCAT('DBMAP-', p_tenant_id, '-', COALESCE(p_branch_id::text, 'ALL'), '-',
                p_daybook_key, '-', p_role_key),
         p_tenant_id, p_branch_id, v_daybook_id, p_role_key, p_account_id, 'A', 1)
    ON CONFLICT (tenant_id, branch_id, daybook_id, role_key) DO UPDATE
        SET account_id = EXCLUDED.account_id, updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- provision_tenant_accounts
-- Creates the standard account group tree and tenant-wide ledgers.
-- Call once when a tenant is created.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.provision_tenant_accounts(p_tenant_id BIGINT)
RETURNS VOID AS $$
DECLARE
    v_currency_id INT;
    -- Groups
    g_cash        BIGINT;
    g_bank        BIGINT;
    g_debtors     BIGINT;
    g_creditors   BIGINT;
    g_stock       BIGINT;
    g_sales       BIGINT;
    g_services    BIGINT;
    g_purchases   BIGINT;
    g_sales_ret   BIGINT;
    g_pur_ret     BIGINT;
    g_duties      BIGINT;
    g_discount_a  BIGINT;
    g_discount_r  BIGINT;
    g_commission  BIGINT;
    g_ind_exp     BIGINT;
    g_ind_inc     BIGINT;
    g_capital     BIGINT;
    g_suspense    BIGINT;
    -- Tenant-wide ledgers
    a_suspense    BIGINT;
    a_rounding_off BIGINT;
    a_tip_payable BIGINT;
BEGIN
    -- Pick tenant's default currency (from first business)
    SELECT registered_country_id INTO v_currency_id FROM businesses WHERE tenant_id = p_tenant_id LIMIT 1;
    SELECT cur.id INTO v_currency_id
      FROM m_currency cur
      JOIN map_country_currency mcc ON mcc.currency_id = cur.id
     WHERE mcc.country_id = (SELECT registered_country_id FROM businesses WHERE tenant_id = p_tenant_id LIMIT 1)
     LIMIT 1;
    IF v_currency_id IS NULL THEN
        SELECT id INTO v_currency_id FROM m_currency WHERE status = 'A' LIMIT 1;
    END IF;

    -- Account groups (standard set)
    g_cash       := ensure_account_group(p_tenant_id, 'CASH_IN_HAND',        'CASH_IN_HAND',       'Cash-in-Hand');
    g_bank       := ensure_account_group(p_tenant_id, 'BANK_ACCOUNTS',       'BANK_ACCOUNTS',      'Bank Accounts');
    g_debtors    := ensure_account_group(p_tenant_id, 'SUNDRY_DEBTORS',      'SUNDRY_DEBTORS',     'Sundry Debtors');
    g_creditors  := ensure_account_group(p_tenant_id, 'SUNDRY_CREDITORS',    'SUNDRY_CREDITORS',   'Sundry Creditors');
    g_stock      := ensure_account_group(p_tenant_id, 'STOCK_IN_HAND',       'STOCK_IN_HAND',      'Stock-in-Hand');
    g_sales      := ensure_account_group(p_tenant_id, 'SALES_ACCOUNTS',      'SALES_ACCOUNTS',     'Sales Accounts');
    g_services   := ensure_account_group(p_tenant_id, 'SERVICE_INCOME',      'SERVICE_INCOME',     'Service Income');
    g_purchases  := ensure_account_group(p_tenant_id, 'PURCHASE_ACCOUNTS',   'PURCHASE_ACCOUNTS',  'Purchase Accounts');
    g_sales_ret  := ensure_account_group(p_tenant_id, 'SALES_RETURNS',       'SALES_RETURNS',      'Sales Returns');
    g_pur_ret    := ensure_account_group(p_tenant_id, 'PURCHASE_RETURNS',    'PURCHASE_RETURNS',   'Purchase Returns');
    g_duties     := ensure_account_group(p_tenant_id, 'DUTIES_TAXES',        'DUTIES_TAXES',       'Duties & Taxes');
    g_discount_a := ensure_account_group(p_tenant_id, 'DISCOUNT_ALLOWED',    'DISCOUNT_ALLOWED',   'Discount Allowed');
    g_discount_r := ensure_account_group(p_tenant_id, 'DISCOUNT_RECEIVED',   'DISCOUNT_RECEIVED',  'Discount Received');
    g_commission := ensure_account_group(p_tenant_id, 'STAFF_COMMISSION',    'STAFF_COMMISSION',   'Staff Commission');
    g_ind_exp    := ensure_account_group(p_tenant_id, 'INDIRECT_EXPENSES',   'INDIRECT_EXPENSES',  'Indirect Expenses');
    g_ind_inc    := ensure_account_group(p_tenant_id, 'INDIRECT_INCOMES',    'INDIRECT_INCOMES',   'Indirect Incomes');
    g_capital    := ensure_account_group(p_tenant_id, 'CAPITAL_ACCOUNT',     'CAPITAL_ACCOUNT',    'Capital Account');
    g_suspense   := ensure_account_group(p_tenant_id, 'SUSPENSE_ACCOUNTS',   'SUSPENSE_ACCOUNTS',  'Suspense Accounts');

    -- Tenant-wide ledgers (not branch-specific)
    a_suspense     := ensure_account_master(p_tenant_id, 'SUSPENSE',       'Suspense Account',
                          g_suspense, 'GENERAL', v_currency_id);
    a_rounding_off := ensure_account_master(p_tenant_id, 'ROUNDING_OFF',   'Rounding Off',
                          g_ind_exp,  'ROUNDING', v_currency_id);
    a_tip_payable  := ensure_account_master(p_tenant_id, 'TIP_PAYABLE',    'Tips Payable to Staff',
                          g_ind_exp,  'TIP', v_currency_id);

    -- Tax ledgers: one per active tax_type/tax_rate combination
    -- (Application will call this after tax_rates are seeded for the tenant.)
    -- Basic output/input tax ledger stubs:
    PERFORM ensure_account_master(p_tenant_id, 'OUTPUT_TAX', 'Output Tax',
              g_duties, 'TAX_OUTPUT', v_currency_id, NULL, NULL, NULL);
    PERFORM ensure_account_master(p_tenant_id, 'INPUT_TAX',  'Input Tax',
              g_duties, 'TAX_INPUT', v_currency_id, NULL, NULL, NULL);
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------
-- provision_branch_accounts
-- Creates branch-specific ledgers and wires them to daybook roles.
-- Call when a branch is added.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION core.provision_branch_accounts(p_branch_id BIGINT)
RETURNS VOID AS $$
DECLARE
    v_tenant_id   BIGINT;
    v_business_id BIGINT;
    v_branch_code character varying;
    v_currency_id INT;
    -- Groups
    g_cash       BIGINT;
    g_sales      BIGINT;
    g_services   BIGINT;
    g_purchases  BIGINT;
    g_sales_ret  BIGINT;
    g_pur_ret    BIGINT;
    g_stock      BIGINT;
    g_discount_a BIGINT;
    g_commission BIGINT;
    -- Ledgers
    a_cash       BIGINT;
    a_sales      BIGINT;
    a_services   BIGINT;
    a_purchases  BIGINT;
    a_sales_ret  BIGINT;
    a_pur_ret    BIGINT;
    a_stock      BIGINT;
    a_discount   BIGINT;
    a_commission BIGINT;
    a_output_tax BIGINT;
    a_input_tax  BIGINT;
    a_rounding   BIGINT;
    a_tip        BIGINT;
BEGIN
    SELECT b.tenant_id, b.business_id,
           COALESCE(NULLIF(b.name, ''), b.id::text),
           (SELECT cur.id FROM m_currency cur
              JOIN map_country_currency mcc ON mcc.currency_id = cur.id
             WHERE mcc.country_id = bz.registered_country_id LIMIT 1)
      INTO v_tenant_id, v_business_id, v_branch_code, v_currency_id
      FROM branches b
      JOIN businesses bz ON bz.id = b.business_id
     WHERE b.id = p_branch_id;

    IF v_tenant_id IS NULL THEN
        RAISE EXCEPTION 'Branch % not found', p_branch_id;
    END IF;

    IF v_currency_id IS NULL THEN
        SELECT id INTO v_currency_id FROM m_currency WHERE status = 'A' LIMIT 1;
    END IF;

    -- Ensure tenant-wide scaffold exists
    PERFORM provision_tenant_accounts(v_tenant_id);

    -- Pick up the groups created by provision_tenant_accounts
    SELECT id INTO g_cash       FROM account_group WHERE tenant_id = v_tenant_id AND code = 'CASH_IN_HAND';
    SELECT id INTO g_sales      FROM account_group WHERE tenant_id = v_tenant_id AND code = 'SALES_ACCOUNTS';
    SELECT id INTO g_services   FROM account_group WHERE tenant_id = v_tenant_id AND code = 'SERVICE_INCOME';
    SELECT id INTO g_purchases  FROM account_group WHERE tenant_id = v_tenant_id AND code = 'PURCHASE_ACCOUNTS';
    SELECT id INTO g_sales_ret  FROM account_group WHERE tenant_id = v_tenant_id AND code = 'SALES_RETURNS';
    SELECT id INTO g_pur_ret    FROM account_group WHERE tenant_id = v_tenant_id AND code = 'PURCHASE_RETURNS';
    SELECT id INTO g_stock      FROM account_group WHERE tenant_id = v_tenant_id AND code = 'STOCK_IN_HAND';
    SELECT id INTO g_discount_a FROM account_group WHERE tenant_id = v_tenant_id AND code = 'DISCOUNT_ALLOWED';
    SELECT id INTO g_commission FROM account_group WHERE tenant_id = v_tenant_id AND code = 'STAFF_COMMISSION';

    -- Branch-specific ledgers
    a_cash      := ensure_account_master(v_tenant_id, CONCAT('CASH_B',     p_branch_id), CONCAT('Cash — ',     v_branch_code), g_cash,      'CASH',          v_currency_id, p_branch_id,
                       (SELECT id FROM m_payment_method WHERE method_key = 'CASH'));
    a_sales     := ensure_account_master(v_tenant_id, CONCAT('SALES_B',    p_branch_id), CONCAT('Sales — ',    v_branch_code), g_sales,     'SALES',         v_currency_id, p_branch_id);
    a_services  := ensure_account_master(v_tenant_id, CONCAT('SERVICE_B',  p_branch_id), CONCAT('Service Income — ', v_branch_code), g_services, 'SALES',     v_currency_id, p_branch_id);
    a_purchases := ensure_account_master(v_tenant_id, CONCAT('PURCH_B',    p_branch_id), CONCAT('Purchase — ', v_branch_code), g_purchases, 'PURCHASE',      v_currency_id, p_branch_id);
    a_sales_ret := ensure_account_master(v_tenant_id, CONCAT('SALRET_B',   p_branch_id), CONCAT('Sales Return — ', v_branch_code), g_sales_ret, 'SALES_RETURN', v_currency_id, p_branch_id);
    a_pur_ret   := ensure_account_master(v_tenant_id, CONCAT('PURRET_B',   p_branch_id), CONCAT('Purchase Return — ', v_branch_code), g_pur_ret, 'PURCHASE_RETURN', v_currency_id, p_branch_id);
    a_stock     := ensure_account_master(v_tenant_id, CONCAT('STOCK_B',    p_branch_id), CONCAT('Stock-in-Hand — ', v_branch_code), g_stock, 'STOCK',         v_currency_id, p_branch_id);
    a_discount  := ensure_account_master(v_tenant_id, CONCAT('DISC_B',     p_branch_id), CONCAT('Discount Allowed — ', v_branch_code), g_discount_a, 'DISCOUNT', v_currency_id, p_branch_id);
    a_commission := ensure_account_master(v_tenant_id, CONCAT('COMM_B',    p_branch_id), CONCAT('Staff Commission — ', v_branch_code), g_commission, 'STAFF_COMMISSION', v_currency_id, p_branch_id);

    -- Shared ledgers
    SELECT id INTO a_output_tax FROM account_master WHERE tenant_id = v_tenant_id AND code = 'OUTPUT_TAX';
    SELECT id INTO a_input_tax  FROM account_master WHERE tenant_id = v_tenant_id AND code = 'INPUT_TAX';
    SELECT id INTO a_rounding   FROM account_master WHERE tenant_id = v_tenant_id AND code = 'ROUNDING_OFF';
    SELECT id INTO a_tip        FROM account_master WHERE tenant_id = v_tenant_id AND code = 'TIP_PAYABLE';

    -- Wire daybook roles → accounts (branch-specific overrides)
    -- SALE
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE', 'SALE_INCOME',   a_sales);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE', 'SERVICE_INCOME',a_services);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE', 'OUTPUT_TAX',    a_output_tax);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE', 'DISCOUNT_GIVEN',a_discount);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE', 'CASH',          a_cash);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE', 'STOCK',         a_stock);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE', 'ROUNDING',      a_rounding);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE', 'TIP_PAYABLE',   a_tip);

    -- SALE_RETURN
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE_RETURN', 'SALES_RETURN', a_sales_ret);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE_RETURN', 'OUTPUT_TAX',   a_output_tax);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE_RETURN', 'CASH',         a_cash);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'SALE_RETURN', 'STOCK',        a_stock);

    -- PURCHASE
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'PURCHASE', 'PURCHASE',  a_purchases);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'PURCHASE', 'INPUT_TAX', a_input_tax);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'PURCHASE', 'STOCK',     a_stock);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'PURCHASE', 'CASH',      a_cash);

    -- PURCHASE_RETURN
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'PURCHASE_RETURN', 'PURCHASE_RETURN', a_pur_ret);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'PURCHASE_RETURN', 'INPUT_TAX',       a_input_tax);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'PURCHASE_RETURN', 'STOCK',           a_stock);

    -- PAYMENT / RECEIPT use the branch cash by default
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'PAYMENT', 'CASH', a_cash);
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'RECEIPT', 'CASH', a_cash);

    -- DEPOSIT
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'DEPOSIT', 'CASH', a_cash);

    -- REFUND
    PERFORM ensure_daybook_account_map(v_tenant_id, p_branch_id, 'REFUND', 'CASH', a_cash);
END;
$$ LANGUAGE plpgsql;
