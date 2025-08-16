/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
  
-- ================================================
-- CTE 1---> Retrieves core columns from the tables
-- ================================================
  
WITH base_query AS (
    SELECT 
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM  gold.fact_sales AS f 
    LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
    WHERE (f.order_date IS NOT NULL)
    ),
  
-- =================================================
-- CTE 2---> Summarizes key metrics at product level
-- =================================================
  
   products_aggregation AS(
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(order_number) AS total_orders,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customers,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
        SUM(sales_amount) AS total_sales,
        MAX(order_date) AS last_order_date
    FROM    base_query
    GROUP BY product_key, product_name, category, subcategory, cost
    )

--  =========================================================
--  Final Query: Combines all product results into one output
--  =========================================================
  
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_order_date,
    total_sales,
    total_orders,
    lifespan,
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,
    CASE WHEN total_orders = 0 THEN 0
         ELSE (total_sales / total_orders) 
    END AS average_order_revenue, 
    CASE WHEN lifespan = 0 THEN total_sales
         ELSE (total_sales / lifespan) 
    END AS average_monthly_revenue
FROM    products_aggregation
