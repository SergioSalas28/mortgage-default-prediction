USE tfm_mortgage;

SELECT DATABASE();


DROP TABLE IF EXISTS gold_orig;

CREATE TABLE gold_orig LIKE silver_orig_2020;

INSERT INTO gold_orig
SELECT * FROM silver_orig_2020

UNION ALL

SELECT * FROM silver_orig_2021

UNION ALL

SELECT * FROM silver_orig_2022

UNION ALL

SELECT * FROM silver_orig_2023

UNION ALL

SELECT * FROM silver_orig_2024;

select COUNT(*)
from gold_orig;

select *
from GOLD_ORIG;

DROP TABLE IF EXISTS gold_perf;

CREATE TABLE gold_perf LIKE silver_perf_2020;

INSERT INTO gold_perf
SELECT * FROM silver_perf_2020

UNION ALL

SELECT * FROM silver_perf_2021

UNION ALL

SELECT * FROM silver_perf_2022

UNION ALL

SELECT * FROM silver_perf_2023

UNION ALL

SELECT * FROM silver_perf_2024;

select COUNT(*)
from gold_perf;

-- Hacemos la columna de loan sequence number la columna key de nuestra tabla orig

ALTER TABLE gold_orig
ADD CONSTRAINT uq_gold_orig_loan_sequence
UNIQUE (loan_sequence_number);

-- Construimos la relación de 1 a muchos de la columna loan sequence number

ALTER TABLE gold_perf
ADD CONSTRAINT fk_gold_perf_orig
FOREIGN KEY (loan_sequence_number)
REFERENCES gold_orig (loan_sequence_number);
