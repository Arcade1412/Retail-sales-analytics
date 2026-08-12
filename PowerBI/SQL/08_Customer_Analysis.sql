/*
=========================================================
Customer Analysis

Question 1

Business Question:
How are customers distributed across different countries?

Business Importance:
Understanding customer distribution helps identify
major markets and supports regional marketing strategies.
=========================================================
*/

SELECT
    country,
    COUNT(customer_id) AS total_customers
FROM customer
GROUP BY country
ORDER BY total_customers DESC;

/*
=========================================================
CUSTOMER ANALYSIS
=========================================================
*/

USE retail_sales_analytics;

-- =====================================================
-- Q1. Customer Distribution by Country
-- =====================================================
SELECT
    country,
    COUNT(customer_id) AS total_customers
FROM customer
GROUP BY country
ORDER BY total_customers DESC;

-- =====================================================
-- Q2. Revenue by Country
-- =====================================================
SELECT
    country,
    ROUND(SUM(total_usd),2) AS total_revenue
FROM orders
GROUP BY country
ORDER BY total_revenue DESC;

-- =====================================================
-- Q3. Orders by Country
-- =====================================================
SELECT
    country,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY country
ORDER BY total_orders DESC;

-- =====================================================
-- Q4. Top 10 Customers by Revenue
-- =====================================================
SELECT
    customer_id,
    ROUND(SUM(total_usd),2) AS total_spent
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- =====================================================
-- Q5. Customer Distribution by Age
-- =====================================================
SELECT
    age,
    COUNT(customer_id) AS total_customers
FROM customer
GROUP BY age
ORDER BY age;

-- =====================================================
-- Q6. Marketing Opt-in Analysis
-- =====================================================
SELECT
    marketing_opt_in,
    COUNT(customer_id) AS total_customers,
    ROUND(
        COUNT(customer_id) * 100.0 /
        (SELECT COUNT(*) FROM customer),
        2
    ) AS percentage
FROM customer
GROUP BY marketing_opt_in;

/*=========================================================
CUSTOMER ANALYSIS SUMMARY
Purpose:
Return high-level customer KPIs in a single row.
=========================================================*/

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT country) AS total_countries,
    ROUND(AVG(age),2) AS average_customer_age,
    SUM(marketing_opt_in = 1) AS marketing_opt_in_customers,
    ROUND(
        SUM(marketing_opt_in = 1) * 100.0 / COUNT(*),
        2
    ) AS marketing_opt_in_percentage
FROM customer;