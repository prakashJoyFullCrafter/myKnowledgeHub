INSERT INTO tenants (internal_id,
                     tenant_code,
                     name,
                     legal_name,
                     country_id,
                     default_locale_id,
                     default_currency_id,
                     default_timezone_id,
                     status,
                     created_at,
                     updated_at,
                     version)
VALUES ('TNT-000001', -- internal_id
        'PEPBITS', -- tenant_code
        'pepbits.com', -- name
        'Pepbits Technologies', -- legal_name
        (select id from countries where country_code2 ='IN'), -- country_id  → update once countries seed is in
        NULL, -- default_locale_id → update once locales seed is in
        (select id from currencies where currency_code='INR'), -- default_currency_id → update once currencies seed is in
        NULL, -- default_timezone_id → update once timezones seed is in
        'A',
        NOW(),
        NOW(),
        1);


