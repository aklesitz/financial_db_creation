-- Create table for wells fargo credit info
CREATE TABLE wf_credit (
	date date,
	amount numeric,
	description text,
	category text
);

-- Create table for wells fargo debit info
CREATE TABLE wf_debit (
	date date,
	amount numeric,
	description text,
	category text
);

-- Import credit data into wf_credit
COPY wf_credit (
	date,
	amount,
	description,
	category
)
FROM 'WF_Credit FilePath'
DELIMITER ','
CSV HEADER;

-- Import debit data into wf_debit
COPY wf_debit (
	date,
	amount,
	description,
	category
)
FROM 'WF_Debit FilePath'
DELIMITER ','
CSV HEADER;

-- adding account column to identify transactions from wf_credit account
ALTER TABLE wf_credit
ADD COLUMN account text;

UPDATE wf_credit
SET account = 'WF Credit';

-- adding account column to identify transactions from wf_debit account
ALTER TABLE wf_debit
ADD COLUMN account text;

UPDATE wf_debit
SET account = 'WF Debit';

-- Standardizing categories for wf_debit
SELECT DISTINCT category FROM wf_debit;

SELECT * FROM wf_debit WHERE category ilike '%squish mallow%';

UPDATE wf_debit
SET category = CASE
	WHEN category ilike '%planet fit club%' THEN 'Planet Fit Club Fees'
	WHEN category ilike '%capital one mobile pmt%' THEN 'Cap One Payment'
	WHEN category ilike 'venmo payment%' THEN 'Venmo Payment'
	WHEN category ilike 'venmo cashout%' THEN 'Venmo Cashout'
	WHEN category ilike 'atlanta contract payroll%' THEN 'Erica Income'
	WHEN category ilike 'Georgia Departme%' THEN 'Tax Refund'
	WHEN category ilike 'online transfer ref%' THEN 'WF Credit Payment'
	WHEN category ilike 'honda%' THEN 'Erica Car Payment'
	WHEN category ilike 'recurring payment%' THEN 'Equifax Payment'
	WHEN category ilike 'georgia housing%' THEN 'Mortgage Payment'
	WHEN category ilike '%scana%' THEN 'Natural Gas Payment'
	WHEN category ilike 'mobile deposit%' THEN 'Erica Bonus Check'
	WHEN category ilike '%klesitz%' THEN 'Credit Card Payment'
	WHEN category ilike '%dekalb far%'
	OR category ilike '%kroger%' THEN 'Groceries'
	WHEN category ilike '%dmv%' THEN 'Car Tag/DMV fees'
	WHEN category ilike '%cookies%' THEN 'Restaurant'
	WHEN category ilike '%carpay%' THEN 'Adam Car Payment'
	WHEN category ilike '%irs treas%' THEN 'Tax Refund'
	WHEN category ilike '%atm%' THEN 'Atm fees'
	WHEN category ilike '%gpc%' THEN 'GA Power'
	WHEN category ilike '%ach%' THEN 'Tax Payment'
	ELSE category
END;

SELECT * FROM wf_debit