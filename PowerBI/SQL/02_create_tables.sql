/*
=========================================================
Retail Sales, Customer & Marketing Analytics Platform

Data Validation & Data Cleaning

Author :Nitish kumar

Purpose:
Validate imported data before performing business analysis.

Checks Included:

1. Row Count Validation
2. Duplicate Primary Keys
3. NULL Analysis
4. Invalid Values
5. Referential Integrity
6. Business Rule Validation

=========================================================
*/

USE retail_sales_analytics;
/*=========================================================
1. DUPLICATE PRIMARY KEY VALIDATION
=========================================================*/

-- Customer
SELECT customer_id, COUNT(*) AS duplicate_count
FROM customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Product
SELECT product_id, COUNT(*) AS duplicate_count
FROM product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Customer Session
SELECT session_id, COUNT(*) AS duplicate_count
FROM customer_session
GROUP BY session_id
HAVING COUNT(*) > 1;

-- Orders
SELECT order_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Order Items
SELECT order_item_id, COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1;

-- Events
SELECT event_id, COUNT(*) AS duplicate_count
FROM events
GROUP BY event_id
HAVING COUNT(*) > 1;

-- Reviews
SELECT review_id, COUNT(*) AS duplicate_count
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;
/*=========================================================
2. NULL VALUE ANALYSIS
Purpose:
Identify missing values that may affect reporting,
analysis and dashboard calculations.
=========================================================*/

-- Customer
SELECT
    SUM(customer_name IS NULL) AS missing_customer_name,
    SUM(email IS NULL) AS missing_email,
    SUM(country IS NULL) AS missing_country,
    SUM(age IS NULL) AS missing_age,
    SUM(signup_date IS NULL) AS missing_signup_date,
    SUM(marketing_opt_in IS NULL) AS missing_marketing_opt_in
FROM customer;

-- Product
SELECT
    SUM(category IS NULL) AS missing_category,
    SUM(product_name IS NULL) AS missing_product_name,
    SUM(price_usd IS NULL) AS missing_price,
    SUM(cost_usd IS NULL) AS missing_cost,
    SUM(margin_usd IS NULL) AS missing_margin
FROM product;

-- Customer Session
SELECT
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(start_time IS NULL) AS missing_start_time,
    SUM(device IS NULL) AS missing_device,
    SUM(traffic_source IS NULL) AS missing_traffic_source,
    SUM(country IS NULL) AS missing_country
FROM customer_session;

-- Orders
SELECT
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_time IS NULL) AS missing_order_time,
    SUM(payment_method IS NULL) AS missing_payment_method,
    SUM(discount_pct IS NULL) AS missing_discount_pct,
    SUM(subtotal_usd IS NULL) AS missing_subtotal,
    SUM(total_usd IS NULL) AS missing_total,
    SUM(device IS NULL) AS missing_device,
    SUM(traffic_source IS NULL) AS missing_traffic_source,
    SUM(country IS NULL) AS missing_country
FROM orders;

-- Order Items
SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(unit_price_usd IS NULL) AS missing_unit_price,
    SUM(line_total_usd IS NULL) AS missing_line_total
FROM order_items;

-- Events
SELECT
    SUM(session_id IS NULL) AS missing_session_id,
    SUM(event_timestamp IS NULL) AS missing_event_timestamp,
    SUM(event_type IS NULL) AS missing_event_type,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(cart_size IS NULL) AS missing_cart_size,
    SUM(payment IS NULL) AS missing_payment,
    SUM(discount_amount IS NULL) AS missing_discount_amount,
    SUM(amount_usd IS NULL) AS missing_amount
FROM events;

-- Reviews
SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(rating IS NULL) AS missing_rating,
    SUM(review_time IS NULL) AS missing_review_time,
    SUM(review_text IS NULL) AS missing_review_text
FROM reviews;

/*=========================================================
3. INVALID BUSINESS VALUE ANALYSIS
Purpose:
Identify values that violate business rules.
=========================================================*/

-- Customer: Invalid Age
SELECT *
FROM customer
WHERE age < 0
   OR age > 120;

-- Product: Negative Price / Cost / Margin
SELECT *
FROM product
WHERE price_usd < 0
   OR cost_usd < 0
   OR margin_usd < 0;

-- Orders: Invalid Discount or Amounts
SELECT *
FROM orders
WHERE discount_pct < 0
   OR discount_pct > 100
   OR subtotal_usd < 0
   OR total_usd < 0;

-- Order Items: Invalid Quantity or Price
SELECT *
FROM order_items
WHERE quantity <= 0
   OR unit_price_usd <= 0
   OR line_total_usd <= 0;

-- Reviews: Rating must be between 1 and 5
SELECT *
FROM reviews
WHERE rating NOT BETWEEN 1 AND 5;


/*=========================================================
4. REFERENTIAL INTEGRITY VALIDATION
Purpose:
Ensure relationships between tables are valid.
=========================================================*/

-- Orders without a Customer
SELECT o.order_id
FROM orders o
LEFT JOIN customer c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Order Items without an Order
SELECT oi.order_item_id
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Order Items without a Product
SELECT oi.order_item_id
FROM order_items oi
LEFT JOIN product p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Customer Sessions without a Customer
SELECT cs.session_id
FROM customer_session cs
LEFT JOIN customer c
ON cs.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Events without a Session
SELECT e.event_id
FROM events e
LEFT JOIN customer_session cs
ON e.session_id = cs.session_id
WHERE cs.session_id IS NULL;

-- Reviews without an Order
SELECT r.review_id
FROM reviews r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Reviews without a Product
SELECT r.review_id
FROM reviews r
LEFT JOIN product p
ON r.product_id = p.product_id
WHERE p.product_id IS NULL;