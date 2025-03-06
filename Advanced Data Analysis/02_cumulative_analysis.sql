-- 2) Cumulative Analysis
-- Calculate the total sales per month
-- and the running total of sales over time
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales, -- Adding each rows value to the sum of all previous rows values partitioned by order_date. 
	AVG(avg_price) OVER (PARTITION BY order_date ORDER BY order_date) AS moving_average_price -- Finds the moving average.
FROM (
  SELECT 
  	DATETRUNC(month, order_date) AS order_date,
  	SUM(sales_amount) AS total_sales,
  	AVG(price) AS avg_price
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(month, order_date)
)t
