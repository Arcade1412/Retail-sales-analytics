/*
=========================================================
Retail Sales Analytics
Product Analysis

Purpose:
Analyze product and category performance, revenue,
profitability, pricing, and product contribution.
=========================================================
*/

USE retail_sales_analytics;


/* =======================================================
1. PRODUCT PERFORMANCE SUMMARY
======================================================= */

SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS product_revenue,
    ROUND(AVG(oi.unit_price), 2) AS average_selling_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY product_revenue DESC;


/* =======================================================
2. TOP 10 PRODUCTS BY REVENUE
======================================================= */

SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY revenue DESC
LIMIT 10;


/* =======================================================
3. CATEGORY PERFORMANCE
======================================================= */

SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
    ROUND(AVG(oi.unit_price), 2) AS average_selling_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


/* =======================================================
4. PRODUCT PROFITABILITY
======================================================= */

SELECT
    p.product_id,
    p.product_name,
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
    ROUND(SUM(oi.quantity * (oi.unit_price_usd- p.cost_usd)), 2) AS gross_profit,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_usd- p.cost_usd))
        * 100.0
        / NULLIF(SUM(oi.quantity * oi.unit_price), 0),
        2
    ) AS profit_margin_pct
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY gross_profit DESC;


/* =======================================================
5. TOP 10 PRODUCTS BY PROFIT
======================================================= */

SELECT
    p.product_name,
    p.category,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_usd- p.cost_usd)),
        2
    ) AS gross_profit,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_usd- p.cost_usd))
        * 100.0
        / NULLIF(SUM(oi.quantity * oi.unit_price), 0),
        2
    ) AS profit_margin_pct
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY gross_profit DESC
LIMIT 10;


/* =======================================================
6. PRODUCTS WITH LOW PROFIT MARGIN
Useful for identifying products that generate sales
but may require pricing or cost review.
======================================================= */

SELECT
    p.product_name,
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_usd- p.cost_usd)),
        2
    ) AS gross_profit,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_usd- p.cost_usd))
        * 100.0
        / NULLIF(SUM(oi.quantity * oi.unit_price), 0),
        2
    ) AS profit_margin_pct
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
HAVING profit_margin_pct < 20
ORDER BY revenue DESC;


/* =======================================================
7. CATEGORY PROFITABILITY
======================================================= */

SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_usd- p.cost_usd)),
        2
    ) AS gross_profit,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_usd- p.cost_usd))
        * 100.0
        / NULLIF(SUM(oi.quantity * oi.unit_price), 0),
        2
    ) AS profit_margin_pct
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY gross_profit DESC;


/* =======================================================
8. PRODUCT REVENUE RANKING
======================================================= */

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
)

SELECT
    product_name,
    category,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM product_sales
ORDER BY revenue_rank;


/* =======================================================
9. CATEGORY SHARE OF TOTAL REVENUE
======================================================= */

WITH category_sales AS (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.category
)

SELECT
    category,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue * 100.0 /
        NULLIF(SUM(revenue) OVER (), 0),
        2
    ) AS revenue_share_pct
FROM category_sales
ORDER BY revenue DESC;
