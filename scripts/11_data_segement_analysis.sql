/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/


-- Segement products into cost range and count how many products fall into each sagement 
 
WITH product_segement AS (
SELECT 
product_key,
product_name,
product_cost,
CASE
	WHEN product_cost < 100  THEN 'Below 100'
	WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN product_cost  BETWEEN 500 AND 1000 THEN '500-1000'
	ELSE 'Above 1000'
END cost_range
FROM gold.dim_product)
SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM product_segement 
GROUP BY cost_range 
ORDER BY total_products DESC;

/*  Group customers into three Segements based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than 5000.
	- Regular: Customers with at least 12 months of history but spending 5000 or less.
	- New: Customer with a lifespane less than 12 months.
and find the total number of customer by each group.
*/

WITH customer_spending AS (
SELECT
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN(f.order_date ) AS first_order,
MAX(f.order_date) AS last_order,
DATEDIFF_MONTH(MIN(f.order_date ),MAX(f.order_date)) AS lifespane
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
ON c.customer_key = f.customer_key 
GROUP BY c.customer_key
)
SELECT 
customers_segment,
COUNT(customer_key) AS total_customer
FROM (
	SELECT
	customer_key ,
	CASE 
		WHEN lifespane >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespane >= 12 AND total_spending  <= 5000 THEN 'Regular'
		ELSE 'New'
	END customers_segment
	FROM customer_spending 
	) t 
GROUP BY customers_segment
ORDER BY total_customer DESC;
