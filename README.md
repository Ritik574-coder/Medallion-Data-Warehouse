# 🏛️ Medallion Data Warehouse 

A Microsoft SQL Server data warehouse project that implements the Medallion Architecture for retail analytics. The repository contains raw CSV source data, database initialization scripts, Bronze ingestion logic, and Silver transformation logic for customers, employees, inventory, products, returns, reviews, stores, and sales transactions.

The project is designed as a practical data engineering portfolio project: it demonstrates raw data ingestion, schema design, full-refresh loading, data quality profiling, standardization rules, and curated analytical tables.

## Project Overview

### Goal
The **Medallion-Data-Warehouse** project implements a modern data architecture for a retail domain using the Medallion Pattern (Bronze → Silver → Gold layers). The project provides a fully containerized SQL Server environment with automated data ingestion, transformation, and business-ready analytics.

### Architecture
- **Pattern**: Three-layer Medallion Architecture (raw → cleansed → refined)
- **Technology Stack**: Microsoft SQL Server 2022, T-SQL, Docker/Docker Compose, CSV ingestion
- **Scope**: Retail enterprise data (8 core entities: customers, employees, products, stores, inventory, sales, returns, reviews)

### Medallion Design Implementation
1. **Bronze Layer**: Raw data ingestion from source files with minimal transformation, source-aligned schema
2. **Silver Layer**: Cleaned, standardized data with applied business rules, defensive parsing, and data quality enforcement
3. **Gold Layer**: Business-ready analytics models and reporting dimensions (currently in development)

The pipeline currently focuses on database setup, raw ingestion, and detailed Silver transformations and data modeling . It uses SQL Server scripts for DDL, stored procedures, data profiling, and transformation and business logic and more.....

## Architecture

![Data Flow Diagram](https://github.com/Ritik574-coder/Medallion-Data-Warehouse/blob/main/docs/data_architecture.png)

## Business Domain

The dataset models a retail business with operational data across:

- Customer master data
- Employee and store operations
- Product catalog and supplier details
- Inventory snapshots
- Sales transactions
- Product returns
- Customer reviews

These domains support analytics use cases such as sales performance, inventory valuation, customer segmentation, store operations, return behavior, product quality, and channel analysis.

## 🧩 Entity Relationship Diagram (ERD)

![Entity Relationship Diagram](https://github.com/Ritik574-coder/Medallion-Data-Warehouse/blob/main/docs/Screencast%20from%202026-06-13%2010-24-36.gif)

## Architecture Assessment

#### Strengths
1. **Modern Medallion Pattern**: Three-layer architecture enables separation of concerns (raw ingestion → transformation → analytics)
2. **Data Quality Foundation**: Comprehensive transformation documentation with defensive parsing patterns
3. **Containerization**: Docker-based environment eliminates "works on my machine" issues
4. **Scalability Ready**: Table structures support future growth; BULK INSERT scales to larger datasets
5. **Community-Ready Infrastructure**: Contributing guidelines, code of conduct, PR/issue templates in place
6. **Defensive SQL Patterns**: TRY_CONVERT(), CASE-based transformations, NULL handling demonstrate mature practices


### Repository Strengths
✅ **Well-Structured** — Clear separation of Bronze/Silver/Gold layers  
✅ **Data Quality Focused** — Comprehensive transformation documentation  
✅ **Developer-Friendly** — Containerized setup, clear directory organization  
✅ **Community Ready** — Established governance (COC, security policy, contributing guide)  
✅ **Retail Domain Knowledge** — Realistic business rules (email standardization, phone formatting, geographic normalization)  


## Project Structure

```text
Medallion-Data-Warehouse/
│
├── .github/                                    # GitHub automation and community management
│   ├── ISSUE_TEMPLATE/                         # Issue templates for contributors
│   │   ├── bug_report.yml                      # Bug reporting template
│   │   ├── docs_improvement.yml                # Documentation improvement template
│   │   └── feature_request.yml                 # Feature request template
│   │
│   ├── PULL_REQUEST_TEMPLATE.md                # Standard pull request template
│   │
│   └── workflows/
│       └── pr-agent.yml                        # Automated PR review workflow
│
├── .qodo/                                      # Qodo AI configuration
│   ├── agents/                                 # AI agent definitions
│   └── workflows/                              # AI workflow definitions
│
├── dataset/                                    # Source datasets
│   ├── raw_customers.csv                       # Customer master dataset
│   ├── raw_employees.csv                       # Employee master dataset
│   ├── raw_inventory_snapshots.csv             # Inventory snapshot dataset
│   ├── raw_products.csv                        # Product catalog dataset
│   ├── raw_returns.csv                         # Product returns dataset
│   ├── raw_reviews.csv                         # Customer reviews dataset
│   ├── raw_sales_transactions.csv              # Sales transaction dataset
│   └── raw_stores.csv                          # Store master dataset
│
├── docs/                                       # Project documentation assets
|   ├──PROJECT_STRUCTURE.md                     # All info about this project 
│   ├── data_architecture.png                   # Medallion architecture diagram
│   ├── digram.png                              # Project walkthrough demo
│   └── Screencast.gif                          # Data model / relationship diagram
│                                               
│
├── script/                                     # Core data warehouse implementation
│   │
│   ├── init_databse.sql                        # Database and schema initialization
│   │
│   ├── bronze/                                 # Bronze layer (raw ingestion)
│   │   ├── ddl_bronze.sql                      # Bronze table definitions
│   │   └── proc_bronze.sql                     # Bronze data loading procedures
│   │
│   ├── silver/                                 # Silver layer (cleansing & standardization)
│   │   │
│   │   ├── transform/
│   │   │   ├── ddl_silver.sql                  # Silver table definitions
│   │   │   └── proc_silver.sql                 # Silver transformation procedures
│   │   │
│   │   └── transformation/
│   │
│   │       ├── customers/
│   │       │   ├── customers.sql               # Customer transformation rules
│   │       │   ├── customers_load.sql          # Customer load process
│   │       │   └── customers.md                # Customer transformation documentation
│   │       │
│   │       ├── employees/
│   │       │   ├── employees.sql               # Employee transformation rules
│   │       │   ├── employees_load.sql          # Employee load process
│   │       │   └── employees.md                # Employee transformation documentation
│   │       │
│   │       ├── inventory/
│   │       │   ├── inventory.sql               # Inventory transformation rules
│   │       │   ├── inventory_load.sql          # Inventory load process
│   │       │   └── inventory.md                # Inventory transformation documentation
│   │       │
│   │       ├── products/
│   │       │   ├── product.sql                 # Product transformation rules
│   │       │   ├── products_load.sql           # Product load process
│   │       │   └── product.md                  # Product transformation documentation
│   │       │
│   │       ├── returns/
│   │       │   ├── return.sql                  # Returns transformation rules
│   │       │   ├── returns_load.sql            # Returns load process
│   │       │   └── return.md                   # Returns transformation documentation
│   │       │
│   │       ├── reviews/
│   │       │   ├── reviews.sql                 # Reviews transformation rules
│   │       │   ├── reviews_load.sql            # Reviews load process
│   │       │   └── reviews.md                  # Reviews transformation documentation
│   │       │
│   │       ├── stores/
│   │       │   ├── stores.sql                  # Stores transformation rules
│   │       │   ├── stores_load.sql             # Stores load process
│   │       │   └── stores.md                   # Stores transformation documentation
│   │       │
│   │       └── transactions/
│   │           ├── transactions.sql            # Core transaction transformations
│   │           ├── transaction_cleaning.sql    # Transaction data quality rules
│   │           ├── transaction_date.sql        # Transaction date handling logic
│   │           ├── transctions_load.sql        # Transaction load process
│   │           └── transactions.md             # Transaction transformation documentation
│   │
│   └── gold/                                   # Gold layer (analytics & reporting)
│       └── ddl_gold.sql                        # Gold layer table definitions
│
├── .gitignore                                  # Git ignore rules
├── README.md                                   # Project overview and setup guide
├── LICENSE                                     # Open-source license
├── CHANGELOG.md                                # Release history
├── CONTRIBUTING.md                             # Contribution guidelines
├── CODE_OF_CONDUCT.md                          # Community standards
├── SECURITY.md                                 # Security policy
│
├── docker-compose.yml                          # SQL Server container configuration
└── env_setup_command.sh                        # Automated environment setup
```

## Technology Stack

- **Database**: Microsoft SQL Server 2022
- **Runtime**: Docker
- **Language**: T-SQL
- **Data Format**: CSV
- **Optional BI Tooling**: Apache Superset 

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

## Roadmap

My Planned to next improvements:

- Add row count reconciliation between Bronze and Silver
- Add data quality test queries for uniqueness, null checks, and accepted values
- Add BI dashboards in Apache Superset
- Parameterize database names and file paths
- Move secrets into environment variables or a secure secret manager

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
