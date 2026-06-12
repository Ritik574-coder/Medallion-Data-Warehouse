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
    employee_id             INT PRIMARY KEY            , 
    first_name              VARCHAR(50)                ,
    last_name               VARCHAR(50)                ,
    email                   VARCHAR(200)               ,
    phone                   VARCHAR(30)                ,
    job_title               VARCHAR(50)                ,
    department              VARCHAR(50)                ,
    store_id                INT                        ,
    store_name              VARCHAR(150)               ,
    store_city              VARCHAR(100)               ,
    hire_date               DATE                       ,
    years_employed          DECIMAL(4,2)               ,
    annual_salary_usd       DECIMAL(18,2)              ,
    commission_rate_pct     DECIMAL(4,2)               ,
    is_active               VARCHAR(10)                ,
    performance_rating      VARCHAR(50)                ,
    manager_id              INT                        ,
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
    snapshot_date           DATE                        ,
    product_id              INT                         ,
    product_name            VARCHAR(150)                ,
    sku                     VARCHAR(100)                ,
    category                VARCHAR(100)                ,
    stock_on_hand           INT                         ,
    stock_reserved          INT                         ,
    stock_available         INT                         ,
    reorder_level           INT                         ,
    unit_cost               DECIMAL(10, 2)              ,
    unit_price              DECIMAL(10, 2)              ,
    inventory_value         DECIMAL(18, 2)              ,
    warehouse_location      VARCHAR(20)                 ,
    store_id                INT                         ,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()        
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
    product_id              INT PRIMARY KEY            ,
    sku                     VARCHAR(100)               ,
    product_name            VARCHAR(200)               ,
    brand                   VARCHAR(100)               ,
    category                VARCHAR(100)               ,
    sub_category            VARCHAR(100)               ,
    department              VARCHAR(100)               ,
    base_price_usd          DECIMAL(10, 2)             ,
    cost_price_usd          DECIMAL(10, 2)             ,
    gross_margin_pct        DECIMAL(5, 1)              ,
    weight_kg               DECIMAL(5, 2)              ,
    is_available            VARCHAR(20)                ,
    stock_quantity          INT                        ,
    reorder_level           INT                        ,
    supplier_name           VARCHAR(150)               ,
    supplier_country        VARCHAR(100)               ,
    warranty_years          INT                        ,
    rating_avg              DECIMAL(3, 1)              ,
    review_count            INT                        ,
    launched_date           DATE                       ,
    product_url             VARCHAR(255)               ,
    dwh_create_date         DATETIME2 DEFAULT GETDATE() 
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
    return_id               INT PRIMARY KEY             ,  
    original_txn_id         VARCHAR(50)                 ,  
    original_order_id       INT                         ,  
    customer_id             INT                         ,  
    customer_name           VARCHAR(100)                ,  
    product_id              INT                         ,  
    product_name            VARCHAR(100)                ,  
    quantity_returned       INT                         ,  
    return_date             DATE                        ,  
    return_reason           VARCHAR(50)                 ,  
    refund_amount           DECIMAL(10,2)               ,  
    refund_method           VARCHAR(50)                 ,  
    return_channel          VARCHAR(50)                 ,  
    restocked               VARCHAR(50)                 ,  
    return_status           VARCHAR(50)                 ,  
    handled_by_emp_id       INT                         ,  
    notes                   VARCHAR(100)                ,   
    dwh_create_date         DATETIME2 DEFAULT GETDATE()  
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
    review_id               INT PRIMARY KEY             ,
    txn_id                  VARCHAR(100)                ,
    customer_id             INT                         ,
    customer_name           VARCHAR(100)                ,
    product_id              INT                         ,
    product_name            VARCHAR(150)                ,
    rating                  INT                         ,
    rating_text             VARCHAR(50)                 ,
    review_date             DATE                        ,
    verified_purchase       VARCHAR(20)                 ,
    helpful_votes           INT                         ,
    review_channel          VARCHAR(50)                 ,
    review_title            VARCHAR(100)                ,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()  
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
    transaction_id         VARCHAR(30),
    order_id               INT,
    customer_id            INT,
    product_id             INT,
    store_id               INT,
    employee_id            INT,

    promo_id               INT,
    promo_name             VARCHAR(100),

    sales_channel          VARCHAR(50),
    payment_method         VARCHAR(50),
    shipping_method        VARCHAR(50),
    order_status           VARCHAR(50),
    is_returned            VARCHAR(10),
    data_source            VARCHAR(20),

    order_line_number      TINYINT,
    quantity_ordered       INT,

    unit_list_price        DECIMAL(10,2),
    discount_pct           INT,
    unit_selling_price     DECIMAL(10,2),

    line_total_before_tax  DECIMAL(12,2),
    tax_rate_pct           INT,
    tax_amount             DECIMAL(12,2),
    line_total_with_tax    DECIMAL(12,2),

--    cost_price             DECIMAL(10,2),
--    gross_profit           DECIMAL(12,2),

    order_date             DATE,
    ship_date              DATE,
    delivery_date          DATE,

    record_created         DATE,
    last_modified          DATE
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
    store_id                INT PRIMARY KEY         ,
    store_name              VARCHAR(100)            ,
    store_type              VARCHAR(50)             ,
    address                 VARCHAR(50)             ,
    city                    VARCHAR(50)             ,
    state                   VARCHAR(50)             ,
    state_full              VARCHAR(50)             ,
    zip_code                INT                     ,
    country                 VARCHAR(50)             ,
    region                  VARCHAR(50)             ,
    district                VARCHAR(50)             ,
    phone                   VARCHAR(50)             ,
    manager_name            VARCHAR(50)             ,
    opened_date             DATE                    ,
    sq_footage              INT                     ,
    num_employees           INT                     ,
    annual_rent_usd         INT                     ,
    is_active               VARCHAR(10)             ,
    has_parking             VARCHAR(10)             ,
    has_cafe                VARCHAR(10)             ,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()  
);
GO