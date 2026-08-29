USE tfm_mortgage;
SELECT DATABASE();
DROP TABLE IF EXISTS silver_orig_2024;
DROP TABLE IF EXISTS silver_orig_2023;
DROP TABLE IF EXISTS silver_orig_2022;
DROP TABLE IF EXISTS silver_orig_2021;
DROP TABLE IF EXISTS silver_orig_2020;

DROP TABLE IF EXISTS silver_perf_2024;
DROP TABLE IF EXISTS silver_perf_2023;
DROP TABLE IF EXISTS silver_perf_2022;
DROP TABLE IF EXISTS silver_perf_2021;
DROP TABLE IF EXISTS silver_perf_2020;

CREATE TABLE IF NOT EXISTS silver_orig_2020 LIKE raw_orig_2020;
CREATE TABLE IF NOT EXISTS silver_orig_2021 LIKE raw_orig_2021;
CREATE TABLE IF NOT EXISTS silver_orig_2022 LIKE raw_orig_2022;
CREATE TABLE IF NOT EXISTS silver_orig_2023 LIKE raw_orig_2023;
CREATE TABLE IF NOT EXISTS silver_orig_2024 LIKE raw_orig_2024;

CREATE TABLE IF NOT EXISTS silver_perf_2020 LIKE raw_perf_2020;
CREATE TABLE IF NOT EXISTS silver_perf_2021 LIKE raw_perf_2021;
CREATE TABLE IF NOT EXISTS silver_perf_2022 LIKE raw_perf_2022;
CREATE TABLE IF NOT EXISTS silver_perf_2023 LIKE raw_perf_2023;
CREATE TABLE IF NOT EXISTS silver_perf_2024 LIKE raw_perf_2024;

-- Miramos cuantos regristros tenemos
SELECT COUNT(*)
FROM raw_orig_2020;

select *
from raw_orig_2020 ro;

SELECT
    COUNT(*) AS total_registros,
    COUNT(credit_score) AS credit_score_no_nulo,
    COUNT(first_payment_date) AS first_payment_date_no_nulo,
    COUNT(original_upb) AS original_upb_no_nulo,
    COUNT(original_dti) AS original_dti_no_nulo,
    COUNT(original_ltv) AS original_ltv_no_nulo,
    COUNT(original_interest_rate) AS interest_rate_no_nulo,
    COUNT(property_state) AS property_state_no_nulo,
    COUNT(property_type) AS property_type_no_nulo,
    COUNT(loan_sequence_number) AS loan_id_no_nulo
FROM raw_orig_2020;

select *
from raw_orig_2020 ro ;

SELECT
    COUNT(*) AS total_registros,
    COUNT(msa) AS msa_no_nulo,
    COUNT(*) - COUNT(msa) AS msa_nulo
FROM raw_orig_2020;

-- Veo que hay muchos elementos que son nulos pero que aparecen como ""

SELECT COUNT(*) AS msa_vacio
FROM raw_orig_2020
WHERE msa = '';

-- Vemos en dos tablas de las orig cuales son las columnas con mas elementos vacios

SET SESSION group_concat_max_len = 1000000;

SET @sql = (
    SELECT GROUP_CONCAT(
        CONCAT(
            'SELECT ''', COLUMN_NAME, ''' AS columna, ',
            'SUM(`', COLUMN_NAME, '` IS NULL) AS nulos, ',
            'SUM(`', COLUMN_NAME, '` = '''') AS vacios, ',
            'SUM(`', COLUMN_NAME, '` IS NOT NULL AND TRIM(`', COLUMN_NAME, '`) = '''') AS espacios ',
            'FROM raw_orig_2020'
        )
        SEPARATOR ' UNION ALL '
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'tfm_mortgage'
      AND TABLE_NAME = 'raw_orig_2020'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET SESSION group_concat_max_len = 1000000;

SET @sql = (
    SELECT GROUP_CONCAT(
        CONCAT(
            'SELECT ''', COLUMN_NAME, ''' AS columna, ',
            'SUM(`', COLUMN_NAME, '` IS NULL) AS nulos, ',
            'SUM(`', COLUMN_NAME, '` = '''') AS vacios, ',
            'SUM(`', COLUMN_NAME, '` IS NOT NULL AND TRIM(`', COLUMN_NAME, '`) = '''') AS espacios ',
            'FROM raw_orig_2021'
        )
        SEPARATOR ' UNION ALL '
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'tfm_mortgage'
      AND TABLE_NAME = 'raw_orig_2021'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


INSERT INTO silver_orig_2020 SELECT * FROM raw_orig_2020;
INSERT INTO silver_orig_2021 SELECT * FROM raw_orig_2021;
INSERT INTO silver_orig_2022 SELECT * FROM raw_orig_2022;
INSERT INTO silver_orig_2023 SELECT * FROM raw_orig_2023;
INSERT INTO silver_orig_2024 SELECT * FROM raw_orig_2024;

-- Eliminamos las dos columnas que tienen practicamente todos los elementos nulos de nuestras tablas orig de los 5 años

ALTER TABLE silver_orig_2020
DROP COLUMN super_conforming_flag,
DROP COLUMN pre_relief_refinance_loan_sequence_number;

ALTER TABLE silver_orig_2021
DROP COLUMN super_conforming_flag,
DROP COLUMN pre_relief_refinance_loan_sequence_number;

ALTER TABLE silver_orig_2022
DROP COLUMN super_conforming_flag,
DROP COLUMN pre_relief_refinance_loan_sequence_number;

ALTER TABLE silver_orig_2023
DROP COLUMN super_conforming_flag,
DROP COLUMN pre_relief_refinance_loan_sequence_number;

ALTER TABLE silver_orig_2024
DROP COLUMN super_conforming_flag,
DROP COLUMN pre_relief_refinance_loan_sequence_number;



SELECT
    COUNT(*) AS total,
    COUNT(DISTINCT interest_only_indicator) AS valores_distintos
FROM silver_orig_2020;

SELECT
    COUNT(*) AS total,
    COUNT(DISTINCT interest_only_indicator) AS valores_distintos
FROM silver_orig_2024;

SELECT
    'ppm_flag' AS columna,
    COUNT(DISTINCT ppm_flag) AS valores_distintos
FROM silver_orig_2020

UNION ALL

SELECT
    'amortization_type',
    COUNT(DISTINCT amortization_type)
FROM silver_orig_2020

UNION ALL

SELECT
    'special_eligibility_program',
    COUNT(DISTINCT special_eligibility_program)
FROM silver_orig_2020

UNION ALL

SELECT
    'property_valuation_method',
    COUNT(DISTINCT property_valuation_method)
FROM silver_orig_2020;

-- Eliminamos de nuestras tablas todas estas columnas porque siempre tienen el mismo valor en todas nuestras filas y no aportan 

ALTER TABLE silver_orig_2020
DROP COLUMN ppm_flag,
DROP COLUMN amortization_type,
DROP COLUMN special_eligibility_program,
DROP COLUMN property_valuation_method,
DROP COLUMN interest_only_indicator;

ALTER TABLE silver_orig_2021
DROP COLUMN ppm_flag,
DROP COLUMN amortization_type,
DROP COLUMN special_eligibility_program,
DROP COLUMN property_valuation_method,
DROP COLUMN interest_only_indicator;

ALTER TABLE silver_orig_2022
DROP COLUMN ppm_flag,
DROP COLUMN amortization_type,
DROP COLUMN special_eligibility_program,
DROP COLUMN property_valuation_method,
DROP COLUMN interest_only_indicator;

ALTER TABLE silver_orig_2023
DROP COLUMN ppm_flag,
DROP COLUMN amortization_type,
DROP COLUMN special_eligibility_program,
DROP COLUMN property_valuation_method,
DROP COLUMN interest_only_indicator;

ALTER TABLE silver_orig_2024
DROP COLUMN ppm_flag,
DROP COLUMN amortization_type,
DROP COLUMN special_eligibility_program,
DROP COLUMN property_valuation_method,
DROP COLUMN interest_only_indicator;

-- Cambiamos los "" por elementos NULL

UPDATE silver_orig_2020
SET msa = NULL
WHERE TRIM(msa) = '';

UPDATE silver_orig_2021
SET msa = NULL
WHERE TRIM(msa) = '';
UPDATE silver_orig_2022
SET msa = NULL
WHERE TRIM(msa) = '';
UPDATE silver_orig_2023
SET msa = NULL
WHERE TRIM(msa) = '';
UPDATE silver_orig_2024
SET msa = NULL
WHERE TRIM(msa) = '';



SELECT
    first_payment_date,
    maturity_date
FROM silver_orig_2020
LIMIT 20;

-- Cambiamos las fechas para poder convertirlas a formato DATE

UPDATE silver_orig_2020
SET
    first_payment_date = CONCAT(
        SUBSTRING(first_payment_date, 1, 4), '-',
        SUBSTRING(first_payment_date, 5, 2), '-01'
    ),
    maturity_date = CONCAT(
        SUBSTRING(maturity_date, 1, 4), '-',
        SUBSTRING(maturity_date, 5, 2), '-01'
    );
-- Y adjustamos el tipo de nuestros datos

ALTER TABLE silver_orig_2020
    MODIFY COLUMN credit_score INT,
    MODIFY COLUMN first_payment_date DATE,
    MODIFY COLUMN first_time_homebuyer_flag CHAR(1),
    MODIFY COLUMN maturity_date DATE,
    MODIFY COLUMN msa INT,
    MODIFY COLUMN mi_percentage DECIMAL(5,2),
    MODIFY COLUMN number_of_units INT,
    MODIFY COLUMN occupancy_status CHAR(1),
    MODIFY COLUMN original_cltv DECIMAL(5,2),
    MODIFY COLUMN original_dti DECIMAL(5,2),
    MODIFY COLUMN original_upb DECIMAL(15,2),
    MODIFY COLUMN original_ltv DECIMAL(5,2),
    MODIFY COLUMN original_interest_rate DECIMAL(7,4),
    MODIFY COLUMN channel CHAR(1),
    MODIFY COLUMN property_state CHAR(2),
    MODIFY COLUMN property_type CHAR(2),
    MODIFY COLUMN postal_code VARCHAR(10),
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN loan_purpose CHAR(1),
    MODIFY COLUMN original_loan_term INT,
    MODIFY COLUMN number_of_borrowers INT,
    MODIFY COLUMN seller_name VARCHAR(100),
    MODIFY COLUMN servicer_name VARCHAR(100),
    MODIFY COLUMN relief_refinance_indicator CHAR(1);

UPDATE silver_orig_2021
SET
    first_payment_date = CONCAT(
        SUBSTRING(first_payment_date, 1, 4), '-',
        SUBSTRING(first_payment_date, 5, 2), '-01'
    ),
    maturity_date = CONCAT(
        SUBSTRING(maturity_date, 1, 4), '-',
        SUBSTRING(maturity_date, 5, 2), '-01'
    );

UPDATE silver_orig_2022
SET
    first_payment_date = CONCAT(
        SUBSTRING(first_payment_date, 1, 4), '-',
        SUBSTRING(first_payment_date, 5, 2), '-01'
    ),
    maturity_date = CONCAT(
        SUBSTRING(maturity_date, 1, 4), '-',
        SUBSTRING(maturity_date, 5, 2), '-01'
    );

UPDATE silver_orig_2023
SET
    first_payment_date = CONCAT(
        SUBSTRING(first_payment_date, 1, 4), '-',
        SUBSTRING(first_payment_date, 5, 2), '-01'
    ),
    maturity_date = CONCAT(
        SUBSTRING(maturity_date, 1, 4), '-',
        SUBSTRING(maturity_date, 5, 2), '-01'
    );

UPDATE silver_orig_2024
SET
    first_payment_date = CONCAT(
        SUBSTRING(first_payment_date, 1, 4), '-',
        SUBSTRING(first_payment_date, 5, 2), '-01'
    ),
    maturity_date = CONCAT(
        SUBSTRING(maturity_date, 1, 4), '-',
        SUBSTRING(maturity_date, 5, 2), '-01'
    );

ALTER TABLE silver_orig_2021
    MODIFY COLUMN credit_score INT,
    MODIFY COLUMN first_payment_date DATE,
    MODIFY COLUMN first_time_homebuyer_flag CHAR(1),
    MODIFY COLUMN maturity_date DATE,
    MODIFY COLUMN msa INT,
    MODIFY COLUMN mi_percentage DECIMAL(5,2),
    MODIFY COLUMN number_of_units INT,
    MODIFY COLUMN occupancy_status CHAR(1),
    MODIFY COLUMN original_cltv DECIMAL(5,2),
    MODIFY COLUMN original_dti DECIMAL(5,2),
    MODIFY COLUMN original_upb DECIMAL(15,2),
    MODIFY COLUMN original_ltv DECIMAL(5,2),
    MODIFY COLUMN original_interest_rate DECIMAL(7,4),
    MODIFY COLUMN channel CHAR(1),
    MODIFY COLUMN property_state CHAR(2),
    MODIFY COLUMN property_type CHAR(2),
    MODIFY COLUMN postal_code VARCHAR(10),
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN loan_purpose CHAR(1),
    MODIFY COLUMN original_loan_term INT,
    MODIFY COLUMN number_of_borrowers INT,
    MODIFY COLUMN seller_name VARCHAR(100),
    MODIFY COLUMN servicer_name VARCHAR(100),
    MODIFY COLUMN relief_refinance_indicator CHAR(1);

ALTER TABLE silver_orig_2022
    MODIFY COLUMN credit_score INT,
    MODIFY COLUMN first_payment_date DATE,
    MODIFY COLUMN first_time_homebuyer_flag CHAR(1),
    MODIFY COLUMN maturity_date DATE,
    MODIFY COLUMN msa INT,
    MODIFY COLUMN mi_percentage DECIMAL(5,2),
    MODIFY COLUMN number_of_units INT,
    MODIFY COLUMN occupancy_status CHAR(1),
    MODIFY COLUMN original_cltv DECIMAL(5,2),
    MODIFY COLUMN original_dti DECIMAL(5,2),
    MODIFY COLUMN original_upb DECIMAL(15,2),
    MODIFY COLUMN original_ltv DECIMAL(5,2),
    MODIFY COLUMN original_interest_rate DECIMAL(7,4),
    MODIFY COLUMN channel CHAR(1),
    MODIFY COLUMN property_state CHAR(2),
    MODIFY COLUMN property_type CHAR(2),
    MODIFY COLUMN postal_code VARCHAR(10),
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN loan_purpose CHAR(1),
    MODIFY COLUMN original_loan_term INT,
    MODIFY COLUMN number_of_borrowers INT,
    MODIFY COLUMN seller_name VARCHAR(100),
    MODIFY COLUMN servicer_name VARCHAR(100),
    MODIFY COLUMN relief_refinance_indicator CHAR(1);

ALTER TABLE silver_orig_2023
    MODIFY COLUMN credit_score INT,
    MODIFY COLUMN first_payment_date DATE,
    MODIFY COLUMN first_time_homebuyer_flag CHAR(1),
    MODIFY COLUMN maturity_date DATE,
    MODIFY COLUMN msa INT,
    MODIFY COLUMN mi_percentage DECIMAL(5,2),
    MODIFY COLUMN number_of_units INT,
    MODIFY COLUMN occupancy_status CHAR(1),
    MODIFY COLUMN original_cltv DECIMAL(5,2),
    MODIFY COLUMN original_dti DECIMAL(5,2),
    MODIFY COLUMN original_upb DECIMAL(15,2),
    MODIFY COLUMN original_ltv DECIMAL(5,2),
    MODIFY COLUMN original_interest_rate DECIMAL(7,4),
    MODIFY COLUMN channel CHAR(1),
    MODIFY COLUMN property_state CHAR(2),
    MODIFY COLUMN property_type CHAR(2),
    MODIFY COLUMN postal_code VARCHAR(10),
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN loan_purpose CHAR(1),
    MODIFY COLUMN original_loan_term INT,
    MODIFY COLUMN number_of_borrowers INT,
    MODIFY COLUMN seller_name VARCHAR(100),
    MODIFY COLUMN servicer_name VARCHAR(100),
    MODIFY COLUMN relief_refinance_indicator CHAR(1);

ALTER TABLE silver_orig_2024
    MODIFY COLUMN credit_score INT,
    MODIFY COLUMN first_payment_date DATE,
    MODIFY COLUMN first_time_homebuyer_flag CHAR(1),
    MODIFY COLUMN maturity_date DATE,
    MODIFY COLUMN msa INT,
    MODIFY COLUMN mi_percentage DECIMAL(5,2),
    MODIFY COLUMN number_of_units INT,
    MODIFY COLUMN occupancy_status CHAR(1),
    MODIFY COLUMN original_cltv DECIMAL(5,2),
    MODIFY COLUMN original_dti DECIMAL(5,2),
    MODIFY COLUMN original_upb DECIMAL(15,2),
    MODIFY COLUMN original_ltv DECIMAL(5,2),
    MODIFY COLUMN original_interest_rate DECIMAL(7,4),
    MODIFY COLUMN channel CHAR(1),
    MODIFY COLUMN property_state CHAR(2),
    MODIFY COLUMN property_type CHAR(2),
    MODIFY COLUMN postal_code VARCHAR(10),
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN loan_purpose CHAR(1),
    MODIFY COLUMN original_loan_term INT,
    MODIFY COLUMN number_of_borrowers INT,
    MODIFY COLUMN seller_name VARCHAR(100),
    MODIFY COLUMN servicer_name VARCHAR(100),
    MODIFY COLUMN relief_refinance_indicator CHAR(1);

-- Ya hemos acabado con la limpieza de nuestras 5 tablas orig

INSERT INTO silver_perf_2020
SELECT * FROM raw_perf_2020;

INSERT INTO silver_perf_2021
SELECT * FROM raw_perf_2021;

INSERT INTO silver_perf_2022
SELECT * FROM raw_perf_2022;

INSERT INTO silver_perf_2023
SELECT * FROM raw_perf_2023;

INSERT INTO silver_perf_2024
SELECT * FROM raw_perf_2024;

select * 
FROM silver_perf_2020;


-- Eliminamos de nuestras 5 tablas estas columnas porque describen cosas que suceden después de que ocurra un caso de morosidad
-- en la hipóteca pero no nos sirve para nuestro análisis de quien va a dejar de pagarla

ALTER TABLE silver_perf_2020
DROP COLUMN mi_recoveries,
DROP COLUMN net_sale_proceeds,
DROP COLUMN non_mi_recoveries,
DROP COLUMN total_expenses,
DROP COLUMN legal_costs,
DROP COLUMN maintenance_preservation_costs,
DROP COLUMN taxes_insurance,
DROP COLUMN miscellaneous_expenses,
DROP COLUMN bankruptcy_cramdown_costs,
DROP COLUMN interest_rate_step_indicator;

ALTER TABLE silver_perf_2021
DROP COLUMN mi_recoveries,
DROP COLUMN net_sale_proceeds,
DROP COLUMN non_mi_recoveries,
DROP COLUMN total_expenses,
DROP COLUMN legal_costs,
DROP COLUMN maintenance_preservation_costs,
DROP COLUMN taxes_insurance,
DROP COLUMN miscellaneous_expenses,
DROP COLUMN bankruptcy_cramdown_costs,
DROP COLUMN interest_rate_step_indicator;


ALTER TABLE silver_perf_2022
DROP COLUMN mi_recoveries,
DROP COLUMN net_sale_proceeds,
DROP COLUMN non_mi_recoveries,
DROP COLUMN total_expenses,
DROP COLUMN legal_costs,
DROP COLUMN maintenance_preservation_costs,
DROP COLUMN taxes_insurance,
DROP COLUMN miscellaneous_expenses,
DROP COLUMN bankruptcy_cramdown_costs,
DROP COLUMN interest_rate_step_indicator;


ALTER TABLE silver_perf_2023
DROP COLUMN mi_recoveries,
DROP COLUMN net_sale_proceeds,
DROP COLUMN non_mi_recoveries,
DROP COLUMN total_expenses,
DROP COLUMN legal_costs,
DROP COLUMN maintenance_preservation_costs,
DROP COLUMN taxes_insurance,
DROP COLUMN miscellaneous_expenses,
DROP COLUMN bankruptcy_cramdown_costs,
DROP COLUMN interest_rate_step_indicator;

ALTER TABLE silver_perf_2024
DROP COLUMN mi_recoveries,
DROP COLUMN net_sale_proceeds,
DROP COLUMN non_mi_recoveries,
DROP COLUMN total_expenses,
DROP COLUMN legal_costs,
DROP COLUMN maintenance_preservation_costs,
DROP COLUMN taxes_insurance,
DROP COLUMN miscellaneous_expenses,
DROP COLUMN bankruptcy_cramdown_costs,
DROP COLUMN interest_rate_step_indicator;

-- Vemos los elementos nulos o vacios de las distintas columnas de perf 2020

SELECT
    'loan_sequence_number' AS columna,
    SUM(loan_sequence_number IS NULL OR TRIM(loan_sequence_number) = '') AS vacios
FROM silver_perf_2020

UNION ALL

SELECT
    'monthly_reporting_period',
    SUM(monthly_reporting_period IS NULL OR TRIM(monthly_reporting_period) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'current_actual_upb',
    SUM(current_actual_upb IS NULL OR TRIM(current_actual_upb) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'current_loan_delinquency_status',
    SUM(current_loan_delinquency_status IS NULL OR TRIM(current_loan_delinquency_status) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'loan_age',
    SUM(loan_age IS NULL OR TRIM(loan_age) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'remaining_months_to_legal_maturity',
    SUM(remaining_months_to_legal_maturity IS NULL OR TRIM(remaining_months_to_legal_maturity) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'defect_settlement_date',
    SUM(defect_settlement_date IS NULL OR TRIM(defect_settlement_date) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'modification_flag',
    SUM(modification_flag IS NULL OR TRIM(modification_flag) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'zero_balance_code',
    SUM(zero_balance_code IS NULL OR TRIM(zero_balance_code) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'zero_balance_effective_date',
    SUM(zero_balance_effective_date IS NULL OR TRIM(zero_balance_effective_date) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'current_interest_rate',
    SUM(current_interest_rate IS NULL OR TRIM(current_interest_rate) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'current_non_interest_bearing_upb',
    SUM(current_non_interest_bearing_upb IS NULL OR TRIM(current_non_interest_bearing_upb) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'due_date_last_paid_installment',
    SUM(due_date_last_paid_installment IS NULL OR TRIM(due_date_last_paid_installment) = '')
FROM silver_perf_2020

UNION ALL


SELECT
    'actual_loss',
    SUM(actual_loss IS NULL OR TRIM(actual_loss) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'cumulative_modification_cost',
    SUM(cumulative_modification_cost IS NULL OR TRIM(cumulative_modification_cost) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'payment_deferral_flag',
    SUM(payment_deferral_flag IS NULL OR TRIM(payment_deferral_flag) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'estimated_ltv',
    SUM(estimated_ltv IS NULL OR TRIM(estimated_ltv) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'zero_balance_removal_upb',
    SUM(zero_balance_removal_upb IS NULL OR TRIM(zero_balance_removal_upb) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'delinquent_accrued_interest',
    SUM(delinquent_accrued_interest IS NULL OR TRIM(delinquent_accrued_interest) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'delinquency_due_to_disaster',
    SUM(delinquency_due_to_disaster IS NULL OR TRIM(delinquency_due_to_disaster) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'borrower_assistance_status_code',
    SUM(borrower_assistance_status_code IS NULL OR TRIM(borrower_assistance_status_code) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'current_month_modification_cost',
    SUM(current_month_modification_cost IS NULL OR TRIM(current_month_modification_cost) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'interest_bearing_upb',
    SUM(interest_bearing_upb IS NULL OR TRIM(interest_bearing_upb) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'mortgage_insurance_cancellation_indicator',
    SUM(mortgage_insurance_cancellation_indicator IS NULL OR TRIM(mortgage_insurance_cancellation_indicator) = '')
FROM silver_perf_2020

UNION ALL

SELECT
    'servicer_name',
    SUM(servicer_name IS NULL OR TRIM(servicer_name) = '')
FROM silver_perf_2020

-- No elimino las columnas aunque tengan muchos elementos nulos ya que creo que dichos elementos cuando no sean nulos pueden 
-- aportar información útil

SELECT COUNT(*) AS filas
FROM silver_perf_2020;


select *
from silver_perf_2020 sp ;

-- Aqui convierto al igual que he hecho con las tablas orig los "" en NULL en mi tabla de 2020

SET SESSION group_concat_max_len = 1000000;

SET @sql = (
    SELECT CONCAT(
        'UPDATE silver_perf_2020 SET ',
        GROUP_CONCAT(
            CONCAT(
                '`', COLUMN_NAME, '` = NULLIF(TRIM(`',
                COLUMN_NAME,
                '`), '''')'
            )
            SEPARATOR ', '
        ),
        ';'
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'tfm_mortgage'
      AND TABLE_NAME = 'silver_perf_2020'
);

PREPARE stmt FROM @sql;
EXECUTE stmt; 
DEALLOCATE PREPARE stmt;


select *
from silver_perf_2020;


-- Preparo las columnas con fechas para pasarlas a formato DATE

UPDATE silver_perf_2020
SET monthly_reporting_period =
    CONCAT(
        SUBSTRING(TRIM(monthly_reporting_period), 1, 4),
        '-',
        SUBSTRING(TRIM(monthly_reporting_period), 5, 2),
        '-01'
    )
WHERE monthly_reporting_period IS NOT NULL
  AND TRIM(monthly_reporting_period) <> '';

UPDATE silver_perf_2020
SET
    zero_balance_effective_date =
        CONCAT(
            SUBSTRING(TRIM(zero_balance_effective_date), 1, 4),
            '-',
            SUBSTRING(TRIM(zero_balance_effective_date), 5, 2),
            '-01'
        )
WHERE zero_balance_effective_date IS NOT NULL
  AND TRIM(zero_balance_effective_date) <> '';

UPDATE silver_perf_2020
SET
    due_date_last_paid_installment =
        CONCAT(
            SUBSTRING(TRIM(due_date_last_paid_installment), 1, 4),
            '-',
            SUBSTRING(TRIM(due_date_last_paid_installment), 5, 2),
            '-01'
        )
WHERE due_date_last_paid_installment IS NOT NULL
  AND TRIM(due_date_last_paid_installment) <> '';

UPDATE silver_perf_2020
SET defect_settlement_date =
    CONCAT(
        SUBSTRING(TRIM(defect_settlement_date), 1, 4),
        '-',
        SUBSTRING(TRIM(defect_settlement_date), 5, 2),
        '-01'
    )
WHERE defect_settlement_date IS NOT NULL
  AND TRIM(defect_settlement_date) <> '';

-- Cambio los formatos al tipo correcto

ALTER TABLE silver_perf_2020
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN monthly_reporting_period DATE,
    MODIFY COLUMN current_actual_upb DECIMAL(15,2),
    MODIFY COLUMN current_loan_delinquency_status VARCHAR(5),
    MODIFY COLUMN loan_age INT,
    MODIFY COLUMN remaining_months_to_legal_maturity INT,
    MODIFY COLUMN defect_settlement_date DATE,
    MODIFY COLUMN modification_flag CHAR(1),
    MODIFY COLUMN zero_balance_code CHAR(2),
    MODIFY COLUMN zero_balance_effective_date DATE,
    MODIFY COLUMN current_interest_rate DECIMAL(7,4),
    MODIFY COLUMN current_non_interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN due_date_last_paid_installment DATE,
    MODIFY COLUMN actual_loss DECIMAL(15,2),
    MODIFY COLUMN cumulative_modification_cost DECIMAL(15,2),
    MODIFY COLUMN payment_deferral_flag CHAR(1),
    MODIFY COLUMN estimated_ltv DECIMAL(5,2),
    MODIFY COLUMN zero_balance_removal_upb DECIMAL(15,2),
    MODIFY COLUMN delinquent_accrued_interest DECIMAL(15,2),
    MODIFY COLUMN delinquency_due_to_disaster CHAR(1),
    MODIFY COLUMN borrower_assistance_status_code CHAR(2),
    MODIFY COLUMN current_month_modification_cost DECIMAL(15,2),
    MODIFY COLUMN interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN mortgage_insurance_cancellation_indicator CHAR(1),
    MODIFY COLUMN servicer_name VARCHAR(100);

select *
from silver_perf_2020 sp ;

-- Y repito lo mismo con los otros 4 años

SET SESSION group_concat_max_len = 1000000;

SET @sql = (
    SELECT CONCAT(
        'UPDATE silver_perf_2021 SET ',
        GROUP_CONCAT(
            CONCAT(
                '`', COLUMN_NAME, '` = NULLIF(TRIM(`',
                COLUMN_NAME,
                '`), '''')'
            )
            SEPARATOR ', '
        ),
        ';'
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'tfm_mortgage'
      AND TABLE_NAME = 'silver_perf_2021'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET SESSION group_concat_max_len = 1000000;

SET @sql = (
    SELECT CONCAT(
        'UPDATE silver_perf_2022 SET ',
        GROUP_CONCAT(
            CONCAT(
                '`', COLUMN_NAME, '` = NULLIF(TRIM(`',
                COLUMN_NAME,
                '`), '''')'
            )
            SEPARATOR ', '
        ),
        ';'
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'tfm_mortgage'
      AND TABLE_NAME = 'silver_perf_2022'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET SESSION group_concat_max_len = 1000000;

SET @sql = (
    SELECT CONCAT(
        'UPDATE silver_perf_2023 SET ',
        GROUP_CONCAT(
            CONCAT(
                '`', COLUMN_NAME, '` = NULLIF(TRIM(`',
                COLUMN_NAME,
                '`), '''')'
            )
            SEPARATOR ', '
        ),
        ';'
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'tfm_mortgage'
      AND TABLE_NAME = 'silver_perf_2023'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET SESSION group_concat_max_len = 1000000;

SET @sql = (
    SELECT CONCAT(
        'UPDATE silver_perf_2024 SET ',
        GROUP_CONCAT(
            CONCAT(
                '`', COLUMN_NAME, '` = NULLIF(TRIM(`',
                COLUMN_NAME,
                '`), '''')'
            )
            SEPARATOR ', '
        ),
        ';'
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'tfm_mortgage'
      AND TABLE_NAME = 'silver_perf_2024'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE silver_perf_2021
SET monthly_reporting_period = CONCAT(
    SUBSTRING(TRIM(monthly_reporting_period), 1, 4),
    '-',
    SUBSTRING(TRIM(monthly_reporting_period), 5, 2),
    '-01'
)
WHERE monthly_reporting_period IS NOT NULL
  AND TRIM(monthly_reporting_period) <> '';

UPDATE silver_perf_2021
SET
    defect_settlement_date = CONCAT(
        SUBSTRING(TRIM(defect_settlement_date), 1, 4), '-',
        SUBSTRING(TRIM(defect_settlement_date), 5, 2), '-01'
    )
WHERE defect_settlement_date IS NOT NULL
  AND TRIM(defect_settlement_date) <> '';

UPDATE silver_perf_2021
SET
    zero_balance_effective_date = CONCAT(
        SUBSTRING(TRIM(zero_balance_effective_date), 1, 4), '-',
        SUBSTRING(TRIM(zero_balance_effective_date), 5, 2), '-01'
    )
WHERE zero_balance_effective_date IS NOT NULL
  AND TRIM(zero_balance_effective_date) <> '';

UPDATE silver_perf_2021
SET
    due_date_last_paid_installment = CONCAT(
        SUBSTRING(TRIM(due_date_last_paid_installment), 1, 4), '-',
        SUBSTRING(TRIM(due_date_last_paid_installment), 5, 2), '-01'
    )
WHERE due_date_last_paid_installment IS NOT NULL
  AND TRIM(due_date_last_paid_installment) <> '';


UPDATE silver_perf_2022
SET monthly_reporting_period = CONCAT(
    SUBSTRING(TRIM(monthly_reporting_period), 1, 4),
    '-',
    SUBSTRING(TRIM(monthly_reporting_period), 5, 2),
    '-01'
)
WHERE monthly_reporting_period IS NOT NULL
  AND TRIM(monthly_reporting_period) <> '';


UPDATE silver_perf_2022
SET
    defect_settlement_date = CONCAT(
        SUBSTRING(TRIM(defect_settlement_date), 1, 4), '-',
        SUBSTRING(TRIM(defect_settlement_date), 5, 2), '-01'
    )
WHERE defect_settlement_date IS NOT NULL
  AND TRIM(defect_settlement_date) <> '';

UPDATE silver_perf_2022
SET
    zero_balance_effective_date = CONCAT(
        SUBSTRING(TRIM(zero_balance_effective_date), 1, 4), '-',
        SUBSTRING(TRIM(zero_balance_effective_date), 5, 2), '-01'
    )
WHERE zero_balance_effective_date IS NOT NULL
  AND TRIM(zero_balance_effective_date) <> '';

UPDATE silver_perf_2022
SET
    due_date_last_paid_installment = CONCAT(
        SUBSTRING(TRIM(due_date_last_paid_installment), 1, 4), '-',
        SUBSTRING(TRIM(due_date_last_paid_installment), 5, 2), '-01'
    )
WHERE due_date_last_paid_installment IS NOT NULL
  AND TRIM(due_date_last_paid_installment) <> '';



UPDATE silver_perf_2023
SET monthly_reporting_period = CONCAT(
    SUBSTRING(TRIM(monthly_reporting_period), 1, 4),
    '-',
    SUBSTRING(TRIM(monthly_reporting_period), 5, 2),
    '-01'
)
WHERE monthly_reporting_period IS NOT NULL
  AND TRIM(monthly_reporting_period) <> '';

UPDATE silver_perf_2023
SET
    defect_settlement_date = CONCAT(
        SUBSTRING(TRIM(defect_settlement_date), 1, 4), '-',
        SUBSTRING(TRIM(defect_settlement_date), 5, 2), '-01'
    )
WHERE defect_settlement_date IS NOT NULL
  AND TRIM(defect_settlement_date) <> '';

UPDATE silver_perf_2023
SET
    zero_balance_effective_date = CONCAT(
        SUBSTRING(TRIM(zero_balance_effective_date), 1, 4), '-',
        SUBSTRING(TRIM(zero_balance_effective_date), 5, 2), '-01'
    )
WHERE zero_balance_effective_date IS NOT NULL
  AND TRIM(zero_balance_effective_date) <> '';

UPDATE silver_perf_2023
SET
    due_date_last_paid_installment = CONCAT(
        SUBSTRING(TRIM(due_date_last_paid_installment), 1, 4), '-',
        SUBSTRING(TRIM(due_date_last_paid_installment), 5, 2), '-01'
    )
WHERE due_date_last_paid_installment IS NOT NULL
  AND TRIM(due_date_last_paid_installment) <> '';

UPDATE silver_perf_2024
SET monthly_reporting_period = CONCAT(
    SUBSTRING(TRIM(monthly_reporting_period), 1, 4),
    '-',
    SUBSTRING(TRIM(monthly_reporting_period), 5, 2),
    '-01'
)
WHERE monthly_reporting_period IS NOT NULL
  AND TRIM(monthly_reporting_period) <> '';


UPDATE silver_perf_2024
SET
    defect_settlement_date = CONCAT(
        SUBSTRING(TRIM(defect_settlement_date), 1, 4), '-',
        SUBSTRING(TRIM(defect_settlement_date), 5, 2), '-01'
    )
WHERE defect_settlement_date IS NOT NULL
  AND TRIM(defect_settlement_date) <> '';

UPDATE silver_perf_2024
SET
    zero_balance_effective_date = CONCAT(
        SUBSTRING(TRIM(zero_balance_effective_date), 1, 4), '-',
        SUBSTRING(TRIM(zero_balance_effective_date), 5, 2), '-01'
    )
WHERE zero_balance_effective_date IS NOT NULL
  AND TRIM(zero_balance_effective_date) <> '';

UPDATE silver_perf_2024
SET
    due_date_last_paid_installment = CONCAT(
        SUBSTRING(TRIM(due_date_last_paid_installment), 1, 4), '-',
        SUBSTRING(TRIM(due_date_last_paid_installment), 5, 2), '-01'
    )
WHERE due_date_last_paid_installment IS NOT NULL
  AND TRIM(due_date_last_paid_installment) <> '';

select *
from silver_perf_2021;

ALTER TABLE silver_perf_2021
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN monthly_reporting_period DATE,
    MODIFY COLUMN current_actual_upb DECIMAL(15,2),
    MODIFY COLUMN current_loan_delinquency_status VARCHAR(5),
    MODIFY COLUMN loan_age INT,
    MODIFY COLUMN remaining_months_to_legal_maturity INT,
    MODIFY COLUMN defect_settlement_date DATE,
    MODIFY COLUMN modification_flag CHAR(1),
    MODIFY COLUMN zero_balance_code CHAR(2),
    MODIFY COLUMN zero_balance_effective_date DATE,
    MODIFY COLUMN current_interest_rate DECIMAL(7,4),
    MODIFY COLUMN current_non_interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN due_date_last_paid_installment DATE,
    MODIFY COLUMN actual_loss DECIMAL(15,2),
    MODIFY COLUMN cumulative_modification_cost DECIMAL(15,2),
    MODIFY COLUMN payment_deferral_flag CHAR(1),
    MODIFY COLUMN estimated_ltv DECIMAL(5,2),
    MODIFY COLUMN zero_balance_removal_upb DECIMAL(15,2),
    MODIFY COLUMN delinquent_accrued_interest DECIMAL(15,2),
    MODIFY COLUMN delinquency_due_to_disaster CHAR(1),
    MODIFY COLUMN borrower_assistance_status_code CHAR(2),
    MODIFY COLUMN current_month_modification_cost DECIMAL(15,2),
    MODIFY COLUMN interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN mortgage_insurance_cancellation_indicator CHAR(1),
    MODIFY COLUMN servicer_name VARCHAR(100);


ALTER TABLE silver_perf_2022
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN monthly_reporting_period DATE,
    MODIFY COLUMN current_actual_upb DECIMAL(15,2),
    MODIFY COLUMN current_loan_delinquency_status VARCHAR(5),
    MODIFY COLUMN loan_age INT,
    MODIFY COLUMN remaining_months_to_legal_maturity INT,
    MODIFY COLUMN defect_settlement_date DATE,
    MODIFY COLUMN modification_flag CHAR(1),
    MODIFY COLUMN zero_balance_code CHAR(2),
    MODIFY COLUMN zero_balance_effective_date DATE,
    MODIFY COLUMN current_interest_rate DECIMAL(7,4),
    MODIFY COLUMN current_non_interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN due_date_last_paid_installment DATE,
    MODIFY COLUMN actual_loss DECIMAL(15,2),
    MODIFY COLUMN cumulative_modification_cost DECIMAL(15,2),
    MODIFY COLUMN payment_deferral_flag CHAR(1),
    MODIFY COLUMN estimated_ltv DECIMAL(5,2),
    MODIFY COLUMN zero_balance_removal_upb DECIMAL(15,2),
    MODIFY COLUMN delinquent_accrued_interest DECIMAL(15,2),
    MODIFY COLUMN delinquency_due_to_disaster CHAR(1),
    MODIFY COLUMN borrower_assistance_status_code CHAR(2),
    MODIFY COLUMN current_month_modification_cost DECIMAL(15,2),
    MODIFY COLUMN interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN mortgage_insurance_cancellation_indicator CHAR(1),
    MODIFY COLUMN servicer_name VARCHAR(100);

ALTER TABLE silver_perf_2023
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN monthly_reporting_period DATE,
    MODIFY COLUMN current_actual_upb DECIMAL(15,2),
    MODIFY COLUMN current_loan_delinquency_status VARCHAR(5),
    MODIFY COLUMN loan_age INT,
    MODIFY COLUMN remaining_months_to_legal_maturity INT,
    MODIFY COLUMN defect_settlement_date DATE,
    MODIFY COLUMN modification_flag CHAR(1),
    MODIFY COLUMN zero_balance_code CHAR(2),
    MODIFY COLUMN zero_balance_effective_date DATE,
    MODIFY COLUMN current_interest_rate DECIMAL(7,4),
    MODIFY COLUMN current_non_interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN due_date_last_paid_installment DATE,
    MODIFY COLUMN actual_loss DECIMAL(15,2),
    MODIFY COLUMN cumulative_modification_cost DECIMAL(15,2),
    MODIFY COLUMN payment_deferral_flag CHAR(1),
    MODIFY COLUMN estimated_ltv DECIMAL(5,2),
    MODIFY COLUMN zero_balance_removal_upb DECIMAL(15,2),
    MODIFY COLUMN delinquent_accrued_interest DECIMAL(15,2),
    MODIFY COLUMN delinquency_due_to_disaster CHAR(1),
    MODIFY COLUMN borrower_assistance_status_code CHAR(2),
    MODIFY COLUMN current_month_modification_cost DECIMAL(15,2),
    MODIFY COLUMN interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN mortgage_insurance_cancellation_indicator CHAR(1),
    MODIFY COLUMN servicer_name VARCHAR(100);

ALTER TABLE silver_perf_2024
    MODIFY COLUMN loan_sequence_number VARCHAR(20),
    MODIFY COLUMN monthly_reporting_period DATE,
    MODIFY COLUMN current_actual_upb DECIMAL(15,2),
    MODIFY COLUMN current_loan_delinquency_status VARCHAR(5),
    MODIFY COLUMN loan_age INT,
    MODIFY COLUMN remaining_months_to_legal_maturity INT,
    MODIFY COLUMN defect_settlement_date DATE,
    MODIFY COLUMN modification_flag CHAR(1),
    MODIFY COLUMN zero_balance_code CHAR(2),
    MODIFY COLUMN zero_balance_effective_date DATE,
    MODIFY COLUMN current_interest_rate DECIMAL(7,4),
    MODIFY COLUMN current_non_interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN due_date_last_paid_installment DATE,
    MODIFY COLUMN actual_loss DECIMAL(15,2),
    MODIFY COLUMN cumulative_modification_cost DECIMAL(15,2),
    MODIFY COLUMN payment_deferral_flag CHAR(1),
    MODIFY COLUMN estimated_ltv DECIMAL(5,2),
    MODIFY COLUMN zero_balance_removal_upb DECIMAL(15,2),
    MODIFY COLUMN delinquent_accrued_interest DECIMAL(15,2),
    MODIFY COLUMN delinquency_due_to_disaster CHAR(1),
    MODIFY COLUMN borrower_assistance_status_code CHAR(2),
    MODIFY COLUMN current_month_modification_cost DECIMAL(15,2),
    MODIFY COLUMN interest_bearing_upb DECIMAL(15,2),
    MODIFY COLUMN mortgage_insurance_cancellation_indicator CHAR(1),
    MODIFY COLUMN servicer_name VARCHAR(100);

