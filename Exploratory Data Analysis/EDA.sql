/*
1) Database Exploration – This helps give us an overview of the database and see how many 
tables there are, what the names of columns/tables are. This helps provide the foundation 
of exploring the data.
========================================================================================
2) Dimensions Exploration – Identifying the unique values (or categories) in each 
dimension. Recognizing how data might be grouped or segmented, which is useful for 
later analysis. 
========================================================================================
3) Date Exploration – Identify the earliest and latest dates (boundaries).
Understand the scope of data and the timespan. 
========================================================================================
4) Measures Exploration – Calculate the key metric of the business (Big Numbers). 
The highest level of aggregation. Will use aggregate functions like the SUM, AVG, COUNT.
========================================================================================
5) Magnitude – Compare the measure values by categories. It helps us understand 
the importance of different categories. 
========================================================================================
6) Ranking Analysis: Order the values of dimensions by measure. 
Top N performers | Bottom N performers. 
*/

-- 1) Database Exploration:

-- Explore All Object in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore All Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
-- =====================================================================================

-- 2) Dimension Exploration:

-- Explore all countries our customers come from.
SELECT DISTINCT country FROM gold.dim_customers

-- Explore all categories "The Major Divsions"
SELECT DISTINCT 
	category, 
	subcategory, 
	product_name 
FROM gold.dim_products
ORDER BY 1,2,3
-- =====================================================================================

-- 3) Date Exploration:

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
-- =====================================================================================

-- 4) Measures Exploration: 

-- Find the total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_sales FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Find the total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales -- This is the correct format. We want to find how many orders from different customers. 

-- Find the total number of products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales

-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL 
SELECT 'Total Number of Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total Number of Customers', COUNT(DISTINCT customer_key) FROM gold.fact_sales
-- =====================================================================================

-- 5) Magnitude: 

-- Find total customers by countries
SELECT 
	country,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

-- Find total customers by gender
SELECT 
	gender,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

-- Find total products by category
SELECT 
	category,
	COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

-- What is the average costs in each category?
SELECT 
	category,
	AVG(cost) AS avg_costs
FROM gold.dim_products
GROUP BY category
ORDER BY avg_costs DESC

-- What is the total revenue generated for each category?
SELECT 
	p.category,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC

-- Find total revenue is generated by each customer
SELECT 
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_revenue DESC

-- What is the distribution of sold items across countries?
SELECT 
	country, 
	SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC
-- =====================================================================================

-- 6) Ranking Analysis:

-- Which 5 products generate the highest revenue?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

--OR (Window Function):

SELECT *
FROM (
	SELECT	
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p 
	ON p.product_key = f.product_key
	GROUP BY p.product_name
)t
WHERE rank_products <=5

-- Which 5 subcategories generate the highest revenue? -- Can change the Dimension around (subcategory in this case) 
SELECT TOP 5
	p.subcategory,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_revenue DESC

-- The 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_orders 

-- What are the 5 worst performing products in terms of sales? 
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue 
