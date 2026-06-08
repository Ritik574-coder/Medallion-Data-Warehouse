--#############################################################################################
--#################################### TRANSACTION DATA #######################################
--#############################################################################################

--=============================================================================================
--================================== transactions table overview ==============================
--=============================================================================================
SELECT [transaction_id]
      ,[order_id]
      ,[order_line_number]
      ,[order_date]
      ,[order_year]
      ,[order_month]
      ,[order_month_name]
      ,[order_quarter]
      ,[order_day_of_week]
      ,[ship_date]
      ,[delivery_date]
      ,[customer_id]
      ,[customer_full_name]
      ,[customer_first_name]
      ,[customer_last_name]
      ,[customer_email]
      ,[customer_phone]
      ,[customer_city]
      ,[customer_state]
      ,[customer_zip]
      ,[customer_region]
      ,[customer_segment]
      ,[customer_gender]
      ,[customer_age]
      ,[customer_age_group]
      ,[product_id]
      ,[product_name]
      ,[sku]
      ,[brand]
      ,[category]
      ,[sub_category]
      ,[department]
      ,[quantity_ordered]
      ,[unit_list_price]
      ,[discount_pct]
      ,[unit_selling_price]
      ,[line_total_before_tax]
      ,[tax_rate_pct]
      ,[tax_amount]
      ,[line_total_with_tax]
      ,[store_id]
      ,[store_name]
      ,[store_city]
      ,[store_state]
      ,[store_region]
      ,[store_type]
      ,[employee_id]
      ,[employee_name]
      ,[employee_job_title]
      ,[promo_id]
      ,[promo_name]
      ,[sales_channel]
      ,[payment_method]
      ,[shipping_method]
      ,[order_status]
      ,[is_returned]
      ,[cost_price]
      ,[gross_profit]
      ,[data_source]
      ,[record_created_ts]
      ,[last_modified_ts]
  FROM .[bronze].[sales_transactions]
--=============================================================================================
--=============================== transaction_id cleaning overview ============================
--=============================================================================================
-- transaction_id data overview 
SELECT 
    transaction_id 
FROM bronze.sales_transactions ;

-- transaction_id data profiling 
SELECT 
      transaction_id 
FROM  bronze.sales_transactions 
WHERE transaction_id  IS NULL 
   OR transaction_id  NOT LIKE 'TXN%'
   OR transaction_id != TRIM(transaction_id)
   OR transaction_id != UPPER(transaction_id)
   OR TRIM(transaction_id) = ''
   OR LEN(TRIM(transaction_id)) < 13 ;

-- Check for duplicates in transaction_id
SELECT 
    *
FROM 
(
    SELECT 
        transaction_id,
        ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY transaction_id) as flag 
    FROM bronze.sales_transactions
) t
WHERE flag > 1 ;

-- inspect duplicate transaction_id records
SELECT *
FROM bronze.sales_transactions
WHERE transaction_id IN (
    SELECT transaction_id
    FROM bronze.sales_transactions
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
)
ORDER BY transaction_id, order_line_number;

-- final cleaning and standardization transaction_id
WITH clean_transaction_id AS 
(
    SELECT 
        *
    FROM 
        (
            SELECT 
                transaction_id,
                ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY transaction_id) as flag 
            FROM bronze.sales_transactions
        ) t
    WHERE flag = 1 
)  
SELECT 
* 
FROM clean_transaction_id ;

--=============================================================================================
--================================= order_id cleaning overview ================================
--=============================================================================================
-- order_id data overview 
SELECT 
    order_id 
FROM bronze.sales_transactions ;

-- order_id data profiling 
SELECT 
    order_id 
FROM bronze.sales_transactions 
WHERE order_id IS NULL 
   OR TRY_CONVERT(INT, order_id) IS NULL 
   OR LEN(order_id) < 5 ; 

-- duplicate check in order id 
SELECT 
    * 
FROM 
(
    SELECT 
        order_id ,
        ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY order_id) as flag
    FROM bronze.sales_transactions 
)t WHERE flag > 1 
ORDER BY flag DESC ;
 
-- final cleaning and standardization order_id
SELECT
    CASE 
        WHEN TRY_CONVERT(INT, order_id) IS NULL OR LEN(order_id) < 5 THEN NULL 
        ELSE TRY_CONVERT(INT, order_id)
    END order_id
FROM bronze.sales_transactions ;

--#############################################################################################
--#################################### TRANSACTION CLEAN DATA #################################
--#############################################################################################
WITH SalesTransaction  AS 
(
SELECT TOP 100
     TRIM(UPPER(transaction_id)) as transaction_id
    ,[order_id]
    ,[order_line_number]
    ,[order_date]
    ,[order_year]
    ,[order_month]
    ,[order_month_name]
    ,[order_quarter]
    ,[order_day_of_week]
    ,[ship_date]
    ,[delivery_date]

    ,[customer_id]
    ,TRIM(dbo.TitleCase(customer_full_name)) as customer_full_name
    ,TRIM(dbo.TitleCase(customer_first_name)) as customer_first_name
    ,TRIM(dbo.TitleCase(customer_last_name)) as customer_last_names 
    ,[customer_email]
    ,[customer_phone]
    ,[customer_city]
    ,[customer_state]
    ,[customer_zip]
    ,[customer_region]
    ,[customer_segment]
    ,[customer_gender]
    ,[customer_age]
    ,[customer_age_group]

    ,[product_id]
    ,[product_name]
    ,[sku]
    ,[brand]
    ,[category]
    ,[sub_category]
    ,[department]

    ,[quantity_ordered] 
    ,[unit_list_price]
    ,[discount_pct]
    ,[unit_selling_price]
    ,[line_total_before_tax]
    ,[tax_rate_pct]
    ,[tax_amount]
    ,[line_total_with_tax]

    ,[store_id]
    ,[store_name]
    ,[store_city]
    ,[store_state]
    ,[store_region]
    ,[store_type]

    ,[employee_id]
    ,[employee_name]
    ,[employee_job_title]

    ,[promo_id]
    ,[promo_name]
    ,[sales_channel]
    ,[payment_method]
    ,[shipping_method]
    ,[order_status]
    ,[is_returned]
    ,[cost_price]
    ,[gross_profit]
    ,[data_source]
    ,[record_created_ts]
    ,[last_modified_ts]
FROM bronze.sales_transactions 
)
SELECT
    * 
FROM SalesTransaction ;

SELECT 
    transaction_id,
    customer_id,
    full_name
FROM 
(
    SELECT 
        t.transaction_id ,
        c.customer_id,
        c.full_name,
        ROW_NUMBER() OVER(PARTITION BY t.transaction_id ORDER BY t.transaction_id) as flag
    FROM bronze.sales_transactions as t 
    INNER JOIN bronze.customers as c
    ON t.customer_id = c.customer_id 
)t WHERE flag = 1 ; 




WITH clean_transaction AS 
(
    SELECT 
    transaction_id,
    customer_id,
    full_name
FROM 
(
    SELECT TOP 100 
        t.transaction_id ,
        c.customer_id,
        c.full_name,
        ROW_NUMBER() OVER(PARTITION BY t.transaction_id ORDER BY t.transaction_id) as flag
    FROM bronze.sales_transactions as t 
    INNER JOIN bronze.customers as c
    ON t.customer_id = c.customer_id 
)t WHERE flag = 1 
)
SELECT 
    *
FROM clean_transaction ;


SELECT TOP 10 * FROM bronze.sales_transactions ;
