/* 2) CUMULATIVE ANALYSIS- Aggregating the data progressively over time

Task 1- Calculate the total sales per month and the running total of sales over time
Task 2- Also find the moving average
*/


--Task 1
-- Month Wise
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales --default frame(unbounded preceding and current row)
FROM(
	SELECT 
		DATETRUNC(month,order_date) AS order_date,
		SUM(sales_amount) AS total_sales
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY DATETRUNC(month, order_date)
	) AS t

-- YEAR wise

SELECT 
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales --default frame(unbounded preceding and current row)
FROM(
	SELECT 
		YEAR(order_date) AS order_date,
		SUM(sales_amount) AS total_sales
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY YEAR(order_date)
	) AS t

-- Task 2
-- MOVING AVERAGE

SELECT 
order_date,
average_price,
CAST(AVG(average_price) OVER (ORDER BY order_date) AS float) AS moving_average --default frame(unbounded preceding and current row)
FROM(
	SELECT 
		DATETRUNC(month,order_date) AS order_date,
		CAST(AVG(price) AS float) AS average_price
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY DATETRUNC(month, order_date)
	) AS t
