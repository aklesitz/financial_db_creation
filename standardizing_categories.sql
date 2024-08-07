-- Finding all unassigned standardized categories
SELECT
	c.orig_category,
	t.amount,
	t.description
FROM categories c
JOIN transactions t
	ON t.category_id = c.category_id
WHERE stand_category ilike 'unassigned'

-- Replacing unclear or redundant categories with standardized versions
UPDATE categories
SET stand_category = CASE
	WHEN orig_category ilike '%restaurant%'
		THEN 'Dining Out'
	WHEN orig_category ilike '%groceries%' 
	OR orig_category ilike '%grocery%'
		THEN 'Grocery'
	WHEN orig_category ilike 'merchandise%'
	OR orig_category ilike 'other-charities'
	OR orig_category ilike '%internet services%'
	OR orig_category ilike '%miscellaneous%'
	OR orig_category ilike 'apple%'
	OR orig_category ilike 'retail-clothing'
		THEN 'Retail'
	WHEN orig_category ilike '%travel%'
		THEN 'Travel'
	WHEN orig_category ilike 'transportation%'
	OR orig_category ilike 'gas%'
	OR orig_category ilike 'decatur parking%'
		THEN 'Gas/Automotive'
	WHEN orig_category ilike 'payment'
	OR orig_category ilike 'cc payment'
	OR orig_category ilike 'amex epayment'
	OR orig_category ilike 'citi%'
	OR orig_category ilike 'bk of amer%'
	OR orig_category ilike '%zelle%'
	OR orig_category ilike 'capital one%'
	OR orig_category ilike 'capitol one'
		THEN 'CC Payment'
	WHEN orig_category ilike '%insurance%'
		THEN 'Auto Insurance'
	WHEN orig_category ilike 'business services%'
		THEN RIGHT(orig_category, LENGTH(orig_category) - POSITION('-' IN orig_category))
	WHEN orig_category ilike 'fees%'
		THEN 'Interest/Fees'
	WHEN orig_category ilike 'entertainment%'
	OR orig_category ilike 'splice%'
	OR orig_category ilike 'spotify%'
		THEN 'Entertainment'
	WHEN orig_category ilike '%education%'
		THEN 'Online Courses'
	WHEN orig_category ilike '%government services%'
		THEN 'DMV/Permit Fees'
	WHEN orig_category ilike 'rocket%'
	OR orig_category ilike 'boa rewards'
	OR orig_category ilike 'escrow%'
	OR orig_category ilike 'jury%'
		THEN 'Income'
	WHEN orig_category ilike 'fraud%'
		THEN 'Fraud Dispute'
	WHEN orig_category ilike 'ak student loan'
	OR orig_category ilike 'launch%'
		THEN 'Ascent Loan'
	WHEN orig_category ilike 'unassigned'
		THEN 'Hines Interest'
	ELSE 'unassigned'
END