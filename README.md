# Amazon India Store Sales Analysis

An end-to-end data analyst portfolio project analyzing a simulated Amazon India e-commerce dataset across sales, customers, products, returns, sellers, payments, and reviews.

## Project objective

Build a reliable reporting workflow that:

- validates data quality before reporting;
- analyzes revenue, customer, product, return, seller, payment, and delivery performance;
- models the data in Microsoft SQL Server; and
- presents the results in an interactive Power BI dashboard.

## Technology stack

- Python: basic data inspection, cleaning support, and EDA
- Microsoft SQL Server: schema, relationships, validation, and business analysis
- Power BI: interactive dashboard connected directly to SQL Server

## Workflow

```text
Amazon India source dataset
        ↓
SQL Server schema and seed data
        ↓
Cleaning and validation checks
        ↓
Business analysis queries
        ↓
Power BI dashboard connected to SQL Server
```

The original project brief used MySQL files named `Cleaning.sql` and `Analysis.sql`. This project uses SQL Server equivalents:

- [SQL Server dataset and schema](./amazon_india_store_dataset.sql)
- [Cleaning and validation checks](./sqlserver/03_validation.sql)
- [Business analysis queries](./sqlserver/05_analysis.sql)
- [Power BI dashboard](./Amazon_India_Sales_Dashboard.pbix)

## Data model

The database contains seven core tables:

| Table | Purpose |
|---|---|
| `customers` | Customer profile, location, and Prime membership |
| `products` | Product listings, prices, GST, ratings, and stock |
| `sellers` | Seller profile, fulfillment, rating, and account health |
| `orders` | Order, quantity, shipping, discount, tax, and total values |
| `returns` | Return requests, reasons, and refund amounts |
| `transactions` | Payment method, payment status, and refund information |
| `reviews` | Customer ratings, review text, and verified-purchase details |

## Data-quality workflow

The validation stage follows the original project brief:

1. Duplicate and integrity checks
2. NULL and missing-value checks
3. Business-logic inconsistencies
4. Price and financial anomalies
5. Outlier and range validation
6. Formatting and standardization

Examples include validating order totals, dates, GST, discounts, refunds, payment links, return records, customer contact formats, seller health, and review votes.

## Business analysis

The SQL analysis covers:

1. Sales and revenue: KPIs, monthly trends, categories, and top products
2. Customer behavior: Prime vs non-Prime, top customers, cities, and repeat buyers
3. Product performance: ratings, margins, and quality-risk products
4. Returns and refunds: category return rates, reasons, refunds, and customers with returns
5. Seller performance: seller revenue, quantity, health, and return rate
6. Payments and orders: payment revenue, order status, delivery time, and COD by city

## Verified headline metrics

| Metric | Result |
|---|---:|
| Total orders | 2,100 |
| Total revenue | ₹19,913,711.01 |
| Average order value | ₹9,482.72 |
| Units sold | 6,201 |
| Customers | 320 |
| Products | 180 |
| Sellers | 75 |
| Returns | 420 |
| Transactions | 2,100 |
| Reviews | 1,850 |

## Example business findings

- Repeat buyers generated ₹19.55M across 2,069 orders, while one-time buyers generated ₹0.36M across 31 orders.
- Prime customers generated ₹10.43M across 1,083 orders; non-Prime customers generated ₹9.49M across 1,017 orders.
- Cash on Delivery was the largest payment method by revenue at approximately ₹3.04M.
- `Missing Parts` was the most frequent return reason and represented ₹0.55M in associated order value.
- Seller performance varies materially by account health, return rate, seller rating, and on-time shipping.
- The dashboard and SQL Server KPI totals were reconciled before reporting.

These findings are descriptive observations from the simulated dataset, not claims about Amazon's real business.

## Power BI dashboard

The dashboard is connected directly to SQL Server and contains six pages:

- Executive Sales Overview
- Customer Behavior
- Product Performance
- Seller Performance
- Operations & Delivery
- Seller Risk Analysis

It includes KPI cards, revenue trends, category and product rankings, buyer segmentation, return analysis, payment analysis, delivery analysis, seller-risk visuals, and slicers created for the relevant pages.

## Reproducing the project

1. Open SQL Server Management Studio.
2. Execute [amazon_india_store_dataset.sql](./amazon_india_store_dataset.sql) to create and populate the database.
3. Execute [03_validation.sql](./sqlserver/03_validation.sql) and review the validation results.
4. Execute [05_analysis.sql](./sqlserver/05_analysis.sql) for the business-analysis result sets.
5. Open [Amazon_India_Sales_Dashboard.pbix](./Amazon_India_Sales_Dashboard.pbix).
6. Refresh the SQL Server connection if required.

## Portfolio deliverables

- SQL Server schema and populated relational database
- Data-quality and validation queries
- Business-analysis SQL queries
- Power BI dashboard
- Python cleaning, EDA, and diagnostic-analysis notebooks under [Data/amazon_india_project/notebooks](./Data/amazon_india_project/notebooks)
- Supporting cleaned CSV tables and quality reports under [Data/amazon_india_project](./Data/amazon_india_project)

## Python notebooks

The Python work is deliberately kept interview-friendly:

- [01_data_cleaning.ipynb](./Data/amazon_india_project/notebooks/01_data_cleaning.ipynb): inspect the seven tables, standardize dates and flags, validate keys and business rules, and export analysis-ready CSVs.
- [02_eda.ipynb](./Data/amazon_india_project/notebooks/02_eda.ipynb): calculate KPIs, monthly revenue, category performance, Prime behavior, buyer segments, and return reasons.
- [03_diagnostic_analysis.ipynb](./Data/amazon_india_project/notebooks/03_diagnostic_analysis.ipynb): explain the drivers behind the descriptive results using category concentration, repeat-buyer contribution, return reasons, payment mix, and seller risk.

The notebooks are supporting analysis artifacts. The Power BI dashboard continues to use the SQL Server database directly.

## Resume bullet points

- Built an end-to-end Amazon India sales analytics project using Python, Microsoft SQL Server, and Power BI across 7 normalized tables and 2,100 orders.
- Developed SQL validation and business-analysis workflows covering revenue, customer behavior, product performance, returns, sellers, payments, and delivery operations.
- Created and reconciled a six-page Power BI dashboard with KPI cards, trends, segmentation, return analysis, seller-risk visuals, and interactive slicers.
