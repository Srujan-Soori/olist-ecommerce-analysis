-- Order status analysis
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-- Order date validation
SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order,
    COUNT(*) AS total_orders,
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_dates
FROM olist_orders_dataset;

-- Check for duplicate orders
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_rows
FROM olist_orders_dataset;

-- Check customer data quality
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    SUM(customer_id IS NULL) AS missing_customer_ids,
    SUM(customer_unique_id IS NULL) AS missing_unique_ids
FROM olist_customers_dataset;

-- Validate the Products table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products,
    SUM(product_id IS NULL) AS missing_product_ids,
    SUM(product_category_name IS NULL) AS missing_categories
FROM olist_products_dataset;

-- Check whether category translation can fill the gaps
SELECT
    COUNT(*) AS missing_category_products,
    SUM(t.product_category_name IS NOT NULL) AS category_found_in_translation
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NULL;

-- Validate the sellers table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_seller_ids,
    SUM(seller_id IS NULL) AS missing_seller_ids,
    SUM(seller_city IS NULL) AS missing_seller_cities,
    SUM(seller_state IS NULL) AS missing_seller_states
FROM olist_sellers_dataset;

-- Validate the Order Items table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(order_id IS NULL) AS missing_order_ids,
    SUM(product_id IS NULL) AS missing_product_ids,
    SUM(seller_id IS NULL) AS missing_seller_ids,
    SUM(price IS NULL) AS missing_prices,
    SUM(freight_value IS NULL) AS missing_freight
FROM olist_order_items_dataset;

-- Validate Order Payments
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(order_id IS NULL) AS missing_order_ids,
    SUM(payment_type IS NULL) AS missing_payment_types,
    SUM(payment_value IS NULL) AS missing_payment_values,
    SUM(payment_value < 0) AS negative_payment_values
FROM olist_order_payments_dataset;

-- Validate the Product Category Translation table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_category_name) AS unique_category_names,
    SUM(product_category_name IS NULL) AS missing_category_names,
    SUM(product_category_name_english IS NULL) AS missing_english_names
FROM product_category_name_translation;
-- Check the relationships between tables 
SELECT COUNT(*) AS unmatched_orders
FROM olist_order_items_dataset oi
LEFT JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Verify products id
SELECT COUNT(*) AS unmatched_products
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Verify seller IDs
SELECT COUNT(*) AS unmatched_sellers
FROM olist_order_items_dataset oi
LEFT JOIN olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- Verify the customer-to-order relationship
SELECT COUNT(*) AS unmatched_customers
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Verify payment-to-order relationships
SELECT COUNT(*) AS unmatched_payment_orders
FROM olist_order_payments_dataset p
LEFT JOIN olist_orders_dataset o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;