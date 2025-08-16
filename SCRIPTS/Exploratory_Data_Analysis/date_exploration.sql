/* 3) DATE EXPLORATION- Explore the boundaries of date that we have in our datasets
	  
Task 1- Find the date of the first and the last order
Task 2- Find the youngest and oldest customer
*/

--Task 1
SELECT 
MAX(order_date) AS last_order_date,
MIN(order_date) AS first_order_date,
DATEDIFF(YEAR,MIN(order_date),MAX(order_date)) AS order_range_in_years
FROM gold.fact_sales;

-- Task 2
SELECT 
MIN(birthdate) AS oldest_customer,
DATEDIFF(YEAR,MIN(birthdate),GETDATE()) AS age_of_oldest_customer,
MAX(birthdate) AS youngest_customer,
DATEDIFF(YEAR,MAX(birthdate),GETDATE()) AS age_of_youngest_customer
FROM gold.dim_customers;
