CREATE VIEW vw_sales_summary AS
SELECT
    order_id,
    customer_id,
    order_time,
    total_usd,
    payment_method,
    traffic_source,
    device
FROM orders;

-- View 2 ==================================
CREATE VIEW vw_product_sales AS
SELECT
    p.product_name,
    p.category,
    oi.quantity,
    oi.line_total_usd
FROM order_items oi
INNER JOIN product p
ON oi.product_id = p.product_id;
-- View 3 =================================
CREATE VIEW vw_customer_orders AS
SELECT
    c.customer_id,
    c.country,
    c.age,
    c.gender,
    o.order_id,
    o.total_usd
FROM customer c
INNER JOIN orders o
ON c.customer_id = o.customer_id;