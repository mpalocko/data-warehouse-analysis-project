/*
- Change-Over-Time Trends: Analyze how a measure evolves over time. Helps track trends and identify seasonality in your data. 
- Tasks: Showcase the different ways of identifying changes over time using differnt date functions. 
*/
SELECT 
	YEAR(order_date) AS order_year,             -- Data type will be INT
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

SELECT 
	DATETRUNC(month, order_date) AS order_date, -- Can use DATETRUNC instead so the month and year are all in one column. Data type will be DATE
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)

SELECT 
	FORMAT(order_date, 'yyyy-MMM') AS order_date, -- Can use FORMAT instead so you get whatever specific format you'd like. Data type will be a STRING, so be careful
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')

-- How many new customers were added each year?
SELECT 
	DATETRUNC(year, order_date) AS create_year,
	COUNT(customer_key) AS total_customer
FROM gold.fact_sales
GROUP BY DATETRUNC(year, order_date)
ORDER BY DATETRUNC(year, order_date)
