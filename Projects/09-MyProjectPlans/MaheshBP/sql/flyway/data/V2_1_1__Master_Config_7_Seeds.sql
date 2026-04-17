-- =========================================================
-- Master Config 7 - Seeds
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- Nature of account
-- ---------------------------------------------------------
INSERT INTO m_account_nature (internal_id, nature_key, name, normal_balance, is_pnl, is_bs, display_order, status, version)
VALUES ('AC-NAT-001', 'ASSET', 'Asset', 'D', FALSE, TRUE, 1, 'A', 1),
       ('AC-NAT-002', 'LIABILITY', 'Liability', 'C', FALSE, TRUE, 2, 'A', 1),
       ('AC-NAT-003', 'EQUITY', 'Equity / Capital', 'C', FALSE, TRUE, 3, 'A', 1),
       ('AC-NAT-004', 'INCOME', 'Income', 'C', TRUE, FALSE, 4, 'A', 1),
       ('AC-NAT-005', 'EXPENSE', 'Expense', 'D', TRUE, FALSE, 5, 'A', 1);

-- ---------------------------------------------------------
-- Primary groups (Tally-style fixed top-level classification)
-- pnl_section drives P&L statement structure.
-- ---------------------------------------------------------
INSERT INTO m_account_primary_group
    (internal_id, group_key, name, nature_id, pnl_section, display_order, status, version)
VALUES
-- Assets
    ('AC-PG-001', 'FIXED_ASSETS', 'Fixed Assets',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 1, 'A', 1),
    ('AC-PG-002', 'INVESTMENTS', 'Investments',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 2, 'A', 1),
    ('AC-PG-003', 'CURRENT_ASSETS', 'Current Assets',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 3, 'A', 1),
    ('AC-PG-004', 'STOCK_IN_HAND', 'Stock-in-Hand',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 4, 'A', 1),
    ('AC-PG-005', 'CASH_IN_HAND', 'Cash-in-Hand',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 5, 'A', 1),
    ('AC-PG-006', 'BANK_ACCOUNTS', 'Bank Accounts',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 6, 'A', 1),
    ('AC-PG-007', 'SUNDRY_DEBTORS', 'Sundry Debtors (Customers)',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 7, 'A', 1),
    ('AC-PG-008', 'LOANS_ADVANCES_ASSET', 'Loans & Advances (Asset)',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 8, 'A', 1),
    ('AC-PG-009', 'DEPOSITS_ASSET', 'Deposits (Asset)',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 9, 'A', 1),

-- Liabilities
    ('AC-PG-010', 'CAPITAL_ACCOUNT', 'Capital Account',
        (SELECT id FROM m_account_nature WHERE nature_key = 'EQUITY'), NULL, 10, 'A', 1),
    ('AC-PG-011', 'RESERVES_SURPLUS', 'Reserves & Surplus',
        (SELECT id FROM m_account_nature WHERE nature_key = 'EQUITY'), NULL, 11, 'A', 1),
    ('AC-PG-012', 'CURRENT_LIABILITIES', 'Current Liabilities',
        (SELECT id FROM m_account_nature WHERE nature_key = 'LIABILITY'), NULL, 12, 'A', 1),
    ('AC-PG-013', 'SUNDRY_CREDITORS', 'Sundry Creditors (Suppliers)',
        (SELECT id FROM m_account_nature WHERE nature_key = 'LIABILITY'), NULL, 13, 'A', 1),
    ('AC-PG-014', 'DUTIES_TAXES', 'Duties & Taxes',
        (SELECT id FROM m_account_nature WHERE nature_key = 'LIABILITY'), NULL, 14, 'A', 1),
    ('AC-PG-015', 'PROVISIONS', 'Provisions',
        (SELECT id FROM m_account_nature WHERE nature_key = 'LIABILITY'), NULL, 15, 'A', 1),
    ('AC-PG-016', 'LOANS_LIABILITY', 'Loans (Liability)',
        (SELECT id FROM m_account_nature WHERE nature_key = 'LIABILITY'), NULL, 16, 'A', 1),

-- Income (P&L - Credit side)
    ('AC-PG-017', 'SALES_ACCOUNTS', 'Sales Accounts',
        (SELECT id FROM m_account_nature WHERE nature_key = 'INCOME'), 'DIRECT_INCOME', 17, 'A', 1),
    ('AC-PG-018', 'SERVICE_INCOME', 'Service Income',
        (SELECT id FROM m_account_nature WHERE nature_key = 'INCOME'), 'DIRECT_INCOME', 18, 'A', 1),
    ('AC-PG-019', 'DIRECT_INCOMES', 'Direct Incomes',
        (SELECT id FROM m_account_nature WHERE nature_key = 'INCOME'), 'DIRECT_INCOME', 19, 'A', 1),
    ('AC-PG-020', 'INDIRECT_INCOMES', 'Indirect Incomes',
        (SELECT id FROM m_account_nature WHERE nature_key = 'INCOME'), 'INDIRECT_INCOME', 20, 'A', 1),

-- Expense (P&L - Debit side)
    ('AC-PG-021', 'PURCHASE_ACCOUNTS', 'Purchase Accounts',
        (SELECT id FROM m_account_nature WHERE nature_key = 'EXPENSE'), 'COGS', 21, 'A', 1),
    ('AC-PG-022', 'DIRECT_EXPENSES', 'Direct Expenses',
        (SELECT id FROM m_account_nature WHERE nature_key = 'EXPENSE'), 'DIRECT_EXPENSE', 22, 'A', 1),
    ('AC-PG-023', 'INDIRECT_EXPENSES', 'Indirect Expenses',
        (SELECT id FROM m_account_nature WHERE nature_key = 'EXPENSE'), 'INDIRECT_EXPENSE', 23, 'A', 1),
    ('AC-PG-024', 'SALES_RETURNS', 'Sales Returns',
        (SELECT id FROM m_account_nature WHERE nature_key = 'EXPENSE'), 'DIRECT_EXPENSE', 24, 'A', 1),
    ('AC-PG-025', 'PURCHASE_RETURNS', 'Purchase Returns',
        (SELECT id FROM m_account_nature WHERE nature_key = 'INCOME'), 'COGS', 25, 'A', 1),
    ('AC-PG-026', 'DISCOUNT_ALLOWED', 'Discount Allowed',
        (SELECT id FROM m_account_nature WHERE nature_key = 'EXPENSE'), 'INDIRECT_EXPENSE', 26, 'A', 1),
    ('AC-PG-027', 'DISCOUNT_RECEIVED', 'Discount Received',
        (SELECT id FROM m_account_nature WHERE nature_key = 'INCOME'), 'INDIRECT_INCOME', 27, 'A', 1),
    ('AC-PG-028', 'STAFF_COMMISSION', 'Staff Commission',
        (SELECT id FROM m_account_nature WHERE nature_key = 'EXPENSE'), 'DIRECT_EXPENSE', 28, 'A', 1),
    ('AC-PG-029', 'SUSPENSE_ACCOUNTS', 'Suspense Accounts',
        (SELECT id FROM m_account_nature WHERE nature_key = 'ASSET'), NULL, 29, 'A', 1);

-- Daybook seeds are in V1_6_1 (defined earlier because item_trans depends on m_daybook).
