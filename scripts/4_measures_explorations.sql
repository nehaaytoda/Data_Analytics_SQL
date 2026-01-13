/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/


-- Find the total Sales

SELECT SUM(sales_amount) AS total_sales 
FROM gold.fact_sales;

-- Find how many items are sold

SELECT SUM(quantity) AS total_item_sold 
FROM gold.fact_sales;

-- Find the averge selling price

SELECT AVG(price) AS avg_selling_price
FROM gold.fact_sales;

-- Find the Total number of orders

SELECT COUNT(order_number) AS total_orders
FROM gold.fact_sales;

SELECT COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- find total number of products

SELECT COUNT(product_key) AS total_product
FROM gold.dim_product;

SELECT COUNT(DISTINCT product_key) AS total_product
FROM gold.dim_product;

-- Find the Total number of customers

SELECT COUNT(customer_key) AS total_customer
FROM gold.dim_customer;

SELECT COUNT(DISTINCT customer_key) AS total_customer
FROM gold.dim_customer;

-- Find the total number of customers that place an order

SELECT COUNT(DISTINCT customer_key) AS total_customer
FROM gold.fact_sales;


-- Generate a report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Item Sold' AS measure_name, SUM(quantity) AS measure_value  FROM gold.fact_sales
UNION ALL
SELECT 'Average Selling Price' AS measure_name, AVG(price) AS measure_value  FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value  FROM gold.fact_sales
UNION ALL
SELECT 'Total Products' AS measure_name, COUNT(DISTINCT product_key) AS measure_value  FROM gold.dim_product
UNION ALL
SELECT 'Total Customers' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value  FROM gold.dim_customer
UNION ALL
SELECT 'Total Customers that place an order' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value  FROM gold.fact_sales