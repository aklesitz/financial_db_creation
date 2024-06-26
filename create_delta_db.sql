-- Create table for Delta 
CREATE TABLE delta (
	date date,
	amount numeric,
	description text,
	category text
);

-- Import data (already formatted in power query)
COPY delta (
	date,
	amount,
	description,
	category
)
FROM 'Delta FilePath'
DELIMITER ','
CSV HEADER;

-- Importing new data (already formatted)
COPY delta (date, amount, description, category)
FROM 'Delta_new_trans FilePath'
DELIMITER ','
CSV HEADER;

-- adding account column to identify transactions from Delta account
ALTER TABLE delta
ADD COLUMN account text;

UPDATE delta
SET account = 'delta';

-- Cleaning unclear category data for delta account
UPDATE delta
SET standardized_category = CASE
	WHEN category ilike 'rocket farm rest' THEN 'AK Income'
	ELSE 'unassigned'
END;