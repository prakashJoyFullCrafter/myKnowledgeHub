
INSERT INTO subscription_plans (internal_id, plan_key, name, description, price_monthly, price_annually, currency_id,
                                branch_limit, staff_limit, booking_limit_monthly, commission_rate, feature_flags,
                                display_order, status, version)
VALUES ('SUB-PLN-001', 'STARTER', 'Starter', 'For small single-branch businesses', 49.00, 490.00, 1, 1, 5, 200, 0.08, '{
  "reports": false,
  "promotions": false,
  "api_access": false,
  "home_service": false,
  "advanced_analytics": false
}', 1, 'A', 1),
       ('SUB-PLN-002', 'GROWTH', 'Growth', 'For growing businesses with more branches', 99.00, 990.00, 1, 3, 15, 1000,
        0.06, '{
         "reports": true,
         "promotions": true,
         "api_access": false,
         "home_service": true,
         "advanced_analytics": false
       }', 2, 'A', 1),
       ('SUB-PLN-003', 'PRO', 'Pro', 'For established multi-branch operations', 199.00, 1990.00, 1, 10, 50, 5000, 0.04,
        '{
          "reports": true,
          "promotions": true,
          "api_access": true,
          "home_service": true,
          "advanced_analytics": true
        }', 3, 'A', 1),
       ('SUB-PLN-004', 'ENTERPRISE', 'Enterprise', 'For large chains and franchise operators', NULL, NULL, 1, NULL,
        NULL, NULL, 0.02, '{
         "reports": true,
         "promotions": true,
         "api_access": true,
         "home_service": true,
         "advanced_analytics": true
       }', 4, 'A', 1);