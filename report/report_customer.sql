/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

/*
===============================================================================
1. Base Query: Retrives core columns from tables
===============================================================================
*/
DROP VIEW IF EXISTS gold.report_customer;
CREATE  VIEW gold.report_customer AS 
WITH base_query AS (
SELECT 
f.order_number, 
f.order_date,
f.product_key,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
DATEDIFF_YEAR(c.birthdate, CURDATE()) AS age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
ON c.customer_key = f.customer_key 
WHERE f.order_date IS NOT NULL )
, customer_aggregation AS (
/*
-------------------------------------------------------------------------------
2. Customer segmention: Summarizes key metrics at the customer level
-------------------------------------------------------------------------------
*/
SELECT 
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) AS total_order,
SUM(sales_amount) AS total_sale,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS total_product,
MAX(order_date) AS last_order,
DATEDIFF_MONTH(MIN(order_date),MAX(order_date)) AS lifespane 
FROM base_query 
GROUP BY 
customer_key,
customer_number,
customer_name,
age
) 
/*---------------------------------------------------------------------------
  3) Final Query: Combines all customer results into one output
---------------------------------------------------------------------------*/
SELECT 
customer_key,
customer_number,
customer_name,
age,
CASE
	WHEN age < 20 THEN 'Under 20'
	WHEN age BETWEEN 20 AND 29 THEN '20-29'
	WHEN age BETWEEN 30 AND 39 THEN '30-39'
	WHEN age BETWEEN 40 AND 49 THEN '40-49'
	ELSE '50+'
END age_group,
CASE 
	WHEN lifespane >= 12 AND total_sale  > 5000 THEN 'VIP'
	WHEN lifespane >= 12 AND total_sale  <= 5000 THEN 'Regular'
	ELSE 'New'
END customers_segment,
last_order,
DATEDIFF_MONTH(last_order,CURDATE()) AS recency,
total_order,
total_sale,
total_quantity,
total_product,
lifespane,
-- compute average order value
CASE 
	WHEN total_order = 0 THEN 0
	ELSE ROUND(total_sale / total_order, 1) 
END avg_order_value, 
-- compute average monthy spand
CASE 
	WHEN lifespane = 0 THEN total_sale
	ELSE ROUND(total_sale / lifespane, 1) 
END avg_montly_spand
FROM customer_aggregation ;
