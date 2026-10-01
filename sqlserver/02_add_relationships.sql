USE amazon_india_store;
GO

ALTER TABLE dbo.products
ADD CONSTRAINT fk_products_sellers
FOREIGN KEY (seller_id) REFERENCES dbo.sellers(seller_id);
GO

ALTER TABLE dbo.orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id),
    CONSTRAINT fk_orders_products
FOREIGN KEY (product_id) REFERENCES dbo.products(product_id),
    CONSTRAINT fk_orders_sellers
FOREIGN KEY (seller_id) REFERENCES dbo.sellers(seller_id);
GO

ALTER TABLE dbo.reviews
ADD CONSTRAINT fk_reviews_products
FOREIGN KEY (product_id) REFERENCES dbo.products(product_id),
    CONSTRAINT fk_reviews_customers
FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id),
    CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id);
GO

ALTER TABLE dbo.returns
ADD CONSTRAINT fk_returns_orders
FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id),
    CONSTRAINT fk_returns_customers
FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id),
    CONSTRAINT fk_returns_products
FOREIGN KEY (product_id) REFERENCES dbo.products(product_id);
GO

ALTER TABLE dbo.transactions
ADD CONSTRAINT fk_transactions_orders
FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id),
    CONSTRAINT fk_transactions_customers
FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id),
    CONSTRAINT fk_transactions_sellers
FOREIGN KEY (seller_id) REFERENCES dbo.sellers(seller_id);
GO
