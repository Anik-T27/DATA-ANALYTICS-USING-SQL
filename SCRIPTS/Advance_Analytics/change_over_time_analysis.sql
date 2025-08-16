/* 1) CHANGE OVER TIME ANALYSIS- Analysing how a measure evolves over time

TASK 1- Analyse Sales performance over time
*/


-- Year Wise

SELECT
YEAR(order_date) AS year,
SUM(sales_amount) AS total_yearly_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

-- Month Wise

SELECT 
DATETRUNC(month,order_date) AS order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date)
