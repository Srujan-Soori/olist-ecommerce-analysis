-- Business scenario
-- An e-commerce company wants to identify customers who have placed multiple orders. The marketing team wants to target these customers with a loyalty program.
-- Write a SQL query to return customers who have placed more than one delivered order.
-- Your output should contain:
-- Column	                      Meaning
-- customer_unique_id	          Unique customer identity
-- total_orders	                  Number of distinct delivered orders placed by that customer

-- Requirements
-- 1. Consider only orders where order_status = 'delivered'.
-- 2. Count orders per customer_unique_id, not per customer_id.
-- 3. Show only customers with more than one delivered order.
-- 4. Sort by total_orders from highest to lowest.

SELECT c.customer_unique_id , COUNT(DISTINCT(o.order_id)) AS total_orders
FROM olist_customers_dataset c
INNER JOIN  olist_orders_dataset o
ON o.customer_id = c.customer_id
WHERE order_status = 'delivered' 
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT(o.order_id)) > 2
ORDER BY total_orders DESC;