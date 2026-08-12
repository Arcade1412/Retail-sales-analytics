/*
=========================================================
PRODUCT ANALYSIS
Retail Sales, Customer & Marketing Analytics
=========================================================
*/

USE retail_sales_analytics;

-- =====================================================
-- Q1. Product Distribution by Category
-- =====================================================
SELECT
    category,
    COUNT(product_id) AS total_products
FROM product
GROUP BY category
ORDER BY total_products DESC;

-- =====================================================
-- Q2. Revenue by Product Category
-- =====================================================
SELECT
    p.category,
    ROUND(SUM(oi.line_total_usd),2) AS total_revenue
FROM order_items oi
INNER JOIN product p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- =====================================================
-- Q3. Top 10 Best-Selling Products
-- =====================================================
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
INNER JOIN product p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
LIMIT 10;

-- =====================================================
-- Q4. Top 10 Products by Revenue
-- =====================================================
SELECT
    p.product_name,
    ROUND(SUM(oi.line_total_usd),2) AS revenue
FROM order_items oi
INNER JOIN product p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- =====================================================
-- Q5. Average Rating by Category
-- =====================================================
SELECT
    p.category,
    ROUND(AVG(r.rating),2) AS average_rating
FROM reviews r
INNER JOIN product p
    ON r.product_id = p.product_id
GROUP BY p.category
ORDER BY average_rating DESC;

-- =====================================================
-- PRODUCT ANALYSIS SUMMARY
-- =====================================================

SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT category) AS total_categories,
    ROUND(AVG(price_usd),2) AS average_product_price,
    ROUND(AVG(margin_usd),2) AS average_margin
FROM product;

/*=========================================================
PRODUCT ANALYSIS SUMMARY
Purpose:
Provide a high-level summary of the product catalog.
=========================================================*/

SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT category) AS total_categories,
    ROUND(AVG(price_usd),2) AS average_product_price,
    ROUND(AVG(cost_usd),2) AS average_product_cost,
    ROUND(AVG(margin_usd),2) AS average_product_margin,
    ROUND(MAX(price_usd),2) AS highest_product_price,
    ROUND(MIN(price_usd),2) AS lowest_product_price
FROM product;
