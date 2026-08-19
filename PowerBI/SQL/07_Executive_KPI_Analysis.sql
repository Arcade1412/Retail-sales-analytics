/*
=========================================================
Retail Sales Analytics
Executive KPI Analysis

Purpose:
Calculate the main business KPIs used for executive
reporting and the Power BI dashboard.
=========================================================
*/

USE retail_sales_analytics;


/* =======================================================
1. CORE SALES KPIs
======================================================= */

SELECT
    ROUND(SUM(total_usd), 2) AS total_revenue,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(AVG(total_usd), 2) AS average_order_value
FROM orders;


/* =======================================================
2. SALES VOLUME KPIs
======================================================= */

SELECT
    SUM(oi.quantity) AS total_units_sold,
    ROUND(AVG(oi.quantity), 2) AS avg_units_per_order
FROM order_items oi;


/* =======================================================
3. CUSTOMER VALUE KPIs
======================================================= */

SELECT
    ROUND(
        SUM(total_usd) / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS revenue_per_customer,

    ROUND(
        COUNT(order_id) / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS orders_per_customer
FROM orders;


/* =======================================================
4. DISCOUNT PERFORMANCE
======================================================= */

SELECT
    ROUND(AVG(discount_pct), 2) AS average_discount_pct,
    ROUND(MIN(discount_pct), 2) AS minimum_discount_pct,
    ROUND(MAX(discount_pct), 2) AS maximum_discount_pct
FROM orders;


/* =======================================================
5. REPEAT CUSTOMER RATE
A repeat customer is defined as a customer with
more than one completed order.
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
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;


/* =======================================================
6. MONTHLY REVENUE TREND
======================================================= */

SELECT
    DATE_FORMAT(order_time, '%Y-%m') AS sales_month,
    ROUND(SUM(total_usd), 2) AS monthly_revenue,
    COUNT(order_id) AS monthly_orders,
    ROUND(AVG(total_usd), 2) AS monthly_aov
FROM orders
GROUP BY DATE_FORMAT(order_time, '%Y-%m')
ORDER BY sales_month;


/* =======================================================
7. MONTH-OVER-MONTH REVENUE GROWTH
======================================================= */

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_time, '%Y-%m') AS sales_month,
        ROUND(SUM(total_usd), 2) AS revenue
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
    revenue,
    previous_month_revenue,
    ROUND(
        (revenue - previous_month_revenue)
        * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_pct
FROM sales_with_previous_month
ORDER BY sales_month;


/* =======================================================
8. PAYMENT METHOD PERFORMANCE
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
9. DEVICE PERFORMANCE
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
10. TRAFFIC SOURCE PERFORMANCE
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
11. EXECUTIVE KPI SUMMARY
Single-row summary for reporting.
======================================================= */

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
),

repeat_rate AS (
    SELECT
        ROUND(
            SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
            * 100.0 / NULLIF(COUNT(*), 0),
            2
        ) AS repeat_customer_rate_pct
    FROM customer_orders
),

sales_kpis AS (
    SELECT
        ROUND(SUM(total_usd), 2) AS total_revenue,
        COUNT(order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS total_customers,
        ROUND(AVG(total_usd), 2) AS average_order_value,
        ROUND(AVG(discount_pct), 2) AS average_discount_pct,
        ROUND(
            SUM(total_usd) /
            NULLIF(COUNT(DISTINCT customer_id), 0),
            2
        ) AS revenue_per_customer
    FROM orders
),

unit_kpis AS (
    SELECT
        SUM(quantity) AS total_units_sold
    FROM order_items
)

SELECT
    s.total_revenue,
    s.total_orders,
    s.total_customers,
    u.total_units_sold,
    s.average_order_value,
    s.average_discount_pct,
    s.revenue_per_customer,
    r.repeat_customer_rate_pct
FROM sales_kpis s
CROSS JOIN unit_kpis u
CROSS JOIN repeat_rate r;
