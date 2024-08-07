# Credit Card Transaction Analysis

# Project Overview
This project analyzes credit card transactions from multiple accounts to gain insights into spending patterns. The data is cleaned, standardized, and analyzed using PostgreSQL and visualized using Power BI.

# Data Sources
The data for this project comes from multiple CSV files containing transaction records from different credit card accounts and different years and transaction periods. <br>

* American Express
* Bank Of America
* Capitol One
* Citibank
* Delta
* Wells Fargo (Credit and Debit)

# Database Creation
The database consists of the following columns and data types across all accounts: <br>
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
Category text <br>

Many of these columns are redundant or unnecessary for this project, so I created a temporary staging table to import the data from the CSV, pulled the desired columns into the database, and then dropped the staging table. I imported the following columns from the staging table: <br>
Date,
Amount,
Description,
Category <br>

I also added a column for each account containing the name of the account the transaction was from. <br>

[SQL CODE Create amex db](https://github.com/aklesitz/financial_db_creation/blob/main/create_amex_db.sql) <br>
[SQL CODE Create cap_one db](https://github.com/aklesitz/financial_db_creation/blob/main/create_cap_one_db.sql) <br>
(There were a few additional transactions for the month of May when I downloaded this data. Instead of downloading a new csv, I just manually imported them to the table) <br>
[SQL CODE Create citibank db](https://github.com/aklesitz/financial_db_creation/blob/main/create_citibank_db.sql) <br>

These needed some editing using power query and required no staging table for SQL population. <br>
[SQL CODE Create delta db](https://github.com/aklesitz/financial_db_creation/blob/main/create_delta_db.sql) <br>
[SQL CODE Create wf databases](https://github.com/aklesitz/financial_db_creation/blob/main/create_wf_dbs.sql) <br>
[SQL CODE Create boa db](https://github.com/aklesitz/financial_db_creation/blob/main/create_boa_db.sql) <br>

# Normalization
In order to improve query efficiency, data integrity, and reduce redundancy, I created 3 seperate tables to normalize this database. <br>
1. Accounts
* account_id PRIMARY KEY
* account_name
2. Categories
* category_id PRIMARY KEY
* orig_category
* stand_category
3. Transactions
* transaction_id PRIMARY KEY
* account_id FOREIGN KEY
* transaction_date
* amount
* description
* category_id FOREIGN KEY

# Next Steps
1. Standardize categories table
2. Set up automated scripts for data import
3. Visualize data and create dashboard