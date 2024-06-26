-- Create table for citibank data with columns I want from csv
CREATE TABLE citibank (
	date date,
	amount numeric,
	description text,
	category text
);

-- Create staging table
CREATE TABLE citibank_staging (
	Status text,
	Date date,
	Description text,
	Debit numeric,
	Credit numeric
);

-- Import data into staging table
COPY citibank_staging (
	Status,
	Date,
	Description,
	Debit,
	Credit
)
FROM 'Citibank FilePath'
DELIMITER ','
CSV HEADER;

-- Inserting desired columns into citibank table
INSERT INTO citibank (
	date,
	amount,
	description,
	category)
SELECT 
	Date,
	Case
		WHEN Debit IS NOT NULL THEN debit 
		WHEN Credit IS NOT NULL THEN -credit
	END AS amount,
	Description,
	'citibank_payment' as category
FROM citibank_staging;

-- Drop staging table
DROP TABLE citibank_staging;

-- adding account column to identify transactions from citibank account
ALTER TABLE citibank
ADD COLUMN account text;

UPDATE citibank
SET account = 'Citibank';

UPDATE citibank
SET standardized_category = CASE
	WHEN description ilike '%payment%' THEN 'CC Payment'
	WHEN description ilike '%balance transfer%' THEN 'Balance Transfer Fee'
	ELSE 'unassigned'
END;
