USE retail_sales_analytics;

-- =====================================================
-- Customer -> Orders
-- =====================================================
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

-- =====================================================
-- Customer -> Customer Session
-- =====================================================
ALTER TABLE customer_session
ADD CONSTRAINT fk_session_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

-- =====================================================
-- Orders -> Order Items
-- =====================================================
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- =====================================================
-- Product -> Order Items
-- =====================================================
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_product
FOREIGN KEY (product_id)
REFERENCES product(product_id);

-- =====================================================
-- Customer Session -> Events
-- =====================================================
ALTER TABLE events
ADD CONSTRAINT fk_events_session
FOREIGN KEY (session_id)
REFERENCES customer_session(session_id);

-- =====================================================
-- Orders -> Reviews
-- =====================================================
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- =====================================================
-- Product -> Reviews
-- =====================================================
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (product_id)
REFERENCES product(product_id);

-- ======================================================
-- Checking of foreign keys 
-- ======================================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA='retail_sales_analytics'
AND REFERENCED_TABLE_NAME IS NOT NULL;