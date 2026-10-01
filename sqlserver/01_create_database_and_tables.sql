/*
    Amazon India Store - SQL Server setup
    Run this file in SSMS before importing the CSV files.
*/

IF DB_ID(N'amazon_india_store') IS NULL
    CREATE DATABASE amazon_india_store;
GO

USE amazon_india_store;
GO

IF OBJECT_ID(N'dbo.transactions', N'U') IS NOT NULL
BEGIN
    ALTER TABLE dbo.transactions DROP CONSTRAINT IF EXISTS fk_transactions_orders;
    ALTER TABLE dbo.transactions DROP CONSTRAINT IF EXISTS fk_transactions_customers;
    ALTER TABLE dbo.transactions DROP CONSTRAINT IF EXISTS fk_transactions_sellers;
END;
IF OBJECT_ID(N'dbo.returns', N'U') IS NOT NULL
BEGIN
    ALTER TABLE dbo.returns DROP CONSTRAINT IF EXISTS fk_returns_orders;
    ALTER TABLE dbo.returns DROP CONSTRAINT IF EXISTS fk_returns_customers;
    ALTER TABLE dbo.returns DROP CONSTRAINT IF EXISTS fk_returns_products;
END;
IF OBJECT_ID(N'dbo.reviews', N'U') IS NOT NULL
BEGIN
    ALTER TABLE dbo.reviews DROP CONSTRAINT IF EXISTS fk_reviews_products;
    ALTER TABLE dbo.reviews DROP CONSTRAINT IF EXISTS fk_reviews_customers;
    ALTER TABLE dbo.reviews DROP CONSTRAINT IF EXISTS fk_reviews_orders;
END;
IF OBJECT_ID(N'dbo.orders', N'U') IS NOT NULL
BEGIN
    ALTER TABLE dbo.orders DROP CONSTRAINT IF EXISTS fk_orders_customers;
    ALTER TABLE dbo.orders DROP CONSTRAINT IF EXISTS fk_orders_products;
    ALTER TABLE dbo.orders DROP CONSTRAINT IF EXISTS fk_orders_sellers;
END;
IF OBJECT_ID(N'dbo.products', N'U') IS NOT NULL
    ALTER TABLE dbo.products DROP CONSTRAINT IF EXISTS fk_products_sellers;
GO

DROP TABLE IF EXISTS dbo.transactions;
DROP TABLE IF EXISTS dbo.returns;
DROP TABLE IF EXISTS dbo.reviews;
DROP TABLE IF EXISTS dbo.orders;
DROP TABLE IF EXISTS dbo.products;
DROP TABLE IF EXISTS dbo.customers;
DROP TABLE IF EXISTS dbo.sellers;
GO

CREATE TABLE dbo.sellers (
    seller_id         varchar(10)   NOT NULL,
    seller_name       varchar(100)  NULL,
    gstin             varchar(16)   NULL,
    primary_category  varchar(60)   NULL,
    city              varchar(60)   NULL,
    state             varchar(60)   NULL,
    fulfillment_type  varchar(12)   NULL,
    seller_rating     decimal(3,1)  NULL,
    total_sales_inr   bigint        NULL,
    total_listings    int           NULL,
    feedback_count    int           NULL,
    joined_date       date          NULL,
    account_health    varchar(12)   NULL,
    return_rate_pct   decimal(5,2)  NULL,
    defect_rate_pct   decimal(5,2)  NULL,
    on_time_ship_pct  decimal(5,2)  NULL,
    avg_response_hrs  decimal(5,2)  NULL,
    brand_registered  varchar(5)    NULL,
    CONSTRAINT pk_sellers PRIMARY KEY (seller_id)
);
GO

CREATE TABLE dbo.customers (
    customer_id        varchar(12)   NOT NULL,
    full_name          varchar(100)  NULL,
    gender             varchar(2)    NULL,
    email              varchar(120)  NULL,
    mobile             varchar(18)   NULL,
    city               varchar(60)   NULL,
    state              varchar(60)   NULL,
    pincode            char(6)       NULL,
    prime_member       varchar(10)   NULL,
    account_created    date          NULL,
    total_orders       int           NULL,
    lifetime_spend_inr decimal(12,2) NULL,
    preferred_category varchar(60)   NULL,
    kyc_verified       varchar(5)    NULL,
    gst_registered     varchar(5)    NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);
GO

CREATE TABLE dbo.products (
    product_id         varchar(12)   NOT NULL,
    asin               varchar(12)   NULL,
    product_name       varchar(250)  NULL,
    category           varchar(60)   NULL,
    brand              varchar(80)   NULL,
    seller_id          varchar(10)   NULL,
    mrp_inr            int           NULL,
    selling_price      decimal(10,2) NULL,
    cost_price         int           NULL,
    gst_percent        int           NULL,
    rating             decimal(3,1)  NULL,
    review_count       int           NULL,
    stock_qty          int           NULL,
    weight_kg          decimal(6,2)  NULL,
    is_prime           varchar(5)    NULL,
    fulfilled_by       varchar(10)   NULL,
    launch_date        date          NULL,
    discount_pct       int           NULL,
    return_window_days int           NULL,
    CONSTRAINT pk_products PRIMARY KEY (product_id)
);
GO

CREATE TABLE dbo.orders (
    order_id           varchar(22)   NOT NULL,
    customer_id        varchar(12)   NULL,
    product_id         varchar(12)   NULL,
    seller_id          varchar(10)   NULL,
    order_date         date          NULL,
    ship_date          date          NULL,
    delivery_date      date          NULL,
    quantity           int           NULL,
    unit_price_inr     decimal(10,2) NULL,
    subtotal_inr       decimal(12,2) NULL,
    shipping_fee_inr   decimal(8,2)  NULL,
    gst_inr            decimal(10,2) NULL,
    discount_inr       int           NULL,
    order_total_inr    decimal(12,2) NULL,
    payment_method     varchar(25)   NULL,
    shipping_type      varchar(30)   NULL,
    order_status       varchar(20)   NULL,
    warehouse_state    varchar(60)   NULL,
    invoice_no         varchar(12)   NULL,
    is_business_order  varchar(5)    NULL,
    promo_applied      varchar(15)   NULL,
    CONSTRAINT pk_orders PRIMARY KEY (order_id)
);
GO

CREATE TABLE dbo.reviews (
    review_id         varchar(14)  NOT NULL,
    product_id        varchar(12)  NULL,
    customer_id       varchar(12)  NULL,
    order_id          varchar(22)  NULL,
    review_date       date         NULL,
    rating            tinyint      NULL,
    review_title      varchar(120) NULL,
    review_language   varchar(12)  NULL,
    verified_purchase varchar(5)   NULL,
    helpful_votes     int          NULL,
    total_votes       int          NULL,
    vine_review       varchar(5)   NULL,
    image_attached    varchar(5)   NULL,
    seller_response   varchar(5)   NULL,
    CONSTRAINT pk_reviews PRIMARY KEY (review_id)
);
GO

CREATE TABLE dbo.returns (
    return_id           varchar(12)   NOT NULL,
    order_id            varchar(22)   NULL,
    customer_id         varchar(12)   NULL,
    product_id          varchar(12)   NULL,
    return_request_date date          NULL,
    return_reason       varchar(40)   NULL,
    return_status       varchar(20)   NULL,
    refund_amount_inr   decimal(12,2) NULL,
    refund_method       varchar(35)   NULL,
    days_to_return      int           NULL,
    condition_received  varchar(12)   NULL,
    pickup_agent        varchar(20)   NULL,
    replacement_issued  varchar(5)    NULL,
    CONSTRAINT pk_returns PRIMARY KEY (return_id)
);
GO

CREATE TABLE dbo.transactions (
    transaction_id   varchar(14)   NOT NULL,
    order_id         varchar(22)   NULL,
    customer_id      varchar(12)   NULL,
    seller_id        varchar(10)   NULL,
    transaction_date date          NULL,
    amount_inr       decimal(12,2) NULL,
    payment_method   varchar(25)   NULL,
    transaction_status varchar(10) NULL,
    gateway_reference varchar(15)  NULL,
    bank_name        varchar(35)   NULL,
    upi_id           varchar(50)   NULL,
    currency         char(3)       NULL,
    failure_reason   varchar(60)   NULL,
    is_refund        varchar(5)    NULL,
    linked_return_id varchar(12)   NULL,
    CONSTRAINT pk_transactions PRIMARY KEY (transaction_id)
);
GO
