/* 4) MEASURES EXPLORATION- Calculate the key metrics of business

Task-1 Find the total sales
Task-2 Find how many items are sold?
Task-3 Find the average selling price
Task-4 Find the total number of orders
Task-5 Find the total number of products
Task-6 Find the total number of customers
Task-7 Find the total number of customers that has placed an order
*/

-- Solution: Calculating all the key metrics individually and then combining the results into 1 single report using "UNION ALL".

--Task-1
SELECT 
'total_sales' AS measure_name, 
SUM(sales_amount) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Task-2
SELECT 
'total_items_sold' AS measure_name, 
SUM(quantity) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Task-3
SELECT
'average_sales_price' AS measure_name, 
AVG(price) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Task-4 
SELECT
'total_number_of_orders' AS measure_name, 
COUNT(DISTINCT(order_number)) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Task-5
SELECT
'total_number_of_products' AS measure_name, 
COUNT(DISTINCT(product_key)) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Task-6
SELECT
'total_number_of_customer' AS measure_name, 
COUNT(DISTINCT(customer_key)) AS measure_value
FROM gold.fact_sales

UNION ALL 

-- Task-7
SELECT
'total_number_of_customers_with_orders' AS measure_name, 
COUNT(DISTINCT(c.customer_key)) AS measure_value
FROM gold.fact_sales AS f
INNER JOIN gold.dim_customers as c
ON f.customer_key=c.customer_key
