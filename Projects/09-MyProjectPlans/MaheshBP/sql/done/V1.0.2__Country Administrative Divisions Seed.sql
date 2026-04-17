-- Seed data for country_administrative_divisions_types
-- Note: a truly complete global list is not stable because subdivision categories vary by country and change over time.
-- This script provides a broad, normalized master list of commonly used administrative division types.

INSERT INTO country_administrative_divisions_types
(internal_id, name, status, created_at, updated_at, created_by, updated_by, version)
VALUES ('ADM_DIV_TYPE_STATE', 'State', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_PROVINCE', 'Province', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_REGION', 'Region', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_DISTRICT', 'District', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_COUNTY', 'County', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_GOVERNORATE', 'Governorate', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_PREFECTURE', 'Prefecture', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_CANTON', 'Canton', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_EMIRATE', 'Emirate', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_PARISH', 'Parish', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_DEPARTMENT', 'Department', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_MUNICIPALITY', 'Municipality', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_COMMUNE', 'Commune', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_TERRITORY', 'Territory', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_AUTONOMOUS_REGION', 'Autonomous Region', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_AUTONOMOUS_REPUBLIC', 'Autonomous Republic', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_AUTONOMOUS_COMMUNITY', 'Autonomous Community', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_AUTONOMOUS_PROVINCE', 'Autonomous Province', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_AUTONOMOUS_DISTRICT', 'Autonomous District', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_FEDERAL_DISTRICT', 'Federal District', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_CAPITAL_DISTRICT', 'Capital District', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_SPECIAL_ADMINISTRATIVE_REGION', 'Special Administrative Region', 'A', NOW(), NOW(), NULL, NULL,
        1),
       ('ADM_DIV_TYPE_SPECIAL_REGION', 'Special Region', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_SPECIAL_CITY', 'Special City', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_METROPOLITAN_CITY', 'Metropolitan City', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_CITY', 'City', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_BOROUGH', 'Borough', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_TOWN', 'Town', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_TOWNSHIP', 'Township', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_VILLAGE', 'Village', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_SUBDISTRICT', 'Subdistrict', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_SUBCOUNTY', 'Subcounty', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_WARD', 'Ward', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_DIVISION', 'Division', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_DELEGATION', 'Delegation', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_OBLAST', 'Oblast', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_KRAI', 'Krai', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_OKRUG', 'Okrug', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_RAYON', 'Rayon', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_RAION', 'Raion', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_VOIVODESHIP', 'Voivodeship', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_LAND', 'Land', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_LANDKREIS', 'Landkreis', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_BEZIRK', 'Bezirk', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_ARRONDISSEMENT', 'Arrondissement', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_CIRCUMSCRIPTION', 'Circumscription', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_CONSTITUENCY', 'Constituency', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_CHIEFDOM', 'Chiefdom', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_ISLAND', 'Island', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_ATOLL', 'Atoll', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_DEPENDENCY', 'Dependency', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_ENTITY', 'Entity', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_REPUBLIC', 'Republic', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_KINGDOM', 'Kingdom', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_COMMONWEALTH', 'Commonwealth', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_LOCALITY', 'Locality', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_COMMUNITY', 'Community', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_QUARTER', 'Quarter', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_NEIGHBORHOOD', 'Neighborhood', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_SECTOR', 'Sector', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_ZONE', 'Zone', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_BLOCK', 'Block', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_CLAIM', 'Claim', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_RESORT', 'Resort', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_AREA', 'Area', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_SUBPREFECTURE', 'Subprefecture', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_PAYAM', 'Payam', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_BOMA', 'Boma', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_AIMAQ', 'Aimaq', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_MUKIM', 'Mukim', 'A', NOW(), NOW(), NULL, NULL, 1),
       ('ADM_DIV_TYPE_DIOCESE', 'Diocese', 'A', NOW(), NOW(), NULL, NULL, 1) ON CONFLICT (internal_id) DO
UPDATE SET
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by,
    version = country_administrative_divisions_types.version + 1;


INSERT INTO country_administrative_divisions_levels
    (internal_id, name, status, version)
VALUES ('ADMIN_LEVEL_1', 'Administrative Level 1', 'A', 1),
       ('ADMIN_LEVEL_2', 'Administrative Level 2', 'A', 1),
       ('ADMIN_LEVEL_3', 'Administrative Level 3', 'A', 1),
       ('ADMIN_LEVEL_4', 'Administrative Level 4', 'A', 1),
       ('ADMIN_LEVEL_5', 'Administrative Level 5', 'A', 1),
       ('ADMIN_LEVEL_6', 'Administrative Level 6', 'A', 1),
       ('ADMIN_LEVEL_7', 'Administrative Level 7', 'A', 1),
       ('ADMIN_LEVEL_8', 'Administrative Level 8', 'A', 1),
       ('ADMIN_LEVEL_9', 'Administrative Level 9', 'A', 1),
       ('ADMIN_LEVEL_10', 'Administrative Level 10', 'A', 1) ON CONFLICT (internal_id) DO
UPDATE
    SET
        name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions_levels.version + 1;


-- Sample seed data for country_administrative_divisions
-- Uses existing countries, country_administrative_divisions_types,
-- and country_administrative_divisions_levels tables.
--
-- This file seeds a practical starter set for selected countries.
-- It is intentionally not a complete worldwide administrative-divisions dataset.


-- UAE: 7 Emirates (Level 1)
INSERT INTO country_administrative_divisions
(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
SELECT v.internal_id,
       v.code,
       c.id,
       t.id,
       l.id,
       NULL,
       v.name,
       'A'
FROM (VALUES ('ARE_ABU_DHABI', 'AE-AZ', 'Abu Dhabi'),
             ('ARE_DUBAI', 'AE-DU', 'Dubai'),
             ('ARE_SHARJAH', 'AE-SH', 'Sharjah'),
             ('ARE_AJMAN', 'AE-AJ', 'Ajman'),
             ('ARE_UMM_AL_QUWAIN', 'AE-UQ', 'Umm Al Quwain'),
             ('ARE_RAS_AL_KHAIMAH', 'AE-RK', 'Ras Al Khaimah'),
             ('ARE_FUJAIRAH', 'AE-FU', 'Fujairah')) AS v(internal_id, code, name)
         CROSS JOIN countries c
         CROSS JOIN country_administrative_divisions_types t
         CROSS JOIN country_administrative_divisions_levels l
WHERE c.country_code3 = 'ARE'
  AND t.internal_id = 'EMIRATE'
  AND l.internal_id = 'ADMIN_LEVEL_1' ON CONFLICT (internal_id) DO
UPDATE SET
    code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions.version + 1;

-- USA: States + District of Columbia (Level 1)
INSERT INTO country_administrative_divisions
(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
SELECT 'USA_' || upper(replace(v.name, ' ', '_')),
       v.code,
       c.id,
       t.id,
       l.id,
       NULL,
       v.name,
       'A'
FROM (VALUES ('US-AL', 'Alabama'),
             ('US-AK', 'Alaska'),
             ('US-AZ', 'Arizona'),
             ('US-AR', 'Arkansas'),
             ('US-CA', 'California'),
             ('US-CO', 'Colorado'),
             ('US-CT', 'Connecticut'),
             ('US-DE', 'Delaware'),
             ('US-FL', 'Florida'),
             ('US-GA', 'Georgia'),
             ('US-HI', 'Hawaii'),
             ('US-ID', 'Idaho'),
             ('US-IL', 'Illinois'),
             ('US-IN', 'Indiana'),
             ('US-IA', 'Iowa'),
             ('US-KS', 'Kansas'),
             ('US-KY', 'Kentucky'),
             ('US-LA', 'Louisiana'),
             ('US-ME', 'Maine'),
             ('US-MD', 'Maryland'),
             ('US-MA', 'Massachusetts'),
             ('US-MI', 'Michigan'),
             ('US-MN', 'Minnesota'),
             ('US-MS', 'Mississippi'),
             ('US-MO', 'Missouri'),
             ('US-MT', 'Montana'),
             ('US-NE', 'Nebraska'),
             ('US-NV', 'Nevada'),
             ('US-NH', 'New Hampshire'),
             ('US-NJ', 'New Jersey'),
             ('US-NM', 'New Mexico'),
             ('US-NY', 'New York'),
             ('US-NC', 'North Carolina'),
             ('US-ND', 'North Dakota'),
             ('US-OH', 'Ohio'),
             ('US-OK', 'Oklahoma'),
             ('US-OR', 'Oregon'),
             ('US-PA', 'Pennsylvania'),
             ('US-RI', 'Rhode Island'),
             ('US-SC', 'South Carolina'),
             ('US-SD', 'South Dakota'),
             ('US-TN', 'Tennessee'),
             ('US-TX', 'Texas'),
             ('US-UT', 'Utah'),
             ('US-VT', 'Vermont'),
             ('US-VA', 'Virginia'),
             ('US-WA', 'Washington'),
             ('US-WV', 'West Virginia'),
             ('US-WI', 'Wisconsin'),
             ('US-WY', 'Wyoming'),
             ('US-DC', 'District of Columbia')) AS v(code, name)
         CROSS JOIN countries c
         CROSS JOIN country_administrative_divisions_types t
         CROSS JOIN country_administrative_divisions_levels l
WHERE c.country_code3 = 'USA'
  AND t.internal_id = 'STATE'
  AND l.internal_id = 'ADMIN_LEVEL_1' ON CONFLICT (internal_id) DO
UPDATE SET
    code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions.version + 1;

-- India: States + Union Territories (Level 1)
INSERT INTO country_administrative_divisions
(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
SELECT v.internal_id,
       v.code,
       c.id,
       CASE WHEN v.kind = 'STATE' THEN t_state.id ELSE t_ut.id END,
       l.id,
       NULL,
       v.name,
       'A'
FROM (VALUES ('IND_ANDHRA_PRADESH', 'IN-AP', 'Andhra Pradesh', 'STATE'),
             ('IND_ARUNACHAL_PRADESH', 'IN-AR', 'Arunachal Pradesh', 'STATE'),
             ('IND_ASSAM', 'IN-AS', 'Assam', 'STATE'),
             ('IND_BIHAR', 'IN-BR', 'Bihar', 'STATE'),
             ('IND_CHHATTISGARH', 'IN-CG', 'Chhattisgarh', 'STATE'),
             ('IND_GOA', 'IN-GA', 'Goa', 'STATE'),
             ('IND_GUJARAT', 'IN-GJ', 'Gujarat', 'STATE'),
             ('IND_HARYANA', 'IN-HR', 'Haryana', 'STATE'),
             ('IND_HIMACHAL_PRADESH', 'IN-HP', 'Himachal Pradesh', 'STATE'),
             ('IND_JHARKHAND', 'IN-JH', 'Jharkhand', 'STATE'),
             ('IND_KARNATAKA', 'IN-KA', 'Karnataka', 'STATE'),
             ('IND_KERALA', 'IN-KL', 'Kerala', 'STATE'),
             ('IND_MADHYA_PRADESH', 'IN-MP', 'Madhya Pradesh', 'STATE'),
             ('IND_MAHARASHTRA', 'IN-MH', 'Maharashtra', 'STATE'),
             ('IND_MANIPUR', 'IN-MN', 'Manipur', 'STATE'),
             ('IND_MEGHALAYA', 'IN-ML', 'Meghalaya', 'STATE'),
             ('IND_MIZORAM', 'IN-MZ', 'Mizoram', 'STATE'),
             ('IND_NAGALAND', 'IN-NL', 'Nagaland', 'STATE'),
             ('IND_ODISHA', 'IN-OD', 'Odisha', 'STATE'),
             ('IND_PUNJAB', 'IN-PB', 'Punjab', 'STATE'),
             ('IND_RAJASTHAN', 'IN-RJ', 'Rajasthan', 'STATE'),
             ('IND_SIKKIM', 'IN-SK', 'Sikkim', 'STATE'),
             ('IND_TAMIL_NADU', 'IN-TN', 'Tamil Nadu', 'STATE'),
             ('IND_TELANGANA', 'IN-TS', 'Telangana', 'STATE'),
             ('IND_TRIPURA', 'IN-TR', 'Tripura', 'STATE'),
             ('IND_UTTAR_PRADESH', 'IN-UP', 'Uttar Pradesh', 'STATE'),
             ('IND_UTTARAKHAND', 'IN-UK', 'Uttarakhand', 'STATE'),
             ('IND_WEST_BENGAL', 'IN-WB', 'West Bengal', 'STATE'),
             ('IND_ANDAMAN_AND_NICOBAR_ISLANDS', 'IN-AN', 'Andaman and Nicobar Islands', 'UNION_TERRITORY'),
             ('IND_CHANDIGARH', 'IN-CH', 'Chandigarh', 'UNION_TERRITORY'),
             ('IND_DADRA_AND_NAGAR_HAVELI_AND_DAMAN_AND_DIU', 'IN-DH', 'Dadra and Nagar Haveli and Daman and Diu',
              'UNION_TERRITORY'),
             ('IND_DELHI', 'IN-DL', 'Delhi', 'UNION_TERRITORY'),
             ('IND_JAMMU_AND_KASHMIR', 'IN-JK', 'Jammu and Kashmir', 'UNION_TERRITORY'),
             ('IND_LADAKH', 'IN-LA', 'Ladakh', 'UNION_TERRITORY'),
             ('IND_LAKSHADWEEP', 'IN-LD', 'Lakshadweep', 'UNION_TERRITORY'),
             ('IND_PUDUCHERRY', 'IN-PY', 'Puducherry', 'UNION_TERRITORY')) AS v(internal_id, code, name, kind)
         CROSS JOIN countries c
         CROSS JOIN country_administrative_divisions_types t_state
         CROSS JOIN country_administrative_divisions_types t_ut
         CROSS JOIN country_administrative_divisions_levels l
WHERE c.country_code3 = 'IND'
  AND t_state.internal_id = 'STATE'
  AND t_ut.internal_id = 'UNION_TERRITORY'
  AND l.internal_id = 'ADMIN_LEVEL_1' ON CONFLICT (internal_id) DO
UPDATE SET
    code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions.version + 1;

-- United Kingdom: Countries (Level 1)
INSERT INTO country_administrative_divisions
(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
SELECT v.internal_id,
       v.code,
       c.id,
       t.id,
       l.id,
       NULL,
       v.name,
       'A'
FROM (VALUES ('GBR_ENGLAND', 'GB-ENG', 'England'),
             ('GBR_SCOTLAND', 'GB-SCT', 'Scotland'),
             ('GBR_WALES', 'GB-WLS', 'Wales'),
             ('GBR_NORTHERN_IRELAND', 'GB-NIR', 'Northern Ireland')) AS v(internal_id, code, name)
         CROSS JOIN countries c
         CROSS JOIN country_administrative_divisions_types t
         CROSS JOIN country_administrative_divisions_levels l
WHERE c.country_code3 = 'GBR'
  AND t.internal_id = 'COUNTRY'
  AND l.internal_id = 'ADMIN_LEVEL_1' ON CONFLICT (internal_id) DO
UPDATE SET
    code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions.version + 1;

-- UAE: selected level-2 municipalities under emirates
INSERT INTO country_administrative_divisions
(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
SELECT v.internal_id,
       v.code,
       c.id,
       t.id,
       l.id,
       p.id,
       v.name,
       'A'
FROM (VALUES ('ARE_ABU_DHABI_MUNICIPALITY', 'AE-AZ-ADM', 'ARE_ABU_DHABI', 'Abu Dhabi Municipality'),
             ('ARE_AL_AIN_MUNICIPALITY', 'AE-AZ-AAN', 'ARE_ABU_DHABI', 'Al Ain Municipality'),
             ('ARE_DUBAI_MUNICIPALITY', 'AE-DU-DXB', 'ARE_DUBAI', 'Dubai Municipality'),
             ('ARE_SHARJAH_MUNICIPALITY', 'AE-SH-SHJ', 'ARE_SHARJAH', 'Sharjah Municipality'),
             ('ARE_AJMAN_MUNICIPALITY', 'AE-AJ-AJM', 'ARE_AJMAN', 'Ajman Municipality'),
             ('ARE_RAS_AL_KHAIMAH_MUNICIPALITY', 'AE-RK-RAK', 'ARE_RAS_AL_KHAIMAH', 'Ras Al Khaimah Municipality'),
             ('ARE_FUJAIRAH_MUNICIPALITY', 'AE-FU-FJR', 'ARE_FUJAIRAH',
              'Fujairah Municipality')) AS v(internal_id, code, parent_internal_id, name)
         JOIN countries c
              ON c.country_code3 = 'ARE'
         JOIN country_administrative_divisions_types t
              ON lower(t.name) = lower('Municipality')
         JOIN country_administrative_divisions_levels l
              ON lower(l.name) = lower('Administrative Level 2')
         JOIN country_administrative_divisions p
              ON p.internal_id = v.parent_internal_id
                  AND p.country_id = c.id ON CONFLICT (internal_id) DO
UPDATE SET
    code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions.version + 1;

-- USA: selected counties under selected states
INSERT INTO country_administrative_divisions
(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
SELECT v.internal_id,
       v.code,
       c.id,
       t.id,
       l.id,
       p.id,
       v.name,
       'A'
FROM (VALUES ('USA_CALIFORNIA_LOS_ANGELES_COUNTY', 'US-CA-LA', 'USA_CALIFORNIA', 'Los Angeles County'),
             ('USA_CALIFORNIA_ORANGE_COUNTY', 'US-CA-ORA', 'USA_CALIFORNIA', 'Orange County'),
             ('USA_CALIFORNIA_SAN_DIEGO_COUNTY', 'US-CA-SDG', 'USA_CALIFORNIA', 'San Diego County'),
             ('USA_TEXAS_HARRIS_COUNTY', 'US-TX-HAR', 'USA_TEXAS', 'Harris County'),
             ('USA_TEXAS_DALLAS_COUNTY', 'US-TX-DAL', 'USA_TEXAS', 'Dallas County'),
             ('USA_TEXAS_TRAVIS_COUNTY', 'US-TX-TRV', 'USA_TEXAS', 'Travis County'),
             ('USA_NEW_YORK_NEW_YORK_COUNTY', 'US-NY-NYC', 'USA_NEW_YORK', 'New York County'),
             ('USA_NEW_YORK_KINGS_COUNTY', 'US-NY-KIN', 'USA_NEW_YORK', 'Kings County'),
             ('USA_NEW_YORK_QUEENS_COUNTY', 'US-NY-QUE', 'USA_NEW_YORK',
              'Queens County')) AS v(internal_id, code, parent_internal_id, name)
         JOIN countries c
              ON c.country_code3 = 'USA'
         JOIN country_administrative_divisions_types t
              ON lower(t.name) = lower('County')
         JOIN country_administrative_divisions_levels l
              ON lower(l.name) = lower('Administrative Level 2')
         JOIN country_administrative_divisions p
              ON p.internal_id = v.parent_internal_id
                  AND p.country_id = c.id ON CONFLICT (internal_id) DO
UPDATE SET
    code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions.version + 1;

-- India: selected districts under selected states / union territories
INSERT INTO country_administrative_divisions
(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
SELECT v.internal_id,
       v.code,
       c.id,
       t.id,
       l.id,
       p.id,
       v.name,
       'A'
FROM (VALUES ('IND_MAHARASHTRA_MUMBAI_DISTRICT', 'IN-MH-MUM', 'IND_MAHARASHTRA', 'Mumbai District'),
             ('IND_MAHARASHTRA_PUNE_DISTRICT', 'IN-MH-PUN', 'IND_MAHARASHTRA', 'Pune District'),
             ('IND_MAHARASHTRA_NAGPUR_DISTRICT', 'IN-MH-NAG', 'IND_MAHARASHTRA', 'Nagpur District'),
             ('IND_KARNATAKA_BENGALURU_URBAN_DISTRICT', 'IN-KA-BGU', 'IND_KARNATAKA', 'Bengaluru Urban District'),
             ('IND_KARNATAKA_MYSURU_DISTRICT', 'IN-KA-MYS', 'IND_KARNATAKA', 'Mysuru District'),
             ('IND_DELHI_CENTRAL_DELHI_DISTRICT', 'IN-DL-CDL', 'IND_DELHI', 'Central Delhi District'),
             ('IND_DELHI_NEW_DELHI_DISTRICT', 'IN-DL-NDL', 'IND_DELHI', 'New Delhi District'),
             ('IND_DELHI_SOUTH_DELHI_DISTRICT', 'IN-DL-SDL', 'IND_DELHI',
              'South Delhi District')) AS v(internal_id, code, parent_internal_id, name)
         JOIN countries c
              ON c.country_code3 = 'IND'
         JOIN country_administrative_divisions_types t
              ON lower(t.name) = lower('District')
         JOIN country_administrative_divisions_levels l
              ON lower(l.name) = lower('Administrative Level 2')
         JOIN country_administrative_divisions p
              ON p.internal_id = v.parent_internal_id
                  AND p.country_id = c.id ON CONFLICT (internal_id) DO
UPDATE SET
    code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions.version + 1;

-- United Kingdom: selected ceremonial/metropolitan counties under England
INSERT INTO country_administrative_divisions
(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
SELECT v.internal_id,
       v.code,
       c.id,
       t.id,
       l.id,
       p.id,
       v.name,
       'A'
FROM (VALUES ('GBR_ENGLAND_GREATER_LONDON', 'GB-ENG-GLN', 'GBR_ENGLAND', 'Greater London'),
             ('GBR_ENGLAND_GREATER_MANCHESTER', 'GB-ENG-GMN', 'GBR_ENGLAND', 'Greater Manchester'),
             ('GBR_ENGLAND_WEST_MIDLANDS', 'GB-ENG-WMD', 'GBR_ENGLAND',
              'West Midlands')) AS v(internal_id, code, parent_internal_id, name)
         JOIN countries c
              ON c.country_code3 = 'GBR'
         JOIN country_administrative_divisions_types t
              ON lower(t.name) = lower('County')
         JOIN country_administrative_divisions_levels l
              ON lower(l.name) = lower('Administrative Level 2')
         JOIN country_administrative_divisions p
              ON p.internal_id = v.parent_internal_id
                  AND p.country_id = c.id ON CONFLICT (internal_id) DO
UPDATE SET
    code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    version = country_administrative_divisions.version + 1;



INSERT INTO country_administrative_divisions
(internal_id,
 code,
 country_id,
 type_id,
 level_id,
 parent_id,
 name,
 status,
 created_at,
 updated_at,
 created_by,
 updated_by,
 version)
SELECT v.internal_id,
       v.code,
       c.id,
       t.id,
       l.id,
       p.id,
       v.name,
       'A',
       NOW(),
       NOW(),
       NULL,
       NULL,
       1
FROM (VALUES
          -- Dubai Municipality
          ('UAE-DU-AREA-DEIRA', 'UAE-DU-DEIRA', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Dubai Municipality', 'Deira'),
          ('UAE-DU-AREA-BUR_DUBAI', 'UAE-DU-BURDUBAI', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Dubai Municipality',
           'Bur Dubai'),
          ('UAE-DU-AREA-JUMEIRAH', 'UAE-DU-JUMEIRAH', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Dubai Municipality', 'Jumeirah'),
          ('UAE-DU-AREA-DUBAI_MARINA', 'UAE-DU-MARINA', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Dubai Municipality',
           'Dubai Marina'),
          ('UAE-DU-AREA-BUSINESS_BAY', 'UAE-DU-BUSINESSBAY', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Dubai Municipality',
           'Business Bay'),
          ('UAE-DU-AREA-AL_BARSHA', 'UAE-DU-ALBARSHA', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Dubai Municipality',
           'Al Barsha'),

          -- Abu Dhabi Municipality
          ('UAE-AD-AREA-KHALIDIYA', 'UAE-AD-KHALIDIYA', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Abu Dhabi Municipality',
           'Al Khalidiyah'),
          ('UAE-AD-AREA-AL_BATEEN', 'UAE-AD-ALBATEEN', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Abu Dhabi Municipality',
           'Al Bateen'),
          ('UAE-AD-AREA-AL_MUSHRIF', 'UAE-AD-ALMUSHRIF', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Abu Dhabi Municipality',
           'Al Mushrif'),
          ('UAE-AD-AREA-MOHAMED_BIN_ZAYED', 'UAE-AD-MBZCITY', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Abu Dhabi Municipality',
           'Mohamed Bin Zayed City'),
          ('UAE-AD-AREA-KHALIFA_CITY', 'UAE-AD-KHALIFACITY', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Abu Dhabi Municipality',
           'Khalifa City'),

          -- Al Ain Municipality
          ('UAE-AA-AREA-AL_JIMI', 'UAE-AA-ALJIMI', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Al Ain Municipality', 'Al Jimi'),
          ('UAE-AA-AREA-AL_MUTARAD', 'UAE-AA-ALMUTARAD', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Al Ain Municipality',
           'Al Mutarad'),
          ('UAE-AA-AREA-AL_MAQAM', 'UAE-AA-ALMAQAM', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Al Ain Municipality', 'Al Maqam'),

          -- Sharjah Municipality
          ('UAE-SHJ-AREA-AL_MAJAZ', 'UAE-SHJ-ALMAJAZ', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Sharjah Municipality',
           'Al Majaz'),
          ('UAE-SHJ-AREA-AL_NAHDA', 'UAE-SHJ-ALNAHDA', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Sharjah Municipality',
           'Al Nahda'),
          ('UAE-SHJ-AREA-AL_QASIMIYA', 'UAE-SHJ-ALQASIMIYA', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Sharjah Municipality',
           'Al Qasimia'),

          -- Ajman Municipality
          ('UAE-AJM-AREA-AL_NUAIMIYA', 'UAE-AJM-ALNUAIMIYA', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Ajman Municipality',
           'Al Nuaimiya'),
          ('UAE-AJM-AREA-AL_JURF', 'UAE-AJM-ALJURF', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Ajman Municipality', 'Al Jurf'),

          -- Ras Al Khaimah Municipality
          ('UAE-RAK-AREA-AL_NAKHEEL', 'UAE-RAK-ALNAKHEEL', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Ras Al Khaimah Municipality',
           'Al Nakheel'),
          ('UAE-RAK-AREA-AL_DHAITH', 'UAE-RAK-ALDHAITH', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Ras Al Khaimah Municipality',
           'Al Dhaith'),

          -- Fujairah Municipality
          ('UAE-FUJ-AREA-MADHAB', 'UAE-FUJ-MADHAB', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Fujairah Municipality', 'Madhab'),
          ('UAE-FUJ-AREA-AL_FASEEL', 'UAE-FUJ-ALFASEEL', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Fujairah Municipality',
           'Al Faseel'),

          -- Umm Al Quwain Municipality
          ('UAE-UAQ-AREA-AL_SALAMAH', 'UAE-UAQ-ALSALAMAH', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Umm Al Quwain Municipality',
           'Al Salamah'),

          -- Khor Fakkan Municipality
          ('UAE-KFK-AREA-HAY_ALHARAY', 'UAE-KFK-HAYALHARAY', 'AE', 'AREA', 'ADMIN_LEVEL_3', 'Khor Fakkan Municipality',
           'Hay Al Haray')) AS v(internal_id, code, country_code2, type_name, level_name, parent_name, name)
         JOIN countries c
              ON c.country_code2 = v.country_code2
         JOIN country_administrative_divisions_types t
              ON UPPER(t.name) = UPPER(v.type_name)
         JOIN country_administrative_divisions_levels l
              ON UPPER(l.name) = UPPER(v.level_name)
         JOIN country_administrative_divisions p
              ON p.country_id = c.id
                  AND p.name = v.parent_name ON CONFLICT (internal_id) DO
UPDATE
    SET
        code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by,
    version = country_administrative_divisions.version + 1;

-- =========================
-- India - Level 3
-- Using TEHSIL / TALUK / SUBDISTRICT style child divisions under districts
-- =========================

INSERT INTO country_administrative_divisions
(internal_id,
 code,
 country_id,
 type_id,
 level_id,
 parent_id,
 name,
 status,
 created_at,
 updated_at,
 created_by,
 updated_by,
 version)
SELECT v.internal_id,
       v.code,
       c.id,
       t.id,
       l.id,
       p.id,
       v.name,
       'A',
       NOW(),
       NOW(),
       NULL,
       NULL,
       1
FROM (VALUES
          -- Delhi district children
          ('IND-DL-ND-TEHSIL-CHANAKYAPURI', 'IND-DL-ND-CHANAKYAPURI', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'New Delhi',
           'Chanakyapuri'),
          ('IND-DL-ND-TEHSIL-VASANT_VIHAR', 'IND-DL-ND-VASANTVIHAR', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'New Delhi',
           'Vasant Vihar'),
          ('IND-DL-CD-TEHSIL-DARYAGANJ', 'IND-DL-CD-DARYAGANJ', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Central Delhi',
           'Daryaganj'),
          ('IND-DL-SD-TEHSIL-SAKET', 'IND-DL-SD-SAKET', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'South Delhi', 'Saket'),

          -- Maharashtra districts
          ('IND-MH-MUM-TEHSIL-ANDHERI', 'IND-MH-MUM-ANDHERI', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Mumbai', 'Andheri'),
          ('IND-MH-MUM-TEHSIL-KURLA', 'IND-MH-MUM-KURLA', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Mumbai', 'Kurla'),
          ('IND-MH-PUN-TEHSIL-HAVELI', 'IND-MH-PUN-HAVELI', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Pune', 'Haveli'),
          ('IND-MH-PUN-TEHSIL-MAWAL', 'IND-MH-PUN-MAWAL', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Pune', 'Mawal'),
          ('IND-MH-NAG-TEHSIL-NAGPUR_URBAN', 'IND-MH-NAG-URBAN', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Nagpur',
           'Nagpur Urban'),

          -- Karnataka districts
          ('IND-KA-BLRU-TALUK-BANGALORE_NORTH', 'IND-KA-BLRU-NORTH', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Bengaluru Urban',
           'Bangalore North'),
          ('IND-KA-BLRU-TALUK-BANGALORE_SOUTH', 'IND-KA-BLRU-SOUTH', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Bengaluru Urban',
           'Bangalore South'),
          ('IND-KA-BLRU-TALUK-ANEKAL', 'IND-KA-BLRU-ANEKAL', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Bengaluru Urban',
           'Anekal'),
          ('IND-KA-MYS-TALUK-MYSURU', 'IND-KA-MYS-MYSURU', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Mysuru', 'Mysuru'),
          ('IND-KA-MYS-TALUK-HUNSUR', 'IND-KA-MYS-HUNSUR', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Mysuru', 'Hunsur'),

          -- Tamil Nadu districts
          ('IND-TN-CHE-TALUK-MAMBALAM', 'IND-TN-CHE-MAMBALAM', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Chennai', 'Mambalam'),
          ('IND-TN-CHE-TALUK-EGMORE', 'IND-TN-CHE-EGMORE', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Chennai', 'Egmore'),
          ('IND-TN-CBE-TALUK-COIMBATORE_NORTH', 'IND-TN-CBE-NORTH', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Coimbatore',
           'Coimbatore North'),
          ('IND-TN-CBE-TALUK-POLLACHI', 'IND-TN-CBE-POLLACHI', 'IN', 'TALUK', 'ADMIN_LEVEL_3', 'Coimbatore',
           'Pollachi'),

          -- Uttar Pradesh districts
          ('IND-UP-LKO-TEHSIL-BAKSHI_KA_TALAB', 'IND-UP-LKO-BKT', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Lucknow',
           'Bakshi Ka Talab'),
          ('IND-UP-LKO-TEHSIL-MALIHABAD', 'IND-UP-LKO-MALIHABAD', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Lucknow',
           'Malihabad'),
          ('IND-UP-VNS-TEHSIL-PINDRA', 'IND-UP-VNS-PINDRA', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Varanasi', 'Pindra'),
          ('IND-UP-VNS-TEHSIL-RAJA_TALAB', 'IND-UP-VNS-RAJATALAB', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Varanasi',
           'Raja Talab'),

          -- Gujarat districts
          ('IND-GJ-AHD-TALUK-AHMEDABAD_CITY', 'IND-GJ-AHD-CITY', 'IN', 'TALUKA', 'ADMIN_LEVEL_3', 'Ahmedabad',
           'Ahmedabad City'),
          ('IND-GJ-AHD-TALUK-DASKROI', 'IND-GJ-AHD-DASKROI', 'IN', 'TALUKA', 'ADMIN_LEVEL_3', 'Ahmedabad', 'Daskroi'),
          ('IND-GJ-SRT-TALUK-CHORYASI', 'IND-GJ-SRT-CHORYASI', 'IN', 'TALUKA', 'ADMIN_LEVEL_3', 'Surat', 'Choryasi'),
          ('IND-GJ-SRT-TALUK-OLPAD', 'IND-GJ-SRT-OLPAD', 'IN', 'TALUKA', 'ADMIN_LEVEL_3', 'Surat', 'Olpad'),

          -- Rajasthan districts
          ('IND-RJ-JPR-TEHSIL-SANGANER', 'IND-RJ-JPR-SANGANER', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Jaipur', 'Sanganer'),
          ('IND-RJ-JPR-TEHSIL-AMBER', 'IND-RJ-JPR-AMBER', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Jaipur', 'Amber'),
          ('IND-RJ-UDR-TEHSIL-GIRWA', 'IND-RJ-UDR-GIRWA', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Udaipur', 'Girwa'),

          -- Telangana districts
          ('IND-TS-HYD-TEHSIL-AMBERPET', 'IND-TS-HYD-AMBERPET', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Hyderabad',
           'Amberpet'),
          ('IND-TS-HYD-TEHSIL-NAMPALLY', 'IND-TS-HYD-NAMPALLY', 'IN', 'TEHSIL', 'ADMIN_LEVEL_3', 'Hyderabad',
           'Nampally'),

          -- West Bengal districts
          ('IND-WB-KOL-SUBDISTRICT-ALIPORE', 'IND-WB-KOL-ALIPORE', 'IN', 'SUBDISTRICT', 'ADMIN_LEVEL_3', 'Kolkata',
           'Alipore'),
          ('IND-WB-KOL-SUBDISTRICT-BALLYGUNGE', 'IND-WB-KOL-BALLYGUNGE', 'IN', 'SUBDISTRICT', 'ADMIN_LEVEL_3',
           'Kolkata', 'Ballygunge')) AS v(internal_id, code, country_code2, type_name, level_name, parent_name, name)
         JOIN countries c
              ON c.country_code2 = v.country_code2
         JOIN country_administrative_divisions_types t
              ON UPPER(t.name) = UPPER(v.type_name)
         JOIN country_administrative_divisions_levels l
              ON UPPER(l.name) = UPPER(v.level_name)
         JOIN country_administrative_divisions p
              ON p.country_id = c.id
                  AND p.name = v.parent_name ON CONFLICT (internal_id) DO
UPDATE
    SET
        code = EXCLUDED.code,
    country_id = EXCLUDED.country_id,
    type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name,
    status = EXCLUDED.status,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by,
    version = country_administrative_divisions.version + 1;



INSERT INTO cities
(internal_id,
 country_id,
 state_id,
 name,
 latitude,
 longitude,
 timezone_id,
 status,
 created_at,
 updated_at,
 created_by,
 updated_by,
 version)
SELECT v.internal_id,
       c.id,
       s.id,
       v.name,
       v.latitude,
       v.longitude,
       tz.id,
       'A',
       NOW(),
       NOW(),
       NULL,
       NULL,
       1
FROM (VALUES
          -- UAE
          ('CITY-UAE-ABU_DHABI', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.45388400, 54.37734400, 'Asia/Dubai'),
          ('CITY-UAE-AL_AIN', 'AE', 'Abu Dhabi', 'Al Ain', 24.20750000, 55.74472200, 'Asia/Dubai'),
          ('CITY-UAE-DUBAI', 'AE', 'Dubai', 'Dubai', 25.20484900, 55.27078300, 'Asia/Dubai'),
          ('CITY-UAE-SHARJAH', 'AE', 'Sharjah', 'Sharjah', 25.34625500, 55.42093200, 'Asia/Dubai'),

          -- India
          ('CITY-IND-BENGALURU', 'IN', 'Karnataka', 'Bengaluru', 12.97159900, 77.59456600, 'Asia/Kolkata'),
          ('CITY-IND-KOCHI', 'IN', 'Kerala', 'Kochi', 9.93123300, 76.26730300, 'Asia/Kolkata'),
          ('CITY-IND-ERNAKULAM', 'IN', 'Kerala', 'Ernakulam', 10.00000000, 76.30000000, 'Asia/Kolkata'),
          ('CITY-IND-MUMBAI', 'IN', 'Maharashtra', 'Mumbai', 19.07609000, 72.87742600,
           'Asia/Kolkata')) AS v(internal_id, country_code2, state_name, name, latitude, longitude, timezone_name)
         JOIN countries c
              ON c.country_code2 = v.country_code2
         LEFT JOIN country_administrative_divisions s
                   ON s.country_id = c.id
                       AND s.name = v.state_name
         LEFT JOIN timezones tz
                   ON tz.name = v.timezone_name ON CONFLICT (internal_id) DO
UPDATE
    SET
        country_id = EXCLUDED.country_id,
    state_id = EXCLUDED.state_id,
    name = EXCLUDED.name,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    timezone_id = EXCLUDED.timezone_id,
    status = EXCLUDED.status,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by,
    version = cities.version + 1;

-- =========================
-- LOCALITIES
-- =========================
INSERT INTO localities
(internal_id,
 country_id,
 state_id,
 city_id,
 latitude,
 longitude,
 name,
 timezone_id,
 status,
 created_at,
 updated_at,
 created_by,
 updated_by,
 version)
SELECT v.internal_id,
       c.id,
       s.id,
       ci.id,
       v.latitude,
       v.longitude,
       v.name,
       tz.id,
       'A',
       NOW(),
       NOW(),
       NULL,
       NULL,
       1
FROM (VALUES
          -- Abu Dhabi
          ('LOC-UAE-ABU_DHABI-AL_BATEEN', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.42830000, 54.35110000, 'Al Bateen',
           'Asia/Dubai'),
          ('LOC-UAE-ABU_DHABI-AL_KHALIDIYAH', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.47080000, 54.34470000, 'Al Khalidiyah',
           'Asia/Dubai'),
          ('LOC-UAE-ABU_DHABI-KHALIFA_CITY', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.42590000, 54.57750000, 'Khalifa City',
           'Asia/Dubai'),
          ('LOC-UAE-ABU_DHABI-MBZ_CITY', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.32370000, 54.54840000,
           'Mohamed Bin Zayed City', 'Asia/Dubai'),

          -- Dubai
          ('LOC-UAE-DUBAI-DEIRA', 'AE', 'Dubai', 'Dubai', 25.26970000, 55.30880000, 'Deira', 'Asia/Dubai'),
          ('LOC-UAE-DUBAI-BUR_DUBAI', 'AE', 'Dubai', 'Dubai', 25.25480000, 55.29220000, 'Bur Dubai', 'Asia/Dubai'),
          ('LOC-UAE-DUBAI-JUMEIRAH', 'AE', 'Dubai', 'Dubai', 25.20480000, 55.24240000, 'Jumeirah', 'Asia/Dubai'),

          -- Bengaluru
          ('LOC-IND-BENGALURU-WHITEFIELD', 'IN', 'Karnataka', 'Bengaluru', 12.96980000, 77.75000000, 'Whitefield',
           'Asia/Kolkata'),
          ('LOC-IND-BENGALURU-INDIRANAGAR', 'IN', 'Karnataka', 'Bengaluru', 12.97840000, 77.64080000, 'Indiranagar',
           'Asia/Kolkata'),
          ('LOC-IND-BENGALURU-KORAMANGALA', 'IN', 'Karnataka', 'Bengaluru', 12.93520000, 77.62450000, 'Koramangala',
           'Asia/Kolkata'),
          ('LOC-IND-BENGALURU-JAYANAGAR', 'IN', 'Karnataka', 'Bengaluru', 12.92500000, 77.59380000, 'Jayanagar',
           'Asia/Kolkata'),

          -- Kochi
          ('LOC-IND-KOCHI-FORT_KOCHI', 'IN', 'Kerala', 'Kochi', 9.96670000, 76.24250000, 'Fort Kochi', 'Asia/Kolkata'),
          ('LOC-IND-KOCHI-KALOOR', 'IN', 'Kerala', 'Kochi', 9.99460000, 76.29170000, 'Kaloor', 'Asia/Kolkata'),
          ('LOC-IND-KOCHI-EDAPPALLY', 'IN', 'Kerala', 'Kochi', 10.02770000, 76.30890000, 'Edappally', 'Asia/Kolkata'),
          ('LOC-IND-KOCHI-TRIPUNITHURA', 'IN', 'Kerala', 'Kochi', 9.94970000, 76.34950000, 'Tripunithura',
           'Asia/Kolkata'),

          -- Mumbai
          ('LOC-IND-MUMBAI-ANDHERI', 'IN', 'Maharashtra', 'Mumbai', 19.11970000, 72.84680000, 'Andheri',
           'Asia/Kolkata'),
          ('LOC-IND-MUMBAI-BANDRA', 'IN', 'Maharashtra', 'Mumbai', 19.05960000, 72.82950000, 'Bandra',
           'Asia/Kolkata')) AS v(internal_id, country_code2, state_name, city_name, latitude, longitude, name,
                                 timezone_name)
         JOIN countries c
              ON c.country_code2 = v.country_code2
         LEFT JOIN country_administrative_divisions s
                   ON s.country_id = c.id
                       AND s.name = v.state_name
         JOIN cities ci
              ON ci.country_id = c.id
                  AND ci.name = v.city_name
         LEFT JOIN timezones tz
                   ON tz.name = v.timezone_name ON CONFLICT (internal_id) DO
UPDATE
    SET
        country_id = EXCLUDED.country_id,
    state_id = EXCLUDED.state_id,
    city_id = EXCLUDED.city_id,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    name = EXCLUDED.name,
    timezone_id = EXCLUDED.timezone_id,
    status = EXCLUDED.status,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by,
    version = localities.version + 1;

-- =========================
-- POSTAL CODES
-- =========================
INSERT INTO postal_codes
(internal_id,
 country_id,
 city_id,
 locality_id,
 postal_code,
 status,
 created_at,
 updated_at,
 created_by,
 updated_by,
 version)
SELECT v.internal_id,
       c.id,
       ci.id,
       l.id,
       v.postal_code,
       'A',
       NOW(),
       NOW(),
       NULL,
       NULL,
       1
FROM (VALUES
          -- UAE sample / test-style placeholders
          ('PC-UAE-ABU_DHABI-GENERAL', 'AE', 'Abu Dhabi', 'Al Khalidiyah', '00000'),
          ('PC-UAE-DUBAI-GENERAL', 'AE', 'Dubai', 'Deira', '00000'),

          -- Bengaluru
          ('PC-IND-BENGALURU-WHITEFIELD', 'IN', 'Bengaluru', 'Whitefield', '560066'),
          ('PC-IND-BENGALURU-INDIRANAGAR', 'IN', 'Bengaluru', 'Indiranagar', '560038'),
          ('PC-IND-BENGALURU-KORAMANGALA', 'IN', 'Bengaluru', 'Koramangala', '560034'),
          ('PC-IND-BENGALURU-JAYANAGAR', 'IN', 'Bengaluru', 'Jayanagar', '560041'),

          -- Kochi
          ('PC-IND-KOCHI-FORT_KOCHI', 'IN', 'Kochi', 'Fort Kochi', '682001'),
          ('PC-IND-KOCHI-KALOOR', 'IN', 'Kochi', 'Kaloor', '682017'),
          ('PC-IND-KOCHI-EDAPPALLY', 'IN', 'Kochi', 'Edappally', '682024'),
          ('PC-IND-KOCHI-TRIPUNITHURA', 'IN', 'Kochi', 'Tripunithura', '682301'),

          -- Mumbai
          ('PC-IND-MUMBAI-ANDHERI', 'IN', 'Mumbai', 'Andheri', '400053'),
          ('PC-IND-MUMBAI-BANDRA', 'IN', 'Mumbai', 'Bandra',
           '400050')) AS v(internal_id, country_code2, city_name, locality_name, postal_code)
         JOIN countries c
              ON c.country_code2 = v.country_code2
         JOIN cities ci
              ON ci.country_id = c.id
                  AND ci.name = v.city_name
         LEFT JOIN localities l
                   ON l.country_id = c.id
                       AND l.city_id = ci.id
                       AND l.name = v.locality_name ON CONFLICT (internal_id) DO
UPDATE
    SET
        country_id = EXCLUDED.country_id,
    city_id = EXCLUDED.city_id,
    locality_id = EXCLUDED.locality_id,
    postal_code = EXCLUDED.postal_code,
    status = EXCLUDED.status,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by,
    version = postal_codes.version + 1;