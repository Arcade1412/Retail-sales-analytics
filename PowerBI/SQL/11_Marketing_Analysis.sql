/*
=========================================================
MARKETING ANALYSIS
Retail Sales, Customer & Marketing Analytics
=========================================================
*/

USE retail_sales_analytics;

-- =====================================================
-- Q1. Sessions by Traffic Source
-- =====================================================
SELECT
    traffic_source,
    COUNT(session_id) AS total_sessions
FROM customer_session
GROUP BY traffic_source
ORDER BY total_sessions DESC;

-- =====================================================
-- Q2. Revenue by Traffic Source
-- =====================================================
SELECT
    traffic_source,
    ROUND(SUM(total_usd),2) AS total_revenue
FROM orders
GROUP BY traffic_source
ORDER BY total_revenue DESC;

-- =====================================================
-- Q3. Average Order Value by Traffic Source
-- =====================================================
SELECT
    traffic_source,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_usd),2) AS average_order_value
FROM orders
GROUP BY traffic_source
ORDER BY average_order_value DESC;

-- =====================================================
-- Q4. Average Order Value by Device
-- =====================================================
SELECT
    device,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_usd),2) AS average_order_value
FROM orders
GROUP BY device
ORDER BY average_order_value DESC;
-- =====================================================
-- Q5. Website Events
-- =====================================================
SELECT
    event_type,
    COUNT(*) AS total_events
FROM events
GROUP BY event_type
ORDER BY total_events DESC;

-- =====================================================
-- Q6. Revenue by Marketing Opt-in
-- =====================================================
SELECT
    c.marketing_opt_in,
    ROUND(SUM(o.total_usd),2) AS total_revenue,
    COUNT(o.order_id) AS total_orders
FROM customer c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.marketing_opt_in;

-- =====================================================
-- Q7. Revenue per Order by Traffic Source
-- =====================================================
SELECT
    traffic_source,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_usd),2) AS total_revenue,
    ROUND(AVG(total_usd),2) AS revenue_per_order
FROM orders
GROUP BY traffic_source
ORDER BY total_revenue DESC;

-- =====================================================
-- MARKETING SUMMARY
-- =====================================================
SELECT
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT customer_id) AS active_customers,
    COUNT(DISTINCT traffic_source) AS traffic_sources,
    COUNT(DISTINCT device) AS devices
FROM customer_session;