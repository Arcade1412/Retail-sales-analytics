/*
=========================================================
Retail Sales Analytics
Sales Analysis

Purpose:
Analyze sales trends, order performance, geographic
performance, and key sales drivers.
=========================================================
*/

USE retail_sales_analytics;


/* =======================================================
1. MONTHLY REVENUE TREND
======================================================= */

SELECT
    DATE_FORMAT(order_time, '%Y-%m') AS sales_month,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY DATE_FORMAT(order_time, '%Y-%m')
ORDER BY sales_month;


/* =======================================================
2. MONTH-OVER-MONTH REVENUE GROWTH
Shows how revenue changes compared with the
previous month.
======================================================= */

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_time, '%Y-%m') AS sales_month,
        SUM(total_usd) AS revenue
    FROM orders
    GROUP BY DATE_FORMAT(order_time, '%Y-%m')
),

sales_with_previous_month AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (revenue - previous_month_revenue)
        * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_pct
FROM sales_with_previous_month
ORDER BY sales_month;


/* =======================================================
3. SALES BY COUNTRY
======================================================= */

SELECT
    country,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY country
ORDER BY total_revenue DESC;


/* =======================================================
4. TOP 5 COUNTRIES BY REVENUE
======================================================= */

SELECT
    country,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(total_usd), 2) AS total_revenue
FROM orders
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 5;


/* =======================================================
5. REVENUE BY PAYMENT METHOD
======================================================= */

SELECT
    payment_method,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY payment_method
ORDER BY total_revenue DESC;


/* =======================================================
6. REVENUE BY DEVICE
======================================================= */

SELECT
    device,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY device
ORDER BY total_revenue DESC;


/* =======================================================
7. REVENUE BY TRAFFIC SOURCE
======================================================= */

SELECT
    traffic_source,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_usd), 2) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders
GROUP BY traffic_source
ORDER BY total_revenue DESC;


/* =======================================================
8. DISCOUNT AND SALES PERFORMANCE
======================================================= */

SELECT
    ROUND(AVG(discount_pct), 2) AS average_discount_pct,
    ROUND(MIN(discount_pct), 2) AS minimum_discount_pct,
    ROUND(MAX(discount_pct), 2) AS maximum_discount_pct,
    ROUND(SUM(total_usd), 2) AS total_revenue
FROM orders;


/* =======================================================
9. ORDER VALUE DISTRIBUTION
======================================================= */

SELECT
    ROUND(MIN(total_usd), 2) AS minimum_order_value,
    ROUND(AVG(total_usd), 2) AS average_order_value,
    ROUND(MAX(total_usd), 2) AS maximum_order_value,
    ROUND(
        SUM(total_usd) / NULLIF(COUNT(order_id), 0),
        2
    ) AS revenue_per_order
FROM orders;


/* =======================================================
10. SALES RANKING BY COUNTRY
======================================================= */

WITH country_sales AS (
    SELECT
        country,
        SUM(total_usd) AS revenue
    FROM orders
    GROUP BY country
)

SELECT
    country,
    ROUND(revenue, 2) AS total_revenue,
    RANK() OVER (
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM country_sales
ORDER BY revenue_rank;


/* =======================================================
11. CUSTOMER CONTRIBUTION TO SALES
======================================================= */

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_usd) AS revenue
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer_id,
    ROUND(revenue, 2) AS total_revenue,
    ROUND(
        revenue * 100.0 /
        NULLIF(SUM(revenue) OVER (), 0),
        2
    ) AS revenue_contribution_pct
FROM customer_sales
ORDER BY total_revenue DESC;


/* =======================================================
12. SALES SUMMARY
======================================================= */

SELECT
    ROUND(SUM(total_usd), 2) AS total_sales,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(AVG(total_usd), 2) AS average_order_value,
    ROUND(MAX(total_usd), 2) AS highest_order_value,
    ROUND(MIN(total_usd), 2) AS lowest_order_value,
    ROUND(AVG(discount_pct), 2) AS average_discount
FROM orders;
