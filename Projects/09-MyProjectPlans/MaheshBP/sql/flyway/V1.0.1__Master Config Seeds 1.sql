set
search_path to core;

INSERT INTO m_timezone (internal_id, timezone_key, name, utc_offset, status, created_at, updated_at, version)
VALUES ('TZ-001', 'Asia/Dubai', 'Gulf Standard Time', '+05:30', 'A', NOW(), NOW(), 1),
       ('TZ-002', 'Asia/Kolkata', 'India Standard Time', '+04:00', 'A', NOW(), NOW(), 1);

INSERT INTO m_country (internal_id, country_code2, country_code3, country_code_numeric, name)
VALUES ('country_af', 'AF', 'AFG', 4, 'Afghanistan'),
       ('country_al', 'AL', 'ALB', 8, 'Albania'),
       ('country_dz', 'DZ', 'DZA', 12, 'Algeria'),
       ('country_as', 'AS', 'ASM', 16, 'American Samoa'),
       ('country_ad', 'AD', 'AND', 20, 'Andorra'),
       ('country_ao', 'AO', 'AGO', 24, 'Angola'),
       ('country_ai', 'AI', 'AIA', 660, 'Anguilla'),
       ('country_aq', 'AQ', 'ATA', 10, 'Antarctica'),
       ('country_ag', 'AG', 'ATG', 28, 'Antigua and Barbuda'),
       ('country_ar', 'AR', 'ARG', 32, 'Argentina'),
       ('country_am', 'AM', 'ARM', 51, 'Armenia'),
       ('country_aw', 'AW', 'ABW', 533, 'Aruba'),
       ('country_au', 'AU', 'AUS', 36, 'Australia'),
       ('country_at', 'AT', 'AUT', 40, 'Austria'),
       ('country_az', 'AZ', 'AZE', 31, 'Azerbaijan'),
       ('country_bs', 'BS', 'BHS', 44, 'Bahamas'),
       ('country_bh', 'BH', 'BHR', 48, 'Bahrain'),
       ('country_bd', 'BD', 'BGD', 50, 'Bangladesh'),
       ('country_bb', 'BB', 'BRB', 52, 'Barbados'),
       ('country_by', 'BY', 'BLR', 112, 'Belarus'),
       ('country_be', 'BE', 'BEL', 56, 'Belgium'),
       ('country_bz', 'BZ', 'BLZ', 84, 'Belize'),
       ('country_bj', 'BJ', 'BEN', 204, 'Benin'),
       ('country_bm', 'BM', 'BMU', 60, 'Bermuda'),
       ('country_bt', 'BT', 'BTN', 64, 'Bhutan'),
       ('country_bo', 'BO', 'BOL', 68, 'Bolivia'),
       ('country_bq', 'BQ', 'BES', 535, 'Bonaire, Sint Eustatius and Saba'),
       ('country_ba', 'BA', 'BIH', 70, 'Bosnia and Herzegovina'),
       ('country_bw', 'BW', 'BWA', 72, 'Botswana'),
       ('country_bv', 'BV', 'BVT', 74, 'Bouvet Island'),
       ('country_br', 'BR', 'BRA', 76, 'Brazil'),
       ('country_io', 'IO', 'IOT', 86, 'British Indian Ocean Territory'),
       ('country_bn', 'BN', 'BRN', 96, 'Brunei'),
       ('country_bg', 'BG', 'BGR', 100, 'Bulgaria'),
       ('country_bf', 'BF', 'BFA', 854, 'Burkina Faso'),
       ('country_bi', 'BI', 'BDI', 108, 'Burundi'),
       ('country_cv', 'CV', 'CPV', 132, 'Cabo Verde'),
       ('country_kh', 'KH', 'KHM', 116, 'Cambodia'),
       ('country_cm', 'CM', 'CMR', 120, 'Cameroon'),
       ('country_ca', 'CA', 'CAN', 124, 'Canada'),
       ('country_ky', 'KY', 'CYM', 136, 'Cayman Islands'),
       ('country_cf', 'CF', 'CAF', 140, 'Central African Republic'),
       ('country_td', 'TD', 'TCD', 148, 'Chad'),
       ('country_cl', 'CL', 'CHL', 152, 'Chile'),
       ('country_cn', 'CN', 'CHN', 156, 'China'),
       ('country_cx', 'CX', 'CXR', 162, 'Christmas Island'),
       ('country_cc', 'CC', 'CCK', 166, 'Cocos (Keeling) Islands'),
       ('country_co', 'CO', 'COL', 170, 'Colombia'),
       ('country_km', 'KM', 'COM', 174, 'Comoros'),
       ('country_cg', 'CG', 'COG', 178, 'Congo'),
       ('country_cd', 'CD', 'COD', 180, 'Congo (DRC)'),
       ('country_ck', 'CK', 'COK', 184, 'Cook Islands'),
       ('country_cr', 'CR', 'CRI', 188, 'Costa Rica'),
       ('country_hr', 'HR', 'HRV', 191, 'Croatia'),
       ('country_cu', 'CU', 'CUB', 192, 'Cuba'),
       ('country_cw', 'CW', 'CUW', 531, 'Curaçao'),
       ('country_cy', 'CY', 'CYP', 196, 'Cyprus'),
       ('country_cz', 'CZ', 'CZE', 203, 'Czechia'),
       ('country_ci', 'CI', 'CIV', 384, 'Côte d''Ivoire'),
       ('country_dk', 'DK', 'DNK', 208, 'Denmark'),
       ('country_dj', 'DJ', 'DJI', 262, 'Djibouti'),
       ('country_dm', 'DM', 'DMA', 212, 'Dominica'),
       ('country_do', 'DO', 'DOM', 214, 'Dominican Republic'),
       ('country_ec', 'EC', 'ECU', 218, 'Ecuador'),
       ('country_eg', 'EG', 'EGY', 818, 'Egypt'),
       ('country_sv', 'SV', 'SLV', 222, 'El Salvador'),
       ('country_gq', 'GQ', 'GNQ', 226, 'Equatorial Guinea'),
       ('country_er', 'ER', 'ERI', 232, 'Eritrea'),
       ('country_ee', 'EE', 'EST', 233, 'Estonia'),
       ('country_sz', 'SZ', 'SWZ', 748, 'Eswatini'),
       ('country_et', 'ET', 'ETH', 231, 'Ethiopia'),
       ('country_fk', 'FK', 'FLK', 238, 'Falkland Islands (Malvinas)'),
       ('country_fo', 'FO', 'FRO', 234, 'Faroe Islands'),
       ('country_fj', 'FJ', 'FJI', 242, 'Fiji'),
       ('country_fi', 'FI', 'FIN', 246, 'Finland'),
       ('country_fr', 'FR', 'FRA', 250, 'France'),
       ('country_gf', 'GF', 'GUF', 254, 'French Guiana'),
       ('country_pf', 'PF', 'PYF', 258, 'French Polynesia'),
       ('country_tf', 'TF', 'ATF', 260, 'French Southern Territories'),
       ('country_ga', 'GA', 'GAB', 266, 'Gabon'),
       ('country_gm', 'GM', 'GMB', 270, 'Gambia'),
       ('country_ge', 'GE', 'GEO', 268, 'Georgia'),
       ('country_de', 'DE', 'DEU', 276, 'Germany'),
       ('country_gh', 'GH', 'GHA', 288, 'Ghana'),
       ('country_gi', 'GI', 'GIB', 292, 'Gibraltar'),
       ('country_gr', 'GR', 'GRC', 300, 'Greece'),
       ('country_gl', 'GL', 'GRL', 304, 'Greenland'),
       ('country_gd', 'GD', 'GRD', 308, 'Grenada'),
       ('country_gp', 'GP', 'GLP', 312, 'Guadeloupe'),
       ('country_gu', 'GU', 'GUM', 316, 'Guam'),
       ('country_gt', 'GT', 'GTM', 320, 'Guatemala'),
       ('country_gg', 'GG', 'GGY', 831, 'Guernsey'),
       ('country_gn', 'GN', 'GIN', 324, 'Guinea'),
       ('country_gw', 'GW', 'GNB', 624, 'Guinea-Bissau'),
       ('country_gy', 'GY', 'GUY', 328, 'Guyana'),
       ('country_ht', 'HT', 'HTI', 332, 'Haiti'),
       ('country_hm', 'HM', 'HMD', 334, 'Heard Island and McDonald Islands'),
       ('country_va', 'VA', 'VAT', 336, 'Holy See (Vatican City State)'),
       ('country_hn', 'HN', 'HND', 340, 'Honduras'),
       ('country_hk', 'HK', 'HKG', 344, 'Hong Kong'),
       ('country_hu', 'HU', 'HUN', 348, 'Hungary'),
       ('country_is', 'IS', 'ISL', 352, 'Iceland'),
       ('country_in', 'IN', 'IND', 356, 'India'),
       ('country_id', 'ID', 'IDN', 360, 'Indonesia'),
       ('country_ir', 'IR', 'IRN', 364, 'Iran'),
       ('country_iq', 'IQ', 'IRQ', 368, 'Iraq'),
       ('country_ie', 'IE', 'IRL', 372, 'Ireland'),
       ('country_im', 'IM', 'IMN', 833, 'Isle of Man'),
       ('country_il', 'IL', 'ISR', 376, 'Israel'),
       ('country_it', 'IT', 'ITA', 380, 'Italy'),
       ('country_jm', 'JM', 'JAM', 388, 'Jamaica'),
       ('country_jp', 'JP', 'JPN', 392, 'Japan'),
       ('country_je', 'JE', 'JEY', 832, 'Jersey'),
       ('country_jo', 'JO', 'JOR', 400, 'Jordan'),
       ('country_kz', 'KZ', 'KAZ', 398, 'Kazakhstan'),
       ('country_ke', 'KE', 'KEN', 404, 'Kenya'),
       ('country_ki', 'KI', 'KIR', 296, 'Kiribati'),
       ('country_kw', 'KW', 'KWT', 414, 'Kuwait'),
       ('country_kg', 'KG', 'KGZ', 417, 'Kyrgyzstan'),
       ('country_la', 'LA', 'LAO', 418, 'Laos'),
       ('country_lv', 'LV', 'LVA', 428, 'Latvia'),
       ('country_lb', 'LB', 'LBN', 422, 'Lebanon'),
       ('country_ls', 'LS', 'LSO', 426, 'Lesotho'),
       ('country_lr', 'LR', 'LBR', 430, 'Liberia'),
       ('country_ly', 'LY', 'LBY', 434, 'Libya'),
       ('country_li', 'LI', 'LIE', 438, 'Liechtenstein'),
       ('country_lt', 'LT', 'LTU', 440, 'Lithuania'),
       ('country_lu', 'LU', 'LUX', 442, 'Luxembourg'),
       ('country_mo', 'MO', 'MAC', 446, 'Macao'),
       ('country_mg', 'MG', 'MDG', 450, 'Madagascar'),
       ('country_mw', 'MW', 'MWI', 454, 'Malawi'),
       ('country_my', 'MY', 'MYS', 458, 'Malaysia'),
       ('country_mv', 'MV', 'MDV', 462, 'Maldives'),
       ('country_ml', 'ML', 'MLI', 466, 'Mali'),
       ('country_mt', 'MT', 'MLT', 470, 'Malta'),
       ('country_mh', 'MH', 'MHL', 584, 'Marshall Islands'),
       ('country_mq', 'MQ', 'MTQ', 474, 'Martinique'),
       ('country_mr', 'MR', 'MRT', 478, 'Mauritania'),
       ('country_mu', 'MU', 'MUS', 480, 'Mauritius'),
       ('country_yt', 'YT', 'MYT', 175, 'Mayotte'),
       ('country_mx', 'MX', 'MEX', 484, 'Mexico'),
       ('country_fm', 'FM', 'FSM', 583, 'Micronesia, Federated States of'),
       ('country_md', 'MD', 'MDA', 498, 'Moldova'),
       ('country_mc', 'MC', 'MCO', 492, 'Monaco'),
       ('country_mn', 'MN', 'MNG', 496, 'Mongolia'),
       ('country_me', 'ME', 'MNE', 499, 'Montenegro'),
       ('country_ms', 'MS', 'MSR', 500, 'Montserrat'),
       ('country_ma', 'MA', 'MAR', 504, 'Morocco'),
       ('country_mz', 'MZ', 'MOZ', 508, 'Mozambique'),
       ('country_mm', 'MM', 'MMR', 104, 'Myanmar'),
       ('country_na', 'NA', 'NAM', 516, 'Namibia'),
       ('country_nr', 'NR', 'NRU', 520, 'Nauru'),
       ('country_np', 'NP', 'NPL', 524, 'Nepal'),
       ('country_nl', 'NL', 'NLD', 528, 'Netherlands'),
       ('country_nc', 'NC', 'NCL', 540, 'New Caledonia'),
       ('country_nz', 'NZ', 'NZL', 554, 'New Zealand'),
       ('country_ni', 'NI', 'NIC', 558, 'Nicaragua'),
       ('country_ne', 'NE', 'NER', 562, 'Niger'),
       ('country_ng', 'NG', 'NGA', 566, 'Nigeria'),
       ('country_nu', 'NU', 'NIU', 570, 'Niue'),
       ('country_nf', 'NF', 'NFK', 574, 'Norfolk Island'),
       ('country_kp', 'KP', 'PRK', 408, 'North Korea'),
       ('country_mk', 'MK', 'MKD', 807, 'North Macedonia'),
       ('country_mp', 'MP', 'MNP', 580, 'Northern Mariana Islands'),
       ('country_no', 'NO', 'NOR', 578, 'Norway'),
       ('country_om', 'OM', 'OMN', 512, 'Oman'),
       ('country_pk', 'PK', 'PAK', 586, 'Pakistan'),
       ('country_pw', 'PW', 'PLW', 585, 'Palau'),
       ('country_ps', 'PS', 'PSE', 275, 'Palestine'),
       ('country_pa', 'PA', 'PAN', 591, 'Panama'),
       ('country_pg', 'PG', 'PNG', 598, 'Papua New Guinea'),
       ('country_py', 'PY', 'PRY', 600, 'Paraguay'),
       ('country_pe', 'PE', 'PER', 604, 'Peru'),
       ('country_ph', 'PH', 'PHL', 608, 'Philippines'),
       ('country_pn', 'PN', 'PCN', 612, 'Pitcairn'),
       ('country_pl', 'PL', 'POL', 616, 'Poland'),
       ('country_pt', 'PT', 'PRT', 620, 'Portugal'),
       ('country_pr', 'PR', 'PRI', 630, 'Puerto Rico'),
       ('country_qa', 'QA', 'QAT', 634, 'Qatar'),
       ('country_ro', 'RO', 'ROU', 642, 'Romania'),
       ('country_ru', 'RU', 'RUS', 643, 'Russia'),
       ('country_rw', 'RW', 'RWA', 646, 'Rwanda'),
       ('country_re', 'RE', 'REU', 638, 'Réunion'),
       ('country_bl', 'BL', 'BLM', 652, 'Saint Barthélemy'),
       ('country_sh', 'SH', 'SHN', 654, 'Saint Helena, Ascension and Tristan da Cunha'),
       ('country_kn', 'KN', 'KNA', 659, 'Saint Kitts and Nevis'),
       ('country_lc', 'LC', 'LCA', 662, 'Saint Lucia'),
       ('country_mf', 'MF', 'MAF', 663, 'Saint Martin (French part)'),
       ('country_pm', 'PM', 'SPM', 666, 'Saint Pierre and Miquelon'),
       ('country_vc', 'VC', 'VCT', 670, 'Saint Vincent and the Grenadines'),
       ('country_ws', 'WS', 'WSM', 882, 'Samoa'),
       ('country_sm', 'SM', 'SMR', 674, 'San Marino'),
       ('country_st', 'ST', 'STP', 678, 'Sao Tome and Principe'),
       ('country_sa', 'SA', 'SAU', 682, 'Saudi Arabia'),
       ('country_sn', 'SN', 'SEN', 686, 'Senegal'),
       ('country_rs', 'RS', 'SRB', 688, 'Serbia'),
       ('country_sc', 'SC', 'SYC', 690, 'Seychelles'),
       ('country_sl', 'SL', 'SLE', 694, 'Sierra Leone'),
       ('country_sg', 'SG', 'SGP', 702, 'Singapore'),
       ('country_sx', 'SX', 'SXM', 534, 'Sint Maarten (Dutch part)'),
       ('country_sk', 'SK', 'SVK', 703, 'Slovakia'),
       ('country_si', 'SI', 'SVN', 705, 'Slovenia'),
       ('country_sb', 'SB', 'SLB', 90, 'Solomon Islands'),
       ('country_so', 'SO', 'SOM', 706, 'Somalia'),
       ('country_za', 'ZA', 'ZAF', 710, 'South Africa'),
       ('country_gs', 'GS', 'SGS', 239, 'South Georgia and the South Sandwich Islands'),
       ('country_kr', 'KR', 'KOR', 410, 'South Korea'),
       ('country_ss', 'SS', 'SSD', 728, 'South Sudan'),
       ('country_es', 'ES', 'ESP', 724, 'Spain'),
       ('country_lk', 'LK', 'LKA', 144, 'Sri Lanka'),
       ('country_sd', 'SD', 'SDN', 729, 'Sudan'),
       ('country_sr', 'SR', 'SUR', 740, 'Suriname'),
       ('country_sj', 'SJ', 'SJM', 744, 'Svalbard and Jan Mayen'),
       ('country_se', 'SE', 'SWE', 752, 'Sweden'),
       ('country_ch', 'CH', 'CHE', 756, 'Switzerland'),
       ('country_sy', 'SY', 'SYR', 760, 'Syria'),
       ('country_tw', 'TW', 'TWN', 158, 'Taiwan'),
       ('country_tj', 'TJ', 'TJK', 762, 'Tajikistan'),
       ('country_tz', 'TZ', 'TZA', 834, 'Tanzania'),
       ('country_th', 'TH', 'THA', 764, 'Thailand'),
       ('country_tl', 'TL', 'TLS', 626, 'Timor-Leste'),
       ('country_tg', 'TG', 'TGO', 768, 'Togo'),
       ('country_tk', 'TK', 'TKL', 772, 'Tokelau'),
       ('country_to', 'TO', 'TON', 776, 'Tonga'),
       ('country_tt', 'TT', 'TTO', 780, 'Trinidad and Tobago'),
       ('country_tn', 'TN', 'TUN', 788, 'Tunisia'),
       ('country_tm', 'TM', 'TKM', 795, 'Turkmenistan'),
       ('country_tc', 'TC', 'TCA', 796, 'Turks and Caicos Islands'),
       ('country_tv', 'TV', 'TUV', 798, 'Tuvalu'),
       ('country_tr', 'TR', 'TUR', 792, 'Türkiye'),
       ('country_ug', 'UG', 'UGA', 800, 'Uganda'),
       ('country_ua', 'UA', 'UKR', 804, 'Ukraine'),
       ('country_ae', 'AE', 'ARE', 784, 'United Arab Emirates'),
       ('country_gb', 'GB', 'GBR', 826, 'United Kingdom'),
       ('country_us', 'US', 'USA', 840, 'United States'),
       ('country_um', 'UM', 'UMI', 581, 'United States Minor Outlying Islands'),
       ('country_uy', 'UY', 'URY', 858, 'Uruguay'),
       ('country_uz', 'UZ', 'UZB', 860, 'Uzbekistan'),
       ('country_vu', 'VU', 'VUT', 548, 'Vanuatu'),
       ('country_ve', 'VE', 'VEN', 862, 'Venezuela'),
       ('country_vn', 'VN', 'VNM', 704, 'Vietnam'),
       ('country_vg', 'VG', 'VGB', 92, 'Virgin Islands, British'),
       ('country_vi', 'VI', 'VIR', 850, 'Virgin Islands, U.S.'),
       ('country_wf', 'WF', 'WLF', 876, 'Wallis and Futuna'),
       ('country_eh', 'EH', 'ESH', 732, 'Western Sahara'),
       ('country_ye', 'YE', 'YEM', 887, 'Yemen'),
       ('country_zm', 'ZM', 'ZMB', 894, 'Zambia'),
       ('country_zw', 'ZW', 'ZWE', 716, 'Zimbabwe'),
       ('country_ax', 'AX', 'ALA', 248, 'Åland Islands') ON CONFLICT (country_code2) DO
UPDATE SET internal_id = EXCLUDED.internal_id, country_code3 = EXCLUDED.country_code3, country_code_numeric = EXCLUDED.country_code_numeric,
    name = EXCLUDED.name, updated_at = NOW(), version = m_country.version + 1;

INSERT INTO m_nationality (internal_id, country_id, name, native_name, adjective)
SELECT 'nationality_af' AS internal_id, c.id AS country_id, 'Afghan' AS name, NULL AS native_name, 'Afghan' AS adjective
FROM m_country c
WHERE c.country_code2 = 'AF'
UNION ALL
SELECT 'nationality_al' AS internal_id,
       c.id             AS country_id,
       'Albanian'       AS name,
       NULL             AS native_name,
       'Albanian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'AL'
UNION ALL
SELECT 'nationality_dz' AS internal_id,
       c.id             AS country_id,
       'Algerian'       AS name,
       NULL             AS native_name,
       'Algerian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'DZ'
UNION ALL
SELECT 'nationality_as'  AS internal_id,
       c.id              AS country_id,
       'American Samoan' AS name,
       NULL              AS native_name,
       'American Samoan' AS adjective
FROM m_country c
WHERE c.country_code2 = 'AS'
UNION ALL
SELECT 'nationality_ad' AS internal_id,
       c.id             AS country_id,
       'Andorran'       AS name,
       NULL             AS native_name,
       'Andorran'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'AD'
UNION ALL
SELECT 'nationality_ao' AS internal_id,
       c.id             AS country_id,
       'Angolan'        AS name,
       NULL             AS native_name,
       'Angolan'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'AO'
UNION ALL
SELECT 'nationality_ai' AS internal_id,
       c.id             AS country_id,
       'Anguillian'     AS name,
       NULL             AS native_name,
       'Anguillian'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'AI'
UNION ALL
SELECT 'nationality_aq' AS internal_id,
       c.id             AS country_id,
       'Antarctic'      AS name,
       NULL             AS native_name,
       'Antarctic'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'AQ'
UNION ALL
SELECT 'nationality_ag'    AS internal_id,
       c.id                AS country_id,
       'Antiguan,Barbudan' AS name,
       NULL                AS native_name,
       'Antiguan,Barbudan' AS adjective
FROM m_country c
WHERE c.country_code2 = 'AG'
UNION ALL
SELECT 'nationality_ar' AS internal_id,
       c.id             AS country_id,
       'Argentinean'    AS name,
       NULL             AS native_name,
       'Argentinean'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'AR'
UNION ALL
SELECT 'nationality_am' AS internal_id,
       c.id             AS country_id,
       'Armenian'       AS name,
       NULL             AS native_name,
       'Armenian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'AM'
UNION ALL
SELECT 'nationality_aw' AS internal_id, c.id AS country_id, 'Aruban' AS name, NULL AS native_name, 'Aruban' AS adjective
FROM m_country c
WHERE c.country_code2 = 'AW'
UNION ALL
SELECT 'nationality_au' AS internal_id,
       c.id             AS country_id,
       'Australian'     AS name,
       NULL             AS native_name,
       'Australian'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'AU'
UNION ALL
SELECT 'nationality_at' AS internal_id,
       c.id             AS country_id,
       'Austrian'       AS name,
       NULL             AS native_name,
       'Austrian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'AT'
UNION ALL
SELECT 'nationality_az' AS internal_id,
       c.id             AS country_id,
       'Azerbaijani'    AS name,
       NULL             AS native_name,
       'Azerbaijani'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'AZ'
UNION ALL
SELECT 'nationality_bs' AS internal_id,
       c.id             AS country_id,
       'Bahamian'       AS name,
       NULL             AS native_name,
       'Bahamian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'BS'
UNION ALL
SELECT 'nationality_bh' AS internal_id,
       c.id             AS country_id,
       'Bahraini'       AS name,
       NULL             AS native_name,
       'Bahraini'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'BH'
UNION ALL
SELECT 'nationality_bd' AS internal_id,
       c.id             AS country_id,
       'Bangladeshi'    AS name,
       NULL             AS native_name,
       'Bangladeshi'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'BD'
UNION ALL
SELECT 'nationality_bb' AS internal_id,
       c.id             AS country_id,
       'Barbadian'      AS name,
       NULL             AS native_name,
       'Barbadian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'BB'
UNION ALL
SELECT 'nationality_by' AS internal_id,
       c.id             AS country_id,
       'Belarusian'     AS name,
       NULL             AS native_name,
       'Belarusian'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'BY'
UNION ALL
SELECT 'nationality_be' AS internal_id,
       c.id             AS country_id,
       'Belgian'        AS name,
       NULL             AS native_name,
       'Belgian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'BE'
UNION ALL
SELECT 'nationality_bz' AS internal_id,
       c.id             AS country_id,
       'Belizean'       AS name,
       NULL             AS native_name,
       'Belizean'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'BZ'
UNION ALL
SELECT 'nationality_bj' AS internal_id,
       c.id             AS country_id,
       'Beninese'       AS name,
       NULL             AS native_name,
       'Beninese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'BJ'
UNION ALL
SELECT 'nationality_bm' AS internal_id,
       c.id             AS country_id,
       'Bermudian'      AS name,
       NULL             AS native_name,
       'Bermudian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'BM'
UNION ALL
SELECT 'nationality_bt' AS internal_id,
       c.id             AS country_id,
       'Bhutanese'      AS name,
       NULL             AS native_name,
       'Bhutanese'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'BT'
UNION ALL
SELECT 'nationality_bo' AS internal_id,
       c.id             AS country_id,
       'Bolivian'       AS name,
       NULL             AS native_name,
       'Bolivian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'BO'
UNION ALL
SELECT 'nationality_bq'  AS internal_id,
       c.id              AS country_id,
       'Caribbean Dutch' AS name,
       NULL              AS native_name,
       'Caribbean Dutch' AS adjective
FROM m_country c
WHERE c.country_code2 = 'BQ'
UNION ALL
SELECT 'nationality_ba'        AS internal_id,
       c.id                    AS country_id,
       'Bosnian,Herzegovinian' AS name,
       NULL                    AS native_name,
       'Bosnian,Herzegovinian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'BA'
UNION ALL
SELECT 'nationality_bw' AS internal_id,
       c.id             AS country_id,
       'Motswana'       AS name,
       NULL             AS native_name,
       'Motswana'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'BW'
UNION ALL
SELECT 'nationality_bv'  AS internal_id,
       c.id              AS country_id,
       'Bouvet Islander' AS name,
       NULL              AS native_name,
       'Bouvet Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'BV'
UNION ALL
SELECT 'nationality_br' AS internal_id,
       c.id             AS country_id,
       'Brazilian'      AS name,
       NULL             AS native_name,
       'Brazilian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'BR'
UNION ALL
SELECT 'nationality_io' AS internal_id, c.id AS country_id, 'Indian' AS name, NULL AS native_name, 'Indian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'IO'
UNION ALL
SELECT 'nationality_bn' AS internal_id,
       c.id             AS country_id,
       'Bruneian'       AS name,
       NULL             AS native_name,
       'Bruneian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'BN'
UNION ALL
SELECT 'nationality_bg' AS internal_id,
       c.id             AS country_id,
       'Bulgarian'      AS name,
       NULL             AS native_name,
       'Bulgarian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'BG'
UNION ALL
SELECT 'nationality_bf' AS internal_id,
       c.id             AS country_id,
       'Burkinabe'      AS name,
       NULL             AS native_name,
       'Burkinabe'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'BF'
UNION ALL
SELECT 'nationality_bi' AS internal_id,
       c.id             AS country_id,
       'Burundian'      AS name,
       NULL             AS native_name,
       'Burundian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'BI'
UNION ALL
SELECT 'nationality_cv' AS internal_id,
       c.id             AS country_id,
       'Cape Verdian'   AS name,
       NULL             AS native_name,
       'Cape Verdian'   AS adjective
FROM m_country c
WHERE c.country_code2 = 'CV'
UNION ALL
SELECT 'nationality_kh' AS internal_id,
       c.id             AS country_id,
       'Cambodian'      AS name,
       NULL             AS native_name,
       'Cambodian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'KH'
UNION ALL
SELECT 'nationality_cm' AS internal_id,
       c.id             AS country_id,
       'Cameroonian'    AS name,
       NULL             AS native_name,
       'Cameroonian'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'CM'
UNION ALL
SELECT 'nationality_ca' AS internal_id,
       c.id             AS country_id,
       'Canadian'       AS name,
       NULL             AS native_name,
       'Canadian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'CA'
UNION ALL
SELECT 'nationality_ky' AS internal_id,
       c.id             AS country_id,
       'Caymanian'      AS name,
       NULL             AS native_name,
       'Caymanian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'KY'
UNION ALL
SELECT 'nationality_cf'  AS internal_id,
       c.id              AS country_id,
       'Central African' AS name,
       NULL              AS native_name,
       'Central African' AS adjective
FROM m_country c
WHERE c.country_code2 = 'CF'
UNION ALL
SELECT 'nationality_td' AS internal_id,
       c.id             AS country_id,
       'Chadian'        AS name,
       NULL             AS native_name,
       'Chadian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'TD'
UNION ALL
SELECT 'nationality_cl' AS internal_id,
       c.id             AS country_id,
       'Chilean'        AS name,
       NULL             AS native_name,
       'Chilean'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'CL'
UNION ALL
SELECT 'nationality_cn' AS internal_id,
       c.id             AS country_id,
       'Chinese'        AS name,
       NULL             AS native_name,
       'Chinese'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'CN'
UNION ALL
SELECT 'nationality_cx'   AS internal_id,
       c.id               AS country_id,
       'Christmas Island' AS name,
       NULL               AS native_name,
       'Christmas Island' AS adjective
FROM m_country c
WHERE c.country_code2 = 'CX'
UNION ALL
SELECT 'nationality_cc' AS internal_id,
       c.id             AS country_id,
       'Cocos Islander' AS name,
       NULL             AS native_name,
       'Cocos Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'CC'
UNION ALL
SELECT 'nationality_co' AS internal_id,
       c.id             AS country_id,
       'Colombian'      AS name,
       NULL             AS native_name,
       'Colombian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'CO'
UNION ALL
SELECT 'nationality_km' AS internal_id,
       c.id             AS country_id,
       'Comoran'        AS name,
       NULL             AS native_name,
       'Comoran'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'KM'
UNION ALL
SELECT 'nationality_cg' AS internal_id,
       c.id             AS country_id,
       'Congolese'      AS name,
       NULL             AS native_name,
       'Congolese'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'CG'
UNION ALL
SELECT 'nationality_cd' AS internal_id,
       c.id             AS country_id,
       'Congolese'      AS name,
       NULL             AS native_name,
       'Congolese'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'CD'
UNION ALL
SELECT 'nationality_ck' AS internal_id,
       c.id             AS country_id,
       'Cook Islander'  AS name,
       NULL             AS native_name,
       'Cook Islander'  AS adjective
FROM m_country c
WHERE c.country_code2 = 'CK'
UNION ALL
SELECT 'nationality_cr' AS internal_id,
       c.id             AS country_id,
       'Costa Rican'    AS name,
       NULL             AS native_name,
       'Costa Rican'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'CR'
UNION ALL
SELECT 'nationality_hr' AS internal_id,
       c.id             AS country_id,
       'Croatian'       AS name,
       NULL             AS native_name,
       'Croatian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'HR'
UNION ALL
SELECT 'nationality_cu' AS internal_id, c.id AS country_id, 'Cuban' AS name, NULL AS native_name, 'Cuban' AS adjective
FROM m_country c
WHERE c.country_code2 = 'CU'
UNION ALL
SELECT 'nationality_cw' AS internal_id,
       c.id             AS country_id,
       'Curaçaoan'      AS name,
       NULL             AS native_name,
       'Curaçaoan'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'CW'
UNION ALL
SELECT 'nationality_cy' AS internal_id,
       c.id             AS country_id,
       'Cypriot'        AS name,
       NULL             AS native_name,
       'Cypriot'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'CY'
UNION ALL
SELECT 'nationality_cz' AS internal_id, c.id AS country_id, 'Czech' AS name, NULL AS native_name, 'Czech' AS adjective
FROM m_country c
WHERE c.country_code2 = 'CZ'
UNION ALL
SELECT 'nationality_ci' AS internal_id,
       c.id             AS country_id,
       'Ivorian'        AS name,
       NULL             AS native_name,
       'Ivorian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'CI'
UNION ALL
SELECT 'nationality_dk' AS internal_id, c.id AS country_id, 'Danish' AS name, NULL AS native_name, 'Danish' AS adjective
FROM m_country c
WHERE c.country_code2 = 'DK'
UNION ALL
SELECT 'nationality_dj' AS internal_id,
       c.id             AS country_id,
       'Djibouti'       AS name,
       NULL             AS native_name,
       'Djibouti'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'DJ'
UNION ALL
SELECT 'nationality_dm' AS internal_id,
       c.id             AS country_id,
       'Dominican'      AS name,
       NULL             AS native_name,
       'Dominican'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'DM'
UNION ALL
SELECT 'nationality_do' AS internal_id,
       c.id             AS country_id,
       'Dominican'      AS name,
       NULL             AS native_name,
       'Dominican'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'DO'
UNION ALL
SELECT 'nationality_ec' AS internal_id,
       c.id             AS country_id,
       'Ecuadorean'     AS name,
       NULL             AS native_name,
       'Ecuadorean'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'EC'
UNION ALL
SELECT 'nationality_eg' AS internal_id,
       c.id             AS country_id,
       'Egyptian'       AS name,
       NULL             AS native_name,
       'Egyptian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'EG'
UNION ALL
SELECT 'nationality_sv' AS internal_id,
       c.id             AS country_id,
       'Salvadoran'     AS name,
       NULL             AS native_name,
       'Salvadoran'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'SV'
UNION ALL
SELECT 'nationality_gq'     AS internal_id,
       c.id                 AS country_id,
       'Equatorial Guinean' AS name,
       NULL                 AS native_name,
       'Equatorial Guinean' AS adjective
FROM m_country c
WHERE c.country_code2 = 'GQ'
UNION ALL
SELECT 'nationality_er' AS internal_id,
       c.id             AS country_id,
       'Eritrean'       AS name,
       NULL             AS native_name,
       'Eritrean'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'ER'
UNION ALL
SELECT 'nationality_ee' AS internal_id,
       c.id             AS country_id,
       'Estonian'       AS name,
       NULL             AS native_name,
       'Estonian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'EE'
UNION ALL
SELECT 'nationality_sz' AS internal_id, c.id AS country_id, 'Swazi' AS name, NULL AS native_name, 'Swazi' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SZ'
UNION ALL
SELECT 'nationality_et' AS internal_id,
       c.id             AS country_id,
       'Ethiopian'      AS name,
       NULL             AS native_name,
       'Ethiopian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'ET'
UNION ALL
SELECT 'nationality_fk'    AS internal_id,
       c.id                AS country_id,
       'Falkland Islander' AS name,
       NULL                AS native_name,
       'Falkland Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'FK'
UNION ALL
SELECT 'nationality_fo' AS internal_id,
       c.id             AS country_id,
       'Faroese'        AS name,
       NULL             AS native_name,
       'Faroese'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'FO'
UNION ALL
SELECT 'nationality_fj' AS internal_id, c.id AS country_id, 'Fijian' AS name, NULL AS native_name, 'Fijian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'FJ'
UNION ALL
SELECT 'nationality_fi' AS internal_id,
       c.id             AS country_id,
       'Finnish'        AS name,
       NULL             AS native_name,
       'Finnish'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'FI'
UNION ALL
SELECT 'nationality_fr' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective
FROM m_country c
WHERE c.country_code2 = 'FR'
UNION ALL
SELECT 'nationality_gf'  AS internal_id,
       c.id              AS country_id,
       'French Guianese' AS name,
       NULL              AS native_name,
       'French Guianese' AS adjective
FROM m_country c
WHERE c.country_code2 = 'GF'
UNION ALL
SELECT 'nationality_pf'    AS internal_id,
       c.id                AS country_id,
       'French Polynesian' AS name,
       NULL                AS native_name,
       'French Polynesian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'PF'
UNION ALL
SELECT 'nationality_tf' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective
FROM m_country c
WHERE c.country_code2 = 'TF'
UNION ALL
SELECT 'nationality_ga' AS internal_id,
       c.id             AS country_id,
       'Gabonese'       AS name,
       NULL             AS native_name,
       'Gabonese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'GA'
UNION ALL
SELECT 'nationality_gm' AS internal_id,
       c.id             AS country_id,
       'Gambian'        AS name,
       NULL             AS native_name,
       'Gambian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'GM'
UNION ALL
SELECT 'nationality_ge' AS internal_id,
       c.id             AS country_id,
       'Georgian'       AS name,
       NULL             AS native_name,
       'Georgian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'GE'
UNION ALL
SELECT 'nationality_de' AS internal_id, c.id AS country_id, 'German' AS name, NULL AS native_name, 'German' AS adjective
FROM m_country c
WHERE c.country_code2 = 'DE'
UNION ALL
SELECT 'nationality_gh' AS internal_id,
       c.id             AS country_id,
       'Ghanaian'       AS name,
       NULL             AS native_name,
       'Ghanaian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'GH'
UNION ALL
SELECT 'nationality_gi' AS internal_id,
       c.id             AS country_id,
       'Gibraltar'      AS name,
       NULL             AS native_name,
       'Gibraltar'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'GI'
UNION ALL
SELECT 'nationality_gr' AS internal_id, c.id AS country_id, 'Greek' AS name, NULL AS native_name, 'Greek' AS adjective
FROM m_country c
WHERE c.country_code2 = 'GR'
UNION ALL
SELECT 'nationality_gl' AS internal_id,
       c.id             AS country_id,
       'Greenlandic'    AS name,
       NULL             AS native_name,
       'Greenlandic'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'GL'
UNION ALL
SELECT 'nationality_gd' AS internal_id,
       c.id             AS country_id,
       'Grenadian'      AS name,
       NULL             AS native_name,
       'Grenadian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'GD'
UNION ALL
SELECT 'nationality_gp' AS internal_id,
       c.id             AS country_id,
       'Guadeloupian'   AS name,
       NULL             AS native_name,
       'Guadeloupian'   AS adjective
FROM m_country c
WHERE c.country_code2 = 'GP'
UNION ALL
SELECT 'nationality_gu' AS internal_id,
       c.id             AS country_id,
       'Guamanian'      AS name,
       NULL             AS native_name,
       'Guamanian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'GU'
UNION ALL
SELECT 'nationality_gt' AS internal_id,
       c.id             AS country_id,
       'Guatemalan'     AS name,
       NULL             AS native_name,
       'Guatemalan'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'GT'
UNION ALL
SELECT 'nationality_gg'   AS internal_id,
       c.id               AS country_id,
       'Channel Islander' AS name,
       NULL               AS native_name,
       'Channel Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'GG'
UNION ALL
SELECT 'nationality_gn' AS internal_id,
       c.id             AS country_id,
       'Guinean'        AS name,
       NULL             AS native_name,
       'Guinean'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'GN'
UNION ALL
SELECT 'nationality_gw'  AS internal_id,
       c.id              AS country_id,
       'Guinea-Bissauan' AS name,
       NULL              AS native_name,
       'Guinea-Bissauan' AS adjective
FROM m_country c
WHERE c.country_code2 = 'GW'
UNION ALL
SELECT 'nationality_gy' AS internal_id,
       c.id             AS country_id,
       'Guyanese'       AS name,
       NULL             AS native_name,
       'Guyanese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'GY'
UNION ALL
SELECT 'nationality_ht' AS internal_id,
       c.id             AS country_id,
       'Haitian'        AS name,
       NULL             AS native_name,
       'Haitian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'HT'
UNION ALL
SELECT 'nationality_hm'              AS internal_id,
       c.id                          AS country_id,
       'Heard and McDonald Islander' AS name,
       NULL                          AS native_name,
       'Heard and McDonald Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'HM'
UNION ALL
SELECT 'nationality_va' AS internal_id,
       c.id             AS country_id,
       'Vatican'        AS name,
       NULL             AS native_name,
       'Vatican'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'VA'
UNION ALL
SELECT 'nationality_hn' AS internal_id,
       c.id             AS country_id,
       'Honduran'       AS name,
       NULL             AS native_name,
       'Honduran'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'HN'
UNION ALL
SELECT 'nationality_hk' AS internal_id,
       c.id             AS country_id,
       'Chinese'        AS name,
       NULL             AS native_name,
       'Chinese'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'HK'
UNION ALL
SELECT 'nationality_hu' AS internal_id,
       c.id             AS country_id,
       'Hungarian'      AS name,
       NULL             AS native_name,
       'Hungarian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'HU'
UNION ALL
SELECT 'nationality_is' AS internal_id,
       c.id             AS country_id,
       'Icelander'      AS name,
       NULL             AS native_name,
       'Icelander'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'IS'
UNION ALL
SELECT 'nationality_in' AS internal_id, c.id AS country_id, 'Indian' AS name, NULL AS native_name, 'Indian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'IN'
UNION ALL
SELECT 'nationality_id' AS internal_id,
       c.id             AS country_id,
       'Indonesian'     AS name,
       NULL             AS native_name,
       'Indonesian'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'ID'
UNION ALL
SELECT 'nationality_ir' AS internal_id,
       c.id             AS country_id,
       'Iranian'        AS name,
       NULL             AS native_name,
       'Iranian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'IR'
UNION ALL
SELECT 'nationality_iq' AS internal_id, c.id AS country_id, 'Iraqi' AS name, NULL AS native_name, 'Iraqi' AS adjective
FROM m_country c
WHERE c.country_code2 = 'IQ'
UNION ALL
SELECT 'nationality_ie' AS internal_id, c.id AS country_id, 'Irish' AS name, NULL AS native_name, 'Irish' AS adjective
FROM m_country c
WHERE c.country_code2 = 'IE'
UNION ALL
SELECT 'nationality_im' AS internal_id, c.id AS country_id, 'Manx' AS name, NULL AS native_name, 'Manx' AS adjective
FROM m_country c
WHERE c.country_code2 = 'IM'
UNION ALL
SELECT 'nationality_il' AS internal_id,
       c.id             AS country_id,
       'Israeli'        AS name,
       NULL             AS native_name,
       'Israeli'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'IL'
UNION ALL
SELECT 'nationality_it' AS internal_id,
       c.id             AS country_id,
       'Italian'        AS name,
       NULL             AS native_name,
       'Italian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'IT'
UNION ALL
SELECT 'nationality_jm' AS internal_id,
       c.id             AS country_id,
       'Jamaican'       AS name,
       NULL             AS native_name,
       'Jamaican'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'JM'
UNION ALL
SELECT 'nationality_jp' AS internal_id,
       c.id             AS country_id,
       'Japanese'       AS name,
       NULL             AS native_name,
       'Japanese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'JP'
UNION ALL
SELECT 'nationality_je'   AS internal_id,
       c.id               AS country_id,
       'Channel Islander' AS name,
       NULL               AS native_name,
       'Channel Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'JE'
UNION ALL
SELECT 'nationality_jo' AS internal_id,
       c.id             AS country_id,
       'Jordanian'      AS name,
       NULL             AS native_name,
       'Jordanian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'JO'
UNION ALL
SELECT 'nationality_kz' AS internal_id,
       c.id             AS country_id,
       'Kazakhstani'    AS name,
       NULL             AS native_name,
       'Kazakhstani'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'KZ'
UNION ALL
SELECT 'nationality_ke' AS internal_id, c.id AS country_id, 'Kenyan' AS name, NULL AS native_name, 'Kenyan' AS adjective
FROM m_country c
WHERE c.country_code2 = 'KE'
UNION ALL
SELECT 'nationality_ki' AS internal_id,
       c.id             AS country_id,
       'I-Kiribati'     AS name,
       NULL             AS native_name,
       'I-Kiribati'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'KI'
UNION ALL
SELECT 'nationality_kw' AS internal_id,
       c.id             AS country_id,
       'Kuwaiti'        AS name,
       NULL             AS native_name,
       'Kuwaiti'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'KW'
UNION ALL
SELECT 'nationality_kg' AS internal_id,
       c.id             AS country_id,
       'Kirghiz'        AS name,
       NULL             AS native_name,
       'Kirghiz'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'KG'
UNION ALL
SELECT 'nationality_la' AS internal_id,
       c.id             AS country_id,
       'Laotian'        AS name,
       NULL             AS native_name,
       'Laotian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'LA'
UNION ALL
SELECT 'nationality_lv' AS internal_id,
       c.id             AS country_id,
       'Latvian'        AS name,
       NULL             AS native_name,
       'Latvian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'LV'
UNION ALL
SELECT 'nationality_lb' AS internal_id,
       c.id             AS country_id,
       'Lebanese'       AS name,
       NULL             AS native_name,
       'Lebanese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'LB'
UNION ALL
SELECT 'nationality_ls' AS internal_id,
       c.id             AS country_id,
       'Mosotho'        AS name,
       NULL             AS native_name,
       'Mosotho'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'LS'
UNION ALL
SELECT 'nationality_lr' AS internal_id,
       c.id             AS country_id,
       'Liberian'       AS name,
       NULL             AS native_name,
       'Liberian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'LR'
UNION ALL
SELECT 'nationality_ly' AS internal_id, c.id AS country_id, 'Libyan' AS name, NULL AS native_name, 'Libyan' AS adjective
FROM m_country c
WHERE c.country_code2 = 'LY'
UNION ALL
SELECT 'nationality_li'  AS internal_id,
       c.id              AS country_id,
       'Liechtensteiner' AS name,
       NULL              AS native_name,
       'Liechtensteiner' AS adjective
FROM m_country c
WHERE c.country_code2 = 'LI'
UNION ALL
SELECT 'nationality_lt' AS internal_id,
       c.id             AS country_id,
       'Lithuanian'     AS name,
       NULL             AS native_name,
       'Lithuanian'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'LT'
UNION ALL
SELECT 'nationality_lu' AS internal_id,
       c.id             AS country_id,
       'Luxembourger'   AS name,
       NULL             AS native_name,
       'Luxembourger'   AS adjective
FROM m_country c
WHERE c.country_code2 = 'LU'
UNION ALL
SELECT 'nationality_mo' AS internal_id,
       c.id             AS country_id,
       'Chinese'        AS name,
       NULL             AS native_name,
       'Chinese'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'MO'
UNION ALL
SELECT 'nationality_mg' AS internal_id,
       c.id             AS country_id,
       'Malagasy'       AS name,
       NULL             AS native_name,
       'Malagasy'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'MG'
UNION ALL
SELECT 'nationality_mw' AS internal_id,
       c.id             AS country_id,
       'Malawian'       AS name,
       NULL             AS native_name,
       'Malawian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'MW'
UNION ALL
SELECT 'nationality_my' AS internal_id,
       c.id             AS country_id,
       'Malaysian'      AS name,
       NULL             AS native_name,
       'Malaysian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'MY'
UNION ALL
SELECT 'nationality_mv' AS internal_id,
       c.id             AS country_id,
       'Maldivan'       AS name,
       NULL             AS native_name,
       'Maldivan'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'MV'
UNION ALL
SELECT 'nationality_ml' AS internal_id, c.id AS country_id, 'Malian' AS name, NULL AS native_name, 'Malian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'ML'
UNION ALL
SELECT 'nationality_mt' AS internal_id,
       c.id             AS country_id,
       'Maltese'        AS name,
       NULL             AS native_name,
       'Maltese'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'MT'
UNION ALL
SELECT 'nationality_mh' AS internal_id,
       c.id             AS country_id,
       'Marshallese'    AS name,
       NULL             AS native_name,
       'Marshallese'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'MH'
UNION ALL
SELECT 'nationality_mq' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective
FROM m_country c
WHERE c.country_code2 = 'MQ'
UNION ALL
SELECT 'nationality_mr' AS internal_id,
       c.id             AS country_id,
       'Mauritanian'    AS name,
       NULL             AS native_name,
       'Mauritanian'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'MR'
UNION ALL
SELECT 'nationality_mu' AS internal_id,
       c.id             AS country_id,
       'Mauritian'      AS name,
       NULL             AS native_name,
       'Mauritian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'MU'
UNION ALL
SELECT 'nationality_yt' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective
FROM m_country c
WHERE c.country_code2 = 'YT'
UNION ALL
SELECT 'nationality_mx' AS internal_id,
       c.id             AS country_id,
       'Mexican'        AS name,
       NULL             AS native_name,
       'Mexican'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'MX'
UNION ALL
SELECT 'nationality_fm' AS internal_id,
       c.id             AS country_id,
       'Micronesian'    AS name,
       NULL             AS native_name,
       'Micronesian'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'FM'
UNION ALL
SELECT 'nationality_md' AS internal_id,
       c.id             AS country_id,
       'Moldovan'       AS name,
       NULL             AS native_name,
       'Moldovan'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'MD'
UNION ALL
SELECT 'nationality_mc' AS internal_id,
       c.id             AS country_id,
       'Monegasque'     AS name,
       NULL             AS native_name,
       'Monegasque'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'MC'
UNION ALL
SELECT 'nationality_mn' AS internal_id,
       c.id             AS country_id,
       'Mongolian'      AS name,
       NULL             AS native_name,
       'Mongolian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'MN'
UNION ALL
SELECT 'nationality_me' AS internal_id,
       c.id             AS country_id,
       'Montenegrin'    AS name,
       NULL             AS native_name,
       'Montenegrin'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'ME'
UNION ALL
SELECT 'nationality_ms' AS internal_id,
       c.id             AS country_id,
       'Montserratian'  AS name,
       NULL             AS native_name,
       'Montserratian'  AS adjective
FROM m_country c
WHERE c.country_code2 = 'MS'
UNION ALL
SELECT 'nationality_ma' AS internal_id,
       c.id             AS country_id,
       'Moroccan'       AS name,
       NULL             AS native_name,
       'Moroccan'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'MA'
UNION ALL
SELECT 'nationality_mz' AS internal_id,
       c.id             AS country_id,
       'Mozambican'     AS name,
       NULL             AS native_name,
       'Mozambican'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'MZ'
UNION ALL
SELECT 'nationality_mm' AS internal_id,
       c.id             AS country_id,
       'Burmese'        AS name,
       NULL             AS native_name,
       'Burmese'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'MM'
UNION ALL
SELECT 'nationality_na' AS internal_id,
       c.id             AS country_id,
       'Namibian'       AS name,
       NULL             AS native_name,
       'Namibian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'NA'
UNION ALL
SELECT 'nationality_nr' AS internal_id,
       c.id             AS country_id,
       'Nauruan'        AS name,
       NULL             AS native_name,
       'Nauruan'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'NR'
UNION ALL
SELECT 'nationality_np' AS internal_id,
       c.id             AS country_id,
       'Nepalese'       AS name,
       NULL             AS native_name,
       'Nepalese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'NP'
UNION ALL
SELECT 'nationality_nl' AS internal_id, c.id AS country_id, 'Dutch' AS name, NULL AS native_name, 'Dutch' AS adjective
FROM m_country c
WHERE c.country_code2 = 'NL'
UNION ALL
SELECT 'nationality_nc' AS internal_id,
       c.id             AS country_id,
       'New Caledonian' AS name,
       NULL             AS native_name,
       'New Caledonian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'NC'
UNION ALL
SELECT 'nationality_nz' AS internal_id,
       c.id             AS country_id,
       'New Zealander'  AS name,
       NULL             AS native_name,
       'New Zealander'  AS adjective
FROM m_country c
WHERE c.country_code2 = 'NZ'
UNION ALL
SELECT 'nationality_ni' AS internal_id,
       c.id             AS country_id,
       'Nicaraguan'     AS name,
       NULL             AS native_name,
       'Nicaraguan'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'NI'
UNION ALL
SELECT 'nationality_ne' AS internal_id,
       c.id             AS country_id,
       'Nigerien'       AS name,
       NULL             AS native_name,
       'Nigerien'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'NE'
UNION ALL
SELECT 'nationality_ng' AS internal_id,
       c.id             AS country_id,
       'Nigerian'       AS name,
       NULL             AS native_name,
       'Nigerian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'NG'
UNION ALL
SELECT 'nationality_nu' AS internal_id, c.id AS country_id, 'Niuean' AS name, NULL AS native_name, 'Niuean' AS adjective
FROM m_country c
WHERE c.country_code2 = 'NU'
UNION ALL
SELECT 'nationality_nf'   AS internal_id,
       c.id               AS country_id,
       'Norfolk Islander' AS name,
       NULL               AS native_name,
       'Norfolk Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'NF'
UNION ALL
SELECT 'nationality_kp' AS internal_id,
       c.id             AS country_id,
       'North Korean'   AS name,
       NULL             AS native_name,
       'North Korean'   AS adjective
FROM m_country c
WHERE c.country_code2 = 'KP'
UNION ALL
SELECT 'nationality_mk' AS internal_id,
       c.id             AS country_id,
       'Macedonian'     AS name,
       NULL             AS native_name,
       'Macedonian'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'MK'
UNION ALL
SELECT 'nationality_mp' AS internal_id,
       c.id             AS country_id,
       'American'       AS name,
       NULL             AS native_name,
       'American'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'MP'
UNION ALL
SELECT 'nationality_no' AS internal_id,
       c.id             AS country_id,
       'Norwegian'      AS name,
       NULL             AS native_name,
       'Norwegian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'NO'
UNION ALL
SELECT 'nationality_om' AS internal_id, c.id AS country_id, 'Omani' AS name, NULL AS native_name, 'Omani' AS adjective
FROM m_country c
WHERE c.country_code2 = 'OM'
UNION ALL
SELECT 'nationality_pk' AS internal_id,
       c.id             AS country_id,
       'Pakistani'      AS name,
       NULL             AS native_name,
       'Pakistani'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'PK'
UNION ALL
SELECT 'nationality_pw' AS internal_id,
       c.id             AS country_id,
       'Palauan'        AS name,
       NULL             AS native_name,
       'Palauan'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'PW'
UNION ALL
SELECT 'nationality_ps' AS internal_id,
       c.id             AS country_id,
       'Palestinian'    AS name,
       NULL             AS native_name,
       'Palestinian'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'PS'
UNION ALL
SELECT 'nationality_pa' AS internal_id,
       c.id             AS country_id,
       'Panamanian'     AS name,
       NULL             AS native_name,
       'Panamanian'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'PA'
UNION ALL
SELECT 'nationality_pg'    AS internal_id,
       c.id                AS country_id,
       'Papua New Guinean' AS name,
       NULL                AS native_name,
       'Papua New Guinean' AS adjective
FROM m_country c
WHERE c.country_code2 = 'PG'
UNION ALL
SELECT 'nationality_py' AS internal_id,
       c.id             AS country_id,
       'Paraguayan'     AS name,
       NULL             AS native_name,
       'Paraguayan'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'PY'
UNION ALL
SELECT 'nationality_pe' AS internal_id,
       c.id             AS country_id,
       'Peruvian'       AS name,
       NULL             AS native_name,
       'Peruvian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'PE'
UNION ALL
SELECT 'nationality_ph' AS internal_id,
       c.id             AS country_id,
       'Filipino'       AS name,
       NULL             AS native_name,
       'Filipino'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'PH'
UNION ALL
SELECT 'nationality_pn'    AS internal_id,
       c.id                AS country_id,
       'Pitcairn Islander' AS name,
       NULL                AS native_name,
       'Pitcairn Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'PN'
UNION ALL
SELECT 'nationality_pl' AS internal_id, c.id AS country_id, 'Polish' AS name, NULL AS native_name, 'Polish' AS adjective
FROM m_country c
WHERE c.country_code2 = 'PL'
UNION ALL
SELECT 'nationality_pt' AS internal_id,
       c.id             AS country_id,
       'Portuguese'     AS name,
       NULL             AS native_name,
       'Portuguese'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'PT'
UNION ALL
SELECT 'nationality_pr' AS internal_id,
       c.id             AS country_id,
       'Puerto Rican'   AS name,
       NULL             AS native_name,
       'Puerto Rican'   AS adjective
FROM m_country c
WHERE c.country_code2 = 'PR'
UNION ALL
SELECT 'nationality_qa' AS internal_id, c.id AS country_id, 'Qatari' AS name, NULL AS native_name, 'Qatari' AS adjective
FROM m_country c
WHERE c.country_code2 = 'QA'
UNION ALL
SELECT 'nationality_ro' AS internal_id,
       c.id             AS country_id,
       'Romanian'       AS name,
       NULL             AS native_name,
       'Romanian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'RO'
UNION ALL
SELECT 'nationality_ru' AS internal_id,
       c.id             AS country_id,
       'Russian'        AS name,
       NULL             AS native_name,
       'Russian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'RU'
UNION ALL
SELECT 'nationality_rw' AS internal_id,
       c.id             AS country_id,
       'Rwandan'        AS name,
       NULL             AS native_name,
       'Rwandan'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'RW'
UNION ALL
SELECT 'nationality_re' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective
FROM m_country c
WHERE c.country_code2 = 'RE'
UNION ALL
SELECT 'nationality_bl'            AS internal_id,
       c.id                        AS country_id,
       'Saint Barthélemy Resident' AS name,
       NULL                        AS native_name,
       'Saint Barthélemy Resident' AS adjective
FROM m_country c
WHERE c.country_code2 = 'BL'
UNION ALL
SELECT 'nationality_sh' AS internal_id,
       c.id             AS country_id,
       'Saint Helenian' AS name,
       NULL             AS native_name,
       'Saint Helenian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SH'
UNION ALL
SELECT 'nationality_kn'       AS internal_id,
       c.id                   AS country_id,
       'Kittian and Nevisian' AS name,
       NULL                   AS native_name,
       'Kittian and Nevisian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'KN'
UNION ALL
SELECT 'nationality_lc' AS internal_id,
       c.id             AS country_id,
       'Saint Lucian'   AS name,
       NULL             AS native_name,
       'Saint Lucian'   AS adjective
FROM m_country c
WHERE c.country_code2 = 'LC'
UNION ALL
SELECT 'nationality_mf'  AS internal_id,
       c.id              AS country_id,
       'Saint-Martinois' AS name,
       NULL              AS native_name,
       'Saint-Martinois' AS adjective
FROM m_country c
WHERE c.country_code2 = 'MF'
UNION ALL
SELECT 'nationality_pm' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective
FROM m_country c
WHERE c.country_code2 = 'PM'
UNION ALL
SELECT 'nationality_vc'   AS internal_id,
       c.id               AS country_id,
       'Saint Vincentian' AS name,
       NULL               AS native_name,
       'Saint Vincentian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'VC'
UNION ALL
SELECT 'nationality_ws' AS internal_id, c.id AS country_id, 'Samoan' AS name, NULL AS native_name, 'Samoan' AS adjective
FROM m_country c
WHERE c.country_code2 = 'WS'
UNION ALL
SELECT 'nationality_sm' AS internal_id,
       c.id             AS country_id,
       'Sammarinese'    AS name,
       NULL             AS native_name,
       'Sammarinese'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'SM'
UNION ALL
SELECT 'nationality_st' AS internal_id,
       c.id             AS country_id,
       'Sao Tomean'     AS name,
       NULL             AS native_name,
       'Sao Tomean'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'ST'
UNION ALL
SELECT 'nationality_sa' AS internal_id,
       c.id             AS country_id,
       'Saudi Arabian'  AS name,
       NULL             AS native_name,
       'Saudi Arabian'  AS adjective
FROM m_country c
WHERE c.country_code2 = 'SA'
UNION ALL
SELECT 'nationality_sn' AS internal_id,
       c.id             AS country_id,
       'Senegalese'     AS name,
       NULL             AS native_name,
       'Senegalese'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'SN'
UNION ALL
SELECT 'nationality_rs' AS internal_id,
       c.id             AS country_id,
       'Serbian'        AS name,
       NULL             AS native_name,
       'Serbian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'RS'
UNION ALL
SELECT 'nationality_sc' AS internal_id,
       c.id             AS country_id,
       'Seychellois'    AS name,
       NULL             AS native_name,
       'Seychellois'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'SC'
UNION ALL
SELECT 'nationality_sl' AS internal_id,
       c.id             AS country_id,
       'Sierra Leonean' AS name,
       NULL             AS native_name,
       'Sierra Leonean' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SL'
UNION ALL
SELECT 'nationality_sg' AS internal_id,
       c.id             AS country_id,
       'Singaporean'    AS name,
       NULL             AS native_name,
       'Singaporean'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'SG'
UNION ALL
SELECT 'nationality_sx' AS internal_id,
       c.id             AS country_id,
       'Sint Maartener' AS name,
       NULL             AS native_name,
       'Sint Maartener' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SX'
UNION ALL
SELECT 'nationality_sk' AS internal_id, c.id AS country_id, 'Slovak' AS name, NULL AS native_name, 'Slovak' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SK'
UNION ALL
SELECT 'nationality_si' AS internal_id,
       c.id             AS country_id,
       'Slovene'        AS name,
       NULL             AS native_name,
       'Slovene'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'SI'
UNION ALL
SELECT 'nationality_sb'   AS internal_id,
       c.id               AS country_id,
       'Solomon Islander' AS name,
       NULL               AS native_name,
       'Solomon Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SB'
UNION ALL
SELECT 'nationality_so' AS internal_id, c.id AS country_id, 'Somali' AS name, NULL AS native_name, 'Somali' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SO'
UNION ALL
SELECT 'nationality_za' AS internal_id,
       c.id             AS country_id,
       'South African'  AS name,
       NULL             AS native_name,
       'South African'  AS adjective
FROM m_country c
WHERE c.country_code2 = 'ZA'
UNION ALL
SELECT 'nationality_gs'                                AS internal_id,
       c.id                                            AS country_id,
       'South Georgia and the South Sandwich Islander' AS name,
       NULL                                            AS native_name,
       'South Georgia and the South Sandwich Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'GS'
UNION ALL
SELECT 'nationality_kr' AS internal_id,
       c.id             AS country_id,
       'South Korean'   AS name,
       NULL             AS native_name,
       'South Korean'   AS adjective
FROM m_country c
WHERE c.country_code2 = 'KR'
UNION ALL
SELECT 'nationality_ss' AS internal_id,
       c.id             AS country_id,
       'South Sudanese' AS name,
       NULL             AS native_name,
       'South Sudanese' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SS'
UNION ALL
SELECT 'nationality_es' AS internal_id,
       c.id             AS country_id,
       'Spanish'        AS name,
       NULL             AS native_name,
       'Spanish'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'ES'
UNION ALL
SELECT 'nationality_lk' AS internal_id,
       c.id             AS country_id,
       'Sri Lankan'     AS name,
       NULL             AS native_name,
       'Sri Lankan'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'LK'
UNION ALL
SELECT 'nationality_sd' AS internal_id,
       c.id             AS country_id,
       'Sudanese'       AS name,
       NULL             AS native_name,
       'Sudanese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'SD'
UNION ALL
SELECT 'nationality_sr' AS internal_id,
       c.id             AS country_id,
       'Surinamer'      AS name,
       NULL             AS native_name,
       'Surinamer'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'SR'
UNION ALL
SELECT 'nationality_sj' AS internal_id,
       c.id             AS country_id,
       'Norwegian'      AS name,
       NULL             AS native_name,
       'Norwegian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'SJ'
UNION ALL
SELECT 'nationality_se' AS internal_id,
       c.id             AS country_id,
       'Swedish'        AS name,
       NULL             AS native_name,
       'Swedish'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'SE'
UNION ALL
SELECT 'nationality_ch' AS internal_id, c.id AS country_id, 'Swiss' AS name, NULL AS native_name, 'Swiss' AS adjective
FROM m_country c
WHERE c.country_code2 = 'CH'
UNION ALL
SELECT 'nationality_sy' AS internal_id, c.id AS country_id, 'Syrian' AS name, NULL AS native_name, 'Syrian' AS adjective
FROM m_country c
WHERE c.country_code2 = 'SY'
UNION ALL
SELECT 'nationality_tw' AS internal_id,
       c.id             AS country_id,
       'Taiwanese'      AS name,
       NULL             AS native_name,
       'Taiwanese'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'TW'
UNION ALL
SELECT 'nationality_tj' AS internal_id,
       c.id             AS country_id,
       'Tadzhik'        AS name,
       NULL             AS native_name,
       'Tadzhik'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'TJ'
UNION ALL
SELECT 'nationality_tz' AS internal_id,
       c.id             AS country_id,
       'Tanzanian'      AS name,
       NULL             AS native_name,
       'Tanzanian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'TZ'
UNION ALL
SELECT 'nationality_th' AS internal_id, c.id AS country_id, 'Thai' AS name, NULL AS native_name, 'Thai' AS adjective
FROM m_country c
WHERE c.country_code2 = 'TH'
UNION ALL
SELECT 'nationality_tl' AS internal_id,
       c.id             AS country_id,
       'Timorese'       AS name,
       NULL             AS native_name,
       'Timorese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'TL'
UNION ALL
SELECT 'nationality_tg' AS internal_id,
       c.id             AS country_id,
       'Togolese'       AS name,
       NULL             AS native_name,
       'Togolese'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'TG'
UNION ALL
SELECT 'nationality_tk' AS internal_id,
       c.id             AS country_id,
       'Tokelauan'      AS name,
       NULL             AS native_name,
       'Tokelauan'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'TK'
UNION ALL
SELECT 'nationality_to' AS internal_id, c.id AS country_id, 'Tongan' AS name, NULL AS native_name, 'Tongan' AS adjective
FROM m_country c
WHERE c.country_code2 = 'TO'
UNION ALL
SELECT 'nationality_tt' AS internal_id,
       c.id             AS country_id,
       'Trinidadian'    AS name,
       NULL             AS native_name,
       'Trinidadian'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'TT'
UNION ALL
SELECT 'nationality_tn' AS internal_id,
       c.id             AS country_id,
       'Tunisian'       AS name,
       NULL             AS native_name,
       'Tunisian'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'TN'
UNION ALL
SELECT 'nationality_tm' AS internal_id,
       c.id             AS country_id,
       'Turkmen'        AS name,
       NULL             AS native_name,
       'Turkmen'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'TM'
UNION ALL
SELECT 'nationality_tc'            AS internal_id,
       c.id                        AS country_id,
       'Turks and Caicos Islander' AS name,
       NULL                        AS native_name,
       'Turks and Caicos Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'TC'
UNION ALL
SELECT 'nationality_tv' AS internal_id,
       c.id             AS country_id,
       'Tuvaluan'       AS name,
       NULL             AS native_name,
       'Tuvaluan'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'TV'
UNION ALL
SELECT 'nationality_tr' AS internal_id,
       c.id             AS country_id,
       'Turkish'        AS name,
       NULL             AS native_name,
       'Turkish'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'TR'
UNION ALL
SELECT 'nationality_ug' AS internal_id,
       c.id             AS country_id,
       'Ugandan'        AS name,
       NULL             AS native_name,
       'Ugandan'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'UG'
UNION ALL
SELECT 'nationality_ua' AS internal_id,
       c.id             AS country_id,
       'Ukrainian'      AS name,
       NULL             AS native_name,
       'Ukrainian'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'UA'
UNION ALL
SELECT 'nationality_ae' AS internal_id,
       c.id             AS country_id,
       'Emirati'        AS name,
       NULL             AS native_name,
       'Emirati'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'AE'
UNION ALL
SELECT 'nationality_gb' AS internal_id,
       c.id             AS country_id,
       'British'        AS name,
       NULL             AS native_name,
       'British'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'GB'
UNION ALL
SELECT 'nationality_us' AS internal_id,
       c.id             AS country_id,
       'American'       AS name,
       NULL             AS native_name,
       'American'       AS adjective
FROM m_country c
WHERE c.country_code2 = 'US'
UNION ALL
SELECT 'nationality_um'               AS internal_id,
       c.id                           AS country_id,
       'U.S. Minor Outlying Islander' AS name,
       NULL                           AS native_name,
       'U.S. Minor Outlying Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'UM'
UNION ALL
SELECT 'nationality_uy' AS internal_id,
       c.id             AS country_id,
       'Uruguayan'      AS name,
       NULL             AS native_name,
       'Uruguayan'      AS adjective
FROM m_country c
WHERE c.country_code2 = 'UY'
UNION ALL
SELECT 'nationality_uz' AS internal_id,
       c.id             AS country_id,
       'Uzbekistani'    AS name,
       NULL             AS native_name,
       'Uzbekistani'    AS adjective
FROM m_country c
WHERE c.country_code2 = 'UZ'
UNION ALL
SELECT 'nationality_vu' AS internal_id,
       c.id             AS country_id,
       'Ni-Vanuatu'     AS name,
       NULL             AS native_name,
       'Ni-Vanuatu'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'VU'
UNION ALL
SELECT 'nationality_ve' AS internal_id,
       c.id             AS country_id,
       'Venezuelan'     AS name,
       NULL             AS native_name,
       'Venezuelan'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'VE'
UNION ALL
SELECT 'nationality_vn' AS internal_id,
       c.id             AS country_id,
       'Vietnamese'     AS name,
       NULL             AS native_name,
       'Vietnamese'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'VN'
UNION ALL
SELECT 'nationality_vg'          AS internal_id,
       c.id                      AS country_id,
       'British Virgin Islander' AS name,
       NULL                      AS native_name,
       'British Virgin Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'VG'
UNION ALL
SELECT 'nationality_vi'       AS internal_id,
       c.id                   AS country_id,
       'U.S. Virgin Islander' AS name,
       NULL                   AS native_name,
       'U.S. Virgin Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'VI'
UNION ALL
SELECT 'nationality_wf'             AS internal_id,
       c.id                         AS country_id,
       'Wallis and Futuna Islander' AS name,
       NULL                         AS native_name,
       'Wallis and Futuna Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'WF'
UNION ALL
SELECT 'nationality_eh' AS internal_id,
       c.id             AS country_id,
       'Sahrawi'        AS name,
       NULL             AS native_name,
       'Sahrawi'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'EH'
UNION ALL
SELECT 'nationality_ye' AS internal_id, c.id AS country_id, 'Yemeni' AS name, NULL AS native_name, 'Yemeni' AS adjective
FROM m_country c
WHERE c.country_code2 = 'YE'
UNION ALL
SELECT 'nationality_zm' AS internal_id,
       c.id             AS country_id,
       'Zambian'        AS name,
       NULL             AS native_name,
       'Zambian'        AS adjective
FROM m_country c
WHERE c.country_code2 = 'ZM'
UNION ALL
SELECT 'nationality_zw' AS internal_id,
       c.id             AS country_id,
       'Zimbabwean'     AS name,
       NULL             AS native_name,
       'Zimbabwean'     AS adjective
FROM m_country c
WHERE c.country_code2 = 'ZW'
UNION ALL
SELECT 'nationality_ax' AS internal_id,
       c.id             AS country_id,
       'Åland Islander' AS name,
       NULL             AS native_name,
       'Åland Islander' AS adjective
FROM m_country c
WHERE c.country_code2 = 'AX' ON CONFLICT (internal_id) DO
UPDATE SET country_id = EXCLUDED.country_id, name = EXCLUDED.name, native_name = EXCLUDED.native_name, adjective = EXCLUDED.adjective,
    updated_at = NOW(), version = m_nationality.version + 1;

INSERT INTO m_country_admin_div_type (internal_id, name, status, created_at, updated_at, created_by, updated_by,
                                      version)
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
UPDATE SET name = EXCLUDED.name, status = EXCLUDED.status, updated_at = NOW(), updated_by = EXCLUDED.updated_by, version = m_country_admin_div_type.version + 1;

INSERT INTO m_country_admin_div_levels (internal_id, name, status, version)
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
UPDATE SET name = EXCLUDED.name, status = EXCLUDED.status, updated_at = NOW(), version = m_country_admin_div_levels.version + 1;

-- UAE: 7 Emirates (Level 1)
INSERT INTO m_country_admin_division(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
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
         CROSS JOIN m_country c
         CROSS JOIN m_country_admin_div_type t
         CROSS JOIN m_country_admin_div_levels l
WHERE c.country_code3 = 'ARE'
  AND t.internal_id = 'EMIRATE'
  AND l.internal_id = 'ADMIN_LEVEL_1' ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id, parent_id = EXCLUDED.parent_id, name = EXCLUDED.name,
    status = EXCLUDED.status, updated_at = NOW(), version = m_country_admin_division.version + 1;

-- USA: States + District of Columbia (Level 1)
INSERT INTO m_country_admin_division
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
         CROSS JOIN m_country c
         CROSS JOIN m_country_admin_div_type t
         CROSS JOIN m_country_admin_div_levels l
WHERE c.country_code3 = 'USA'
  AND t.internal_id = 'STATE'
  AND l.internal_id = 'ADMIN_LEVEL_1' ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id, parent_id = EXCLUDED.parent_id,
    name = EXCLUDED.name, status = EXCLUDED.status, updated_at = NOW(), version = m_country_admin_division.version + 1;

-- India: States + Union Territories (Level 1)
INSERT INTO m_country_admin_division
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
         CROSS JOIN m_country c
         CROSS JOIN m_country_admin_div_type t_state
         CROSS JOIN m_country_admin_div_type t_ut
         CROSS JOIN m_country_admin_div_levels l
WHERE c.country_code3 = 'IND'
  AND t_state.internal_id = 'STATE'
  AND t_ut.internal_id = 'UNION_TERRITORY'
  AND l.internal_id = 'ADMIN_LEVEL_1' ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id, parent_id = EXCLUDED.parent_id, name = EXCLUDED.name,
    status = EXCLUDED.status, updated_at = NOW(), version = m_country_admin_division.version + 1;

-- United Kingdom: m_country (Level 1)
INSERT INTO m_country_admin_division (internal_id, code, country_id, type_id, level_id, parent_id, name, status)
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
         CROSS JOIN m_country c
         CROSS JOIN m_country_admin_div_type t
         CROSS JOIN m_country_admin_div_levels l
WHERE c.country_code3 = 'GBR'
  AND t.internal_id = 'COUNTRY'
  AND l.internal_id = 'ADMIN_LEVEL_1' ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id, parent_id = EXCLUDED.parent_id, name = EXCLUDED.name,
    status = EXCLUDED.status, updated_at = NOW(), version = m_country_admin_division.version + 1;

-- UAE: selected level-2 municipalities under emirates
INSERT INTO m_country_admin_division(internal_id, code, country_id, type_id, level_id, parent_id, name, status)
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
         JOIN m_country c
              ON c.country_code3 = 'ARE'
         JOIN m_country_admin_div_type t ON lower(t.name) = lower('Municipality')
         JOIN m_country_admin_div_levels l ON lower(l.name) = lower('Administrative Level 2')
         JOIN m_country_admin_division p ON p.internal_id = v.parent_internal_id
    AND p.country_id = c.id ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id, parent_id = EXCLUDED.parent_id, name = EXCLUDED.name,
    status = EXCLUDED.status, updated_at = NOW(), version = m_country_admin_division.version + 1;

-- USA: selected counties under selected states
INSERT INTO m_country_admin_division (internal_id, code, country_id, type_id, level_id, parent_id, name, status)
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
         JOIN m_country c
              ON c.country_code3 = 'USA'
         JOIN m_country_admin_div_type t
              ON lower(t.name) = lower('County')
         JOIN m_country_admin_div_levels l
              ON lower(l.name) = lower('Administrative Level 2')
         JOIN m_country_admin_division p
              ON p.internal_id = v.parent_internal_id AND p.country_id = c.id ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id, parent_id = EXCLUDED.parent_id, name = EXCLUDED.name,
    status = EXCLUDED.status, updated_at = NOW(), version = m_country_admin_division.version + 1;

-- India: selected districts under selected states / union territories
INSERT INTO m_country_admin_division
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
         JOIN m_country c
              ON c.country_code3 = 'IND'
         JOIN m_country_admin_div_type t
              ON lower(t.name) = lower('District')
         JOIN m_country_admin_div_levels l
              ON lower(l.name) = lower('Administrative Level 2')
         JOIN m_country_admin_division p
              ON p.internal_id = v.parent_internal_id
                  AND p.country_id = c.id ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id, name = EXCLUDED.name, status = EXCLUDED.status, updated_at = NOW(), version = m_country_admin_division.version + 1;

-- United Kingdom: selected ceremonial/metropolitan counties under England
INSERT INTO m_country_admin_division
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
         JOIN m_country c
              ON c.country_code3 = 'GBR'
         JOIN m_country_admin_div_type t
              ON lower(t.name) = lower('County')
         JOIN m_country_admin_div_levels l
              ON lower(l.name) = lower('Administrative Level 2')
         JOIN m_country_admin_division p
              ON p.internal_id = v.parent_internal_id
                  AND p.country_id = c.id ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id, name = EXCLUDED.name, status = EXCLUDED.status,
    updated_at = NOW(), version = m_country_admin_division.version + 1;

INSERT INTO m_country_admin_division
(internal_id, code, country_id, type_id, level_id, parent_id, name, status, created_at, updated_at, created_by,
 updated_by, version)
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
         JOIN m_country c
              ON c.country_code2 = v.country_code2
         JOIN m_country_admin_div_type t
              ON UPPER(t.name) = UPPER(v.type_name)
         JOIN m_country_admin_div_levels l
              ON UPPER(l.name) = UPPER(v.level_name)
         JOIN m_country_admin_division p
              ON p.country_id = c.id
                  AND p.name = v.parent_name ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id, level_id = EXCLUDED.level_id,
    parent_id = EXCLUDED.parent_id, name = EXCLUDED.name, status = EXCLUDED.status, updated_at = NOW(), updated_by = EXCLUDED.updated_by,
    version = m_country_admin_division.version + 1;

-- =========================
-- India - Level 3
-- Using TEHSIL / TALUK / SUBDISTRICT style child divisions under districts
-- =========================

INSERT INTO m_country_admin_division
(internal_id, code, country_id, type_id, level_id, parent_id, name, status, created_at, updated_at, created_by,
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
         JOIN m_country c
              ON c.country_code2 = v.country_code2
         JOIN m_country_admin_div_type t
              ON UPPER(t.name) = UPPER(v.type_name)
         JOIN m_country_admin_div_levels l
              ON UPPER(l.name) = UPPER(v.level_name)
         JOIN m_country_admin_division p
              ON p.country_id = c.id
                  AND p.name = v.parent_name ON CONFLICT (internal_id) DO
UPDATE SET code = EXCLUDED.code, country_id = EXCLUDED.country_id, type_id = EXCLUDED.type_id,
    level_id = EXCLUDED.level_id, parent_id = EXCLUDED.parent_id, name = EXCLUDED.name, status = EXCLUDED.status,
    updated_at = NOW(), updated_by = EXCLUDED.updated_by, version = m_country_admin_division.version + 1;



INSERT INTO m_city(internal_id, country_id, state_id, name, latitude, longitude, timezone_id, status,
                   created_at, updated_at, created_by, updated_by, version)
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
       1FROM(VALUES
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
                'Asia/Kolkata')) AS v(internal_id, country_code2, state_name, name, latitude, longitude, timezone_name) JOIN m_country c
ON c.country_code2 = v.country_code2
    LEFT JOIN m_country_admin_division s
    ON s.country_id = c.id
    AND s.name = v.state_name
    LEFT JOIN m_timezone tz
    ON tz.name = v.timezone_name ON CONFLICT (internal_id) DO
UPDATE SET country_id = EXCLUDED.country_id, state_id = EXCLUDED.state_id, name = EXCLUDED.name,
    latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude, timezone_id = EXCLUDED.timezone_id,
    status = EXCLUDED.status, updated_at = NOW(), updated_by = EXCLUDED.updated_by, version = m_city.version + 1;

-- =========================
-- m_locality
-- =========================
INSERT INTO m_locality
(internal_id, country_id, state_id, city_id, latitude, longitude, name, timezone_id, status, created_at, updated_at,
 created_by, updated_by, version)
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
       1FROM(VALUES
          -- Abu Dhabi
          ('LOC-UAE-ABU_DHABI-AL_BATEEN', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.42830000, 54.35110000, 'Al Bateen',
           'Asia/Dubai'), ('LOC-UAE-ABU_DHABI-AL_KHALIDIYAH', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.47080000, 54.34470000,
                           'Al Khalidiyah',
                           'Asia/Dubai'),
                          ('LOC-UAE-ABU_DHABI-KHALIFA_CITY', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.42590000, 54.57750000,
                           'Khalifa City',
                           'Asia/Dubai'),
                          ('LOC-UAE-ABU_DHABI-MBZ_CITY', 'AE', 'Abu Dhabi', 'Abu Dhabi', 24.32370000, 54.54840000,
                           'Mohamed Bin Zayed City', 'Asia/Dubai'),

           -- Dubai
                          ('LOC-UAE-DUBAI-DEIRA', 'AE', 'Dubai', 'Dubai', 25.26970000, 55.30880000, 'Deira',
                           'Asia/Dubai'),
                          ('LOC-UAE-DUBAI-BUR_DUBAI', 'AE', 'Dubai', 'Dubai', 25.25480000, 55.29220000, 'Bur Dubai',
                           'Asia/Dubai'),
                          ('LOC-UAE-DUBAI-JUMEIRAH', 'AE', 'Dubai', 'Dubai', 25.20480000, 55.24240000, 'Jumeirah',
                           'Asia/Dubai'),

           -- Bengaluru
                          ('LOC-IND-BENGALURU-WHITEFIELD', 'IN', 'Karnataka', 'Bengaluru', 12.96980000, 77.75000000,
                           'Whitefield',
                           'Asia/Kolkata'),
                          ('LOC-IND-BENGALURU-INDIRANAGAR', 'IN', 'Karnataka', 'Bengaluru', 12.97840000, 77.64080000,
                           'Indiranagar',
                           'Asia/Kolkata'),
                          ('LOC-IND-BENGALURU-KORAMANGALA', 'IN', 'Karnataka', 'Bengaluru', 12.93520000, 77.62450000,
                           'Koramangala',
                           'Asia/Kolkata'),
                          ('LOC-IND-BENGALURU-JAYANAGAR', 'IN', 'Karnataka', 'Bengaluru', 12.92500000, 77.59380000,
                           'Jayanagar',
                           'Asia/Kolkata'),

           -- Kochi
                          ('LOC-IND-KOCHI-FORT_KOCHI', 'IN', 'Kerala', 'Kochi', 9.96670000, 76.24250000, 'Fort Kochi',
                           'Asia/Kolkata'),
                          ('LOC-IND-KOCHI-KALOOR', 'IN', 'Kerala', 'Kochi', 9.99460000, 76.29170000, 'Kaloor',
                           'Asia/Kolkata'),
                          ('LOC-IND-KOCHI-EDAPPALLY', 'IN', 'Kerala', 'Kochi', 10.02770000, 76.30890000, 'Edappally',
                           'Asia/Kolkata'),
                          ('LOC-IND-KOCHI-TRIPUNITHURA', 'IN', 'Kerala', 'Kochi', 9.94970000, 76.34950000,
                           'Tripunithura',
                           'Asia/Kolkata'),

           -- Mumbai
                          ('LOC-IND-MUMBAI-ANDHERI', 'IN', 'Maharashtra', 'Mumbai', 19.11970000, 72.84680000, 'Andheri',
                           'Asia/Kolkata'),
                          ('LOC-IND-MUMBAI-BANDRA', 'IN', 'Maharashtra', 'Mumbai', 19.05960000, 72.82950000, 'Bandra',
                           'Asia/Kolkata')) AS v(internal_id, country_code2, state_name, city_name, latitude, longitude, name,
                                 timezone_name) JOIN m_country c
ON c.country_code2 = v.country_code2
    LEFT JOIN m_country_admin_division s
    ON s.country_id = c.id
    AND s.name = v.state_name
    JOIN m_city ci
    ON ci.country_id = c.id
    AND ci.name = v.city_name
    LEFT JOIN m_timezone tz
    ON tz.name = v.timezone_name ON CONFLICT (internal_id) DO
UPDATE SET country_id = EXCLUDED.country_id, state_id = EXCLUDED.state_id,
    city_id = EXCLUDED.city_id, latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude,
    name = EXCLUDED.name, timezone_id = EXCLUDED.timezone_id, status = EXCLUDED.status,
    updated_at = NOW(), updated_by = EXCLUDED.updated_by, version = m_locality.version + 1;

-- =========================
-- POSTAL CODES
-- =========================
INSERT INTO m_postal_code
(internal_id, country_id, city_id, locality_id, postal_code, status, created_at, updated_at, created_by, updated_by,
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
         JOIN m_country c
              ON c.country_code2 = v.country_code2
         JOIN m_city ci
              ON ci.country_id = c.id
                  AND ci.name = v.city_name
         LEFT JOIN m_locality l
                   ON l.country_id = c.id
                       AND l.city_id = ci.id
                       AND l.name = v.locality_name ON CONFLICT (internal_id) DO
UPDATE SET country_id = EXCLUDED.country_id, city_id = EXCLUDED.city_id, locality_id = EXCLUDED.locality_id, postal_code = EXCLUDED.postal_code,
    status = EXCLUDED.status, updated_at = NOW(), updated_by = EXCLUDED.updated_by, version = m_postal_code.version + 1;



INSERT INTO core.m_language
(internal_id, language_code, name, native_name, direction, display_order, status, created_by, updated_by, version)
VALUES ('LANG_EN', 'en', 'English', 'English', 'ltr', 1, 'A', NULL, NULL, 1),
       ('LANG_HI', 'hi', 'Hindi', 'हिन्दी', 'ltr', 2, 'A', NULL, NULL, 1),
       ('LANG_KN', 'kn', 'Kannada', 'ಕನ್ನಡ', 'ltr', 3, 'A', NULL, NULL, 1),
       ('LANG_ML', 'ml', 'Malayalam', 'മലയാളം', 'ltr', 4, 'A', NULL, NULL, 1),
       ('LANG_TA', 'ta', 'Tamil', 'தமிழ்', 'ltr', 5, 'A', NULL, NULL, 1),
       ('LANG_TE', 'te', 'Telugu', 'తెలుగు', 'ltr', 6, 'A', NULL, NULL, 1),
       ('LANG_MR', 'mr', 'Marathi', 'मराठी', 'ltr', 7, 'A', NULL, NULL, 1),
       ('LANG_BN', 'bn', 'Bengali', 'বাংলা', 'ltr', 8, 'A', NULL, NULL, 1),
       ('LANG_GU', 'gu', 'Gujarati', 'ગુજરાતી', 'ltr', 9, 'A', NULL, NULL, 1),
       ('LANG_PA', 'pa', 'Punjabi', 'ਪੰਜਾਬੀ', 'ltr', 10, 'A', NULL, NULL, 1),
       ('LANG_UR', 'ur', 'Urdu', 'اردو', 'rtl', 11, 'A', NULL, NULL, 1),
       ('LANG_OR', 'or', 'Odia', 'ଓଡ଼ିଆ', 'ltr', 12, 'A', NULL, NULL, 1),
       ('LANG_AS', 'as', 'Assamese', 'অসমীয়া', 'ltr', 13, 'A', NULL, NULL, 1),
       ('LANG_SA', 'sa', 'Sanskrit', 'संस्कृत', 'ltr', 14, 'A', NULL, NULL, 1),
       ('LANG_KS', 'ks', 'Kashmiri', 'کٲشُر', 'rtl', 15, 'A', NULL, NULL, 1),
       ('LANG_SD', 'sd', 'Sindhi', 'سنڌي', 'rtl', 16, 'A', NULL, NULL, 1),
       ('LANG_KOK', 'kok', 'Konkani', 'कोंकणी', 'ltr', 17, 'A', NULL, NULL, 1),
       ('LANG_NE', 'ne', 'Nepali', 'नेपाली', 'ltr', 18, 'A', NULL, NULL, 1),
       ('LANG_MNI', 'mni', 'Manipuri', 'মৈতৈলোন্', 'ltr', 19, 'A', NULL, NULL, 1),
       ('LANG_BRX', 'brx', 'Bodo', 'बर’', 'ltr', 20, 'A', NULL, NULL, 1),
       ('LANG_DOI', 'doi', 'Dogri', 'डोगरी', 'ltr', 21, 'A', NULL, NULL, 1),
       ('LANG_MAI', 'mai', 'Maithili', 'मैथिली', 'ltr', 22, 'A', NULL, NULL, 1),
       ('LANG_SAT', 'sat', 'Santali', 'ᱥᱟᱱᱛᱟᱲᱤ', 'ltr', 23, 'A', NULL, NULL, 1) ON CONFLICT (internal_id) DO NOTHING;


INSERT INTO m_country_calling_code
(internal_id,
 country_id,
 calling_code,
 status,
 created_at,
 updated_at,
 created_by,
 updated_by,
 version)
SELECT v.internal_id,
       c.id,
       v.calling_code,
       'A',
       NOW(),
       NOW(),
       NULL,
       NULL,
       1
FROM (VALUES ('COUNTRY_CALLING_CODE_AE_971', 'AE', '+971'),
             ('COUNTRY_CALLING_CODE_IN_91', 'IN', '+91'),
             ('COUNTRY_CALLING_CODE_AF_93', 'AF', '+93'),
             ('COUNTRY_CALLING_CODE_AG_1268', 'AG', '+1268'),
             ('COUNTRY_CALLING_CODE_AI_1264', 'AI', '+1264'),
             ('COUNTRY_CALLING_CODE_AL_355', 'AL', '+355'),
             ('COUNTRY_CALLING_CODE_AM_374', 'AM', '+374'),
             ('COUNTRY_CALLING_CODE_AO_244', 'AO', '+244'),
             ('COUNTRY_CALLING_CODE_AR_54', 'AR', '+54'),
             ('COUNTRY_CALLING_CODE_AS_1684', 'AS', '+1684'),
             ('COUNTRY_CALLING_CODE_AT_43', 'AT', '+43'),
             ('COUNTRY_CALLING_CODE_AU_61', 'AU', '+61'),
             ('COUNTRY_CALLING_CODE_AW_297', 'AW', '+297'),
             ('COUNTRY_CALLING_CODE_AZ_994', 'AZ', '+994'),
             ('COUNTRY_CALLING_CODE_BA_387', 'BA', '+387'),
             ('COUNTRY_CALLING_CODE_BB_1246', 'BB', '+1246'),
             ('COUNTRY_CALLING_CODE_BD_880', 'BD', '+880'),
             ('COUNTRY_CALLING_CODE_BE_32', 'BE', '+32'),
             ('COUNTRY_CALLING_CODE_BF_226', 'BF', '+226'),
             ('COUNTRY_CALLING_CODE_BG_359', 'BG', '+359'),
             ('COUNTRY_CALLING_CODE_BH_973', 'BH', '+973'),
             ('COUNTRY_CALLING_CODE_BI_257', 'BI', '+257'),
             ('COUNTRY_CALLING_CODE_BJ_229', 'BJ', '+229'),
             ('COUNTRY_CALLING_CODE_BM_1441', 'BM', '+1441'),
             ('COUNTRY_CALLING_CODE_BN_673', 'BN', '+673'),
             ('COUNTRY_CALLING_CODE_BO_591', 'BO', '+591'),
             ('COUNTRY_CALLING_CODE_BR_55', 'BR', '+55'),
             ('COUNTRY_CALLING_CODE_BS_1242', 'BS', '+1242'),
             ('COUNTRY_CALLING_CODE_BT_975', 'BT', '+975'),
             ('COUNTRY_CALLING_CODE_BW_267', 'BW', '+267'),
             ('COUNTRY_CALLING_CODE_BY_375', 'BY', '+375'),
             ('COUNTRY_CALLING_CODE_BZ_501', 'BZ', '+501'),
             ('COUNTRY_CALLING_CODE_CA_1', 'CA', '+1'),
             ('COUNTRY_CALLING_CODE_CC_61', 'CC', '+61'),
             ('COUNTRY_CALLING_CODE_CD_243', 'CD', '+243'),
             ('COUNTRY_CALLING_CODE_CF_236', 'CF', '+236'),
             ('COUNTRY_CALLING_CODE_CG_242', 'CG', '+242'),
             ('COUNTRY_CALLING_CODE_CH_41', 'CH', '+41'),
             ('COUNTRY_CALLING_CODE_CI_225', 'CI', '+225'),
             ('COUNTRY_CALLING_CODE_CK_682', 'CK', '+682'),
             ('COUNTRY_CALLING_CODE_CL_56', 'CL', '+56'),
             ('COUNTRY_CALLING_CODE_CM_237', 'CM', '+237'),
             ('COUNTRY_CALLING_CODE_CN_86', 'CN', '+86'),
             ('COUNTRY_CALLING_CODE_CO_57', 'CO', '+57'),
             ('COUNTRY_CALLING_CODE_CR_506', 'CR', '+506'),
             ('COUNTRY_CALLING_CODE_CU_53', 'CU', '+53'),
             ('COUNTRY_CALLING_CODE_CV_238', 'CV', '+238'),
             ('COUNTRY_CALLING_CODE_CX_61', 'CX', '+61'),
             ('COUNTRY_CALLING_CODE_CY_357', 'CY', '+357'),
             ('COUNTRY_CALLING_CODE_CZ_420', 'CZ', '+420'),
             ('COUNTRY_CALLING_CODE_DE_49', 'DE', '+49'),
             ('COUNTRY_CALLING_CODE_DJ_253', 'DJ', '+253'),
             ('COUNTRY_CALLING_CODE_DK_45', 'DK', '+45'),
             ('COUNTRY_CALLING_CODE_DM_1767', 'DM', '+1767'),
             ('COUNTRY_CALLING_CODE_DO_1809', 'DO', '+1809'),
             ('COUNTRY_CALLING_CODE_DZ_213', 'DZ', '+213'),
             ('COUNTRY_CALLING_CODE_EC_593', 'EC', '+593'),
             ('COUNTRY_CALLING_CODE_EE_372', 'EE', '+372'),
             ('COUNTRY_CALLING_CODE_EG_20', 'EG', '+20'),
             ('COUNTRY_CALLING_CODE_EH_212', 'EH', '+212'),
             ('COUNTRY_CALLING_CODE_ER_291', 'ER', '+291'),
             ('COUNTRY_CALLING_CODE_ES_34', 'ES', '+34'),
             ('COUNTRY_CALLING_CODE_ET_251', 'ET', '+251'),
             ('COUNTRY_CALLING_CODE_FI_358', 'FI', '+358'),
             ('COUNTRY_CALLING_CODE_FJ_679', 'FJ', '+679'),
             ('COUNTRY_CALLING_CODE_FM_691', 'FM', '+691'),
             ('COUNTRY_CALLING_CODE_FO_298', 'FO', '+298'),
             ('COUNTRY_CALLING_CODE_FR_33', 'FR', '+33'),
             ('COUNTRY_CALLING_CODE_GA_241', 'GA', '+241'),
             ('COUNTRY_CALLING_CODE_GB_44', 'GB', '+44'),
             ('COUNTRY_CALLING_CODE_GD_1473', 'GD', '+1473'),
             ('COUNTRY_CALLING_CODE_GE_995', 'GE', '+995'),
             ('COUNTRY_CALLING_CODE_GF_594', 'GF', '+594'),
             ('COUNTRY_CALLING_CODE_GG_44', 'GG', '+44'),
             ('COUNTRY_CALLING_CODE_GH_233', 'GH', '+233'),
             ('COUNTRY_CALLING_CODE_GI_350', 'GI', '+350'),
             ('COUNTRY_CALLING_CODE_GL_299', 'GL', '+299'),
             ('COUNTRY_CALLING_CODE_GM_220', 'GM', '+220'),
             ('COUNTRY_CALLING_CODE_GN_224', 'GN', '+224'),
             ('COUNTRY_CALLING_CODE_GP_590', 'GP', '+590'),
             ('COUNTRY_CALLING_CODE_GQ_240', 'GQ', '+240'),
             ('COUNTRY_CALLING_CODE_GR_30', 'GR', '+30'),
             ('COUNTRY_CALLING_CODE_GS_500', 'GS', '+500'),
             ('COUNTRY_CALLING_CODE_GT_502', 'GT', '+502'),
             ('COUNTRY_CALLING_CODE_GU_1671', 'GU', '+1671'),
             ('COUNTRY_CALLING_CODE_GW_245', 'GW', '+245'),
             ('COUNTRY_CALLING_CODE_GY_592', 'GY', '+592'),
             ('COUNTRY_CALLING_CODE_HK_852', 'HK', '+852'),
             ('COUNTRY_CALLING_CODE_HN_504', 'HN', '+504'),
             ('COUNTRY_CALLING_CODE_HR_385', 'HR', '+385'),
             ('COUNTRY_CALLING_CODE_HT_509', 'HT', '+509'),
             ('COUNTRY_CALLING_CODE_HU_36', 'HU', '+36'),
             ('COUNTRY_CALLING_CODE_ID_62', 'ID', '+62'),
             ('COUNTRY_CALLING_CODE_IE_353', 'IE', '+353'),
             ('COUNTRY_CALLING_CODE_IL_972', 'IL', '+972'),
             ('COUNTRY_CALLING_CODE_IM_44', 'IM', '+44'),
             ('COUNTRY_CALLING_CODE_IO_246', 'IO', '+246'),
             ('COUNTRY_CALLING_CODE_IQ_964', 'IQ', '+964'),
             ('COUNTRY_CALLING_CODE_IR_98', 'IR', '+98'),
             ('COUNTRY_CALLING_CODE_IS_354', 'IS', '+354'),
             ('COUNTRY_CALLING_CODE_IT_39', 'IT', '+39'),
             ('COUNTRY_CALLING_CODE_JE_44', 'JE', '+44'),
             ('COUNTRY_CALLING_CODE_JM_1876', 'JM', '+1876'),
             ('COUNTRY_CALLING_CODE_JO_962', 'JO', '+962'),
             ('COUNTRY_CALLING_CODE_JP_81', 'JP', '+81'),
             ('COUNTRY_CALLING_CODE_KE_254', 'KE', '+254'),
             ('COUNTRY_CALLING_CODE_KG_996', 'KG', '+996'),
             ('COUNTRY_CALLING_CODE_KH_855', 'KH', '+855'),
             ('COUNTRY_CALLING_CODE_KI_686', 'KI', '+686'),
             ('COUNTRY_CALLING_CODE_KM_269', 'KM', '+269'),
             ('COUNTRY_CALLING_CODE_KN_1869', 'KN', '+1869'),
             ('COUNTRY_CALLING_CODE_KP_850', 'KP', '+850'),
             ('COUNTRY_CALLING_CODE_KR_82', 'KR', '+82'),
             ('COUNTRY_CALLING_CODE_KW_965', 'KW', '+965'),
             ('COUNTRY_CALLING_CODE_KY_1345', 'KY', '+1345'),
             ('COUNTRY_CALLING_CODE_KZ_76', 'KZ', '+76'),
             ('COUNTRY_CALLING_CODE_LA_856', 'LA', '+856'),
             ('COUNTRY_CALLING_CODE_LB_961', 'LB', '+961'),
             ('COUNTRY_CALLING_CODE_LC_1758', 'LC', '+1758'),
             ('COUNTRY_CALLING_CODE_LI_423', 'LI', '+423'),
             ('COUNTRY_CALLING_CODE_LK_94', 'LK', '+94'),
             ('COUNTRY_CALLING_CODE_LR_231', 'LR', '+231'),
             ('COUNTRY_CALLING_CODE_LS_266', 'LS', '+266'),
             ('COUNTRY_CALLING_CODE_LT_370', 'LT', '+370'),
             ('COUNTRY_CALLING_CODE_LU_352', 'LU', '+352'),
             ('COUNTRY_CALLING_CODE_LV_371', 'LV', '+371'),
             ('COUNTRY_CALLING_CODE_LY_218', 'LY', '+218'),
             ('COUNTRY_CALLING_CODE_MA_212', 'MA', '+212'),
             ('COUNTRY_CALLING_CODE_MC_377', 'MC', '+377'),
             ('COUNTRY_CALLING_CODE_MD_373', 'MD', '+373'),
             ('COUNTRY_CALLING_CODE_MG_261', 'MG', '+261'),
             ('COUNTRY_CALLING_CODE_MH_692', 'MH', '+692'),
             ('COUNTRY_CALLING_CODE_ML_223', 'ML', '+223'),
             ('COUNTRY_CALLING_CODE_MN_976', 'MN', '+976'),
             ('COUNTRY_CALLING_CODE_MP_1670', 'MP', '+1670'),
             ('COUNTRY_CALLING_CODE_MQ_596', 'MQ', '+596'),
             ('COUNTRY_CALLING_CODE_MR_222', 'MR', '+222'),
             ('COUNTRY_CALLING_CODE_MS_1664', 'MS', '+1664'),
             ('COUNTRY_CALLING_CODE_MT_356', 'MT', '+356'),
             ('COUNTRY_CALLING_CODE_MU_230', 'MU', '+230'),
             ('COUNTRY_CALLING_CODE_MV_960', 'MV', '+960'),
             ('COUNTRY_CALLING_CODE_MW_265', 'MW', '+265'),
             ('COUNTRY_CALLING_CODE_MX_52', 'MX', '+52'),
             ('COUNTRY_CALLING_CODE_MY_60', 'MY', '+60'),
             ('COUNTRY_CALLING_CODE_MZ_258', 'MZ', '+258'),
             ('COUNTRY_CALLING_CODE_NA_264', 'NA', '+264'),
             ('COUNTRY_CALLING_CODE_NC_687', 'NC', '+687'),
             ('COUNTRY_CALLING_CODE_NE_227', 'NE', '+227'),
             ('COUNTRY_CALLING_CODE_NF_672', 'NF', '+672'),
             ('COUNTRY_CALLING_CODE_NG_234', 'NG', '+234'),
             ('COUNTRY_CALLING_CODE_NI_505', 'NI', '+505'),
             ('COUNTRY_CALLING_CODE_NL_31', 'NL', '+31'),
             ('COUNTRY_CALLING_CODE_NO_47', 'NO', '+47'),
             ('COUNTRY_CALLING_CODE_NP_977', 'NP', '+977'),
             ('COUNTRY_CALLING_CODE_NR_674', 'NR', '+674'),
             ('COUNTRY_CALLING_CODE_NU_683', 'NU', '+683'),
             ('COUNTRY_CALLING_CODE_NZ_64', 'NZ', '+64'),
             ('COUNTRY_CALLING_CODE_OM_968', 'OM', '+968'),
             ('COUNTRY_CALLING_CODE_PA_507', 'PA', '+507'),
             ('COUNTRY_CALLING_CODE_PE_51', 'PE', '+51'),
             ('COUNTRY_CALLING_CODE_PF_689', 'PF', '+689'),
             ('COUNTRY_CALLING_CODE_PG_675', 'PG', '+675'),
             ('COUNTRY_CALLING_CODE_PH_63', 'PH', '+63'),
             ('COUNTRY_CALLING_CODE_PK_92', 'PK', '+92'),
             ('COUNTRY_CALLING_CODE_PL_48', 'PL', '+48'),
             ('COUNTRY_CALLING_CODE_PM_508', 'PM', '+508'),
             ('COUNTRY_CALLING_CODE_PR_1787', 'PR', '+1787'),
             ('COUNTRY_CALLING_CODE_PT_351', 'PT', '+351'),
             ('COUNTRY_CALLING_CODE_PW_680', 'PW', '+680'),
             ('COUNTRY_CALLING_CODE_PY_595', 'PY', '+595'),
             ('COUNTRY_CALLING_CODE_QA_974', 'QA', '+974'),
             ('COUNTRY_CALLING_CODE_RE_262', 'RE', '+262'),
             ('COUNTRY_CALLING_CODE_RO_40', 'RO', '+40'),
             ('COUNTRY_CALLING_CODE_RS_381', 'RS', '+381'),
             ('COUNTRY_CALLING_CODE_RU_7', 'RU', '+7'),
             ('COUNTRY_CALLING_CODE_RW_250', 'RW', '+250'),
             ('COUNTRY_CALLING_CODE_SA_966', 'SA', '+966'),
             ('COUNTRY_CALLING_CODE_SB_677', 'SB', '+677'),
             ('COUNTRY_CALLING_CODE_SC_248', 'SC', '+248'),
             ('COUNTRY_CALLING_CODE_SD_249', 'SD', '+249'),
             ('COUNTRY_CALLING_CODE_SE_46', 'SE', '+46'),
             ('COUNTRY_CALLING_CODE_SG_65', 'SG', '+65'),
             ('COUNTRY_CALLING_CODE_SI_386', 'SI', '+386'),
             ('COUNTRY_CALLING_CODE_SJ_4779', 'SJ', '+4779'),
             ('COUNTRY_CALLING_CODE_SK_421', 'SK', '+421'),
             ('COUNTRY_CALLING_CODE_SL_232', 'SL', '+232'),
             ('COUNTRY_CALLING_CODE_SM_378', 'SM', '+378'),
             ('COUNTRY_CALLING_CODE_SN_221', 'SN', '+221'),
             ('COUNTRY_CALLING_CODE_SO_252', 'SO', '+252'),
             ('COUNTRY_CALLING_CODE_SR_597', 'SR', '+597'),
             ('COUNTRY_CALLING_CODE_SS_211', 'SS', '+211'),
             ('COUNTRY_CALLING_CODE_SV_503', 'SV', '+503'),
             ('COUNTRY_CALLING_CODE_SY_963', 'SY', '+963'),
             ('COUNTRY_CALLING_CODE_TD_235', 'TD', '+235'),
             ('COUNTRY_CALLING_CODE_TG_228', 'TG', '+228'),
             ('COUNTRY_CALLING_CODE_TH_66', 'TH', '+66'),
             ('COUNTRY_CALLING_CODE_TJ_992', 'TJ', '+992'),
             ('COUNTRY_CALLING_CODE_TK_690', 'TK', '+690'),
             ('COUNTRY_CALLING_CODE_TL_670', 'TL', '+670'),
             ('COUNTRY_CALLING_CODE_TM_993', 'TM', '+993'),
             ('COUNTRY_CALLING_CODE_TN_216', 'TN', '+216'),
             ('COUNTRY_CALLING_CODE_TO_676', 'TO', '+676'),
             ('COUNTRY_CALLING_CODE_TR_90', 'TR', '+90'),
             ('COUNTRY_CALLING_CODE_TT_1868', 'TT', '+1868'),
             ('COUNTRY_CALLING_CODE_TV_688', 'TV', '+688'),
             ('COUNTRY_CALLING_CODE_TW_886', 'TW', '+886'),
             ('COUNTRY_CALLING_CODE_TZ_255', 'TZ', '+255'),
             ('COUNTRY_CALLING_CODE_UA_380', 'UA', '+380'),
             ('COUNTRY_CALLING_CODE_UG_256', 'UG', '+256'),
             ('COUNTRY_CALLING_CODE_US_1', 'US', '+1'),
             ('COUNTRY_CALLING_CODE_UY_598', 'UY', '+598'),
             ('COUNTRY_CALLING_CODE_UZ_998', 'UZ', '+998'),
             ('COUNTRY_CALLING_CODE_VC_1784', 'VC', '+1784'),
             ('COUNTRY_CALLING_CODE_VE_58', 'VE', '+58'),
             ('COUNTRY_CALLING_CODE_VN_84', 'VN', '+84'),
             ('COUNTRY_CALLING_CODE_VU_678', 'VU', '+678'),
             ('COUNTRY_CALLING_CODE_WF_681', 'WF', '+681'),
             ('COUNTRY_CALLING_CODE_WS_685', 'WS', '+685'),
             ('COUNTRY_CALLING_CODE_YE_967', 'YE', '+967'),
             ('COUNTRY_CALLING_CODE_YT_262', 'YT', '+262'),
             ('COUNTRY_CALLING_CODE_ZA_27', 'ZA', '+27'),
             ('COUNTRY_CALLING_CODE_ZM_260', 'ZM', '+260'),
             ('COUNTRY_CALLING_CODE_ZW_263', 'ZW', '+263')) AS v(internal_id, country_code2, calling_code)
         JOIN m_country c
              ON c.country_code2 = v.country_code2 ON CONFLICT (internal_id) DO
UPDATE
    SET
        country_id = EXCLUDED.country_id,
    calling_code = EXCLUDED.calling_code,
    status = EXCLUDED.status,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by,
    version = m_country_calling_code.version + 1;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_EN_IN',
       'en-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'en' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_HI_IN',
       'hi-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'hi' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_KN_IN',
       'kn-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'kn' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_ML_IN',
       'ml-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ml' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_TA_IN',
       'ta-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ta' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_TE_IN',
       'te-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'te' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_MR_IN',
       'mr-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'mr' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_BN_IN',
       'bn-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'bn' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_GU_IN',
       'gu-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'gu' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_PA_IN',
       'pa-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'pa' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_UR_IN',
       'ur-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ur' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_OR_IN',
       'or-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'or' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_AS_IN',
       'as-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'as' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_SA_IN',
       'sa-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'sa' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_KS_IN',
       'ks-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ks' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_SD_IN',
       'sd-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'sd' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_KOK_IN',
       'kok-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'kok' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_NE_IN',
       'ne-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ne' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_MNI_IN',
       'mni-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'mni' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_BRX_IN',
       'brx-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'brx' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_DOI_IN',
       'doi-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'doi' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_MAI_IN',
       'mai-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'mai' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_locale
(internal_id, locale_code, language_id, country_id, date_format, time_format, first_day_of_week, is_active, status,
 created_by, updated_by, version)
SELECT 'LOC_SAT_IN',
       'sat-IN',
       l.id,
       c.id,
       'DD-MM-YYYY',
       '12h',
       1,
       TRUE,
       'A',
       NULL,
       NULL,
       1
FROM m_language l
         JOIN m_country c ON c.country_code2 = 'IN'
WHERE l.language_code = 'sat' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO m_currency (internal_id, currency_code, name, symbol, symbol_position, decimal_places, status)
VALUES ('CUR_AED', 'AED', 'UAE Dirham', 'AED', 'before', 2, 'A'),
       ('CUR_INR', 'INR', 'Indian Rupee', '₹', 'before', 2, 'A') ON CONFLICT (internal_id) DO NOTHING;


INSERT INTO map_country_currency
(internal_id, country_id, currency_id, status, created_by, updated_by, version)
SELECT 'CCY_MAP_INDIA_INR',
       c.id,
       cur.id,
       'A',
       NULL,
       NULL,
       1
FROM m_country c
         JOIN m_currency cur
              ON cur.currency_code = 'INR'
WHERE c.country_code2 = 'IN' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO map_country_currency
(internal_id, country_id, currency_id, status, created_by, updated_by, version)
SELECT 'CCY_MAP_UAE_AED',
       c.id,
       cur.id,
       'A',
       NULL,
       NULL,
       1
FROM m_country c
         JOIN m_currency cur
              ON cur.currency_code = 'AED'
WHERE c.country_code2 = 'AE' ON CONFLICT (internal_id) DO NOTHING;


INSERT INTO m_address_type (internal_id, type_key, label, display_order, status)
VALUES ('ADDR_TYPE_HOME', 'HOME', 'Home', 1, 'A'),
       ('ADDR_TYPE_WORK', 'WORK', 'Work', 2, 'A'),
       ('ADDR_TYPE_BILLING', 'BILLING', 'Billing', 3, 'A'),
       ('ADDR_TYPE_SHIPPING', 'SHIPPING', 'Shipping', 4, 'A'),
       ('ADDR_TYPE_MAILING', 'MAILING', 'Mailing', 5, 'A'),
       ('ADDR_TYPE_REGISTERED', 'REGISTERED', 'Registered', 6, 'A'),
       ('ADDR_TYPE_PERMANENT', 'PERMANENT', 'Permanent', 7, 'A'),
       ('ADDR_TYPE_TEMPORARY', 'TEMPORARY', 'Temporary', 8, 'A'),
       ('ADDR_TYPE_OFFICE', 'OFFICE', 'Office', 9, 'A'),
       ('ADDR_TYPE_OTHER', 'OTHER', 'Other', 10, 'A');


