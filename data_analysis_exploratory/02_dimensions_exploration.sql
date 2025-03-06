/* 
Dimensions Exploration – Identifying the unique values (or categories) in each 
dimension. Recognizing how data might be grouped or segmented, which is useful for 
later analysis. 
*/

-- Explore all countries our customers come from.
SELECT DISTINCT country FROM gold.dim_customers

-- Explore all categories "The Major Divsions"
SELECT DISTINCT 
	category, 
	subcategory, 
	product_name 
FROM gold.dim_products
ORDER BY 1,2,3
