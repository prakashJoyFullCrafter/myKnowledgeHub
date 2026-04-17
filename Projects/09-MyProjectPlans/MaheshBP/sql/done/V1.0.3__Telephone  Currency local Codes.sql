INSERT INTO core.languages
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


INSERT INTO core.country_calling_codes
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
         JOIN countries c
              ON c.country_code2 = v.country_code2 ON CONFLICT (internal_id) DO
UPDATE
    SET
        country_id = EXCLUDED.country_id,
    calling_code = EXCLUDED.calling_code,
    status = EXCLUDED.status,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by,
    version = country_calling_codes.version + 1;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'en' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'hi' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'kn' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ml' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ta' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'te' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'mr' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'bn' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'gu' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'pa' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ur' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'or' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'as' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'sa' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ks' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'sd' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'kok' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'ne' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'mni' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'brx' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'doi' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'mai' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO locales
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
FROM languages l
         JOIN countries c ON c.country_code2 = 'IN'
WHERE l.language_code = 'sat' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO currencies (internal_id, currency_code, name, symbol, symbol_position, decimal_places, status)
VALUES ('CUR_AED', 'AED', 'UAE Dirham', 'AED', 'before', 2, 'A'),
       ('CUR_INR', 'INR', 'Indian Rupee', '₹', 'before', 2, 'A') ON CONFLICT (internal_id) DO NOTHING;


INSERT INTO country_currency_mappings
(internal_id, country_id, currency_id, status, created_by, updated_by, version)
SELECT 'CCY_MAP_INDIA_INR',
       c.id,
       cur.id,
       'A',
       NULL,
       NULL,
       1
FROM countries c
         JOIN currencies cur
              ON cur.currency_code = 'INR'
WHERE c.country_code2 = 'IN' ON CONFLICT (internal_id) DO NOTHING;

INSERT INTO country_currency_mappings
(internal_id, country_id, currency_id, status, created_by, updated_by, version)
SELECT 'CCY_MAP_UAE_AED',
       c.id,
       cur.id,
       'A',
       NULL,
       NULL,
       1
FROM countries c
         JOIN currencies cur
              ON cur.currency_code = 'AED'
WHERE c.country_code2 = 'AE' ON CONFLICT (internal_id) DO NOTHING;

