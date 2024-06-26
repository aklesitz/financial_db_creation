-- Create table for amex data with columns I want from csv
CREATE TABLE amex (
	date date,
	amount numeric,
	description text,
	category text
);

-- Create staging table
CREATE TABLE amex_staging (
	Date date,
	Description text,
	Amount numeric,
	Extended_Details text,
	Appears_On_Your_Statement_As text,
	Address text,
	City_State text,
	Zip_Code text,
	Country text,
	Reference text,
	Category text
);

-- Import data into staging table
COPY amex_staging (
	Date,
	Description,
	Amount,
	Extended_Details,
	Appears_On_Your_Statement_As,
	Address,
	City_State,
	Zip_Code,
	Country,
	Reference,
	Category
)
FROM 'AMEX_2021 FilePath'
DELIMITER ','
CSV HEADER;

COPY amex_staging (
	Date,
	Description,
	Amount,
	Extended_Details,
	Appears_On_Your_Statement_As,
	Address,
	City_State,
	Zip_Code,
	Country,
	Reference,
	Category
)
FROM 'AMEX_2022 FilePath'
DELIMITER ','
CSV HEADER;

COPY amex_staging (
	Date,
	Description,
	Amount,
	Extended_Details,
	Appears_On_Your_Statement_As,
	Address,
	City_State,
	Zip_Code,
	Country,
	Reference,
	Category
)
FROM 'AMEX_2023 FilePath'
DELIMITER ','
CSV HEADER;

COPY amex_staging (
	Date,
	Description,
	Amount,
	Extended_Details,
	Appears_On_Your_Statement_As,
	Address,
	City_State,
	Zip_Code,
	Country,
	Reference,
	Category
)
FROM 'AMEX_2024 FilePath'
DELIMITER ','
CSV HEADER;

-- Inserting desired columns into amex table
INSERT INTO amex (
	date,
	amount,
	description,
	category)
SELECT date, amount, description, category
FROM amex_staging;

-- Drop staging table
DROP TABLE amex_staging;


-- Updating amex db with new transactions
CREATE TABLE amex_staging (
	Date date,
	Description text,
	Amount numeric,
	Extended_Details text,
	Appears_On_Your_Statement_As text,
	Address text,
	City_State text,
	Zip_Code text,
	Country text,
	Reference text,
	Category text
);

COPY amex_staging (
	Date,
	Description,
	Amount,
	Extended_Details,
	Appears_On_Your_Statement_As,
	Address,
	City_State,
	Zip_Code,
	Country,
	Reference,
	Category
)
FROM 'AMEX_New_Trans FilePath'
DELIMITER ','
CSV HEADER;

INSERT INTO amex (date, amount, description, category)
SELECT s.date, s.amount, s.description, s.category
FROM amex_staging s
LEFT JOIN amex m
ON s.date = m.date AND s.amount = m.amount AND s.description = m.description
WHERE m.date IS NULL;

DROP TABLE amex_staging;

-- adding account column to identify transactions from amex account
ALTER TABLE amex
ADD COLUMN account text;

UPDATE amex
SET account = 'amex';

-- adding standardized category column to amex
ALTER TABLE amex
ADD COLUMN standardized_category text;

UPDATE amex
SET standardized_category = 
	CASE
		WHEN description ILIKE 'firestone%' OR
			 description ILIKE 'jcorp%' OR
			 description ILIKE 'autozone%' OR
			 description ILIKE '%dmv%' OR
			 description ILIKE 'ga driver svcs%' OR
			 description ILIKE '%emissions%' THEN 'Auto Repair/Fee'
		WHEN category ILIKE '%Transportation-Fuel%' AND amount > 15 THEN 'Gas/Automotive'
		WHEN category ILIKE '%Transportation-Fuel%' AND amount <= 15 OR
			 (description ILIKE '%savi%' AND category ILIKE '%groceries%') OR
			 (description ILIKE '%qt%' AND category ILIKE '%groceries%') THEN 'Cigarettes'
		WHEN category ILIKE '%Groceries%' OR
			 description ILIKE '%kroger%' OR
			 description ILIKE '%food mart%' OR
			 description ILIKE '%publix%' OR
			 description ILIKE '%costco%' THEN 'Grocery'
		WHEN description ILIKE '%amazon%' THEN 'Amazon Purchase'
		WHEN category ILIKE '%Restaurant%' OR
			 category ILIKE '%dining%' OR
			 description ILIKE '%spa land%' OR
			 category ILIKE '%entertainment%' OR
			 category ILIKE '%other services%' THEN 'Dining Out/Entertainment'
		WHEN category ILIKE '%Book Stores%' OR
			 description ILIKE '%southern thrift%' OR
			 description ILIKE '%michaels%' OR
			 description ILIKE 'rag-o-rama%' OR
			 description ILIKE '%tjmaxx%' THEN 'Purchases'
		WHEN category ILIKE '%Fees & Adjustments%' OR
			 category ILIKE '%interest charge%' THEN 'CC Interest'
		WHEN category ILIKE '%hardware%' OR
			 description ILIKE '%home depot%' OR
			 description ILIKE '%homegoods%' THEN 'Home Improvement'
		WHEN category ILIKE '%office%' OR
			 category ILIKE '%splice%' OR
			 category ILIKE '%spotify%' OR
			 description ILIKE '%apple%' OR
			 description ILIKE '%hulu%' OR
			 description ILIKE '%netflix%' THEN 'Streaming Service'
		WHEN category ILIKE '%parking%' OR
			 description ILIKE '%laz parking%' OR
			 description ILIKE '%parkmobile%' THEN 'Parking'
		WHEN category ILIKE '%capitol one%' OR
			 category ILIKE '%citi%' OR
			 category ILIKE '%bk of amer%' OR
			 category ILIKE '%amex%' THEN 'CC Payment'
		WHEN description ILIKE '%geico%' THEN 'Auto Insurance'
		WHEN description ILIKE '%columbia%' OR
			 description ILIKE '%petco%' THEN 'Pet Expense'
		WHEN category ILIKE '%pharmacies%' OR
			 description ILIKE '%kaiser%' THEN 'Healthcare'
		WHEN description ILIKE '%CFM GROUP%' THEN 'Chiropractor Charge'
		WHEN category ILIKE '%rocket farm rest%' THEN 'AK Income'
		WHEN description ILIKE '%atlanta contract payroll%' THEN 'EW Income'
		WHEN category ILIKE '%mortgage payment%' THEN 'Mortgage'
		WHEN category ILIKE '%natural gas payment%' OR
			 category ILIKE '%ga power%' THEN 'Utilities'
		ELSE 'unasssigned'
	END;

-- Finding number of distinct categories across all accounts
WITH dist_cat_count AS (
	SELECT DISTINCT category
	FROM amex
	UNION ALL
	SELECT DISTINCT category
	FROM boa
	UNION ALL
	SELECT DISTINCT category
	FROM cap_one
	UNION ALL
	SELECT DISTINCT category
	FROM citibank
	UNION ALL
	SELECT DISTINCT category
	FROM delta
	UNION ALL
	SELECT DISTINCT category
	FROM wf_credit
	UNION ALL
	SELECT DISTINCT category
	FROM wf_debit
)
SELECT COUNT(*)
FROM dist_cat_count;