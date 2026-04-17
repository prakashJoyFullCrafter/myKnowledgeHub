set
search_path to core;


CREATE OR REPLACE FUNCTION resolve_service_price(
    p_tenant_id        BIGINT,
    p_service_id       BIGINT,
    p_branch_id        BIGINT,
    p_customer_tier_id INT,
    p_booking_date     DATE DEFAULT CURRENT_DATE
) RETURNS NUMERIC(12,2) AS $$
DECLARE
v_business_id      BIGINT;
    v_business_tier_id INT;
    v_price            NUMERIC(12,2);
BEGIN
    -- Get business + tier from branch
SELECT b.business_id, bz.business_tier_id
INTO v_business_id, v_business_tier_id
FROM branches b
         JOIN businesses bz ON bz.id = b.business_id
WHERE b.id = p_branch_id;

-- Find the highest-precedence matching rule
SELECT price INTO v_price
FROM service_price_rules
WHERE tenant_id  = p_tenant_id
  AND service_id = p_service_id
  AND status     = 'A'
  AND p_booking_date BETWEEN valid_from AND COALESCE(valid_until, DATE '9999-12-31')
  AND (
    (branch_id = p_branch_id)
        OR (business_id = v_business_id AND branch_id IS NULL)
        OR (business_tier_id = v_business_tier_id AND business_id IS NULL AND branch_id IS NULL)
        OR (pricing_scope_id = 1 /* TENANT */)
    )
  AND (customer_tier_id = p_customer_tier_id OR customer_tier_id IS NULL)
ORDER BY
    -- Scope specificity
    CASE
        WHEN branch_id        IS NOT NULL THEN 4
        WHEN business_id      IS NOT NULL THEN 3
        WHEN business_tier_id IS NOT NULL THEN 2
        ELSE 1
        END DESC,
    -- Customer tier specificity
    (customer_tier_id IS NOT NULL) DESC,
    -- Explicit priority tie-breaker
    priority DESC,
    -- Newest rule wins
    valid_from DESC
    LIMIT 1;

-- Fallback to base_price
IF v_price IS NULL THEN
SELECT base_price INTO v_price FROM service_master WHERE id = p_service_id;
END IF;

RETURN v_price;
END;
$$ LANGUAGE plpgsql STABLE;