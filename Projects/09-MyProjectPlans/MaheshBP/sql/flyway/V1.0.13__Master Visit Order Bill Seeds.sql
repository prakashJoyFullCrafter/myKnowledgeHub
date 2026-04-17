set
search_path to core;

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