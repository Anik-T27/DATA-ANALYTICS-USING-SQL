/* 4) PART TO WHOLE ANALYSIS(Proportional Analysis)- Analyse how an individual part is 
      performing compared to the overall

Task 1- Which Category contribute the most to overall Sales?
*/

-- USING CTE
WITH category_sales AS(
SELECT
p.category,
SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key=p.product_key
GROUP BY p.category)

-- Final query
SELECT
category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(
    ROUND(
        (CAST(total_sales AS float) / SUM(total_sales) OVER()) * 100, 
        2), '%') AS percentage_sales -- Float/ INT--> gives decimal,then we rounded it till 2 decimals place and then concat '%' sign

FROM category_sales
ORDER BY total_sales DESC
