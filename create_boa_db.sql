-- Create table for bank of america data
-- (already modeled with power query)
CREATE table BOA (
	date date,
	amount numeric,
	description text,
	category text
);

-- Inserting data
COPY BOA (
	date,
	amount,
	description,
	category
)
FROM 'BOA FilePath'
DELIMITER ','
CSV HEADER;

-- adding account column to identify transactions from boa account
ALTER TABLE boa
ADD COLUMN account text;

UPDATE boa
SET account = 'boa';

-- Adding category names to standardized category
SELECT *
FROM BOA
WHERE category ilike 'category';

UPDATE BOA
SET standardized_category = CASE
	WHEN description ilike '%splice%' THEN 'Splice'
	WHEN description ilike 'shell%'
	OR description ilike 'texaco%'
	OR description ilike 'bp%'
	OR description ilike 'chevron%' THEN 'Gas'
	WHEN description ilike 'spotify%' THEN 'Spotify'
	WHEN description ilike 'BA%' THEN 'CC Payment'
	WHEN description ilike 'apple%' THEN 'Apple Icloud Storage'
	WHEN description ilike '%parents%' THEN 'Restaurant'
	WHEN description ilike 'circle%' THEN 'Gas Station'
	WHEN description ilike '%trinity%' THEN 'Decatur Parking'
	WHEN description ilike '%rewards%' THEN 'BOA Rewards'
	WHEN description ilike '%nintendo%' THEN 'Entertainment'
	WHEN description ilike 'goodwill%' THEN 'Retail-Clothing'
	WHEN description ilike 'etsy%'
	OR description ilike 'fraud%' THEN 'Fraud Dispute-Dec'
	ELSE 'unassigned'
END;
