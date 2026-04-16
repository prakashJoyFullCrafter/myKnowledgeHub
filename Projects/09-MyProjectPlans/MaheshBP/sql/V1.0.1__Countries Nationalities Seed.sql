-- Seed data for countries and nationalities
-- Scope: ISO 3166-1 assigned country/territory entries.
-- Nationality values are English demonyms; native_name is left NULL for manual localization.
set
search_path to core;


INSERT INTO countries (
    internal_id,
    country_code2,
    country_code3,
    country_code_numeric,
    name
)
VALUES
('country_af', 'AF', 'AFG', 4, 'Afghanistan'),
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
('country_ax', 'AX', 'ALA', 248, 'Åland Islands')
ON CONFLICT (country_code2) DO UPDATE SET
    internal_id = EXCLUDED.internal_id,
    country_code3 = EXCLUDED.country_code3,
    country_code_numeric = EXCLUDED.country_code_numeric,
    name = EXCLUDED.name,
    updated_at = NOW(),
    version = countries.version + 1;

INSERT INTO nationalities (
    internal_id,
    country_id,
    name,
    native_name,
    adjective
)
SELECT 'nationality_af' AS internal_id, c.id AS country_id, 'Afghan' AS name, NULL AS native_name, 'Afghan' AS adjective FROM countries c WHERE c.country_code2 = 'AF'
UNION ALL
SELECT 'nationality_al' AS internal_id, c.id AS country_id, 'Albanian' AS name, NULL AS native_name, 'Albanian' AS adjective FROM countries c WHERE c.country_code2 = 'AL'
UNION ALL
SELECT 'nationality_dz' AS internal_id, c.id AS country_id, 'Algerian' AS name, NULL AS native_name, 'Algerian' AS adjective FROM countries c WHERE c.country_code2 = 'DZ'
UNION ALL
SELECT 'nationality_as' AS internal_id, c.id AS country_id, 'American Samoan' AS name, NULL AS native_name, 'American Samoan' AS adjective FROM countries c WHERE c.country_code2 = 'AS'
UNION ALL
SELECT 'nationality_ad' AS internal_id, c.id AS country_id, 'Andorran' AS name, NULL AS native_name, 'Andorran' AS adjective FROM countries c WHERE c.country_code2 = 'AD'
UNION ALL
SELECT 'nationality_ao' AS internal_id, c.id AS country_id, 'Angolan' AS name, NULL AS native_name, 'Angolan' AS adjective FROM countries c WHERE c.country_code2 = 'AO'
UNION ALL
SELECT 'nationality_ai' AS internal_id, c.id AS country_id, 'Anguillian' AS name, NULL AS native_name, 'Anguillian' AS adjective FROM countries c WHERE c.country_code2 = 'AI'
UNION ALL
SELECT 'nationality_aq' AS internal_id, c.id AS country_id, 'Antarctic' AS name, NULL AS native_name, 'Antarctic' AS adjective FROM countries c WHERE c.country_code2 = 'AQ'
UNION ALL
SELECT 'nationality_ag' AS internal_id, c.id AS country_id, 'Antiguan,Barbudan' AS name, NULL AS native_name, 'Antiguan,Barbudan' AS adjective FROM countries c WHERE c.country_code2 = 'AG'
UNION ALL
SELECT 'nationality_ar' AS internal_id, c.id AS country_id, 'Argentinean' AS name, NULL AS native_name, 'Argentinean' AS adjective FROM countries c WHERE c.country_code2 = 'AR'
UNION ALL
SELECT 'nationality_am' AS internal_id, c.id AS country_id, 'Armenian' AS name, NULL AS native_name, 'Armenian' AS adjective FROM countries c WHERE c.country_code2 = 'AM'
UNION ALL
SELECT 'nationality_aw' AS internal_id, c.id AS country_id, 'Aruban' AS name, NULL AS native_name, 'Aruban' AS adjective FROM countries c WHERE c.country_code2 = 'AW'
UNION ALL
SELECT 'nationality_au' AS internal_id, c.id AS country_id, 'Australian' AS name, NULL AS native_name, 'Australian' AS adjective FROM countries c WHERE c.country_code2 = 'AU'
UNION ALL
SELECT 'nationality_at' AS internal_id, c.id AS country_id, 'Austrian' AS name, NULL AS native_name, 'Austrian' AS adjective FROM countries c WHERE c.country_code2 = 'AT'
UNION ALL
SELECT 'nationality_az' AS internal_id, c.id AS country_id, 'Azerbaijani' AS name, NULL AS native_name, 'Azerbaijani' AS adjective FROM countries c WHERE c.country_code2 = 'AZ'
UNION ALL
SELECT 'nationality_bs' AS internal_id, c.id AS country_id, 'Bahamian' AS name, NULL AS native_name, 'Bahamian' AS adjective FROM countries c WHERE c.country_code2 = 'BS'
UNION ALL
SELECT 'nationality_bh' AS internal_id, c.id AS country_id, 'Bahraini' AS name, NULL AS native_name, 'Bahraini' AS adjective FROM countries c WHERE c.country_code2 = 'BH'
UNION ALL
SELECT 'nationality_bd' AS internal_id, c.id AS country_id, 'Bangladeshi' AS name, NULL AS native_name, 'Bangladeshi' AS adjective FROM countries c WHERE c.country_code2 = 'BD'
UNION ALL
SELECT 'nationality_bb' AS internal_id, c.id AS country_id, 'Barbadian' AS name, NULL AS native_name, 'Barbadian' AS adjective FROM countries c WHERE c.country_code2 = 'BB'
UNION ALL
SELECT 'nationality_by' AS internal_id, c.id AS country_id, 'Belarusian' AS name, NULL AS native_name, 'Belarusian' AS adjective FROM countries c WHERE c.country_code2 = 'BY'
UNION ALL
SELECT 'nationality_be' AS internal_id, c.id AS country_id, 'Belgian' AS name, NULL AS native_name, 'Belgian' AS adjective FROM countries c WHERE c.country_code2 = 'BE'
UNION ALL
SELECT 'nationality_bz' AS internal_id, c.id AS country_id, 'Belizean' AS name, NULL AS native_name, 'Belizean' AS adjective FROM countries c WHERE c.country_code2 = 'BZ'
UNION ALL
SELECT 'nationality_bj' AS internal_id, c.id AS country_id, 'Beninese' AS name, NULL AS native_name, 'Beninese' AS adjective FROM countries c WHERE c.country_code2 = 'BJ'
UNION ALL
SELECT 'nationality_bm' AS internal_id, c.id AS country_id, 'Bermudian' AS name, NULL AS native_name, 'Bermudian' AS adjective FROM countries c WHERE c.country_code2 = 'BM'
UNION ALL
SELECT 'nationality_bt' AS internal_id, c.id AS country_id, 'Bhutanese' AS name, NULL AS native_name, 'Bhutanese' AS adjective FROM countries c WHERE c.country_code2 = 'BT'
UNION ALL
SELECT 'nationality_bo' AS internal_id, c.id AS country_id, 'Bolivian' AS name, NULL AS native_name, 'Bolivian' AS adjective FROM countries c WHERE c.country_code2 = 'BO'
UNION ALL
SELECT 'nationality_bq' AS internal_id, c.id AS country_id, 'Caribbean Dutch' AS name, NULL AS native_name, 'Caribbean Dutch' AS adjective FROM countries c WHERE c.country_code2 = 'BQ'
UNION ALL
SELECT 'nationality_ba' AS internal_id, c.id AS country_id, 'Bosnian,Herzegovinian' AS name, NULL AS native_name, 'Bosnian,Herzegovinian' AS adjective FROM countries c WHERE c.country_code2 = 'BA'
UNION ALL
SELECT 'nationality_bw' AS internal_id, c.id AS country_id, 'Motswana' AS name, NULL AS native_name, 'Motswana' AS adjective FROM countries c WHERE c.country_code2 = 'BW'
UNION ALL
SELECT 'nationality_bv' AS internal_id, c.id AS country_id, 'Bouvet Islander' AS name, NULL AS native_name, 'Bouvet Islander' AS adjective FROM countries c WHERE c.country_code2 = 'BV'
UNION ALL
SELECT 'nationality_br' AS internal_id, c.id AS country_id, 'Brazilian' AS name, NULL AS native_name, 'Brazilian' AS adjective FROM countries c WHERE c.country_code2 = 'BR'
UNION ALL
SELECT 'nationality_io' AS internal_id, c.id AS country_id, 'Indian' AS name, NULL AS native_name, 'Indian' AS adjective FROM countries c WHERE c.country_code2 = 'IO'
UNION ALL
SELECT 'nationality_bn' AS internal_id, c.id AS country_id, 'Bruneian' AS name, NULL AS native_name, 'Bruneian' AS adjective FROM countries c WHERE c.country_code2 = 'BN'
UNION ALL
SELECT 'nationality_bg' AS internal_id, c.id AS country_id, 'Bulgarian' AS name, NULL AS native_name, 'Bulgarian' AS adjective FROM countries c WHERE c.country_code2 = 'BG'
UNION ALL
SELECT 'nationality_bf' AS internal_id, c.id AS country_id, 'Burkinabe' AS name, NULL AS native_name, 'Burkinabe' AS adjective FROM countries c WHERE c.country_code2 = 'BF'
UNION ALL
SELECT 'nationality_bi' AS internal_id, c.id AS country_id, 'Burundian' AS name, NULL AS native_name, 'Burundian' AS adjective FROM countries c WHERE c.country_code2 = 'BI'
UNION ALL
SELECT 'nationality_cv' AS internal_id, c.id AS country_id, 'Cape Verdian' AS name, NULL AS native_name, 'Cape Verdian' AS adjective FROM countries c WHERE c.country_code2 = 'CV'
UNION ALL
SELECT 'nationality_kh' AS internal_id, c.id AS country_id, 'Cambodian' AS name, NULL AS native_name, 'Cambodian' AS adjective FROM countries c WHERE c.country_code2 = 'KH'
UNION ALL
SELECT 'nationality_cm' AS internal_id, c.id AS country_id, 'Cameroonian' AS name, NULL AS native_name, 'Cameroonian' AS adjective FROM countries c WHERE c.country_code2 = 'CM'
UNION ALL
SELECT 'nationality_ca' AS internal_id, c.id AS country_id, 'Canadian' AS name, NULL AS native_name, 'Canadian' AS adjective FROM countries c WHERE c.country_code2 = 'CA'
UNION ALL
SELECT 'nationality_ky' AS internal_id, c.id AS country_id, 'Caymanian' AS name, NULL AS native_name, 'Caymanian' AS adjective FROM countries c WHERE c.country_code2 = 'KY'
UNION ALL
SELECT 'nationality_cf' AS internal_id, c.id AS country_id, 'Central African' AS name, NULL AS native_name, 'Central African' AS adjective FROM countries c WHERE c.country_code2 = 'CF'
UNION ALL
SELECT 'nationality_td' AS internal_id, c.id AS country_id, 'Chadian' AS name, NULL AS native_name, 'Chadian' AS adjective FROM countries c WHERE c.country_code2 = 'TD'
UNION ALL
SELECT 'nationality_cl' AS internal_id, c.id AS country_id, 'Chilean' AS name, NULL AS native_name, 'Chilean' AS adjective FROM countries c WHERE c.country_code2 = 'CL'
UNION ALL
SELECT 'nationality_cn' AS internal_id, c.id AS country_id, 'Chinese' AS name, NULL AS native_name, 'Chinese' AS adjective FROM countries c WHERE c.country_code2 = 'CN'
UNION ALL
SELECT 'nationality_cx' AS internal_id, c.id AS country_id, 'Christmas Island' AS name, NULL AS native_name, 'Christmas Island' AS adjective FROM countries c WHERE c.country_code2 = 'CX'
UNION ALL
SELECT 'nationality_cc' AS internal_id, c.id AS country_id, 'Cocos Islander' AS name, NULL AS native_name, 'Cocos Islander' AS adjective FROM countries c WHERE c.country_code2 = 'CC'
UNION ALL
SELECT 'nationality_co' AS internal_id, c.id AS country_id, 'Colombian' AS name, NULL AS native_name, 'Colombian' AS adjective FROM countries c WHERE c.country_code2 = 'CO'
UNION ALL
SELECT 'nationality_km' AS internal_id, c.id AS country_id, 'Comoran' AS name, NULL AS native_name, 'Comoran' AS adjective FROM countries c WHERE c.country_code2 = 'KM'
UNION ALL
SELECT 'nationality_cg' AS internal_id, c.id AS country_id, 'Congolese' AS name, NULL AS native_name, 'Congolese' AS adjective FROM countries c WHERE c.country_code2 = 'CG'
UNION ALL
SELECT 'nationality_cd' AS internal_id, c.id AS country_id, 'Congolese' AS name, NULL AS native_name, 'Congolese' AS adjective FROM countries c WHERE c.country_code2 = 'CD'
UNION ALL
SELECT 'nationality_ck' AS internal_id, c.id AS country_id, 'Cook Islander' AS name, NULL AS native_name, 'Cook Islander' AS adjective FROM countries c WHERE c.country_code2 = 'CK'
UNION ALL
SELECT 'nationality_cr' AS internal_id, c.id AS country_id, 'Costa Rican' AS name, NULL AS native_name, 'Costa Rican' AS adjective FROM countries c WHERE c.country_code2 = 'CR'
UNION ALL
SELECT 'nationality_hr' AS internal_id, c.id AS country_id, 'Croatian' AS name, NULL AS native_name, 'Croatian' AS adjective FROM countries c WHERE c.country_code2 = 'HR'
UNION ALL
SELECT 'nationality_cu' AS internal_id, c.id AS country_id, 'Cuban' AS name, NULL AS native_name, 'Cuban' AS adjective FROM countries c WHERE c.country_code2 = 'CU'
UNION ALL
SELECT 'nationality_cw' AS internal_id, c.id AS country_id, 'Curaçaoan' AS name, NULL AS native_name, 'Curaçaoan' AS adjective FROM countries c WHERE c.country_code2 = 'CW'
UNION ALL
SELECT 'nationality_cy' AS internal_id, c.id AS country_id, 'Cypriot' AS name, NULL AS native_name, 'Cypriot' AS adjective FROM countries c WHERE c.country_code2 = 'CY'
UNION ALL
SELECT 'nationality_cz' AS internal_id, c.id AS country_id, 'Czech' AS name, NULL AS native_name, 'Czech' AS adjective FROM countries c WHERE c.country_code2 = 'CZ'
UNION ALL
SELECT 'nationality_ci' AS internal_id, c.id AS country_id, 'Ivorian' AS name, NULL AS native_name, 'Ivorian' AS adjective FROM countries c WHERE c.country_code2 = 'CI'
UNION ALL
SELECT 'nationality_dk' AS internal_id, c.id AS country_id, 'Danish' AS name, NULL AS native_name, 'Danish' AS adjective FROM countries c WHERE c.country_code2 = 'DK'
UNION ALL
SELECT 'nationality_dj' AS internal_id, c.id AS country_id, 'Djibouti' AS name, NULL AS native_name, 'Djibouti' AS adjective FROM countries c WHERE c.country_code2 = 'DJ'
UNION ALL
SELECT 'nationality_dm' AS internal_id, c.id AS country_id, 'Dominican' AS name, NULL AS native_name, 'Dominican' AS adjective FROM countries c WHERE c.country_code2 = 'DM'
UNION ALL
SELECT 'nationality_do' AS internal_id, c.id AS country_id, 'Dominican' AS name, NULL AS native_name, 'Dominican' AS adjective FROM countries c WHERE c.country_code2 = 'DO'
UNION ALL
SELECT 'nationality_ec' AS internal_id, c.id AS country_id, 'Ecuadorean' AS name, NULL AS native_name, 'Ecuadorean' AS adjective FROM countries c WHERE c.country_code2 = 'EC'
UNION ALL
SELECT 'nationality_eg' AS internal_id, c.id AS country_id, 'Egyptian' AS name, NULL AS native_name, 'Egyptian' AS adjective FROM countries c WHERE c.country_code2 = 'EG'
UNION ALL
SELECT 'nationality_sv' AS internal_id, c.id AS country_id, 'Salvadoran' AS name, NULL AS native_name, 'Salvadoran' AS adjective FROM countries c WHERE c.country_code2 = 'SV'
UNION ALL
SELECT 'nationality_gq' AS internal_id, c.id AS country_id, 'Equatorial Guinean' AS name, NULL AS native_name, 'Equatorial Guinean' AS adjective FROM countries c WHERE c.country_code2 = 'GQ'
UNION ALL
SELECT 'nationality_er' AS internal_id, c.id AS country_id, 'Eritrean' AS name, NULL AS native_name, 'Eritrean' AS adjective FROM countries c WHERE c.country_code2 = 'ER'
UNION ALL
SELECT 'nationality_ee' AS internal_id, c.id AS country_id, 'Estonian' AS name, NULL AS native_name, 'Estonian' AS adjective FROM countries c WHERE c.country_code2 = 'EE'
UNION ALL
SELECT 'nationality_sz' AS internal_id, c.id AS country_id, 'Swazi' AS name, NULL AS native_name, 'Swazi' AS adjective FROM countries c WHERE c.country_code2 = 'SZ'
UNION ALL
SELECT 'nationality_et' AS internal_id, c.id AS country_id, 'Ethiopian' AS name, NULL AS native_name, 'Ethiopian' AS adjective FROM countries c WHERE c.country_code2 = 'ET'
UNION ALL
SELECT 'nationality_fk' AS internal_id, c.id AS country_id, 'Falkland Islander' AS name, NULL AS native_name, 'Falkland Islander' AS adjective FROM countries c WHERE c.country_code2 = 'FK'
UNION ALL
SELECT 'nationality_fo' AS internal_id, c.id AS country_id, 'Faroese' AS name, NULL AS native_name, 'Faroese' AS adjective FROM countries c WHERE c.country_code2 = 'FO'
UNION ALL
SELECT 'nationality_fj' AS internal_id, c.id AS country_id, 'Fijian' AS name, NULL AS native_name, 'Fijian' AS adjective FROM countries c WHERE c.country_code2 = 'FJ'
UNION ALL
SELECT 'nationality_fi' AS internal_id, c.id AS country_id, 'Finnish' AS name, NULL AS native_name, 'Finnish' AS adjective FROM countries c WHERE c.country_code2 = 'FI'
UNION ALL
SELECT 'nationality_fr' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective FROM countries c WHERE c.country_code2 = 'FR'
UNION ALL
SELECT 'nationality_gf' AS internal_id, c.id AS country_id, 'French Guianese' AS name, NULL AS native_name, 'French Guianese' AS adjective FROM countries c WHERE c.country_code2 = 'GF'
UNION ALL
SELECT 'nationality_pf' AS internal_id, c.id AS country_id, 'French Polynesian' AS name, NULL AS native_name, 'French Polynesian' AS adjective FROM countries c WHERE c.country_code2 = 'PF'
UNION ALL
SELECT 'nationality_tf' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective FROM countries c WHERE c.country_code2 = 'TF'
UNION ALL
SELECT 'nationality_ga' AS internal_id, c.id AS country_id, 'Gabonese' AS name, NULL AS native_name, 'Gabonese' AS adjective FROM countries c WHERE c.country_code2 = 'GA'
UNION ALL
SELECT 'nationality_gm' AS internal_id, c.id AS country_id, 'Gambian' AS name, NULL AS native_name, 'Gambian' AS adjective FROM countries c WHERE c.country_code2 = 'GM'
UNION ALL
SELECT 'nationality_ge' AS internal_id, c.id AS country_id, 'Georgian' AS name, NULL AS native_name, 'Georgian' AS adjective FROM countries c WHERE c.country_code2 = 'GE'
UNION ALL
SELECT 'nationality_de' AS internal_id, c.id AS country_id, 'German' AS name, NULL AS native_name, 'German' AS adjective FROM countries c WHERE c.country_code2 = 'DE'
UNION ALL
SELECT 'nationality_gh' AS internal_id, c.id AS country_id, 'Ghanaian' AS name, NULL AS native_name, 'Ghanaian' AS adjective FROM countries c WHERE c.country_code2 = 'GH'
UNION ALL
SELECT 'nationality_gi' AS internal_id, c.id AS country_id, 'Gibraltar' AS name, NULL AS native_name, 'Gibraltar' AS adjective FROM countries c WHERE c.country_code2 = 'GI'
UNION ALL
SELECT 'nationality_gr' AS internal_id, c.id AS country_id, 'Greek' AS name, NULL AS native_name, 'Greek' AS adjective FROM countries c WHERE c.country_code2 = 'GR'
UNION ALL
SELECT 'nationality_gl' AS internal_id, c.id AS country_id, 'Greenlandic' AS name, NULL AS native_name, 'Greenlandic' AS adjective FROM countries c WHERE c.country_code2 = 'GL'
UNION ALL
SELECT 'nationality_gd' AS internal_id, c.id AS country_id, 'Grenadian' AS name, NULL AS native_name, 'Grenadian' AS adjective FROM countries c WHERE c.country_code2 = 'GD'
UNION ALL
SELECT 'nationality_gp' AS internal_id, c.id AS country_id, 'Guadeloupian' AS name, NULL AS native_name, 'Guadeloupian' AS adjective FROM countries c WHERE c.country_code2 = 'GP'
UNION ALL
SELECT 'nationality_gu' AS internal_id, c.id AS country_id, 'Guamanian' AS name, NULL AS native_name, 'Guamanian' AS adjective FROM countries c WHERE c.country_code2 = 'GU'
UNION ALL
SELECT 'nationality_gt' AS internal_id, c.id AS country_id, 'Guatemalan' AS name, NULL AS native_name, 'Guatemalan' AS adjective FROM countries c WHERE c.country_code2 = 'GT'
UNION ALL
SELECT 'nationality_gg' AS internal_id, c.id AS country_id, 'Channel Islander' AS name, NULL AS native_name, 'Channel Islander' AS adjective FROM countries c WHERE c.country_code2 = 'GG'
UNION ALL
SELECT 'nationality_gn' AS internal_id, c.id AS country_id, 'Guinean' AS name, NULL AS native_name, 'Guinean' AS adjective FROM countries c WHERE c.country_code2 = 'GN'
UNION ALL
SELECT 'nationality_gw' AS internal_id, c.id AS country_id, 'Guinea-Bissauan' AS name, NULL AS native_name, 'Guinea-Bissauan' AS adjective FROM countries c WHERE c.country_code2 = 'GW'
UNION ALL
SELECT 'nationality_gy' AS internal_id, c.id AS country_id, 'Guyanese' AS name, NULL AS native_name, 'Guyanese' AS adjective FROM countries c WHERE c.country_code2 = 'GY'
UNION ALL
SELECT 'nationality_ht' AS internal_id, c.id AS country_id, 'Haitian' AS name, NULL AS native_name, 'Haitian' AS adjective FROM countries c WHERE c.country_code2 = 'HT'
UNION ALL
SELECT 'nationality_hm' AS internal_id, c.id AS country_id, 'Heard and McDonald Islander' AS name, NULL AS native_name, 'Heard and McDonald Islander' AS adjective FROM countries c WHERE c.country_code2 = 'HM'
UNION ALL
SELECT 'nationality_va' AS internal_id, c.id AS country_id, 'Vatican' AS name, NULL AS native_name, 'Vatican' AS adjective FROM countries c WHERE c.country_code2 = 'VA'
UNION ALL
SELECT 'nationality_hn' AS internal_id, c.id AS country_id, 'Honduran' AS name, NULL AS native_name, 'Honduran' AS adjective FROM countries c WHERE c.country_code2 = 'HN'
UNION ALL
SELECT 'nationality_hk' AS internal_id, c.id AS country_id, 'Chinese' AS name, NULL AS native_name, 'Chinese' AS adjective FROM countries c WHERE c.country_code2 = 'HK'
UNION ALL
SELECT 'nationality_hu' AS internal_id, c.id AS country_id, 'Hungarian' AS name, NULL AS native_name, 'Hungarian' AS adjective FROM countries c WHERE c.country_code2 = 'HU'
UNION ALL
SELECT 'nationality_is' AS internal_id, c.id AS country_id, 'Icelander' AS name, NULL AS native_name, 'Icelander' AS adjective FROM countries c WHERE c.country_code2 = 'IS'
UNION ALL
SELECT 'nationality_in' AS internal_id, c.id AS country_id, 'Indian' AS name, NULL AS native_name, 'Indian' AS adjective FROM countries c WHERE c.country_code2 = 'IN'
UNION ALL
SELECT 'nationality_id' AS internal_id, c.id AS country_id, 'Indonesian' AS name, NULL AS native_name, 'Indonesian' AS adjective FROM countries c WHERE c.country_code2 = 'ID'
UNION ALL
SELECT 'nationality_ir' AS internal_id, c.id AS country_id, 'Iranian' AS name, NULL AS native_name, 'Iranian' AS adjective FROM countries c WHERE c.country_code2 = 'IR'
UNION ALL
SELECT 'nationality_iq' AS internal_id, c.id AS country_id, 'Iraqi' AS name, NULL AS native_name, 'Iraqi' AS adjective FROM countries c WHERE c.country_code2 = 'IQ'
UNION ALL
SELECT 'nationality_ie' AS internal_id, c.id AS country_id, 'Irish' AS name, NULL AS native_name, 'Irish' AS adjective FROM countries c WHERE c.country_code2 = 'IE'
UNION ALL
SELECT 'nationality_im' AS internal_id, c.id AS country_id, 'Manx' AS name, NULL AS native_name, 'Manx' AS adjective FROM countries c WHERE c.country_code2 = 'IM'
UNION ALL
SELECT 'nationality_il' AS internal_id, c.id AS country_id, 'Israeli' AS name, NULL AS native_name, 'Israeli' AS adjective FROM countries c WHERE c.country_code2 = 'IL'
UNION ALL
SELECT 'nationality_it' AS internal_id, c.id AS country_id, 'Italian' AS name, NULL AS native_name, 'Italian' AS adjective FROM countries c WHERE c.country_code2 = 'IT'
UNION ALL
SELECT 'nationality_jm' AS internal_id, c.id AS country_id, 'Jamaican' AS name, NULL AS native_name, 'Jamaican' AS adjective FROM countries c WHERE c.country_code2 = 'JM'
UNION ALL
SELECT 'nationality_jp' AS internal_id, c.id AS country_id, 'Japanese' AS name, NULL AS native_name, 'Japanese' AS adjective FROM countries c WHERE c.country_code2 = 'JP'
UNION ALL
SELECT 'nationality_je' AS internal_id, c.id AS country_id, 'Channel Islander' AS name, NULL AS native_name, 'Channel Islander' AS adjective FROM countries c WHERE c.country_code2 = 'JE'
UNION ALL
SELECT 'nationality_jo' AS internal_id, c.id AS country_id, 'Jordanian' AS name, NULL AS native_name, 'Jordanian' AS adjective FROM countries c WHERE c.country_code2 = 'JO'
UNION ALL
SELECT 'nationality_kz' AS internal_id, c.id AS country_id, 'Kazakhstani' AS name, NULL AS native_name, 'Kazakhstani' AS adjective FROM countries c WHERE c.country_code2 = 'KZ'
UNION ALL
SELECT 'nationality_ke' AS internal_id, c.id AS country_id, 'Kenyan' AS name, NULL AS native_name, 'Kenyan' AS adjective FROM countries c WHERE c.country_code2 = 'KE'
UNION ALL
SELECT 'nationality_ki' AS internal_id, c.id AS country_id, 'I-Kiribati' AS name, NULL AS native_name, 'I-Kiribati' AS adjective FROM countries c WHERE c.country_code2 = 'KI'
UNION ALL
SELECT 'nationality_kw' AS internal_id, c.id AS country_id, 'Kuwaiti' AS name, NULL AS native_name, 'Kuwaiti' AS adjective FROM countries c WHERE c.country_code2 = 'KW'
UNION ALL
SELECT 'nationality_kg' AS internal_id, c.id AS country_id, 'Kirghiz' AS name, NULL AS native_name, 'Kirghiz' AS adjective FROM countries c WHERE c.country_code2 = 'KG'
UNION ALL
SELECT 'nationality_la' AS internal_id, c.id AS country_id, 'Laotian' AS name, NULL AS native_name, 'Laotian' AS adjective FROM countries c WHERE c.country_code2 = 'LA'
UNION ALL
SELECT 'nationality_lv' AS internal_id, c.id AS country_id, 'Latvian' AS name, NULL AS native_name, 'Latvian' AS adjective FROM countries c WHERE c.country_code2 = 'LV'
UNION ALL
SELECT 'nationality_lb' AS internal_id, c.id AS country_id, 'Lebanese' AS name, NULL AS native_name, 'Lebanese' AS adjective FROM countries c WHERE c.country_code2 = 'LB'
UNION ALL
SELECT 'nationality_ls' AS internal_id, c.id AS country_id, 'Mosotho' AS name, NULL AS native_name, 'Mosotho' AS adjective FROM countries c WHERE c.country_code2 = 'LS'
UNION ALL
SELECT 'nationality_lr' AS internal_id, c.id AS country_id, 'Liberian' AS name, NULL AS native_name, 'Liberian' AS adjective FROM countries c WHERE c.country_code2 = 'LR'
UNION ALL
SELECT 'nationality_ly' AS internal_id, c.id AS country_id, 'Libyan' AS name, NULL AS native_name, 'Libyan' AS adjective FROM countries c WHERE c.country_code2 = 'LY'
UNION ALL
SELECT 'nationality_li' AS internal_id, c.id AS country_id, 'Liechtensteiner' AS name, NULL AS native_name, 'Liechtensteiner' AS adjective FROM countries c WHERE c.country_code2 = 'LI'
UNION ALL
SELECT 'nationality_lt' AS internal_id, c.id AS country_id, 'Lithuanian' AS name, NULL AS native_name, 'Lithuanian' AS adjective FROM countries c WHERE c.country_code2 = 'LT'
UNION ALL
SELECT 'nationality_lu' AS internal_id, c.id AS country_id, 'Luxembourger' AS name, NULL AS native_name, 'Luxembourger' AS adjective FROM countries c WHERE c.country_code2 = 'LU'
UNION ALL
SELECT 'nationality_mo' AS internal_id, c.id AS country_id, 'Chinese' AS name, NULL AS native_name, 'Chinese' AS adjective FROM countries c WHERE c.country_code2 = 'MO'
UNION ALL
SELECT 'nationality_mg' AS internal_id, c.id AS country_id, 'Malagasy' AS name, NULL AS native_name, 'Malagasy' AS adjective FROM countries c WHERE c.country_code2 = 'MG'
UNION ALL
SELECT 'nationality_mw' AS internal_id, c.id AS country_id, 'Malawian' AS name, NULL AS native_name, 'Malawian' AS adjective FROM countries c WHERE c.country_code2 = 'MW'
UNION ALL
SELECT 'nationality_my' AS internal_id, c.id AS country_id, 'Malaysian' AS name, NULL AS native_name, 'Malaysian' AS adjective FROM countries c WHERE c.country_code2 = 'MY'
UNION ALL
SELECT 'nationality_mv' AS internal_id, c.id AS country_id, 'Maldivan' AS name, NULL AS native_name, 'Maldivan' AS adjective FROM countries c WHERE c.country_code2 = 'MV'
UNION ALL
SELECT 'nationality_ml' AS internal_id, c.id AS country_id, 'Malian' AS name, NULL AS native_name, 'Malian' AS adjective FROM countries c WHERE c.country_code2 = 'ML'
UNION ALL
SELECT 'nationality_mt' AS internal_id, c.id AS country_id, 'Maltese' AS name, NULL AS native_name, 'Maltese' AS adjective FROM countries c WHERE c.country_code2 = 'MT'
UNION ALL
SELECT 'nationality_mh' AS internal_id, c.id AS country_id, 'Marshallese' AS name, NULL AS native_name, 'Marshallese' AS adjective FROM countries c WHERE c.country_code2 = 'MH'
UNION ALL
SELECT 'nationality_mq' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective FROM countries c WHERE c.country_code2 = 'MQ'
UNION ALL
SELECT 'nationality_mr' AS internal_id, c.id AS country_id, 'Mauritanian' AS name, NULL AS native_name, 'Mauritanian' AS adjective FROM countries c WHERE c.country_code2 = 'MR'
UNION ALL
SELECT 'nationality_mu' AS internal_id, c.id AS country_id, 'Mauritian' AS name, NULL AS native_name, 'Mauritian' AS adjective FROM countries c WHERE c.country_code2 = 'MU'
UNION ALL
SELECT 'nationality_yt' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective FROM countries c WHERE c.country_code2 = 'YT'
UNION ALL
SELECT 'nationality_mx' AS internal_id, c.id AS country_id, 'Mexican' AS name, NULL AS native_name, 'Mexican' AS adjective FROM countries c WHERE c.country_code2 = 'MX'
UNION ALL
SELECT 'nationality_fm' AS internal_id, c.id AS country_id, 'Micronesian' AS name, NULL AS native_name, 'Micronesian' AS adjective FROM countries c WHERE c.country_code2 = 'FM'
UNION ALL
SELECT 'nationality_md' AS internal_id, c.id AS country_id, 'Moldovan' AS name, NULL AS native_name, 'Moldovan' AS adjective FROM countries c WHERE c.country_code2 = 'MD'
UNION ALL
SELECT 'nationality_mc' AS internal_id, c.id AS country_id, 'Monegasque' AS name, NULL AS native_name, 'Monegasque' AS adjective FROM countries c WHERE c.country_code2 = 'MC'
UNION ALL
SELECT 'nationality_mn' AS internal_id, c.id AS country_id, 'Mongolian' AS name, NULL AS native_name, 'Mongolian' AS adjective FROM countries c WHERE c.country_code2 = 'MN'
UNION ALL
SELECT 'nationality_me' AS internal_id, c.id AS country_id, 'Montenegrin' AS name, NULL AS native_name, 'Montenegrin' AS adjective FROM countries c WHERE c.country_code2 = 'ME'
UNION ALL
SELECT 'nationality_ms' AS internal_id, c.id AS country_id, 'Montserratian' AS name, NULL AS native_name, 'Montserratian' AS adjective FROM countries c WHERE c.country_code2 = 'MS'
UNION ALL
SELECT 'nationality_ma' AS internal_id, c.id AS country_id, 'Moroccan' AS name, NULL AS native_name, 'Moroccan' AS adjective FROM countries c WHERE c.country_code2 = 'MA'
UNION ALL
SELECT 'nationality_mz' AS internal_id, c.id AS country_id, 'Mozambican' AS name, NULL AS native_name, 'Mozambican' AS adjective FROM countries c WHERE c.country_code2 = 'MZ'
UNION ALL
SELECT 'nationality_mm' AS internal_id, c.id AS country_id, 'Burmese' AS name, NULL AS native_name, 'Burmese' AS adjective FROM countries c WHERE c.country_code2 = 'MM'
UNION ALL
SELECT 'nationality_na' AS internal_id, c.id AS country_id, 'Namibian' AS name, NULL AS native_name, 'Namibian' AS adjective FROM countries c WHERE c.country_code2 = 'NA'
UNION ALL
SELECT 'nationality_nr' AS internal_id, c.id AS country_id, 'Nauruan' AS name, NULL AS native_name, 'Nauruan' AS adjective FROM countries c WHERE c.country_code2 = 'NR'
UNION ALL
SELECT 'nationality_np' AS internal_id, c.id AS country_id, 'Nepalese' AS name, NULL AS native_name, 'Nepalese' AS adjective FROM countries c WHERE c.country_code2 = 'NP'
UNION ALL
SELECT 'nationality_nl' AS internal_id, c.id AS country_id, 'Dutch' AS name, NULL AS native_name, 'Dutch' AS adjective FROM countries c WHERE c.country_code2 = 'NL'
UNION ALL
SELECT 'nationality_nc' AS internal_id, c.id AS country_id, 'New Caledonian' AS name, NULL AS native_name, 'New Caledonian' AS adjective FROM countries c WHERE c.country_code2 = 'NC'
UNION ALL
SELECT 'nationality_nz' AS internal_id, c.id AS country_id, 'New Zealander' AS name, NULL AS native_name, 'New Zealander' AS adjective FROM countries c WHERE c.country_code2 = 'NZ'
UNION ALL
SELECT 'nationality_ni' AS internal_id, c.id AS country_id, 'Nicaraguan' AS name, NULL AS native_name, 'Nicaraguan' AS adjective FROM countries c WHERE c.country_code2 = 'NI'
UNION ALL
SELECT 'nationality_ne' AS internal_id, c.id AS country_id, 'Nigerien' AS name, NULL AS native_name, 'Nigerien' AS adjective FROM countries c WHERE c.country_code2 = 'NE'
UNION ALL
SELECT 'nationality_ng' AS internal_id, c.id AS country_id, 'Nigerian' AS name, NULL AS native_name, 'Nigerian' AS adjective FROM countries c WHERE c.country_code2 = 'NG'
UNION ALL
SELECT 'nationality_nu' AS internal_id, c.id AS country_id, 'Niuean' AS name, NULL AS native_name, 'Niuean' AS adjective FROM countries c WHERE c.country_code2 = 'NU'
UNION ALL
SELECT 'nationality_nf' AS internal_id, c.id AS country_id, 'Norfolk Islander' AS name, NULL AS native_name, 'Norfolk Islander' AS adjective FROM countries c WHERE c.country_code2 = 'NF'
UNION ALL
SELECT 'nationality_kp' AS internal_id, c.id AS country_id, 'North Korean' AS name, NULL AS native_name, 'North Korean' AS adjective FROM countries c WHERE c.country_code2 = 'KP'
UNION ALL
SELECT 'nationality_mk' AS internal_id, c.id AS country_id, 'Macedonian' AS name, NULL AS native_name, 'Macedonian' AS adjective FROM countries c WHERE c.country_code2 = 'MK'
UNION ALL
SELECT 'nationality_mp' AS internal_id, c.id AS country_id, 'American' AS name, NULL AS native_name, 'American' AS adjective FROM countries c WHERE c.country_code2 = 'MP'
UNION ALL
SELECT 'nationality_no' AS internal_id, c.id AS country_id, 'Norwegian' AS name, NULL AS native_name, 'Norwegian' AS adjective FROM countries c WHERE c.country_code2 = 'NO'
UNION ALL
SELECT 'nationality_om' AS internal_id, c.id AS country_id, 'Omani' AS name, NULL AS native_name, 'Omani' AS adjective FROM countries c WHERE c.country_code2 = 'OM'
UNION ALL
SELECT 'nationality_pk' AS internal_id, c.id AS country_id, 'Pakistani' AS name, NULL AS native_name, 'Pakistani' AS adjective FROM countries c WHERE c.country_code2 = 'PK'
UNION ALL
SELECT 'nationality_pw' AS internal_id, c.id AS country_id, 'Palauan' AS name, NULL AS native_name, 'Palauan' AS adjective FROM countries c WHERE c.country_code2 = 'PW'
UNION ALL
SELECT 'nationality_ps' AS internal_id, c.id AS country_id, 'Palestinian' AS name, NULL AS native_name, 'Palestinian' AS adjective FROM countries c WHERE c.country_code2 = 'PS'
UNION ALL
SELECT 'nationality_pa' AS internal_id, c.id AS country_id, 'Panamanian' AS name, NULL AS native_name, 'Panamanian' AS adjective FROM countries c WHERE c.country_code2 = 'PA'
UNION ALL
SELECT 'nationality_pg' AS internal_id, c.id AS country_id, 'Papua New Guinean' AS name, NULL AS native_name, 'Papua New Guinean' AS adjective FROM countries c WHERE c.country_code2 = 'PG'
UNION ALL
SELECT 'nationality_py' AS internal_id, c.id AS country_id, 'Paraguayan' AS name, NULL AS native_name, 'Paraguayan' AS adjective FROM countries c WHERE c.country_code2 = 'PY'
UNION ALL
SELECT 'nationality_pe' AS internal_id, c.id AS country_id, 'Peruvian' AS name, NULL AS native_name, 'Peruvian' AS adjective FROM countries c WHERE c.country_code2 = 'PE'
UNION ALL
SELECT 'nationality_ph' AS internal_id, c.id AS country_id, 'Filipino' AS name, NULL AS native_name, 'Filipino' AS adjective FROM countries c WHERE c.country_code2 = 'PH'
UNION ALL
SELECT 'nationality_pn' AS internal_id, c.id AS country_id, 'Pitcairn Islander' AS name, NULL AS native_name, 'Pitcairn Islander' AS adjective FROM countries c WHERE c.country_code2 = 'PN'
UNION ALL
SELECT 'nationality_pl' AS internal_id, c.id AS country_id, 'Polish' AS name, NULL AS native_name, 'Polish' AS adjective FROM countries c WHERE c.country_code2 = 'PL'
UNION ALL
SELECT 'nationality_pt' AS internal_id, c.id AS country_id, 'Portuguese' AS name, NULL AS native_name, 'Portuguese' AS adjective FROM countries c WHERE c.country_code2 = 'PT'
UNION ALL
SELECT 'nationality_pr' AS internal_id, c.id AS country_id, 'Puerto Rican' AS name, NULL AS native_name, 'Puerto Rican' AS adjective FROM countries c WHERE c.country_code2 = 'PR'
UNION ALL
SELECT 'nationality_qa' AS internal_id, c.id AS country_id, 'Qatari' AS name, NULL AS native_name, 'Qatari' AS adjective FROM countries c WHERE c.country_code2 = 'QA'
UNION ALL
SELECT 'nationality_ro' AS internal_id, c.id AS country_id, 'Romanian' AS name, NULL AS native_name, 'Romanian' AS adjective FROM countries c WHERE c.country_code2 = 'RO'
UNION ALL
SELECT 'nationality_ru' AS internal_id, c.id AS country_id, 'Russian' AS name, NULL AS native_name, 'Russian' AS adjective FROM countries c WHERE c.country_code2 = 'RU'
UNION ALL
SELECT 'nationality_rw' AS internal_id, c.id AS country_id, 'Rwandan' AS name, NULL AS native_name, 'Rwandan' AS adjective FROM countries c WHERE c.country_code2 = 'RW'
UNION ALL
SELECT 'nationality_re' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective FROM countries c WHERE c.country_code2 = 'RE'
UNION ALL
SELECT 'nationality_bl' AS internal_id, c.id AS country_id, 'Saint Barthélemy Resident' AS name, NULL AS native_name, 'Saint Barthélemy Resident' AS adjective FROM countries c WHERE c.country_code2 = 'BL'
UNION ALL
SELECT 'nationality_sh' AS internal_id, c.id AS country_id, 'Saint Helenian' AS name, NULL AS native_name, 'Saint Helenian' AS adjective FROM countries c WHERE c.country_code2 = 'SH'
UNION ALL
SELECT 'nationality_kn' AS internal_id, c.id AS country_id, 'Kittian and Nevisian' AS name, NULL AS native_name, 'Kittian and Nevisian' AS adjective FROM countries c WHERE c.country_code2 = 'KN'
UNION ALL
SELECT 'nationality_lc' AS internal_id, c.id AS country_id, 'Saint Lucian' AS name, NULL AS native_name, 'Saint Lucian' AS adjective FROM countries c WHERE c.country_code2 = 'LC'
UNION ALL
SELECT 'nationality_mf' AS internal_id, c.id AS country_id, 'Saint-Martinois' AS name, NULL AS native_name, 'Saint-Martinois' AS adjective FROM countries c WHERE c.country_code2 = 'MF'
UNION ALL
SELECT 'nationality_pm' AS internal_id, c.id AS country_id, 'French' AS name, NULL AS native_name, 'French' AS adjective FROM countries c WHERE c.country_code2 = 'PM'
UNION ALL
SELECT 'nationality_vc' AS internal_id, c.id AS country_id, 'Saint Vincentian' AS name, NULL AS native_name, 'Saint Vincentian' AS adjective FROM countries c WHERE c.country_code2 = 'VC'
UNION ALL
SELECT 'nationality_ws' AS internal_id, c.id AS country_id, 'Samoan' AS name, NULL AS native_name, 'Samoan' AS adjective FROM countries c WHERE c.country_code2 = 'WS'
UNION ALL
SELECT 'nationality_sm' AS internal_id, c.id AS country_id, 'Sammarinese' AS name, NULL AS native_name, 'Sammarinese' AS adjective FROM countries c WHERE c.country_code2 = 'SM'
UNION ALL
SELECT 'nationality_st' AS internal_id, c.id AS country_id, 'Sao Tomean' AS name, NULL AS native_name, 'Sao Tomean' AS adjective FROM countries c WHERE c.country_code2 = 'ST'
UNION ALL
SELECT 'nationality_sa' AS internal_id, c.id AS country_id, 'Saudi Arabian' AS name, NULL AS native_name, 'Saudi Arabian' AS adjective FROM countries c WHERE c.country_code2 = 'SA'
UNION ALL
SELECT 'nationality_sn' AS internal_id, c.id AS country_id, 'Senegalese' AS name, NULL AS native_name, 'Senegalese' AS adjective FROM countries c WHERE c.country_code2 = 'SN'
UNION ALL
SELECT 'nationality_rs' AS internal_id, c.id AS country_id, 'Serbian' AS name, NULL AS native_name, 'Serbian' AS adjective FROM countries c WHERE c.country_code2 = 'RS'
UNION ALL
SELECT 'nationality_sc' AS internal_id, c.id AS country_id, 'Seychellois' AS name, NULL AS native_name, 'Seychellois' AS adjective FROM countries c WHERE c.country_code2 = 'SC'
UNION ALL
SELECT 'nationality_sl' AS internal_id, c.id AS country_id, 'Sierra Leonean' AS name, NULL AS native_name, 'Sierra Leonean' AS adjective FROM countries c WHERE c.country_code2 = 'SL'
UNION ALL
SELECT 'nationality_sg' AS internal_id, c.id AS country_id, 'Singaporean' AS name, NULL AS native_name, 'Singaporean' AS adjective FROM countries c WHERE c.country_code2 = 'SG'
UNION ALL
SELECT 'nationality_sx' AS internal_id, c.id AS country_id, 'Sint Maartener' AS name, NULL AS native_name, 'Sint Maartener' AS adjective FROM countries c WHERE c.country_code2 = 'SX'
UNION ALL
SELECT 'nationality_sk' AS internal_id, c.id AS country_id, 'Slovak' AS name, NULL AS native_name, 'Slovak' AS adjective FROM countries c WHERE c.country_code2 = 'SK'
UNION ALL
SELECT 'nationality_si' AS internal_id, c.id AS country_id, 'Slovene' AS name, NULL AS native_name, 'Slovene' AS adjective FROM countries c WHERE c.country_code2 = 'SI'
UNION ALL
SELECT 'nationality_sb' AS internal_id, c.id AS country_id, 'Solomon Islander' AS name, NULL AS native_name, 'Solomon Islander' AS adjective FROM countries c WHERE c.country_code2 = 'SB'
UNION ALL
SELECT 'nationality_so' AS internal_id, c.id AS country_id, 'Somali' AS name, NULL AS native_name, 'Somali' AS adjective FROM countries c WHERE c.country_code2 = 'SO'
UNION ALL
SELECT 'nationality_za' AS internal_id, c.id AS country_id, 'South African' AS name, NULL AS native_name, 'South African' AS adjective FROM countries c WHERE c.country_code2 = 'ZA'
UNION ALL
SELECT 'nationality_gs' AS internal_id, c.id AS country_id, 'South Georgia and the South Sandwich Islander' AS name, NULL AS native_name, 'South Georgia and the South Sandwich Islander' AS adjective FROM countries c WHERE c.country_code2 = 'GS'
UNION ALL
SELECT 'nationality_kr' AS internal_id, c.id AS country_id, 'South Korean' AS name, NULL AS native_name, 'South Korean' AS adjective FROM countries c WHERE c.country_code2 = 'KR'
UNION ALL
SELECT 'nationality_ss' AS internal_id, c.id AS country_id, 'South Sudanese' AS name, NULL AS native_name, 'South Sudanese' AS adjective FROM countries c WHERE c.country_code2 = 'SS'
UNION ALL
SELECT 'nationality_es' AS internal_id, c.id AS country_id, 'Spanish' AS name, NULL AS native_name, 'Spanish' AS adjective FROM countries c WHERE c.country_code2 = 'ES'
UNION ALL
SELECT 'nationality_lk' AS internal_id, c.id AS country_id, 'Sri Lankan' AS name, NULL AS native_name, 'Sri Lankan' AS adjective FROM countries c WHERE c.country_code2 = 'LK'
UNION ALL
SELECT 'nationality_sd' AS internal_id, c.id AS country_id, 'Sudanese' AS name, NULL AS native_name, 'Sudanese' AS adjective FROM countries c WHERE c.country_code2 = 'SD'
UNION ALL
SELECT 'nationality_sr' AS internal_id, c.id AS country_id, 'Surinamer' AS name, NULL AS native_name, 'Surinamer' AS adjective FROM countries c WHERE c.country_code2 = 'SR'
UNION ALL
SELECT 'nationality_sj' AS internal_id, c.id AS country_id, 'Norwegian' AS name, NULL AS native_name, 'Norwegian' AS adjective FROM countries c WHERE c.country_code2 = 'SJ'
UNION ALL
SELECT 'nationality_se' AS internal_id, c.id AS country_id, 'Swedish' AS name, NULL AS native_name, 'Swedish' AS adjective FROM countries c WHERE c.country_code2 = 'SE'
UNION ALL
SELECT 'nationality_ch' AS internal_id, c.id AS country_id, 'Swiss' AS name, NULL AS native_name, 'Swiss' AS adjective FROM countries c WHERE c.country_code2 = 'CH'
UNION ALL
SELECT 'nationality_sy' AS internal_id, c.id AS country_id, 'Syrian' AS name, NULL AS native_name, 'Syrian' AS adjective FROM countries c WHERE c.country_code2 = 'SY'
UNION ALL
SELECT 'nationality_tw' AS internal_id, c.id AS country_id, 'Taiwanese' AS name, NULL AS native_name, 'Taiwanese' AS adjective FROM countries c WHERE c.country_code2 = 'TW'
UNION ALL
SELECT 'nationality_tj' AS internal_id, c.id AS country_id, 'Tadzhik' AS name, NULL AS native_name, 'Tadzhik' AS adjective FROM countries c WHERE c.country_code2 = 'TJ'
UNION ALL
SELECT 'nationality_tz' AS internal_id, c.id AS country_id, 'Tanzanian' AS name, NULL AS native_name, 'Tanzanian' AS adjective FROM countries c WHERE c.country_code2 = 'TZ'
UNION ALL
SELECT 'nationality_th' AS internal_id, c.id AS country_id, 'Thai' AS name, NULL AS native_name, 'Thai' AS adjective FROM countries c WHERE c.country_code2 = 'TH'
UNION ALL
SELECT 'nationality_tl' AS internal_id, c.id AS country_id, 'Timorese' AS name, NULL AS native_name, 'Timorese' AS adjective FROM countries c WHERE c.country_code2 = 'TL'
UNION ALL
SELECT 'nationality_tg' AS internal_id, c.id AS country_id, 'Togolese' AS name, NULL AS native_name, 'Togolese' AS adjective FROM countries c WHERE c.country_code2 = 'TG'
UNION ALL
SELECT 'nationality_tk' AS internal_id, c.id AS country_id, 'Tokelauan' AS name, NULL AS native_name, 'Tokelauan' AS adjective FROM countries c WHERE c.country_code2 = 'TK'
UNION ALL
SELECT 'nationality_to' AS internal_id, c.id AS country_id, 'Tongan' AS name, NULL AS native_name, 'Tongan' AS adjective FROM countries c WHERE c.country_code2 = 'TO'
UNION ALL
SELECT 'nationality_tt' AS internal_id, c.id AS country_id, 'Trinidadian' AS name, NULL AS native_name, 'Trinidadian' AS adjective FROM countries c WHERE c.country_code2 = 'TT'
UNION ALL
SELECT 'nationality_tn' AS internal_id, c.id AS country_id, 'Tunisian' AS name, NULL AS native_name, 'Tunisian' AS adjective FROM countries c WHERE c.country_code2 = 'TN'
UNION ALL
SELECT 'nationality_tm' AS internal_id, c.id AS country_id, 'Turkmen' AS name, NULL AS native_name, 'Turkmen' AS adjective FROM countries c WHERE c.country_code2 = 'TM'
UNION ALL
SELECT 'nationality_tc' AS internal_id, c.id AS country_id, 'Turks and Caicos Islander' AS name, NULL AS native_name, 'Turks and Caicos Islander' AS adjective FROM countries c WHERE c.country_code2 = 'TC'
UNION ALL
SELECT 'nationality_tv' AS internal_id, c.id AS country_id, 'Tuvaluan' AS name, NULL AS native_name, 'Tuvaluan' AS adjective FROM countries c WHERE c.country_code2 = 'TV'
UNION ALL
SELECT 'nationality_tr' AS internal_id, c.id AS country_id, 'Turkish' AS name, NULL AS native_name, 'Turkish' AS adjective FROM countries c WHERE c.country_code2 = 'TR'
UNION ALL
SELECT 'nationality_ug' AS internal_id, c.id AS country_id, 'Ugandan' AS name, NULL AS native_name, 'Ugandan' AS adjective FROM countries c WHERE c.country_code2 = 'UG'
UNION ALL
SELECT 'nationality_ua' AS internal_id, c.id AS country_id, 'Ukrainian' AS name, NULL AS native_name, 'Ukrainian' AS adjective FROM countries c WHERE c.country_code2 = 'UA'
UNION ALL
SELECT 'nationality_ae' AS internal_id, c.id AS country_id, 'Emirati' AS name, NULL AS native_name, 'Emirati' AS adjective FROM countries c WHERE c.country_code2 = 'AE'
UNION ALL
SELECT 'nationality_gb' AS internal_id, c.id AS country_id, 'British' AS name, NULL AS native_name, 'British' AS adjective FROM countries c WHERE c.country_code2 = 'GB'
UNION ALL
SELECT 'nationality_us' AS internal_id, c.id AS country_id, 'American' AS name, NULL AS native_name, 'American' AS adjective FROM countries c WHERE c.country_code2 = 'US'
UNION ALL
SELECT 'nationality_um' AS internal_id, c.id AS country_id, 'U.S. Minor Outlying Islander' AS name, NULL AS native_name, 'U.S. Minor Outlying Islander' AS adjective FROM countries c WHERE c.country_code2 = 'UM'
UNION ALL
SELECT 'nationality_uy' AS internal_id, c.id AS country_id, 'Uruguayan' AS name, NULL AS native_name, 'Uruguayan' AS adjective FROM countries c WHERE c.country_code2 = 'UY'
UNION ALL
SELECT 'nationality_uz' AS internal_id, c.id AS country_id, 'Uzbekistani' AS name, NULL AS native_name, 'Uzbekistani' AS adjective FROM countries c WHERE c.country_code2 = 'UZ'
UNION ALL
SELECT 'nationality_vu' AS internal_id, c.id AS country_id, 'Ni-Vanuatu' AS name, NULL AS native_name, 'Ni-Vanuatu' AS adjective FROM countries c WHERE c.country_code2 = 'VU'
UNION ALL
SELECT 'nationality_ve' AS internal_id, c.id AS country_id, 'Venezuelan' AS name, NULL AS native_name, 'Venezuelan' AS adjective FROM countries c WHERE c.country_code2 = 'VE'
UNION ALL
SELECT 'nationality_vn' AS internal_id, c.id AS country_id, 'Vietnamese' AS name, NULL AS native_name, 'Vietnamese' AS adjective FROM countries c WHERE c.country_code2 = 'VN'
UNION ALL
SELECT 'nationality_vg' AS internal_id, c.id AS country_id, 'British Virgin Islander' AS name, NULL AS native_name, 'British Virgin Islander' AS adjective FROM countries c WHERE c.country_code2 = 'VG'
UNION ALL
SELECT 'nationality_vi' AS internal_id, c.id AS country_id, 'U.S. Virgin Islander' AS name, NULL AS native_name, 'U.S. Virgin Islander' AS adjective FROM countries c WHERE c.country_code2 = 'VI'
UNION ALL
SELECT 'nationality_wf' AS internal_id, c.id AS country_id, 'Wallis and Futuna Islander' AS name, NULL AS native_name, 'Wallis and Futuna Islander' AS adjective FROM countries c WHERE c.country_code2 = 'WF'
UNION ALL
SELECT 'nationality_eh' AS internal_id, c.id AS country_id, 'Sahrawi' AS name, NULL AS native_name, 'Sahrawi' AS adjective FROM countries c WHERE c.country_code2 = 'EH'
UNION ALL
SELECT 'nationality_ye' AS internal_id, c.id AS country_id, 'Yemeni' AS name, NULL AS native_name, 'Yemeni' AS adjective FROM countries c WHERE c.country_code2 = 'YE'
UNION ALL
SELECT 'nationality_zm' AS internal_id, c.id AS country_id, 'Zambian' AS name, NULL AS native_name, 'Zambian' AS adjective FROM countries c WHERE c.country_code2 = 'ZM'
UNION ALL
SELECT 'nationality_zw' AS internal_id, c.id AS country_id, 'Zimbabwean' AS name, NULL AS native_name, 'Zimbabwean' AS adjective FROM countries c WHERE c.country_code2 = 'ZW'
UNION ALL
SELECT 'nationality_ax' AS internal_id, c.id AS country_id, 'Åland Islander' AS name, NULL AS native_name, 'Åland Islander' AS adjective FROM countries c WHERE c.country_code2 = 'AX'
ON CONFLICT (internal_id) DO UPDATE SET
    country_id = EXCLUDED.country_id,
    name = EXCLUDED.name,
    native_name = EXCLUDED.native_name,
    adjective = EXCLUDED.adjective,
    updated_at = NOW(),
    version = nationalities.version + 1;

INSERT INTO timezones (internal_id, timezone_key, name, utc_offset, status, created_at, updated_at, version)
VALUES ('TZ-001', 'Asia/Dubai', 'Gulf Standard Time', '+05:30', 'A', NOW(), NOW(), 1),
       ('TZ-002', 'Asia/Kolkata', 'India Standard Time', '+04:00', 'A', NOW(), NOW(), 1);

