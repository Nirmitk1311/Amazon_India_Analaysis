/*
    Amazon India Store - SQL Server business analysis
    Run after amazon_india_store_dataset.sql and 03_validation.sql.
*/

IF DB_ID(N'amazon_india_store') IS NULL
    THROW 50010, 'Database amazon_india_store does not exist.', 1;
GO

USE amazon_india_store;
GO

SET NOCOUNT ON;
GO

/* 1. Executive sales KPIs */
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_total_inr) AS total_revenue_inr,
    AVG(order_total_inr) AS average_order_value_inr,
    SUM(quantity) AS units_sold
FROM dbo.orders;
GO

/* 2. Revenue and orders by month */
SELECT
    DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_total_inr) AS revenue_inr,
    SUM(quantity) AS units_sold
FROM dbo.orders
GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
ORDER BY order_month;
GO

/* 3. Revenue by product category */
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS units_sold,
    SUM(o.order_total_inr) AS revenue_inr,
    AVG(o.order_total_inr) AS average_order_value_inr
FROM dbo.orders AS o
JOIN dbo.products AS p ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY revenue_inr DESC;
GO

/* 4. Top 10 products */
SELECT TOP (10)
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    SUM(o.order_total_inr) AS revenue_inr
FROM dbo.orders AS o
JOIN dbo.products AS p ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue_inr DESC;
GO

/* 5. Prime versus non-Prime customer performance */
SELECT
    c.prime_member,
    COUNT(DISTINCT o.customer_id) AS customers,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(o.order_total_inr) AS revenue_inr,
    AVG(o.order_total_inr) AS average_order_value_inr
FROM dbo.orders AS o
JOIN dbo.customers AS c ON c.customer_id = o.customer_id
GROUP BY c.prime_member
ORDER BY revenue_inr DESC;
GO

/* 6. Repeat-buyer segmentation */
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count,
        SUM(order_total_inr) AS revenue_inr
    FROM dbo.orders
    GROUP BY customer_id
)
SELECT
    CASE WHEN order_count = 1 THEN 'One-time buyer' ELSE 'Repeat buyer' END AS buyer_segment,
    COUNT(*) AS customers,
    SUM(order_count) AS orders,
    SUM(revenue_inr) AS revenue_inr,
    AVG(revenue_inr) AS average_customer_revenue_inr
FROM customer_orders
GROUP BY CASE WHEN order_count = 1 THEN 'One-time buyer' ELSE 'Repeat buyer' END;
GO

/* 7. Top customers by order revenue */
SELECT TOP (10)
    c.customer_id,
    c.full_name,
    c.city,
    c.state,
    c.prime_member,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(o.order_total_inr) AS revenue_inr
FROM dbo.orders AS o
JOIN dbo.customers AS c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, c.city, c.state, c.prime_member
ORDER BY revenue_inr DESC;
GO

/* 8. Product ratings and performance */
SELECT
    p.category,
    AVG(p.rating) AS average_product_rating,
    AVG(p.selling_price - p.cost_price) AS average_unit_margin_inr,
    SUM(o.quantity) AS units_sold,
    SUM(o.order_total_inr) AS revenue_inr
FROM dbo.products AS p
LEFT JOIN dbo.orders AS o ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue_inr DESC;
GO

/* 9. Low-rated products with meaningful sales volume */
SELECT TOP (20)
    p.product_id,
    p.product_name,
    p.category,
    p.rating,
    SUM(o.quantity) AS units_sold,
    SUM(o.order_total_inr) AS revenue_inr
FROM dbo.products AS p
JOIN dbo.orders AS o ON o.product_id = p.product_id
WHERE p.rating < 3.5
GROUP BY p.product_id, p.product_name, p.category, p.rating
HAVING SUM(o.quantity) > 0
ORDER BY units_sold DESC, p.rating;
GO

/* 10. Returns by category */
SELECT
    p.category,
    COUNT(DISTINCT r.return_id) AS returns,
    SUM(r.refund_amount_inr) AS refunds_inr,
    CAST(
        100.0 * COUNT(DISTINCT r.return_id)
        / NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS decimal(6,2)
    ) AS return_rate_pct
FROM dbo.products AS p
LEFT JOIN dbo.orders AS o ON o.product_id = p.product_id
LEFT JOIN dbo.returns AS r ON r.order_id = o.order_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;
GO

/* 11. Return reasons */
SELECT
    return_reason,
    COUNT(*) AS return_count,
    SUM(refund_amount_inr) AS refunds_inr
FROM dbo.returns
GROUP BY return_reason
ORDER BY return_count DESC;
GO

/* 12. Monthly refunds */
SELECT
    DATEFROMPARTS(YEAR(return_request_date), MONTH(return_request_date), 1) AS return_month,
    COUNT(*) AS return_count,
    SUM(refund_amount_inr) AS refunds_inr
FROM dbo.returns
GROUP BY DATEFROMPARTS(YEAR(return_request_date), MONTH(return_request_date), 1)
ORDER BY return_month;
GO

/* 13. Seller performance */
SELECT TOP (10)
    s.seller_id,
    s.seller_name,
    s.account_health,
    s.seller_rating,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(o.quantity) AS units_sold,
    SUM(o.order_total_inr) AS revenue_inr,
    s.return_rate_pct,
    s.defect_rate_pct,
    s.on_time_ship_pct
FROM dbo.sellers AS s
LEFT JOIN dbo.orders AS o ON o.seller_id = s.seller_id
GROUP BY
    s.seller_id, s.seller_name, s.account_health, s.seller_rating,
    s.return_rate_pct, s.defect_rate_pct, s.on_time_ship_pct
ORDER BY revenue_inr DESC;
GO

/* 14. Payment methods */
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS orders,
    SUM(amount_inr) AS transaction_value_inr
FROM dbo.transactions
GROUP BY payment_method
ORDER BY transaction_value_inr DESC;
GO

/* 15. Order-status breakdown */
SELECT
    order_status,
    COUNT(*) AS orders,
    SUM(order_total_inr) AS revenue_inr,
    AVG(order_total_inr) AS average_order_value_inr
FROM dbo.orders
GROUP BY order_status
ORDER BY orders DESC;
GO

/* 16. Average delivery time by shipping type */
SELECT
    shipping_type,
    COUNT(*) AS delivered_orders,
    AVG(CAST(DATEDIFF(DAY, order_date, delivery_date) AS decimal(10,2)))
        AS average_delivery_days
FROM dbo.orders
WHERE delivery_date IS NOT NULL
GROUP BY shipping_type
ORDER BY average_delivery_days;
GO

/* 17. COD revenue by city */
SELECT
    c.city,
    COUNT(DISTINCT o.order_id) AS cod_orders,
    SUM(o.order_total_inr) AS cod_revenue_inr
FROM dbo.orders AS o
JOIN dbo.customers AS c ON c.customer_id = o.customer_id
WHERE o.payment_method = 'Cash on Delivery'
GROUP BY c.city
ORDER BY cod_revenue_inr DESC;
GO

/* 18. Financial reconciliation exceptions */
WITH exceptions AS (
    SELECT
        order_id,
        order_total_inr,
        subtotal_inr + shipping_fee_inr + gst_inr - discount_inr AS calculated_total,
        order_total_inr
            - (subtotal_inr + shipping_fee_inr + gst_inr - discount_inr) AS difference
    FROM dbo.orders
    WHERE ABS(
        order_total_inr
        - (subtotal_inr + shipping_fee_inr + gst_inr - discount_inr)
    ) > 0.01
)
SELECT
    order_id,
    order_total_inr,
    calculated_total,
    difference,
    CAST('Exception found' AS varchar(30)) AS result_status
FROM exceptions

UNION ALL

SELECT
    CAST(NULL AS varchar(22)) AS order_id,
    CAST(NULL AS decimal(12,2)) AS order_total_inr,
    CAST(NULL AS decimal(12,2)) AS calculated_total,
    CAST(NULL AS decimal(12,2)) AS difference,
    CAST('No exceptions found' AS varchar(30)) AS result_status
WHERE NOT EXISTS (SELECT 1 FROM exceptions)
ORDER BY difference DESC;
GO
