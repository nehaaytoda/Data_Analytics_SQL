/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), LIMIT
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


-- Which 5 products genrate the highest revenue?

SELECT *
FROM (
SELECT
p.product_name,
SUM(f.sales_amount) AS total_revenue,
RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p 
ON p.product_key  = f.product_key 
GROUP BY p.product_name)t  
WHERE t.rank_products <= 5


-- What are the 5 worst-performaing products in terms of sales?

SELECT
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p 
ON p.product_key  = f.product_key 
GROUP BY p.product_name 
ORDER BY total_revenue
LIMIT 5;

-- What are the best Subcategory that genrate the higiest revenue?

SELECT
p.subcategory,
SUM(f.sales_amount) AS total_revenue,
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p 
ON p.product_key  = f.product_key 
GROUP BY p.subcategory 
ORDER BY total_revenue DESC
LIMIT 5;

-- FInd the Top 10 customers who have genrated the highest revenue 

SELECT *
FROM (
SELECT
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue,
RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_customers
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c 
ON c.customer_key  = f.customer_key 
GROUP BY c.customer_key,
c.first_name,
c.last_name)t  
WHERE rank_customers <= 10;

-- 3 customers with the fewest order placed

SELECT
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT f.order_number ) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c 
ON c.customer_key  = f.customer_key 
GROUP BY c.customer_key,
c.first_name,
c.last_name
ORDER BY total_orders
LIMIT 3;