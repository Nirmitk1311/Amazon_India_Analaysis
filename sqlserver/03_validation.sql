IF DB_ID(N'amazon_india_store') IS NULL
    THROW 50001, 'Database amazon_india_store does not exist. Run amazon_india_store_dataset.sql first.', 1;
GO

USE amazon_india_store;
GO

IF OBJECT_ID(N'dbo.orders', N'U') IS NULL
    THROW 50002, 'Core tables are missing. Run amazon_india_store_dataset.sql first.', 1;
GO

SET NOCOUNT ON;
GO

SELECT
    t.name AS table_name,
    SUM(p.rows) AS row_count
FROM sys.tables AS t
JOIN sys.partitions AS p
    ON p.object_id = t.object_id
   AND p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY t.name;
GO

-- Primary-key duplicates should return zero rows.
SELECT order_id, COUNT(*) AS duplicate_count
FROM dbo.orders
GROUP BY order_id
HAVING COUNT(*) > 1;
GO

-- Delivered orders should have a delivery date.
SELECT order_id, order_status, delivery_date
FROM dbo.orders
WHERE order_status = 'Delivered'
  AND delivery_date IS NULL;
GO

-- Financial reconciliation. Small differences can be caused by source rounding.
SELECT
    order_id,
    order_total_inr,
    subtotal_inr + shipping_fee_inr + gst_inr - discount_inr AS calculated_total,
    order_total_inr - (subtotal_inr + shipping_fee_inr + gst_inr - discount_inr) AS difference
FROM dbo.orders
WHERE ABS(order_total_inr - (subtotal_inr + shipping_fee_inr + gst_inr - discount_inr)) > 0.01;
GO

-- Basic relationship orphan checks before/after adding foreign keys.
SELECT COUNT(*) AS orphan_order_customers
FROM dbo.orders AS o
LEFT JOIN dbo.customers AS c ON c.customer_id = o.customer_id
WHERE o.customer_id IS NOT NULL AND c.customer_id IS NULL;
GO
