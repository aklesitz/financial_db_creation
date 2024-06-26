-- Database Normalization
-- Schema creation for Normalized DB (accounts, categories, transactions)
CREATE TABLE accounts (
	account_id SERIAL PRIMARY KEY,
	account_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE categories (
	category_id SERIAL PRIMARY KEY,
	orig_category VARCHAR(255) NOT NULL,
	stand_category VARCHAR(255) NOT NULL
);

CREATE TABLE transactions (
	transaction_id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	transaction_date DATE NOT NULL,
	amount NUMERIC NOT NULL,
	description TEXT NOT NULL,
	category_id INTEGER NOT NULL,
	FOREIGN KEY (account_id) REFERENCES accounts (account_id),
	FOREIGN KEY (category_id) REFERENCES categories (category_id)
);

-- Populating tables
INSERT INTO accounts (account_name) VALUES
	('amex'), 
	('boa'), 
	('cap_one'), 
	('citi'), 
	('delta'), 
	('wf_credit'), 
	('wf_debit');
	
INSERT INTO categories (orig_category, stand_category)
	SELECT DISTINCT category, standardized_category
	FROM amex
	UNION ALL
	SELECT DISTINCT category, standardized_category
	FROM boa
	UNION ALL
	SELECT DISTINCT category, standardized_category
	FROM cap_one
	UNION ALL
	SELECT DISTINCT category, standardized_category
	FROM citibank
	UNION ALL
	SELECT DISTINCT category, standardized_category
	FROM delta
	UNION ALL
	SELECT DISTINCT category, standardized_category
	FROM wf_credit
	UNION ALL
	SELECT DISTINCT category, standardized_category
	FROM wf_debit;

-- Creating a staging table to import transactions
CREATE TABLE transactions_staging (
	account_name VARCHAR(255),
	transaction_date DATE,
	amount NUMERIC,
	description TEXT,
	orig_category VARCHAR(255)
);

INSERT INTO transactions_staging (account_name, transaction_date, amount, description, orig_category)
	SELECT account, date, amount, description, category
	FROM amex
	UNION ALL
	SELECT account, date, amount, description, category
	FROM boa
	UNION ALL
	SELECT account, date, amount, description, category
	FROM cap_one
	UNION ALL
	SELECT account, date, amount, description, category
	FROM citibank
	UNION ALL
	SELECT account, date, amount, description, category
	FROM delta
	UNION ALL
	SELECT account, date, amount, description, category
	FROM wf_credit
	UNION ALL
	SELECT account, date, amount, description, category
	FROM wf_debit;

-- Inserting data from stagining table to transactions table
INSERT INTO transactions (account_id, transaction_date, amount, description, category_id)
	SELECT
		a.account_id,
		s.transaction_date,
		s.amount,
		s.description,
		c.category_id
	FROM 
		transactions_staging s
	JOIN 
		accounts a ON s.account_name = a.account_name
	JOIN
		categories c ON s.orig_category = c.orig_category;
		
DROP TABLE transactions_staging;
