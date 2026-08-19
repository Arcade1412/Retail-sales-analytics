/*
=========================================================
Retail Sales Analytics
Reporting Views

Purpose:
Create reusable SQL views for sales, product,
customer, and marketing reporting.
=========================================================
*/

USE retail_sales_analytics;


/* =======================================================
1. SALES SUMMARY VIEW
One row per order with the main reporting dimensions.
======================================================= */

CREATE OR REPLACE VIEW vw_sales_summary AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_time,
    o.total_usd,
    o.discount_pct,
    o.payment_method,
    o.traffic_source,
    o.device,
    o.country
FROM orders o;


/* =======================================================
2. PRODUCT SALES VIEW
Combines order items with product information.
Useful for product and category reporting.
======================================================= */

CREATE OR REPLACE VIEW vw_product_sales AS
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price_usd,
    oi.line_total_usd,
    p.cost_usd,
    ROUND(
        oi.quantity * (oi.unit_price_usd - p.cost_usd),
        2
    ) AS gross_profit
FROM order_items oi
INNER JOIN product p
    ON oi.product_id = p.product_id;


/* =======================================================
3. CUSTOMER ORDERS VIEW
Combines customer information with order performance.
======================================================= */

CREATE OR REPLACE VIEW vw_customer_orders AS
SELECT
    c.customer_id,
    c.country,
    c.age,
 
    c.marketing_opt_in,
    o.order_id,
    o.order_time,
    o.total_usd,
    o.discount_pct,
    o.payment_method,
    o.traffic_source,
    o.device
FROM customer c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;


/* =======================================================
4. MARKETING PERFORMANCE VIEW
Combines traffic-source sessions with order performance.
======================================================= */

CREATE OR REPLACE VIEW vw_marketing_performance AS

WITH session_metrics AS (
    SELECT
        traffic_source,
        COUNT(session_id) AS total_sessions,
        COUNT(DISTINCT customer_id) AS session_customers
    FROM customer_session
    GROUP BY traffic_source
),

order_metrics AS (
    SELECT
        traffic_source,
        COUNT(order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS ordering_customers,
        SUM(total_usd) AS total_revenue,
        AVG(total_usd) AS average_order_value
    FROM orders
    GROUP BY traffic_source
)

SELECT
    s.traffic_source,
    s.total_sessions,
    s.session_customers,
    COALESCE(o.total_orders, 0) AS total_orders,
    COALESCE(o.ordering_customers, 0) AS ordering_customers,
    ROUND(COALESCE(o.total_revenue, 0), 2) AS total_revenue,
    ROUND(COALESCE(o.average_order_value, 0), 2)
        AS average_order_value,
    ROUND(
        COALESCE(o.total_revenue, 0)
        / NULLIF(s.total_sessions, 0),
        2
    ) AS revenue_per_session
FROM session_metrics s
LEFT JOIN order_metrics o
    ON s.traffic_source = o.traffic_source;


/* =======================================================
5. CUSTOMER VALUE VIEW
One row per customer with useful customer-level KPIs.
======================================================= */

CREATE OR REPLACE VIEW vw_customer_value AS
SELECT
    c.customer_id,
    c.country,
    c.age,
    
    c.marketing_opt_in,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_usd), 2) AS total_revenue,
    ROUND(AVG(o.total_usd), 2) AS average_order_value,
    CASE
        WHEN SUM(o.total_usd) >= 1000 THEN 'High Value'
        WHEN SUM(o.total_usd) >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.country,
    c.age,
    c.marketing_opt_in;


/* =======================================================
6. CATEGORY PERFORMANCE VIEW
Reusable category-level sales and profitability view.
======================================================= */

CREATE OR REPLACE VIEW vw_category_performance AS
SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * oi.unit_price_usd),
        2
    ) AS total_revenue,
    ROUND(
        SUM(
            oi.quantity *
            (oi.unit_price_usd - p.cost_usd)
        ),
        2
    ) AS gross_profit,
    ROUND(
        SUM(
            oi.quantity *
            (oi.unit_price_usd - p.cost_usd)
        ) * 100.0
        / NULLIF(
            SUM(oi.quantity * oi.unit_price_usd),
            0
        ),
        2
    ) AS profit_margin_pct
FROM product p
INNER JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category;


/* =======================================================
7. VIEW CHECK
Review all views created in the database.
======================================================= */

SELECT
    TABLE_NAME
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'retail_sales_analytics'
ORDER BY TABLE_NAME;
