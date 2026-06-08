# Medallion Data Warehouse

A Microsoft SQL Server data warehouse project that implements the Medallion Architecture for retail analytics. The repository contains raw CSV source data, database initialization scripts, Bronze ingestion logic, and Silver transformation logic for customers, employees, inventory, products, returns, reviews, stores, and sales transactions.

The project is designed as a practical data engineering portfolio project: it demonstrates raw data ingestion, schema design, full-refresh loading, data quality profiling, standardization rules, and curated analytical tables.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Business Domain](#business-domain)
- [Repository Structure](#repository-structure)
- [Dataset Inventory](#dataset-inventory)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Setup and Execution](#setup-and-execution)
- [Data Pipeline Flow](#data-pipeline-flow)
- [Bronze Layer](#bronze-layer)
- [Silver Layer](#silver-layer)
- [Transformation Highlights](#transformation-highlights)
- [Data Quality Rules](#data-quality-rules)
- [Security Notes](#security-notes)
- [Roadmap](#roadmap)
- [License](#license)

## Project Overview

This project builds a retail data warehouse using a layered Medallion Architecture:

- **Bronze Layer**: Raw source-aligned tables loaded from CSV files.
- **Silver Layer**: Cleaned, standardized, and analytics-ready tables.
- **Gold Layer**: Schema is created for future business marts and reporting models.

The pipeline currently focuses on database setup, raw ingestion, and detailed Silver transformations. It uses SQL Server scripts for DDL, stored procedures, data profiling, and transformation logic.

## Architecture

```text
Raw CSV Files
     |
     v
Bronze Schema
Raw ingestion tables loaded with BULK INSERT
     |
     v
Silver Schema
Cleaned, standardized, validated domain tables
     |
     v
Gold Schema
Future business-ready marts and dashboards
```

## Business Domain

The dataset models a retail business with operational data across:

- Customer master data
- Employee and store operations
- Product catalog and supplier details
- Inventory snapshots
- Sales transactions
- Product returns
- Customer reviews

These domains support common analytics use cases such as sales performance, inventory valuation, customer segmentation, store operations, return behavior, product quality, and channel analysis.

## Repository Structure

```text
.
|-- dataset/
|   |-- raw_customers.csv
|   |-- raw_employees.csv
|   |-- raw_inventory_snapshots.csv
|   |-- raw_products.csv
|   |-- raw_returns.csv
|   |-- raw_reviews.csv
|   |-- raw_sales_transactions.csv
|   `-- raw_stores.csv
|-- script/
|   |-- init_databse.sql
|   |-- bronze/
|   |   |-- ddl_bronze.sql
|   |   `-- proc_bronze.sql
|   `-- silver/
|       |-- transform/
|       |   |-- ddl_silver.sql
|       |   `-- proc_silver.sql
|       `-- transformation/
|           |-- customers/
|           |-- employees/
|           |-- inventory/
|           |-- products/
|           |-- returns/
|           |-- reviews/
|           |-- stores/
|           `-- transactions/
|-- env_setup_command.sh
|-- SECURITY.md
|-- LICENSE
`-- README.md
```

## Dataset Inventory

| File | Domain | Approx. Rows Including Header |
| --- | --- | ---: |
| `raw_customers.csv` | Customer master data | 641 |
| `raw_employees.csv` | Employee data | 101 |
| `raw_inventory_snapshots.csv` | Inventory snapshots | 561 |
| `raw_products.csv` | Product catalog | 71 |
| `raw_returns.csv` | Return transactions | 601 |
| `raw_reviews.csv` | Customer reviews | 2,001 |
| `raw_sales_transactions.csv` | Sales order lines | 21,575 |
| `raw_stores.csv` | Store master data | 51 |

## Technology Stack

- **Database**: Microsoft SQL Server 2022
- **Runtime**: Docker
- **Language**: T-SQL
- **Data Format**: CSV
- **Optional BI Tooling**: Apache Superset command references are included in `env_setup_command.sh`

## Prerequisites

Install or prepare the following:

- Docker and Docker Compose
- SQL Server container or SQL Server instance
- SQL Server client tooling, such as `sqlcmd`, Azure Data Studio, or SQL Server Management Studio
- Permission to create databases, schemas, tables, and stored procedures
- CSV files available to the SQL Server container at the expected `/data/` path

## Setup and Execution

### 1. Start SQL Server

The repository includes setup commands in:

```text
env_setup_command.sh
```

Use it as a reference script for installing Docker, pulling the SQL Server image, creating a SQL Server container, and copying datasets into the container.

> Important: Treat credentials in setup scripts as local development placeholders. Replace them before using this project in any shared or production-like environment.

### 2. Copy Source Files Into the Container

The Bronze load procedure expects source CSV files under:

```text
/data/
```

Expected files:

```text
/data/raw_customers.csv
/data/raw_employees.csv
/data/raw_inventory_snapshots.csv
/data/raw_products.csv
/data/raw_returns.csv
/data/raw_reviews.csv
/data/raw_sales_transactions.csv
/data/raw_stores.csv
```

Example Docker copy command:

```bash
docker cp dataset sqlserver:/data
```

Depending on how the files are copied, verify that the CSV files are directly available at `/data/*.csv` inside the container.

### 3. Initialize the Database

Run the database initialization script from the `master` database:

```sql
:r script/init_databse.sql
```

This script:

- Drops and recreates `TestDB`
- Creates the `bronze` schema
- Creates the `silver` schema
- Creates the `gold` schema

Warning: this script drops the existing `TestDB` database if it exists.

### 4. Create Bronze Tables

Run:

```sql
:r script/bronze/ddl_bronze.sql
```

This creates source-aligned Bronze tables for all raw datasets.

Warning: this script drops and recreates existing Bronze tables.

### 5. Load Bronze Data

Run:

```sql
:r script/bronze/proc_bronze.sql
EXEC bronze.load_bronze;
```

The stored procedure performs a full refresh:

- Starts a transaction
- Truncates each Bronze table
- Loads each CSV using `BULK INSERT`
- Logs duration for each table
- Rolls back if any load fails

### 6. Create Silver Tables

Run:

```sql
:r script/silver/transform/ddl_silver.sql
```

This creates the Silver schema tables that receive cleaned and standardized records.

### 7. Run Silver Transformations

Silver transformation logic is organized by business domain:

```text
script/silver/transformation/<domain>/
```

Each domain folder contains:

- A profiling or transformation analysis SQL file
- A Markdown documentation file
- A load SQL file for cleaned Silver output

Use the `*_load.sql` files as the final insert/select logic for loading Silver tables.

## Data Pipeline Flow

| Step | Layer | Script | Purpose |
| --- | --- | --- | --- |
| 1 | Database | `script/init_databse.sql` | Create `TestDB` and Medallion schemas |
| 2 | Bronze | `script/bronze/ddl_bronze.sql` | Create raw ingestion tables |
| 3 | Bronze | `script/bronze/proc_bronze.sql` | Load raw CSV files into Bronze |
| 4 | Silver | `script/silver/transform/ddl_silver.sql` | Create cleaned target tables |
| 5 | Silver | `script/silver/transformation/*/*_load.sql` | Transform Bronze data into Silver tables |

## Bronze Layer

The Bronze layer stores raw operational data with minimal transformation. Its purpose is to preserve the source structure and provide a reproducible ingestion point for downstream processing.

Bronze tables:

- `bronze.customers`
- `bronze.employees`
- `bronze.inventory_snapshots`
- `bronze.products`
- `bronze.returns`
- `bronze.reviews`
- `bronze.sales_transactions`
- `bronze.stores`

Key characteristics:

- Source-aligned column names
- Lenient data types for inconsistent raw values
- Full-refresh loading strategy
- Transaction-controlled bulk ingestion
- Progress and duration logging

## Silver Layer

The Silver layer applies business rules and data quality transformations to make the data more reliable for analytics.

Silver tables:

- `silver.customers`
- `silver.employees`
- `silver.inventory_snapshots`
- `silver.products`
- `silver.returns`
- `silver.reviews`
- `silver.sales_transactions`
- `silver.stores`

The Silver layer standardizes:

- Names and textual attributes
- Emails and phone numbers
- Dates into SQL-compatible date values
- Currency and numeric fields
- Boolean and status indicators
- Product, channel, state, and category values
- Invalid or missing values into controlled defaults such as `Unknown` or `NULL`

## Transformation Highlights

### Customers

- Parses and validates customer names
- Standardizes gender values
- Cleans malformed email addresses and common domain typos
- Converts multiple date formats
- Standardizes US phone numbers
- Normalizes city, state, country, segment, and channel values

### Employees

- Extracts names from full-name fields
- Standardizes email and phone formats
- Cleans job title, department, store, salary, commission, and employment status fields
- Converts hire dates across mixed date formats
- Validates manager identifiers

### Inventory

- Converts snapshot dates
- Validates product and store identifiers
- Standardizes product names, SKUs, categories, warehouse locations
- Calculates `stock_available`
- Calculates `inventory_value`
- Cleans unit cost and unit price values

### Products

- Standardizes SKU, product, brand, category, sub-category, and department values
- Cleans price and cost fields
- Validates gross margin, weight, warranty, ratings, and review counts
- Normalizes product availability status
- Standardizes supplier country names

### Returns

- Validates return IDs and original transaction references
- Cleans customer and product attributes
- Converts return dates
- Standardizes refund amounts, methods, return channels, restock status, and notes

### Reviews

- Converts review dates
- Standardizes verified purchase flags
- Standardizes review channels
- Cleans review titles and text formatting artifacts

### Stores

- Standardizes store names, store types, addresses, cities, states, countries, regions, and districts
- Converts opened dates
- Standardizes phone numbers
- Validates square footage, employee count, rent, parking, cafe, and active status fields

### Sales Transactions

- Provides transaction-level order line data for downstream analysis
- Includes customer, product, store, employee, promotion, payment, shipping, return, cost, and profit attributes
- Supports analytical use cases such as revenue, margin, channel performance, return rate, and store performance

## Data Quality Rules

Common data quality patterns used across the project:

- `TRIM()` and case normalization for text fields
- `TRY_CONVERT()` for defensive date and numeric parsing
- `CASE` expressions for business rule standardization
- `NULL` assignment for invalid numeric identifiers and measures
- `Unknown` assignment for missing or unusable descriptive values
- Currency cleanup using `$` and comma removal
- Boolean normalization from values such as `yes`, `no`, `1`, `0`, `true`, and `false`
- US phone standardization to `+1 (AAA) BBB-CCCC`
- Date standardization from mixed regional and textual formats
- Domain-specific correction rules for known typos and inconsistent labels

## Security Notes

- Do not commit real credentials, tokens, `.env` files, or production connection strings.
- Replace local placeholder passwords before sharing or deploying.
- The setup script is intended for development reference only.
- Review `SECURITY.md` for vulnerability reporting and secret-handling guidance.

## Roadmap

Planned or recommended next improvements:

- Build Gold layer fact and dimension models
- Add stored procedure orchestration for all Silver loads
- Add row count reconciliation between Bronze and Silver
- Add data quality test queries for uniqueness, null checks, and accepted values
- Add ERD or warehouse model diagrams
- Add BI dashboards in Apache Superset
- Parameterize database names and file paths
- Move secrets into environment variables or a secure secret manager

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
