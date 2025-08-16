/* 5) DATA SEGMENTATION - Group the data based on a specific range

Task 1- Segment products into cost ranges and count how many products
        fall into each segment

Task 2- Group customers into 3 segments based on their spending behaviour:
		- VIP: atleast 12 months of history and spending more than $5000
		- Regular: atleast 12 months of history but spending $5000 or less
		- New: lifespan less than 12 months

		and then find the total number of customers by each group
*/

-- Task 1
-- Using Sub-Query
SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM(
	 SELECT 
		product_key,
		cost,
		CASE WHEN cost<100 THEN 'Below 100'
			 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			 WHEN cost BETWEEN 501 AND 1000 THEN '501-1000'
			 ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products) AS t
GROUP BY cost_range
ORDER BY  total_products

-- Task 2
-- Using CTE
WITH customer_segmentation AS(
SELECT 
c.customer_key,
DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan,
SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key= c.customer_key
WHERE f.order_date IS NOT NULL
GROUP BY c.customer_key
)

-- Final query
SELECT 
customer_key,
lifespan,
total_sales,
CASE WHEN lifespan>12 AND total_sales>5000 THEN 'VIP'
	 WHEN lifespan>12 AND total_sales<= 5000 THEN 'Regular'
	 ELSE 'New'
END AS customer_segment
FROM customer_segmentation
ORDER BY lifespan DESC
