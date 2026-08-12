/*
=========================================================
SALES ANALYSIS
Retail Sales, Customer & Marketing Analytics
=========================================================
*/

USE retail_sales_analytics;

-- =====================================================
-- Q1. Monthly Revenue Trend
-- =====================================================
SELECT
    MONTHNAME(order_time) AS month,
    MONTH(order_time) AS month_number,
    ROUND(SUM(total_usd),2) AS total_revenue
FROM orders
GROUP BY MONTH(order_time), MONTHNAME(order_time)
ORDER BY month_number;

-- =====================================================
-- Q2. Monthly Order Volume
-- =====================================================
SELECT
    MONTHNAME(order_time) AS month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY MONTH(order_time), MONTHNAME(order_time)
ORDER BY MONTH(order_time);

-- =====================================================
-- Q3. Revenue by Payment Method
-- =====================================================
SELECT
    payment_method,
    ROUND(SUM(total_usd),2) AS total_revenue
FROM orders
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- =====================================================
-- Q4. Revenue by Device
-- =====================================================
SELECT
    device,
    ROUND(SUM(total_usd),2) AS total_revenue
FROM orders
GROUP BY device
ORDER BY total_revenue DESC;

-- =====================================================
-- Q5. Revenue by Traffic Source
-- =====================================================
SELECT
    traffic_source,
    ROUND(SUM(total_usd),2) AS total_revenue
FROM orders
GROUP BY traffic_source
ORDER BY total_revenue DESC;

-- =====================================================
-- SALES SUMMARY
-- =====================================================
SELECT
    ROUND(SUM(total_usd),2) AS total_sales,
    ROUND(AVG(total_usd),2) AS average_order_value,
    ROUND(MAX(total_usd),2) AS highest_order_value,
    ROUND(MIN(total_usd),2) AS lowest_order_value,
    ROUND(AVG(discount_pct),2) AS average_discount
FROM orders;