/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Find total customer by countries

SELECT country , 
COUNT(customer_key) AS total_customer
FROM gold.dim_customer
GROUP BY country 
ORDER BY total_customer DESC;

-- Find total customers by genders

SELECT gender, 
COUNT(customer_key) AS total_customer
FROM gold.dim_customer
GROUP BY gender
ORDER BY total_customer DESC; 

-- Find total product by category
SELECT category, 
COUNT(product_key) AS total_product
FROM gold.dim_product
GROUP BY category
ORDER BY total_product DESC; 

-- What is the average costs in each category?
SELECT category,
AVG(product_cost) AS avg_cost
FROM gold.dim_product
GROUP BY category
ORDER BY avg_cost DESC; 

-- What is the total revenue genrated for each category?

SELECT 
p.category,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p 
ON p.product_key  = f.product_key 
GROUP BY p.category 
ORDER BY total_revenue DESC;



-- Find total revenue is genrated by each customer
SELECT 
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c 
ON c.customer_key  = f.customer_key 
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC;

-- What is the distribution of sold items across countries?

SELECT 
c.country,
SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c 
ON c.customer_key  = f.customer_key 
GROUP BY c.country
ORDER BY total_sold_items DESC;
