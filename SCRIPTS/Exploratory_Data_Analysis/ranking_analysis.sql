/* 6) RANKING ANALYSIS- Order the values of dimension by measure in order to identify Top & Bottom Performers

Task 1- Which 5 products generate the highest revenue?
Task 2- Which are the 5 worst performing products in terms of sales?
Task 3- Find the top10 customers who have generated the highest revenue and 3 customers with the fewest orders placed
*/

-- Task 1
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key=p.product_key
GROUP BY p.product_name
ORDER BY SUM(f.sales_amount) DESC;


-- Task 2
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key=p.product_key
GROUP BY p.product_name
ORDER BY SUM(f.sales_amount);

-- Task 3 Part 1
SELECT
customer_key,
first_name,
last_name,
total_revenue,
ranking
FROM
	(SELECT 
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS ranking
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON f.customer_key=c.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name ) AS t
WHERE ranking<=10

-- Task 3 Part 2
SELECT
customer_key,
first_name,
last_name,
total_orders_placed,
ranking
FROM
	(SELECT 
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(order_number) AS total_orders_placed,
	ROW_NUMBER() OVER(ORDER BY COUNT(order_number) ) AS ranking
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON f.customer_key=c.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name ) AS t
WHERE ranking<=3
