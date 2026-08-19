/*
=========================================================
Retail Sales Analytics
Customer Analysis

Purpose:
Analyze customer purchasing behavior, revenue contribution,
order frequency, and customer value.
=========================================================
*/

USE retail_sales_analytics;


/* =======================================================
1. CUSTOMER REVENUE AND ORDER SUMMARY
======================================================= */

SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC;


/* =======================================================
2. TOP 10 CUSTOMERS BY REVENUE
======================================================= */

SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;


/* =======================================================
3. CUSTOMER ORDER FREQUENCY
======================================================= */

SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_usd), 2) AS total_revenue
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC, total_revenue DESC;


/* =======================================================
4. REPEAT CUSTOMER ANALYSIS
Customers with more than one order are classified
as repeat customers.
======================================================= */

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END)
        AS one_time_customers,
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;


/* =======================================================
5. CUSTOMER VALUE SEGMENTATION
Segments are based on total customer revenue.
======================================================= */

WITH customer_value AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        ROUND(SUM(total_usd), 2) AS total_revenue,
        ROUND(AVG(total_usd), 2) AS average_order_value
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_orders,
    total_revenue,
    average_order_value,
    CASE
        WHEN total_revenue >= 1000 THEN 'High Value'
        WHEN total_revenue >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_value
ORDER BY total_revenue DESC;


/* =======================================================
6. CUSTOMER SEGMENT SUMMARY
======================================================= */

WITH customer_value AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_usd) AS total_revenue
    FROM orders
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        total_orders,
        total_revenue,
        CASE
            WHEN total_revenue >= 1000 THEN 'High Value'
            WHEN total_revenue >= 500 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_value
)

SELECT
    customer_segment,
    COUNT(customer_id) AS customers,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_customer_revenue
FROM customer_segments
GROUP BY customer_segment
ORDER BY total_revenue DESC;


/* =======================================================
7. CUSTOMER PERFORMANCE BY COUNTRY
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
8. HIGH-VALUE CUSTOMER CONTRIBUTION
======================================================= */

WITH customer_value AS (
    SELECT
        customer_id,
        SUM(total_usd) AS total_revenue
    FROM orders
    GROUP BY customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM customer_value
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank
FROM ranked_customers
WHERE revenue_rank <= 10
ORDER BY revenue_rank;
