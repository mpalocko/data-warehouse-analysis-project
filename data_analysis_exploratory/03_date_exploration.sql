/*
Date Exploration – Identify the earliest and latest dates (boundaries).
Understand the scope of data and the timespan. 
*/

-- Find the date of the first and last order
-- & How many years of sales are available:
SELECT 
	MIN(order_date) first_order_date, 
	MIN(order_date) last_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) order_range_years
FROM gold.fact_sales

-- Find the youngest and the oldest customer:
SELECT
	MIN(birthdate) AS oldest_birthdate,
	DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
	MAX(birthdate) AS youngest_birthdate,
	DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers
