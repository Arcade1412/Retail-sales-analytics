# SQL Analysis

This folder contains the SQL scripts used for data preparation, validation, transformation, exploratory analysis, business analysis, and reporting in the Retail Sales Analytics project.

## SQL Workflow

The SQL analysis follows a structured workflow:

1. Create and prepare the database tables
2. Validate and clean the source data
3. Establish table relationships and foreign keys
4. Perform exploratory and business-focused analysis
5. Analyze sales, customers, products, and marketing channels
6. Develop executive KPIs
7. Create reusable SQL views for reporting and Power BI

## Analysis Areas

- Data validation and quality checks
- Data cleaning and transformation
- Sales and revenue analysis
- Profitability analysis
- Customer behavior and customer value
- Product performance
- Marketing channel performance
- Geographic performance
- Executive KPI analysis
- Business-focused aggregations
- Reusable reporting views

## SQL Techniques Demonstrated

The scripts demonstrate practical SQL techniques including:

- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`
- Aggregate functions such as `SUM`, `AVG`, `COUNT`, `MIN`, and `MAX`
- `CASE WHEN` business logic
- `JOIN` operations
- Common Table Expressions (CTEs)
- Subqueries
- Window functions
- Ranking and segmentation
- Date-based analysis
- Data validation and quality checks
- Data transformation
- Conditional aggregations
- Foreign key relationships
- SQL views
- KPI calculations

## Script Structure

| Script | Purpose |
|---|---|
| `02_create_tables.sql` | Database and table creation |
| `06_Data_Validation_And_Cleaning.sql` | Data quality checks, validation, and cleaning |
| `07_Executive_KPI_Analysis.sql` | Executive-level KPI analysis |
| `08_Customer_Analysis.sql` | Customer behavior and value analysis |
| `09_Product_Analysis.sql` | Product performance and profitability |
| `10_Sales_Analysis.sql` | Sales performance and revenue analysis |
| `11_Marketing_Analysis.sql` | Marketing channel performance |
| `12_Add_Foreign_Keys.sql` | Table relationships and referential integrity |
| `13_Create_Views.sql` | Reusable SQL views for reporting and Power BI |

## Business Questions Addressed

The SQL analysis is designed to answer questions such as:

- What are the key drivers of sales and profitability?
- Which products generate the highest and lowest contribution?
- Which customers and customer segments provide the most value?
- Which marketing channels perform best?
- How does performance vary across geographic markets?
- What KPIs should management monitor regularly?
- Which analytical outputs can be converted into reusable reporting views?

## SQL → Power BI Integration

The final SQL outputs provide a structured analytical layer for the Power BI dashboard.

SQL is used to prepare and analyze the data, while Power BI is used to build the data model, create DAX measures, develop KPIs, and present the findings through interactive dashboards.

## Skills Demonstrated

**SQL:** Data preparation, data cleaning, validation, joins, CTEs, window functions, aggregations, business logic, views, and analytical querying.

**Business Intelligence:** Translating SQL analysis into reporting-ready datasets, KPIs, and Power BI dashboards.

**Business Analysis:** Converting transactional data into actionable insights across sales, customers, products, marketing, and geography.
