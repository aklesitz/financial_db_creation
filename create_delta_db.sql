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

-- "Launch servicing" is my student loan, which is only paid from this account
-- and not represented anywhere else. I will clarify the category.
UPDATE delta
SET category = 'AK Student Loan'
WHERE category ilike 'launch servicing';

-- There is a null value here as well
SELECT * FROM delta WHERE category is null;

-- It is an escrow check from January, I will update the category
UPDATE delta
SET category = 'Escrow Check'
WHERE category IS NULL;

-- There is also a $15 remote check deposit from my day at jury duty
SELECT * FROM delta WHERE category ilike '%remote deposit%';

UPDATE delta
SET category = 'Jury Duty'
WHERE category ilike '%remote deposit%';
