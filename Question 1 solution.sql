-- Business scenario
-- An e-commerce company wants to identify sellers who generate high revenue but have relatively low order volumes.
-- Your manager asks you to analyze seller performance for 2018 using the Olist database.
-- Your task
-- Write a SQL query that returns, for each seller:
-- 1. seller_id
-- 2. Total product revenue generated in 2018
-- 3. Number of distinct orders containing that seller's products
-- 4. Average product price per order item
-- 5. Rank of the seller by total revenue, from highest to lowest
-- Conditions:
-- - Consider only orders with status 'delivered'.
-- - Use the order purchase timestamp to determine whether an order belongs to 2018.
-- - Exclude sellers with zero revenue in the period.
-- - Sort the final result by revenue from highest to lowest.

SELECT oi.seller_id, SUM(oi.price) AS total_revenue, COUNT(DISTINCT(o.order_id)) AS no_of_unique_orders, 
AVG(oi.price) AS avg_price, RANK() OVER (ORDER BY SUM(oi.price) DESC) AS rank_seller
FROM olist_order_items_dataset oi
INNER JOIN olist_orders_dataset o
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered' AND YEAR(o.order_purchase_timestamp) = 2018
GROUP BY oi.seller_id 
HAVING SUM(oi.price) > 0 
ORDER BY total_revenue DESC;