-- E-commerce Sales Analytics - Business KPIs
-- Author: Narges
-- Date: December 2025

-- ============================================
-- 1. TOTAL REVENUE AND ORDER SUMMARY
-- ============================================

SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    SUM(oi.price) AS total_product_revenue,
    SUM(oi.freight_value) AS total_freight_revenue,
    SUM(oi.price + oi.freight_value) AS total_revenue,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- ============================================
-- 2. MONTHLY REVENUE TREND
-- ============================================

SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(oi.price) AS monthly_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


-- ============================================
-- 3. TOP 10 PRODUCT CATEGORIES BY REVENUE
-- ============================================

SELECT 
    ct.product_category_name_english AS category,
    COUNT(DISTINCT oi.order_id) AS orders_count,
    SUM(oi.price) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation ct ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================
-- 4. TOP 10 SELLERS BY REVENUE
-- ============================================

SELECT 
    seller_id,
    COUNT(DISTINCT order_id) AS orders_count,
    SUM(price) AS total_revenue,
    ROUND(AVG(price), 2) AS avg_item_price
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================
-- 5. ORDER STATUS DISTRIBUTION
-- ============================================

SELECT 
    order_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;
