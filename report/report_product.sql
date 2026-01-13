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
/*
===============================================================================
1. Base Query: Retrives core columns from tables
===============================================================================
*/
DROP VIEW IF EXISTS gold.report_product;
CREATE  VIEW gold.report_product AS 
WITH base_quary AS (
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
p.product_cost 
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key 
WHERE f.order_date IS NOT NULL )
, product_aggregation AS (
/*
===============================================================================
2. Product segmention: Summarizes key metrics at the product level
===============================================================================
*/
SELECT 
product_key,
product_name,
category,
subcategory,
product_cost,
COUNT(DISTINCT order_number) AS total_order,
SUM(sales_amount) AS total_revenue,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customer,
MAX(order_date) AS last_sale_order,
DATEDIFF_MONTH(MIN(order_date),MAX(order_date)) AS lifespane,
ROUND(AVG(sales_amount / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_quary

GROUP BY 
product_key,
product_name,
category,
subcategory,
product_cost

)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
product_key,
product_name,
category,
subcategory,
product_cost,
last_sale_order,
DATEDIFF_MONTH(last_sale_order,CURDATE()) AS recency_in_months,
CASE 
	WHEN total_revenue > 50000 THEN  'High-Performers'
	WHEN total_revenue >= 10000  THEN 'Mid-Range'
	ELSE 'Low-Performers'
END product_segment,
lifespane,
total_order,
total_revenue,
total_quantity,
total_customer,
avg_selling_price,

-- compute average order revenue
CASE 
	WHEN total_order = 0 THEN 0
	ELSE ROUND(total_revenue / total_order, 1) 
END avg_order_revenue , 

-- compute average monthy evenue
CASE 
	WHEN lifespane = 0 THEN total_revenue
	ELSE ROUND(total_revenue / lifespane, 1) 
END avg_montly_revenue 

FROM product_aggregation ;
