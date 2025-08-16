/* 2) DIMENSION EXPLORATION(To identify the unique values in each dimension)
	
TASK 1- Explore all countries our customers come from
TASK 2- Explore all the product categories inside our business
*/

--TASK 1
SELECT DISTINCT country
FROM gold.dim_customers;

--TASK 2
SELECT DISTINCT category,
subcategory,
product_name
FROM gold.dim_products
ORDER BY 1,2,3;
