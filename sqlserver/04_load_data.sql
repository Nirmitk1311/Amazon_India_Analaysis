/*
    Amazon India Store - CSV data load

    IMPORTANT:
    BULK INSERT reads files from the SQL Server machine, not necessarily
    from the SSMS client machine. If this path is not visible to SQL Server,
    copy the Data folder to C:\AmazonIndiaData and replace the paths below.

    This loader deliberately uses the older FIELDTERMINATOR/ROWTERMINATOR
    syntax instead of FORMAT = 'CSV'. It works on more SQL Server versions
    and avoids the IID_IColumnsInfo error from the CSV provider. These source
    files do not contain comma characters inside quoted fields.

    Run 01_create_database_and_tables.sql first.
    Run 02_add_relationships.sql only after this script succeeds.
*/

USE amazon_india_store;
GO

/*
    The tables are loaded in parent-to-child order. The tables are empty after
    running the create script, but these DELETE statements make this loader
    safe to re-run before foreign keys are added.
*/
DELETE FROM dbo.transactions;
DELETE FROM dbo.returns;
DELETE FROM dbo.reviews;
DELETE FROM dbo.orders;
DELETE FROM dbo.products;
DELETE FROM dbo.customers;
DELETE FROM dbo.sellers;
GO

BULK INSERT dbo.sellers
FROM 'C:\Users\nirmi\Desktop\Projects\Amazon Data Analysis\Data\sellers.csv'
WITH (
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

BULK INSERT dbo.customers
FROM 'C:\Users\nirmi\Desktop\Projects\Amazon Data Analysis\Data\customers.csv'
WITH (
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

BULK INSERT dbo.products
FROM 'C:\Users\nirmi\Desktop\Projects\Amazon Data Analysis\Data\products.csv'
WITH (
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

BULK INSERT dbo.orders
FROM 'C:\Users\nirmi\Desktop\Projects\Amazon Data Analysis\Data\orders.csv'
WITH (
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

BULK INSERT dbo.reviews
FROM 'C:\Users\nirmi\Desktop\Projects\Amazon Data Analysis\Data\reviews.csv'
WITH (
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

BULK INSERT dbo.returns
FROM 'C:\Users\nirmi\Desktop\Projects\Amazon Data Analysis\Data\returns.csv'
WITH (
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

BULK INSERT dbo.transactions
FROM 'C:\Users\nirmi\Desktop\Projects\Amazon Data Analysis\Data\transactions.csv'
WITH (
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

SELECT 'sellers' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.sellers
UNION ALL
SELECT 'customers', COUNT_BIG(*) FROM dbo.customers
UNION ALL
SELECT 'products', COUNT_BIG(*) FROM dbo.products
UNION ALL
SELECT 'orders', COUNT_BIG(*) FROM dbo.orders
UNION ALL
SELECT 'reviews', COUNT_BIG(*) FROM dbo.reviews
UNION ALL
SELECT 'returns', COUNT_BIG(*) FROM dbo.returns
UNION ALL
SELECT 'transactions', COUNT_BIG(*) FROM dbo.transactions;
GO
