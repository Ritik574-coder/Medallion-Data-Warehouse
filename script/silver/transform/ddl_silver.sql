/*=============================================================================================
--====CREATING DDL FOR SILVER LAYER
===============================================================================================
purpose : 
	these script will create tables for silver table in silver schema of TestDB database .,
	if table is already created if will drop table and recreate .
	
	the script will create these following table .
        - sales_transactions
        - customers 
        - products
        - stores
        - employees
        - returns
        - reviews
        - inventory_snapshots

WARNING :
	execute these script will drop you tables if exists
	all data will permanently deleted .
	
	ensure that backup are available before executing these script .
	
Author : Ritik__
Created on : 2026-06-08
Version : 1.0
project : DataWarehouse | TestDB
schema : Silver

Environment :
	Development / Testing
	
Dependencies :
    - SQL Server Management Studio (SSMS)
=============================================================================================*/

-- Safety check to ensure we are connected to the correct database
IF DB_NAME() NOT IN ('TestDB')
BEGIN
    THROW 50000, 'Error: Not connected to TestDB database. Please switch to TestDB before running this script.', 1;
    RETURN;
END;
GO

---- Switch to TestDB database
USE TestDB;
GO

/*=============================================================
source : API | Table  : customers |schema : silver
=============================================================*/

IF OBJECT_ID('silver.customers', 'U') IS NOT NULL 
BEGIN 
    PRINT '>> dropping table silver.customers..';
    DROP TABLE silver.customers ;
END ;
GO

PRINT '>> creating table silver.customers...';
CREATE TABLE silver.customers
(
    customer_id             INT PRIMARY KEY              ,
    title                   VARCHAR(10)                  ,
    first_name              VARCHAR(50)                  ,
    last_name               VARCHAR(50)                  ,
    gender                  VARCHAR(50)                  ,
    date_of_birth           DATE                         ,
    email                   VARCHAR(200)                 ,
    phone                   VARCHAR(30)                  ,
    address                 VARCHAR(200)                 ,
    city                    VARCHAR(50)                  ,
    state_abbr              VARCHAR(10)                  ,
    state                   VARCHAR(50)                  ,
    zip_code                INT                          ,
    country                 VARCHAR(100)                 ,
    region                  VARCHAR(50)                  ,
    customer_segment        VARCHAR(50)                  ,
    loyalty_points          INT                          ,
    is_active               VARCHAR(50)                  ,
    account_created_date    DATE                         ,
    preferred_channel       VARCHAR(50)                  ,
    annual_income_usd       DECIMAL(18,2)                ,
    company                 VARCHAR(100)                 ,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
) ;
GO

/*=============================================================
source : API | Table  : employees |schema : silver
=============================================================*/
IF OBJECT_ID('silver.employees', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table silver.employees....';
    DROP TABLE silver.employees ;
END ;
GO

PRINT '>> creating silver.employees table... ' ;
CREATE TABLE silver.employees
(
    employee_id             INT PRIMARY KEY, 
    first_name              VARCHAR(50)  ,
    last_name               VARCHAR(50)  ,
    email                   VARCHAR(200) ,
    phone                   VARCHAR(30)  ,
    job_title               VARCHAR(50)  ,
    department              VARCHAR(50)  ,
    store_id                INT          ,
    store_name              VARCHAR(150) ,
    store_city              VARCHAR(100) ,
    hire_date               DATE         ,
    years_employed          INT          ,
    annual_salary_usd       INT          ,
    commission_rate_pct     FLOAT        ,
    is_active               VARCHAR(50)  ,
    performance_rating      VARCHAR(50)  ,
    manager_id              INT          ,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

/*=============================================================
source : API | Table  : inventory_snapshots |schema : silver
=============================================================*/
IF OBJECT_ID('silver.inventory_snapshots', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table silver.inventory_snapshots...';
    DROP TABLE silver.inventory_snapshots ;
END ;
GO

PRINT '>> creating silver.inventory_snapshots table... ';
CREATE TABLE silver.inventory_snapshots
(
    snapshot_date           VARCHAR(50)  ,
    product_id              INT          ,
    product_name            VARCHAR(150) ,
    sku                     VARCHAR(100) ,
    category                VARCHAR(100) ,
    stock_on_hand           INT          ,
    stock_reserved          INT          ,
    stock_available         VARCHAR(50)  ,
    reorder_level           INT          ,
    unit_cost               VARCHAR(50)  ,
    unit_price              VARCHAR(50)  ,
    inventory_value         VARCHAR(50)  ,
    warehouse_location      VARCHAR(20)  ,
    store_id                INT          
);
GO

/*=============================================================
source : API | Table  : products |schema : silver
=============================================================*/
IF OBJECT_ID('silver.products', 'U') IS NOT NULL
BEGIN
    PRINT '>> dropping table silver.products...';
    DROP TABLE silver.products ;
END ;
GO

PRINT '>> creating silver.products table... ';
CREATE TABLE silver.products
(
    product_id              INT          ,
    sku                     VARCHAR(100) ,
    product_name            VARCHAR(200) ,
    brand                   VARCHAR(100) ,
    category                VARCHAR(100) ,
    sub_category            VARCHAR(100) ,
    department              VARCHAR(100) ,
    base_price_usd          VARCHAR(50)  ,
    cost_price_usd          VARCHAR(50)  ,
    gross_margin_pct        FLOAT        ,
    weight_kg               FLOAT        ,
    is_available            VARCHAR(50)  ,
    stock_quantity          INT          ,
    reorder_level           INT          ,
    supplier_name           VARCHAR(150) ,
    supplier_country        VARCHAR(100) ,
    warranty_years          INT          ,
    rating_avg              FLOAT        ,
    review_count            INT          ,
    launched_date           VARCHAR(50)  ,
    product_url             VARCHAR(255)    
);
GO

/*=============================================================
source : API | Table  : returns |schema : silver
=============================================================*/
IF OBJECT_ID('silver.returns', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table silver.returns....' ;
    DROP TABLE silver.returns ;
END ;
GO

PRINT 'creating table silver.returns' ;
CREATE TABLE silver.returns
(  
    return_id               INT          ,  
    original_txn_id         VARCHAR(50)  ,  
    original_order_id       INT          ,  
    customer_id             INT          ,  
    customer_name           VARCHAR(100) ,  
    product_id              INT          ,  
    product_name            VARCHAR(100) ,  
    quantity_returned       INT          ,  
    return_date             VARCHAR(50)  ,  
    return_reason           VARCHAR(50)  ,  
    refund_amount           VARCHAR(50)  ,  
    refund_method           VARCHAR(50)  ,  
    return_channel          VARCHAR(50)  ,  
    restocked               VARCHAR(50)  ,  
    return_status           VARCHAR(50)  ,  
    handled_by_emp_id       INT          ,  
    notes                   VARCHAR(100)     
);
GO

/*=============================================================
source : API | Table  : reviews |schema : silver
=============================================================*/
IF OBJECT_ID('silver.reviews', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table silver.reviews....' ;
    DROP TABLE silver.reviews ;
END ;
GO

PRINT 'creating table silver.reviews' ;
CREATE TABLE silver.reviews
(
    review_id               INT          ,
    txn_id                  VARCHAR(100) ,
    customer_id             INT          ,
    customer_name           VARCHAR(100) ,
    product_id              INT          ,
    product_name            VARCHAR(150) ,
    rating                  INT          ,
    rating_text             VARCHAR(50)  ,
    review_date             VARCHAR(50)  ,
    verified_purchase       VARCHAR(50)  ,
    helpful_votes           INT          ,
    review_channel          VARCHAR(50)  ,
    review_title            VARCHAR(100)  
);
GO

/*=============================================================
source : API | Table  : sales_transactions |schema : silver
=============================================================*/
IF OBJECT_ID('silver.sales_transactions', 'U') IS NOT NULL
BEGIN
    PRINT '>> dropping table silver.sales_transactions...';
    DROP TABLE silver.sales_transactions;
END ;
GO

PRINT 'creating table silver.sales_transactions' ;
CREATE TABLE silver.sales_transactions
(
    transaction_id          VARCHAR(100)  NULL,
    order_id                INT           NULL,
    order_line_number       INT           NULL,
    order_date              VARCHAR(50)   NULL,
    order_year              INT           NULL,
    order_month             INT           NULL,
    order_month_name        VARCHAR(50)   NULL,
    order_quarter           VARCHAR(50)   NULL,
    order_day_of_week       VARCHAR(50)   NULL,
    ship_date               VARCHAR(50)   NULL,
    delivery_date           VARCHAR(50)   NULL,
    customer_id             INT           NULL,
    customer_full_name      VARCHAR(50)   NULL,
    customer_first_name     VARCHAR(50)   NULL,
    customer_last_name      VARCHAR(50)   NULL,
    customer_email          VARCHAR(50)   NULL,
    customer_phone          VARCHAR(50)   NULL,
    customer_city           VARCHAR(50)   NULL,
    customer_state          VARCHAR(50)   NULL,
    customer_zip            INT           NULL,
    customer_region         VARCHAR(100)  NULL,
    customer_segment        VARCHAR(100)  NULL,
    customer_gender         VARCHAR(50)   NULL,
    customer_age            INT           NULL,
    customer_age_group      VARCHAR(50)   NULL,
    product_id              INT           NULL,
    product_name            VARCHAR(50)   NULL,
    sku                     VARCHAR(50)   NULL,
    brand                   VARCHAR(50)   NULL,
    category                VARCHAR(50)   NULL,
    sub_category            VARCHAR(50)   NULL,
    department              VARCHAR(50)   NULL,
    quantity_ordered        INT           NULL,
    unit_list_price         VARCHAR(50)   NULL,
    discount_pct            FLOAT         NULL,
    unit_selling_price      VARCHAR(50)   NULL,
    line_total_before_tax   VARCHAR(50)   NULL,
    tax_rate_pct            FLOAT         NULL,
    tax_amount              VARCHAR(50)   NULL,
    line_total_with_tax     VARCHAR(50)   NULL,
    store_id                INT           NULL,
    store_name              VARCHAR(50)   NULL,
    store_city              VARCHAR(50)   NULL,
    store_state             VARCHAR(50)   NULL,
    store_region            VARCHAR(50)   NULL,
    store_type              VARCHAR(50)   NULL,
    employee_id             INT           NULL,
    employee_name           VARCHAR(100)  NULL,
    employee_job_title      VARCHAR(100)  NULL,
    promo_id                INT           NULL,
    promo_name              VARCHAR(50)   NULL,
    sales_channel           VARCHAR(50)   NULL,
    payment_method          VARCHAR(50)   NULL,
    shipping_method         VARCHAR(50)   NULL,
    order_status            VARCHAR(50)   NULL,
    is_returned             VARCHAR(50)   NULL,
    cost_price              VARCHAR(50)   NULL,
    gross_profit            VARCHAR(50)   NULL,
    data_source             VARCHAR(50)   NULL,
    record_created_ts       DATETIME2     NULL,
    last_modified_ts        DATETIME2     NULL
);
GO

/*=============================================================
source : API | Table  : stores |schema : silver
=============================================================*/
IF OBJECT_ID('silver.stores', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table silver.stores' ;
    DROP TABLE silver.stores ;
END ;
GO 

PRINT '>> creating table silver.stores....';

CREATE TABLE silver.stores
(
    store_id                INT          ,
    store_name              VARCHAR(100) ,
    store_type              VARCHAR(50)  ,
    address                 VARCHAR(50)  ,
    city                    VARCHAR(50)  ,
    state                   VARCHAR(50)  ,
    state_full              VARCHAR(50)  ,
    zip_code                INT          ,
    country                 VARCHAR(50)  ,
    region                  VARCHAR(50)  ,
    district                VARCHAR(50)  ,
    phone                   VARCHAR(50)  ,
    manager_name            VARCHAR(50)  ,
    opened_date             VARCHAR(50)  ,
    sq_footage              INT          ,
    num_employees           INT          ,
    annual_rent_usd         INT          ,
    is_active               VARCHAR(50)  ,
    has_parking             VARCHAR(50)  ,
    has_cafe                VARCHAR(50)   
);
GO