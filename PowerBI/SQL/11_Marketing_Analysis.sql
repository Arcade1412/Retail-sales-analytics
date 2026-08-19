/*
=========================================================
Retail Sales Analytics
Marketing Analysis

Purpose:
Evaluate marketing channel performance, customer
engagement, device behavior, and marketing opt-in
performance.
=========================================================
*/

USE retail_sales_analytics;


/* =======================================================
1. TRAFFIC SOURCE SESSION VOLUME
======================================================= */

SELECT
    traffic_source,
    COUNT(session_id) AS total_sessions,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customer_session
GROUP BY traffic_source
ORDER BY total_sessions DESC;


/* =======================================================
2. TRAFFIC SOURCE REVENUE PERFORMANCE
======================================================= */

SELECT
    traffic_source,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY traffic_source
ORDER BY total_revenue DESC;


/* =======================================================
3. TRAFFIC SOURCE PERFORMANCE SUMMARY
Combines session and order-level metrics.

Revenue per session is used as a channel efficiency
metric. It is not a conversion rate because orders
cannot be directly linked to individual sessions.
======================================================= */

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
        SUM(total_usd) AS revenue,
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
    ROUND(COALESCE(o.revenue, 0), 2) AS total_revenue,
    ROUND(COALESCE(o.average_order_value, 0), 2)
        AS average_order_value,
    ROUND(
        COALESCE(o.revenue, 0)
        / NULLIF(s.total_sessions, 0),
        2
    ) AS revenue_per_session
FROM session_metrics s
LEFT JOIN order_metrics o
    ON s.traffic_source = o.traffic_source
ORDER BY total_revenue DESC;


/* =======================================================
4. TRAFFIC SOURCE REVENUE CONTRIBUTION
======================================================= */

WITH channel_revenue AS (
    SELECT
        traffic_source,
        SUM(total_usd) AS revenue
    FROM orders
    GROUP BY traffic_source
)

SELECT
    traffic_source,
    ROUND(revenue, 2) AS total_revenue,
    ROUND(
        revenue * 100.0 /
        NULLIF(SUM(revenue) OVER (), 0),
        2
    ) AS revenue_share_pct
FROM channel_revenue
ORDER BY total_revenue DESC;


/* =======================================================
5. DEVICE PERFORMANCE
======================================================= */

SELECT
    device,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY device
ORDER BY total_revenue DESC;


/* =======================================================
6. DEVICE SESSION PERFORMANCE
======================================================= */

SELECT
    device,
    COUNT(session_id) AS total_sessions,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customer_session
GROUP BY device
ORDER BY total_sessions DESC;


/* =======================================================
7. MARKETING OPT-IN PERFORMANCE
======================================================= */

SELECT
    c.marketing_opt_in,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_usd), 2) AS total_revenue,
    ROUND(AVG(o.total_usd), 2) AS average_order_value
FROM customer c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.marketing_opt_in
ORDER BY total_revenue DESC;


/* =======================================================
8. WEBSITE EVENT ACTIVITY
======================================================= */

SELECT
    event_type,
    COUNT(event_id) AS total_events,
    COUNT(DISTINCT session_id) AS sessions_with_event,
    COUNT(DISTINCT product_id) AS products_interacted_with
FROM events
GROUP BY event_type
ORDER BY total_events DESC;


/* =======================================================
9. EVENT ACTIVITY BY TRAFFIC SOURCE
Shows where website engagement is coming from.
======================================================= */

SELECT
    cs.traffic_source,
    COUNT(DISTINCT e.event_id) AS total_events,
    COUNT(DISTINCT e.session_id) AS active_sessions,
    COUNT(DISTINCT e.product_id) AS products_interacted_with
FROM events e
INNER JOIN customer_session cs
    ON e.session_id = cs.session_id
GROUP BY cs.traffic_source
ORDER BY total_events DESC;


/* =======================================================
10. MARKETING PERFORMANCE BY COUNTRY
======================================================= */

SELECT
    country,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY country
ORDER BY total_revenue DESC;


/* =======================================================
11. TOP MARKETING CHANNEL BY REVENUE
======================================================= */

WITH channel_performance AS (
    SELECT
        traffic_source,
        COUNT(order_id) AS total_orders,
        SUM(total_usd) AS revenue
    FROM orders
    GROUP BY traffic_source
),

ranked_channels AS (
    SELECT
        traffic_source,
        total_orders,
        revenue,
        RANK() OVER (
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM channel_performance
)

SELECT
    traffic_source,
    total_orders,
    ROUND(revenue, 2) AS total_revenue,
    revenue_rank
FROM ranked_channels
ORDER BY revenue_rank;


/* =======================================================
12. MARKETING ANALYSIS SUMMARY
======================================================= */

SELECT
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT customer_id) AS active_customers,
    COUNT(DISTINCT traffic_source) AS traffic_sources,
    COUNT(DISTINCT device) AS devices
FROM customer_session;
