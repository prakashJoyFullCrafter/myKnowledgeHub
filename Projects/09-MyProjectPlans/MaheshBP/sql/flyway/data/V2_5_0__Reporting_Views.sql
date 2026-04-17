-- =========================================================
-- Reporting Views
--
--   v_trial_balance        : Dr/Cr totals per account (date-ranged via arguments)
--   v_account_balances     : Running balance per account
--   v_pnl_summary          : P&L structured by primary group
--   v_branch_stock         : Current on-hand stock by branch × product
--   v_branch_stock_value   : Stock valuation at weighted-average cost
--   v_ledger               : Full ledger drill-down for one account
--   v_daybook_register     : Daybook-wise voucher register
-- =========================================================

-- ---------------------------------------------------------
-- Account balances (all-time, from POSTED vouchers)
-- Combines opening balance + posted transactions.
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW accounting.v_account_balances AS
SELECT
    am.tenant_id,
    am.id                  AS account_id,
    am.code                AS account_code,
    am.name                AS account_name,
    am.branch_id,
    am.ledger_type,
    nt.nature_key,
    pg.group_key           AS primary_group_key,
    pg.name                AS primary_group_name,
    pg.pnl_section,
    am.currency_id,
    -- Opening balance normalized to signed Dr (+) / Cr (-)
    CASE WHEN am.opening_balance_dc = 'D' THEN am.opening_balance ELSE 0 END AS opening_dr,
    CASE WHEN am.opening_balance_dc = 'C' THEN am.opening_balance ELSE 0 END AS opening_cr,
    COALESCE(t.total_dr, 0) AS period_dr,
    COALESCE(t.total_cr, 0) AS period_cr,
    -- Net balance (positive = Dr, negative = Cr)
    ( CASE WHEN am.opening_balance_dc = 'D' THEN am.opening_balance ELSE -am.opening_balance END
      + COALESCE(t.total_dr, 0) - COALESCE(t.total_cr, 0)
    ) AS net_balance
FROM core.account_master am
JOIN core.m_account_nature nt ON nt.id = am.nature_id
JOIN core.m_account_primary_group pg ON pg.id = am.primary_group_id
LEFT JOIN (
    SELECT act.account_id,
           SUM(act.dr_amount) AS total_dr,
           SUM(act.cr_amount) AS total_cr
      FROM accounting.ac_transaction act
      JOIN accounting.ac_voucher v ON v.id = act.voucher_id
     WHERE v.voucher_status = 'POSTED'
       AND act.status = 'A'
     GROUP BY act.account_id
) t ON t.account_id = am.id
WHERE am.status = 'A';

-- ---------------------------------------------------------
-- Trial balance (all-time snapshot)
-- Columns: opening_dr/cr, period_dr/cr, closing_dr/cr
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW accounting.v_trial_balance AS
SELECT
    tenant_id,
    account_id,
    account_code,
    account_name,
    branch_id,
    primary_group_key,
    primary_group_name,
    opening_dr, opening_cr,
    period_dr,  period_cr,
    CASE WHEN net_balance > 0 THEN net_balance ELSE 0 END AS closing_dr,
    CASE WHEN net_balance < 0 THEN -net_balance ELSE 0 END AS closing_cr
FROM accounting.v_account_balances;

-- ---------------------------------------------------------
-- P&L summary (by primary group + pnl_section)
-- Positive amount = P&L impact in the natural direction
-- (income is positive, expense is positive-expense).
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW accounting.v_pnl_summary AS
SELECT
    am.tenant_id,
    am.branch_id,
    pg.pnl_section,
    pg.group_key   AS primary_group_key,
    pg.name        AS primary_group_name,
    nt.nature_key,
    COUNT(DISTINCT am.id)                          AS account_count,
    SUM(COALESCE(t.total_dr, 0))                   AS total_dr,
    SUM(COALESCE(t.total_cr, 0))                   AS total_cr,
    -- For income (credit-normal): cr - dr = income
    -- For expense (debit-normal): dr - cr = expense
    SUM(CASE nt.normal_balance
          WHEN 'C' THEN COALESCE(t.total_cr, 0) - COALESCE(t.total_dr, 0)
          WHEN 'D' THEN COALESCE(t.total_dr, 0) - COALESCE(t.total_cr, 0)
        END) AS net_amount
FROM core.account_master am
JOIN core.m_account_nature nt ON nt.id = am.nature_id
JOIN core.m_account_primary_group pg ON pg.id = am.primary_group_id
LEFT JOIN (
    SELECT act.account_id,
           SUM(act.dr_amount) AS total_dr,
           SUM(act.cr_amount) AS total_cr
      FROM accounting.ac_transaction act
      JOIN accounting.ac_voucher v ON v.id = act.voucher_id
     WHERE v.voucher_status = 'POSTED'
       AND act.status = 'A'
     GROUP BY act.account_id
) t ON t.account_id = am.id
WHERE am.status = 'A'
  AND pg.pnl_section IS NOT NULL
GROUP BY am.tenant_id, am.branch_id, pg.pnl_section, pg.group_key, pg.name, nt.nature_key;

-- ---------------------------------------------------------
-- Ledger (drill-down view for one account)
-- Use: SELECT * FROM accounting.v_ledger WHERE account_id = ? ORDER BY voucher_date, voucher_id;
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW accounting.v_ledger AS
SELECT
    act.tenant_id,
    act.branch_id,
    act.account_id,
    am.code         AS account_code,
    am.name         AS account_name,
    act.voucher_id,
    v.voucher_number,
    v.voucher_date,
    v.voucher_time,
    db.daybook_key,
    db.name         AS daybook_name,
    act.dr_amount,
    act.cr_amount,
    -- Running balance (within this account, chronological)
    SUM(act.dr_amount - act.cr_amount) OVER (
        PARTITION BY act.account_id
        ORDER BY v.voucher_date, v.voucher_time, act.id
        ROWS UNBOUNDED PRECEDING
    ) AS running_balance,
    act.narration,
    act.reference_number,
    v.source_type,
    v.source_id,
    v.source_code,
    act.customer_account_id,
    act.supplier_id
FROM accounting.ac_transaction act
JOIN accounting.ac_voucher v ON v.id = act.voucher_id
JOIN core.account_master am ON am.id = act.account_id
JOIN core.m_daybook db ON db.id = act.daybook_id
WHERE v.voucher_status = 'POSTED'
  AND act.status = 'A';

-- ---------------------------------------------------------
-- Daybook register (voucher-level view grouped by daybook)
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW accounting.v_daybook_register AS
SELECT
    v.tenant_id,
    v.business_id,
    v.branch_id,
    db.daybook_key,
    db.name          AS daybook_name,
    v.voucher_date,
    v.voucher_number,
    v.id             AS voucher_id,
    v.total_debit,
    v.total_credit,
    v.narration,
    v.source_type,
    v.source_id,
    v.source_code,
    v.voucher_status,
    v.posted_at,
    v.posted_by,
    (SELECT COUNT(*) FROM accounting.ac_transaction act WHERE act.voucher_id = v.id) AS line_count
FROM accounting.ac_voucher v
JOIN core.m_daybook db ON db.id = v.daybook_id
WHERE v.status = 'A';

-- =========================================================
-- Inventory reporting views
-- =========================================================
set
search_path to core;

-- ---------------------------------------------------------
-- Current on-hand stock per branch × product (physical only)
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW core.v_branch_stock AS
SELECT
    bps.tenant_id,
    bps.business_id,
    bps.branch_id,
    b.name              AS branch_name,
    bps.product_id,
    bps.product_variant_id,
    pm.item_code,
    pm.name             AS product_name,
    pv.name             AS variant_name,
    u.name              AS uom,
    bps.quantity_on_hand,
    bps.quantity_reserved,
    (bps.quantity_on_hand - bps.quantity_reserved) AS quantity_available,
    bps.avg_cost_price,
    bps.last_cost_price,
    (bps.quantity_on_hand * COALESCE(bps.avg_cost_price, 0))::NUMERIC(16,2) AS stock_value,
    bps.last_trans_at,
    -- In-transit quantity inbound to this branch (computed from item_trans)
    COALESCE(in_transit.qty_in, 0) AS quantity_in_transit_inbound
FROM core.branch_product_stock bps
JOIN core.branches b      ON b.id = bps.branch_id
JOIN core.product_master pm ON pm.id = bps.product_id
LEFT JOIN core.product_variants pv ON pv.id = bps.product_variant_id
JOIN core.m_uom u         ON u.id = bps.uom_id
LEFT JOIN (
    SELECT destination_branch_id AS branch_id,
           product_id,
           product_variant_id,
           SUM(qty_rec) - SUM(qty_iss) AS qty_in
      FROM core.item_trans
     WHERE in_transit = TRUE
     GROUP BY destination_branch_id, product_id, product_variant_id
) in_transit
  ON in_transit.branch_id = bps.branch_id
 AND in_transit.product_id = bps.product_id
 AND in_transit.product_variant_id IS NOT DISTINCT FROM bps.product_variant_id
WHERE bps.status = 'A';

-- ---------------------------------------------------------
-- Stock valuation summary (per branch, all products)
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW core.v_branch_stock_value AS
SELECT
    bps.tenant_id,
    bps.business_id,
    bps.branch_id,
    b.name                        AS branch_name,
    COUNT(DISTINCT bps.product_id)      AS product_count,
    SUM(bps.quantity_on_hand)           AS total_quantity,
    SUM(bps.quantity_on_hand * COALESCE(bps.avg_cost_price, 0))::NUMERIC(16,2) AS total_value
FROM core.branch_product_stock bps
JOIN core.branches b ON b.id = bps.branch_id
WHERE bps.status = 'A' AND bps.quantity_on_hand > 0
GROUP BY bps.tenant_id, bps.business_id, bps.branch_id, b.name;

-- ---------------------------------------------------------
-- Stock movement register (item_trans with joined names)
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW core.v_stock_ledger AS
SELECT
    it.id                AS item_trans_id,
    it.internal_code,
    it.tenant_id,
    it.branch_id,
    b.name               AS branch_name,
    it.product_id,
    pm.item_code,
    pm.name              AS product_name,
    pv.name              AS variant_name,
    mvt.movement_key,
    mvt.name             AS movement_type,
    db.daybook_key,
    db.name              AS daybook_name,
    u.name               AS uom,
    it.qty_rec,
    it.qty_iss,
    it.unit_cost,
    it.total_cost,
    it.balance_after,
    it.in_transit,
    it.source_branch_id,
    it.destination_branch_id,
    it.batch_number,
    it.expiry_date,
    it.reference_type,
    it.reference_id,
    it.reverses_trans_id,
    it.trans_at,
    it.notes,
    it.created_by
FROM core.item_trans it
JOIN core.branches b            ON b.id = it.branch_id
JOIN core.product_master pm     ON pm.id = it.product_id
LEFT JOIN core.product_variants pv ON pv.id = it.product_variant_id
JOIN core.m_stock_movement_type mvt ON mvt.id = it.movement_type_id
JOIN core.m_daybook db          ON db.id = it.daybook_id
JOIN core.m_uom u               ON u.id = it.uom_id;

-- ---------------------------------------------------------
-- Products at/below reorder level
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW core.v_low_stock_alerts AS
SELECT
    bps.tenant_id,
    bps.branch_id,
    b.name                AS branch_name,
    bps.product_id,
    pm.item_code,
    pm.name               AS product_name,
    bps.quantity_on_hand,
    COALESCE(bp.reorder_level, pm.reorder_level)   AS reorder_level,
    COALESCE(bp.reorder_quantity, pm.reorder_quantity) AS reorder_quantity,
    bps.last_trans_at
FROM core.branch_product_stock bps
JOIN core.branches b         ON b.id = bps.branch_id
JOIN core.product_master pm  ON pm.id = bps.product_id
LEFT JOIN core.branch_products bp
       ON bp.branch_id = bps.branch_id AND bp.product_id = bps.product_id
WHERE bps.status = 'A'
  AND bps.quantity_on_hand <= COALESCE(bp.reorder_level, pm.reorder_level, 0)
  AND COALESCE(bp.reorder_level, pm.reorder_level) IS NOT NULL;

-- =========================================================
-- Sales / Purchase reporting views
-- =========================================================

-- ---------------------------------------------------------
-- Daily sales summary
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW sales.v_daily_sales AS
SELECT
    om.tenant_id,
    om.business_id,
    om.branch_id,
    om.opened_at::date   AS sale_date,
    COUNT(*)                          AS order_count,
    SUM(om.subtotal_amount)           AS total_subtotal,
    SUM(om.line_discount_amount + om.order_discount_amount) AS total_discount,
    SUM(om.tax_amount)                AS total_tax,
    SUM(om.tip_amount)                AS total_tip,
    SUM(om.total_amount)              AS total_revenue,
    SUM(om.amount_paid)               AS total_collected
FROM sales.order_main om
WHERE om.status = 'A'
  AND om.order_status_id IN (SELECT id FROM core.m_order_status WHERE status_key IN ('BILLED', 'PAID', 'CLOSED'))
GROUP BY om.tenant_id, om.business_id, om.branch_id, om.opened_at::date;

-- ---------------------------------------------------------
-- Supplier ageing / outstanding payables
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW core.v_supplier_outstanding AS
SELECT
    pm.tenant_id,
    pm.branch_id,
    pm.supplier_id,
    s.name             AS supplier_name,
    pm.purchase_number,
    pm.purchase_date,
    pm.due_date,
    pm.total_amount,
    pm.amount_paid,
    pm.amount_due,
    CASE
        WHEN pm.due_date IS NULL               THEN 'NOT_DUE'
        WHEN pm.due_date >= CURRENT_DATE        THEN 'NOT_DUE'
        WHEN CURRENT_DATE - pm.due_date <= 30   THEN '0-30'
        WHEN CURRENT_DATE - pm.due_date <= 60   THEN '31-60'
        WHEN CURRENT_DATE - pm.due_date <= 90   THEN '61-90'
        ELSE '90+'
    END                AS ageing_bucket,
    (CURRENT_DATE - pm.due_date) AS days_overdue
FROM core.purchase_main pm
JOIN core.suppliers s ON s.id = pm.supplier_id
WHERE pm.status = 'A'
  AND pm.purchase_status = 'POSTED'
  AND pm.amount_due > 0;

-- ---------------------------------------------------------
-- Customer ageing / outstanding receivables
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW billing.v_customer_outstanding AS
SELECT
    im.tenant_id,
    im.branch_id,
    im.customer_account_id,
    im.bill_to_name,
    im.invoice_number,
    im.issue_date,
    im.due_date,
    im.total_amount,
    im.amount_paid,
    im.amount_refunded,
    im.amount_due,
    CASE
        WHEN im.due_date IS NULL              THEN 'NOT_DUE'
        WHEN im.due_date >= CURRENT_DATE       THEN 'NOT_DUE'
        WHEN CURRENT_DATE - im.due_date <= 30  THEN '0-30'
        WHEN CURRENT_DATE - im.due_date <= 60  THEN '31-60'
        WHEN CURRENT_DATE - im.due_date <= 90  THEN '61-90'
        ELSE '90+'
    END                AS ageing_bucket,
    (CURRENT_DATE - im.due_date) AS days_overdue
FROM billing.invoice_main im
WHERE im.status = 'A'
  AND im.amount_due > 0;
