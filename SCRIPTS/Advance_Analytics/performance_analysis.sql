/* 3) PERFORMANCE ANALYSIS- Comparing the current value to a target value

Task 1- Analyse the yearly performance of products by comparing each product's
        sales to both its average sales performance and the previous year's sales.

*/

--USING CTE(Common Table Expression)
-- This calculates total sales of each product year wise
WITH yearly_product_sales AS(
SELECT
p.product_name,
SUM(f.sales_amount) AS total_sales,
YEAR(order_date) AS order_year
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key=p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(f.order_date),p.product_name
)

-- Final query
SELECT 
order_year,
product_name,
total_sales,
AVG(total_sales) OVER(PARTITION BY product_name) AS average_sales,-- Average sales of each product over all the years
total_sales - AVG(total_sales) OVER(PARTITION BY product_name) AS difference_average_total,-- Comparing total sales of each product year wise with their overall average sales
CASE WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name)>0  THEN 'Above Average'
	 WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name)<0  THEN 'Below Average'
	 ELSE 'Average'
END AS flag_average_difference,
LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS yoy_sales_difference,
CASE WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year)>0 THEN 'Increasing'
	 WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year)<0 THEN'Decreasing'
	 ELSE 'Neutral'
END AS flag_yoy_change
FROM yearly_product_sales
ORDER BY product_name,order_year

/* This gives an output where different windows are created based on partition by product_name 
   with total_sales year wise and average sales overall.
   Based on the difference between total_sales and average_sales, it is flagged as below average if negative,
   above average if positive and neutral if 0.
   Similarly for Year on Year sales difference, if the difference is negative then flagged as decreasing
   if positive then Increasing and if 0 then neutral.
*/
