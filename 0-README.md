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

# Database Structure
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

I also added a column for each account containing the name of the account the transaction was from. This will be useful later when importing the data into Power BI. <br>

Standardizing the categories has been an issue. All of the accounts use different naming conventions and some are not helpful or clear. I added another column called "standardized_category" which utilized a CASE statement to provide standardized categories that I found necessary when beginning to visualize the data from May of 2024. A null value populated the standardized category column if no appropriate match was found. <br>
I ran a SQL query to find the number of distinct categories across all of the accounts and found there are 126 distinct categories. I think that it would be more efficient to write DAX queries in Power BI to standardize the categories on a month to month basis as I do my visualizations, as this data goes back years and some may not even be neccessary to categorize. (This CASE statement was actually based off of a DAX statement I wrote when looking at when visualizing spending data from May)

[SQL CODE Create amex db]
[SQL CODE Create cap_one db](There were a few additional transactions for the month of May when I downloaded this data. Instead of downloading a new csv, I just manually imported them to the table)
[SQL CODE Create citibank db]

These required no staging table.
[SQL CODE Create delta db]
[SQL CODE Create wf databases]
[SQL CODE Create boa db]