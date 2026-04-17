-- =========================================================
-- Master Config 6 - Seeds
-- =========================================================
set
search_path to core;

-- Booking channel
INSERT INTO m_booking_channel (internal_id, channel_key, name, display_order, status, version)
VALUES ('BKG-CHN-001', 'WALK_IN', 'Walk In', 1, 'A', 1),
       ('BKG-CHN-002', 'FRONT_DESK', 'Front Desk', 2, 'A', 1),
       ('BKG-CHN-003', 'PHONE', 'Phone', 3, 'A', 1),
       ('BKG-CHN-004', 'CUSTOMER_APP', 'Customer App', 4, 'A', 1),
       ('BKG-CHN-005', 'WEBSITE', 'Website', 5, 'A', 1),
       ('BKG-CHN-006', 'WHATSAPP', 'WhatsApp', 6, 'A', 1),
       ('BKG-CHN-007', 'INSTAGRAM', 'Instagram', 7, 'A', 1),
       ('BKG-CHN-008', 'MARKETPLACE', 'Marketplace', 8, 'A', 1);

-- Service mode
INSERT INTO m_service_mode (internal_id, mode_key, name, requires_address, display_order, status, version)
VALUES ('SVC-MODE-001', 'IN_STORE', 'In Store', FALSE, 1, 'A', 1),
       ('SVC-MODE-002', 'HOME_SERVICE', 'Home Service', TRUE, 2, 'A', 1),
       ('SVC-MODE-003', 'VIRTUAL', 'Virtual / Online', FALSE, 3, 'A', 1);

-- Booking status
INSERT INTO m_booking_status (internal_id, status_key, name, is_terminal, display_order, status, version)
VALUES ('BKG-STS-001', 'DRAFT', 'Draft', FALSE, 1, 'A', 1),
       ('BKG-STS-002', 'PENDING', 'Pending Confirmation', FALSE, 2, 'A', 1),
       ('BKG-STS-003', 'CONFIRMED', 'Confirmed', FALSE, 3, 'A', 1),
       ('BKG-STS-004', 'CHECKED_IN', 'Checked In', FALSE, 4, 'A', 1),
       ('BKG-STS-005', 'IN_PROGRESS', 'In Progress', FALSE, 5, 'A', 1),
       ('BKG-STS-006', 'COMPLETED', 'Completed', TRUE, 6, 'A', 1),
       ('BKG-STS-007', 'NO_SHOW', 'No Show', TRUE, 7, 'A', 1),
       ('BKG-STS-008', 'CANCELLED', 'Cancelled', TRUE, 8, 'A', 1),
       ('BKG-STS-009', 'RESCHEDULED', 'Rescheduled', TRUE, 9, 'A', 1);

-- Cancellation source
INSERT INTO m_cancellation_source (internal_id, source_key, name, display_order, status, version)
VALUES ('CNL-SRC-001', 'CUSTOMER', 'Customer', 1, 'A', 1),
       ('CNL-SRC-002', 'STAFF', 'Staff', 2, 'A', 1),
       ('CNL-SRC-003', 'BRANCH', 'Branch', 3, 'A', 1),
       ('CNL-SRC-004', 'SYSTEM', 'System', 4, 'A', 1),
       ('CNL-SRC-005', 'PAYMENT_FAILED', 'Payment Failed', 5, 'A', 1);

-- Visit status
INSERT INTO m_visit_status (internal_id, status_key, name, is_terminal, display_order, status, version)
VALUES ('VIS-STS-001', 'REGISTERED', 'Registered', FALSE, 1, 'A', 1),
       ('VIS-STS-002', 'WAITING', 'Waiting', FALSE, 2, 'A', 1),
       ('VIS-STS-003', 'IN_SERVICE', 'In Service', FALSE, 3, 'A', 1),
       ('VIS-STS-004', 'SERVICE_DONE', 'Service Completed', FALSE, 4, 'A', 1),
       ('VIS-STS-005', 'BILLED', 'Billed', FALSE, 5, 'A', 1),
       ('VIS-STS-006', 'CLOSED', 'Closed', TRUE, 6, 'A', 1),
       ('VIS-STS-007', 'LEFT_WITHOUT_SERVICE', 'Left Without Service', TRUE, 7, 'A', 1),
       ('VIS-STS-008', 'CANCELLED', 'Cancelled', TRUE, 8, 'A', 1);

-- Order status
INSERT INTO m_order_status (internal_id, status_key, name, is_terminal, display_order, status, version)
VALUES ('ORD-STS-001', 'DRAFT', 'Draft', FALSE, 1, 'A', 1),
       ('ORD-STS-002', 'OPEN', 'Open', FALSE, 2, 'A', 1),
       ('ORD-STS-003', 'IN_PROGRESS', 'In Progress', FALSE, 3, 'A', 1),
       ('ORD-STS-004', 'SERVICE_DONE', 'Service Completed', FALSE, 4, 'A', 1),
       ('ORD-STS-005', 'BILLED', 'Billed', FALSE, 5, 'A', 1),
       ('ORD-STS-006', 'PAID', 'Paid', FALSE, 6, 'A', 1),
       ('ORD-STS-007', 'CLOSED', 'Closed', TRUE, 7, 'A', 1),
       ('ORD-STS-008', 'VOIDED', 'Voided', TRUE, 8, 'A', 1),
       ('ORD-STS-009', 'CANCELLED', 'Cancelled', TRUE, 9, 'A', 1);

-- Order line type
INSERT INTO m_order_line_type (internal_id, type_key, name, display_order, status, version)
VALUES ('ORD-LNT-001', 'SERVICE', 'Service', 1, 'A', 1),
       ('ORD-LNT-002', 'SERVICE_VARIANT', 'Service Variant', 2, 'A', 1),
       ('ORD-LNT-003', 'SERVICE_ADDON', 'Service Addon', 3, 'A', 1),
       ('ORD-LNT-004', 'SERVICE_BUNDLE', 'Service Bundle', 4, 'A', 1),
       ('ORD-LNT-005', 'PRODUCT', 'Product', 5, 'A', 1),
       ('ORD-LNT-006', 'PRODUCT_VARIANT', 'Product Variant', 6, 'A', 1),
       ('ORD-LNT-007', 'SURCHARGE', 'Surcharge', 7, 'A', 1),
       ('ORD-LNT-008', 'DISCOUNT', 'Discount', 8, 'A', 1),
       ('ORD-LNT-009', 'TIP', 'Tip / Gratuity', 9, 'A', 1);

-- Payment status (order-level and invoice-level rollup)
INSERT INTO m_payment_status (internal_id, status_key, name, is_terminal, display_order, status, version)
VALUES ('PAY-STS-001', 'UNPAID', 'Unpaid', FALSE, 1, 'A', 1),
       ('PAY-STS-002', 'PARTIAL', 'Partially Paid', FALSE, 2, 'A', 1),
       ('PAY-STS-003', 'DEPOSIT_PAID', 'Deposit Paid', FALSE, 3, 'A', 1),
       ('PAY-STS-004', 'PAID', 'Paid', TRUE, 4, 'A', 1),
       ('PAY-STS-005', 'OVERPAID', 'Overpaid', FALSE, 5, 'A', 1),
       ('PAY-STS-006', 'REFUND_PENDING', 'Refund Pending', FALSE, 6, 'A', 1),
       ('PAY-STS-007', 'PARTIALLY_REFUNDED', 'Partially Refunded', FALSE, 7, 'A', 1),
       ('PAY-STS-008', 'REFUNDED', 'Refunded', TRUE, 8, 'A', 1),
       ('PAY-STS-009', 'FAILED', 'Failed', TRUE, 9, 'A', 1),
       ('PAY-STS-010', 'VOIDED', 'Voided', TRUE, 10, 'A', 1);

-- Payment method
INSERT INTO m_payment_method (internal_id, method_key, name, is_online, display_order, status, version)
VALUES ('PAY-MTD-001', 'CASH', 'Cash', FALSE, 1, 'A', 1),
       ('PAY-MTD-002', 'CARD_POS', 'Card (POS)', FALSE, 2, 'A', 1),
       ('PAY-MTD-003', 'CARD_ONLINE', 'Card (Online)', TRUE, 3, 'A', 1),
       ('PAY-MTD-004', 'UPI', 'UPI', TRUE, 4, 'A', 1),
       ('PAY-MTD-005', 'WALLET', 'Wallet', TRUE, 5, 'A', 1),
       ('PAY-MTD-006', 'BANK_TRANSFER', 'Bank Transfer', FALSE, 6, 'A', 1),
       ('PAY-MTD-007', 'CHEQUE', 'Cheque', FALSE, 7, 'A', 1),
       ('PAY-MTD-008', 'GIFT_CARD', 'Gift Card', FALSE, 8, 'A', 1),
       ('PAY-MTD-009', 'LOYALTY_POINTS', 'Loyalty Points', FALSE, 9, 'A', 1),
       ('PAY-MTD-010', 'CREDIT_NOTE', 'Credit Note', FALSE, 10, 'A', 1),
       ('PAY-MTD-011', 'COMPLIMENTARY', 'Complimentary', FALSE, 11, 'A', 1);

-- Tender type (physical / logical settlement instrument)
INSERT INTO m_tender_type (internal_id, tender_key, name, category, requires_reference, display_order, status, version)
VALUES ('TND-TYP-001', 'CASH', 'Cash', 'CASH', FALSE, 1, 'A', 1),
       ('TND-TYP-002', 'CARD_VISA', 'Visa', 'CARD', TRUE, 2, 'A', 1),
       ('TND-TYP-003', 'CARD_MASTER', 'Mastercard', 'CARD', TRUE, 3, 'A', 1),
       ('TND-TYP-004', 'CARD_AMEX', 'Amex', 'CARD', TRUE, 4, 'A', 1),
       ('TND-TYP-005', 'CARD_RUPAY', 'RuPay', 'CARD', TRUE, 5, 'A', 1),
       ('TND-TYP-006', 'UPI', 'UPI', 'UPI', TRUE, 6, 'A', 1),
       ('TND-TYP-007', 'PAYTM', 'Paytm', 'WALLET', TRUE, 7, 'A', 1),
       ('TND-TYP-008', 'PHONEPE', 'PhonePe', 'WALLET', TRUE, 8, 'A', 1),
       ('TND-TYP-009', 'GPAY', 'Google Pay', 'WALLET', TRUE, 9, 'A', 1),
       ('TND-TYP-010', 'BANK_TRANSFER', 'Bank Transfer', 'BANK', TRUE, 10, 'A', 1),
       ('TND-TYP-011', 'CHEQUE', 'Cheque', 'CHEQUE', TRUE, 11, 'A', 1),
       ('TND-TYP-012', 'GIFT_CARD', 'Gift Card', 'GIFT_CARD', TRUE, 12, 'A', 1),
       ('TND-TYP-013', 'LOYALTY_POINTS', 'Loyalty Points', 'LOYALTY', FALSE, 13, 'A', 1),
       ('TND-TYP-014', 'CREDIT_NOTE', 'Credit Note', 'CREDIT_NOTE', TRUE, 14, 'A', 1);

-- Invoice status
INSERT INTO m_invoice_status (internal_id, status_key, name, is_terminal, display_order, status, version)
VALUES ('INV-STS-001', 'DRAFT', 'Draft', FALSE, 1, 'A', 1),
       ('INV-STS-002', 'ISSUED', 'Issued', FALSE, 2, 'A', 1),
       ('INV-STS-003', 'PARTIAL', 'Partially Paid', FALSE, 3, 'A', 1),
       ('INV-STS-004', 'PAID', 'Paid', TRUE, 4, 'A', 1),
       ('INV-STS-005', 'VOIDED', 'Voided', TRUE, 5, 'A', 1),
       ('INV-STS-006', 'CANCELLED', 'Cancelled', TRUE, 6, 'A', 1),
       ('INV-STS-007', 'REFUNDED', 'Refunded', TRUE, 7, 'A', 1);

-- Refund reason
INSERT INTO m_refund_reason (internal_id, reason_key, name, display_order, status, version)
VALUES ('RFD-RSN-001', 'CUSTOMER_REQUEST', 'Customer Request', 1, 'A', 1),
       ('RFD-RSN-002', 'SERVICE_DISSATISFACTION', 'Service Dissatisfaction', 2, 'A', 1),
       ('RFD-RSN-003', 'STAFF_ERROR', 'Staff Error', 3, 'A', 1),
       ('RFD-RSN-004', 'BILLING_ERROR', 'Billing / Pricing Error', 4, 'A', 1),
       ('RFD-RSN-005', 'DUPLICATE_CHARGE', 'Duplicate Charge', 5, 'A', 1),
       ('RFD-RSN-006', 'CANCELLED_SERVICE', 'Service Cancelled', 6, 'A', 1),
       ('RFD-RSN-007', 'PRODUCT_DEFECT', 'Product Defect', 7, 'A', 1),
       ('RFD-RSN-008', 'PRODUCT_RETURN', 'Product Return', 8, 'A', 1),
       ('RFD-RSN-009', 'GOODWILL', 'Goodwill Gesture', 9, 'A', 1),
       ('RFD-RSN-010', 'OTHER', 'Other', 10, 'A', 1);

-- Tax type
INSERT INTO m_tax_type (internal_id, tax_key, name, category, display_order, status, version)
VALUES ('TAX-TYP-001', 'VAT', 'VAT', 'VAT', 1, 'A', 1),
       ('TAX-TYP-002', 'GST', 'GST', 'GST', 2, 'A', 1),
       ('TAX-TYP-003', 'CGST', 'CGST', 'CGST', 3, 'A', 1),
       ('TAX-TYP-004', 'SGST', 'SGST', 'SGST', 4, 'A', 1),
       ('TAX-TYP-005', 'IGST', 'IGST', 'IGST', 5, 'A', 1),
       ('TAX-TYP-006', 'SERVICE_TAX', 'Service Tax', 'SERVICE_TAX', 6, 'A', 1),
       ('TAX-TYP-007', 'SALES_TAX', 'Sales Tax', 'SALES_TAX', 7, 'A', 1);

-- UOM
INSERT INTO m_uom (internal_id, uom_key, name, symbol, display_order, status, version)
VALUES ('UOM-001', 'PIECE', 'Piece', 'pc', 1, 'A', 1),
       ('UOM-002', 'BOTTLE', 'Bottle', 'btl', 2, 'A', 1),
       ('UOM-003', 'PACK', 'Pack', 'pk', 3, 'A', 1),
       ('UOM-004', 'BOX', 'Box', 'bx', 4, 'A', 1),
       ('UOM-005', 'ML', 'Millilitre', 'ml', 5, 'A', 1),
       ('UOM-006', 'L', 'Litre', 'L', 6, 'A', 1),
       ('UOM-007', 'G', 'Gram', 'g', 7, 'A', 1),
       ('UOM-008', 'KG', 'Kilogram', 'kg', 8, 'A', 1),
       ('UOM-009', 'TUBE', 'Tube', 'tb', 9, 'A', 1),
       ('UOM-010', 'SACHET', 'Sachet', 'sc', 10, 'A', 1);

-- Stock movement type
INSERT INTO m_stock_movement_type (internal_id, movement_key, name, direction, display_order, status, version)
VALUES ('STK-MVT-001', 'PURCHASE_RECEIPT', 'Purchase Receipt', 1, 1, 'A', 1),
       ('STK-MVT-002', 'OPENING_STOCK', 'Opening Stock', 1, 2, 'A', 1),
       ('STK-MVT-003', 'STOCK_TRANSFER_IN', 'Stock Transfer In', 1, 3, 'A', 1),
       ('STK-MVT-004', 'CUSTOMER_RETURN', 'Customer Return', 1, 4, 'A', 1),
       ('STK-MVT-005', 'ADJUSTMENT_IN', 'Adjustment (In)', 1, 5, 'A', 1),
       ('STK-MVT-006', 'SALE', 'Sale', -1, 6, 'A', 1),
       ('STK-MVT-007', 'SERVICE_CONSUMPTION', 'Service Consumption', -1, 7, 'A', 1),
       ('STK-MVT-008', 'STOCK_TRANSFER_OUT', 'Stock Transfer Out', -1, 8, 'A', 1),
       ('STK-MVT-009', 'WASTAGE', 'Wastage / Damage', -1, 9, 'A', 1),
       ('STK-MVT-010', 'ADJUSTMENT_OUT', 'Adjustment (Out)', -1, 10, 'A', 1),
       ('STK-MVT-011', 'VENDOR_RETURN', 'Vendor Return', -1, 11, 'A', 1);

-- ---------------------------------------------------------
-- Daybook seeds (needed by item_trans from V1_7_1 onwards)
-- ---------------------------------------------------------
INSERT INTO daybook_master
    (internal_id, daybook_key, name, voucher_class, affects_accounting, affects_stock, voucher_prefix, display_order, status, version)
VALUES
-- Sales / returns
    ('DBK-001', 'SALE',              'Sales',                      'SALE',             TRUE,  TRUE,  'SL',  1,  'A', 1),
    ('DBK-002', 'SALE_RETURN',       'Sales Return',               'SALE_RETURN',      TRUE,  TRUE,  'SR',  2,  'A', 1),
-- Purchase / returns
    ('DBK-003', 'PURCHASE',          'Purchase',                   'PURCHASE',         TRUE,  TRUE,  'PR',  3,  'A', 1),
    ('DBK-004', 'PURCHASE_RETURN',   'Purchase Return',            'PURCHASE_RETURN',  TRUE,  TRUE,  'PRN', 4,  'A', 1),
-- Money
    ('DBK-005', 'PAYMENT',           'Payment',                    'PAYMENT',          TRUE,  FALSE, 'PY',  5,  'A', 1),
    ('DBK-006', 'RECEIPT',           'Receipt',                    'RECEIPT',          TRUE,  FALSE, 'RC',  6,  'A', 1),
    ('DBK-007', 'CONTRA',            'Contra',                     'CONTRA',           TRUE,  FALSE, 'CN',  7,  'A', 1),
    ('DBK-008', 'JOURNAL',           'Journal',                    'JOURNAL',          TRUE,  FALSE, 'JV',  8,  'A', 1),
    ('DBK-009', 'DEPOSIT',           'Customer Deposit',           'DEPOSIT',          TRUE,  FALSE, 'DP',  9,  'A', 1),
    ('DBK-010', 'REFUND',            'Refund',                     'REFUND',           TRUE,  FALSE, 'RF',  10, 'A', 1),
-- Stock (no accounting impact - internal movement)
    ('DBK-011', 'STK_TRF_OUT',       'Stock Transfer - Out',       'STOCK_TRANSFER',   FALSE, TRUE,  'STO', 11, 'A', 1),
    ('DBK-012', 'STK_TRF_IN_TRANSIT','Stock Transfer - In-Transit','STOCK_TRANSFER',   FALSE, TRUE,  'STT', 12, 'A', 1),
    ('DBK-013', 'STK_TRF_IN',        'Stock Transfer - In',        'STOCK_TRANSFER',   FALSE, TRUE,  'STI', 13, 'A', 1),
    ('DBK-014', 'STK_ADJUST',        'Stock Adjustment',           'STOCK_ADJUSTMENT', FALSE, TRUE,  'SA',  14, 'A', 1),
    ('DBK-015', 'STK_OPENING',       'Opening Stock',              'STOCK_OPENING',    FALSE, TRUE,  'SO',  15, 'A', 1),
    ('DBK-016', 'STK_WASTAGE',       'Stock Wastage',              'STOCK_ADJUSTMENT', FALSE, TRUE,  'SW',  16, 'A', 1),
    ('DBK-017', 'SERVICE_CONSUMPTION','Service Consumption',       'STOCK_ADJUSTMENT', FALSE, TRUE,  'SC',  17, 'A', 1);

-- ---------------------------------------------------------
-- m_daybook_item seeds (voucher line templates)
--
-- role_key must exist in daybook_acc for the tenant/branch
-- being posted. The posting engine resolves role_key -> account_id
-- and uses amount_source to compute the amount.
-- ---------------------------------------------------------

-- SALE daybook
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-SALE-01', d.id, 1, 'CUSTOMER',        'Customer / Debtor',    'D', 'TOTAL',           FALSE, FALSE, 'CUSTOMER', 'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE' UNION ALL
SELECT 'DBI-SALE-02', d.id, 2, 'SALE_INCOME',     'Product Sales',        'C', 'PRODUCT_TAXABLE', TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE' UNION ALL
SELECT 'DBI-SALE-03', d.id, 3, 'SERVICE_INCOME',  'Service Income',       'C', 'SERVICE_TAXABLE', TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE' UNION ALL
SELECT 'DBI-SALE-04', d.id, 4, 'OUTPUT_TAX',      'Output Tax',           'C', 'PER_TAX',         TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE' UNION ALL
SELECT 'DBI-SALE-05', d.id, 5, 'DISCOUNT_GIVEN',  'Discount Allowed',     'D', 'DISCOUNT',        TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE' UNION ALL
SELECT 'DBI-SALE-06', d.id, 6, 'TIP_PAYABLE',     'Tip Payable to Staff', 'C', 'TIP',             TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE' UNION ALL
SELECT 'DBI-SALE-07', d.id, 7, 'ROUNDING',        'Rounding Off',         'C', 'ROUNDING',        TRUE,  TRUE,  NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE';

-- SALE_RETURN daybook
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-SRET-01', d.id, 1, 'SALES_RETURN',    'Sales Return',         'D', 'SUBTOTAL',        FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE_RETURN' UNION ALL
SELECT 'DBI-SRET-02', d.id, 2, 'OUTPUT_TAX',      'Output Tax Reversal',  'D', 'TAX',             TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE_RETURN' UNION ALL
SELECT 'DBI-SRET-03', d.id, 3, 'CUSTOMER',        'Customer Refund / Credit','C','TOTAL',         FALSE, FALSE, 'CUSTOMER', 'A', 1 FROM daybook_master d WHERE d.daybook_key = 'SALE_RETURN';

-- PURCHASE daybook
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-PUR-01',  d.id, 1, 'STOCK',           'Stock / Purchase',     'D', 'SUBTOTAL',        FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PURCHASE' UNION ALL
SELECT 'DBI-PUR-02',  d.id, 2, 'INPUT_TAX',       'Input Tax',            'D', 'TAX',             TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PURCHASE' UNION ALL
SELECT 'DBI-PUR-03',  d.id, 3, 'DISCOUNT_RECEIVED','Discount Received',   'C', 'DISCOUNT',        TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PURCHASE' UNION ALL
SELECT 'DBI-PUR-04',  d.id, 4, 'SUPPLIER',        'Supplier / Creditor',  'C', 'TOTAL',           FALSE, FALSE, 'SUPPLIER', 'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PURCHASE';

-- PURCHASE_RETURN daybook
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-PRET-01', d.id, 1, 'SUPPLIER',        'Supplier / Creditor',  'D', 'TOTAL',           FALSE, FALSE, 'SUPPLIER', 'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PURCHASE_RETURN' UNION ALL
SELECT 'DBI-PRET-02', d.id, 2, 'PURCHASE_RETURN', 'Purchase Return',      'C', 'SUBTOTAL',        FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PURCHASE_RETURN' UNION ALL
SELECT 'DBI-PRET-03', d.id, 3, 'INPUT_TAX',       'Input Tax Reversal',   'C', 'TAX',             TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PURCHASE_RETURN';

-- PAYMENT daybook (money out to supplier)
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-PAY-01',  d.id, 1, 'SUPPLIER',        'Supplier / Creditor',  'D', 'TOTAL',           FALSE, FALSE, 'SUPPLIER', 'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PAYMENT' UNION ALL
SELECT 'DBI-PAY-02',  d.id, 2, 'CASH',            'Cash / Bank',          'C', 'PER_TENDER',      FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'PAYMENT';

-- RECEIPT daybook (money in from customer)
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-RCP-01',  d.id, 1, 'CASH',            'Cash / Bank',          'D', 'PER_TENDER',      FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'RECEIPT' UNION ALL
SELECT 'DBI-RCP-02',  d.id, 2, 'CUSTOMER',        'Customer / Debtor',    'C', 'TOTAL',           FALSE, FALSE, 'CUSTOMER', 'A', 1 FROM daybook_master d WHERE d.daybook_key = 'RECEIPT' UNION ALL
SELECT 'DBI-RCP-03',  d.id, 3, 'TIP_PAYABLE',     'Tip Received',         'C', 'TIP',             TRUE,  FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'RECEIPT';

-- DEPOSIT daybook (customer advance)
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-DEP-01',  d.id, 1, 'CASH',            'Cash / Bank',          'D', 'PER_TENDER',      FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'DEPOSIT' UNION ALL
SELECT 'DBI-DEP-02',  d.id, 2, 'CUSTOMER',        'Customer Deposit (Liability)','C','TOTAL',     FALSE, FALSE, 'CUSTOMER', 'A', 1 FROM daybook_master d WHERE d.daybook_key = 'DEPOSIT';

-- REFUND daybook (money back to customer)
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-RFD-01',  d.id, 1, 'CUSTOMER',        'Customer / Debtor',    'D', 'TOTAL',           FALSE, FALSE, 'CUSTOMER', 'A', 1 FROM daybook_master d WHERE d.daybook_key = 'REFUND' UNION ALL
SELECT 'DBI-RFD-02',  d.id, 2, 'CASH',            'Cash / Bank',          'C', 'PER_TENDER',      FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'REFUND';

-- CONTRA daybook (cash/bank to cash/bank transfer)
INSERT INTO m_daybook_item (internal_id, daybook_id, line_seq, role_key, label, dr_cr, amount_source, is_optional, sign_flip, party_type, status, version)
SELECT 'DBI-CNT-01',  d.id, 1, 'CASH_TO',         'Cash / Bank (To)',     'D', 'TOTAL',           FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'CONTRA' UNION ALL
SELECT 'DBI-CNT-02',  d.id, 2, 'CASH_FROM',       'Cash / Bank (From)',   'C', 'TOTAL',           FALSE, FALSE, NULL,       'A', 1 FROM daybook_master d WHERE d.daybook_key = 'CONTRA';

-- JOURNAL daybook has no template — lines are fully user-supplied.
-- Stock-only daybooks (STK_TRF_*, STK_ADJUST, STK_OPENING, STK_WASTAGE,
-- SERVICE_CONSUMPTION) don't produce accounting entries, so no template rows.
