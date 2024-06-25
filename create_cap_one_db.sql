-- Create table for capitol one data with columns I want from csv
CREATE TABLE cap_one (
	date date,
	amount numeric,
	description text,
	category text
);

-- Create staging table
CREATE TABLE cap_one_staging (
	Transaction_Date date,
	Posted_Date date,
	Card_No text,
	Description text,
	Category text,
	Debit numeric,
	Credit numeric
);

-- Import csv data into staging table for each year
COPY cap_one_staging (
	Transaction_Date,
	Posted_Date,
	Card_No,
	Description,
	Category,
	Debit,
	Credit
)
From 'Cap_One_22 FilePath'
DELIMITER ','
CSV HEADER;

COPY cap_one_staging (
	Transaction_Date,
	Posted_Date,
	Card_No,
	Description,
	Category,
	Debit,
	Credit
)
From 'Cap_One_23 FilePath'
DELIMITER ','
CSV HEADER;

COPY cap_one_staging (
	Transaction_Date,
	Posted_Date,
	Card_No,
	Description,
	Category,
	Debit,
	Credit
)
From 'cap_one_24 FilePath'
DELIMITER ','
CSV HEADER;

-- Inserting desired columns into capitol one table
INSERT INTO cap_one (
	date,
	amount,
	description,
	category)
SELECT 
	Transaction_Date,
	CASE
		WHEN Debit IS NOT NULL THEN debit
		WHEN Credit IS NOT NULL THEN -credit
	END AS amount,
	Description,
	Category
FROM cap_one_staging;

-- Drop staging table
DROP TABLE cap_one_staging;

-- adding account column to identify transactions from cap_one account
ALTER TABLE cap_one
ADD COLUMN account text;

UPDATE cap_one
SET account = 'capitol one';

-- Update cap_one db with new transactions
INSERT INTO cap_one(date, amount, description, category)
VALUES
	('2024-05-25', '32.29', 'KROGER #459 DECATUR GA 30033 US', 'Merchandise'),
	('2024-05-25', '2.89', 'COSTCO WHSE #1084 ATLANTA GA 30319 US', 'Merchandise'),
	('2024-05-25', '281.30', 'COSTCO WHSE #1084 ATLANTA GA 30319 US', 'Merchandise'),
	('2024-05-25', '356.63', 'INTEREST CHARGE:PURCHASES', 'Interest Charge'),
	('2024-05-27', '15.88', 'MICHAELS STORES 2017 CONYERS GA 30013 US', 'Merchandise'),
	('2024-05-27', '88.57', 'TJMAXX #0556 CONYERS GA 30013 US', 'Grocery'),
	('2024-05-28', '11.86', 'CHURCHS CHICKEN 4205 DECATUR GA 30035 US', 'Dining'),
	('2024-05-28', '13.99', 'Roku for Disney Electroni 816-2728107 DE 19808 US', 'Phone/Cable'),
	('2024-05-29', '7.60', 'LAZ PARKING ECOMMERCE 860-522-7641 CT 06103 US', 'Gas/Automotive'),
	('2024-05-30', '25.03', 'PUBLIX #752 LITHONIA GA 30038 US', 'Grocery'),
	('2024-05-31', '36.00', 'APPLE.COM/BILL', 'Internet'),
	('2024-05-31', '58.66', 'VCN*DEKALBWATERMISCBILL', 'Utilities');

SELECT * FROM cap_one ORDER BY date desc;