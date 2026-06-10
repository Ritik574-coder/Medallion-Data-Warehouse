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

      ,[customer_id]          -- customer 
      ,[customer_full_name]   -- customer
      ,[customer_first_name]  -- customer
      ,[customer_last_name]   -- customer
      ,[customer_email]       -- customer
      ,[customer_phone]       -- customer
      ,[customer_city]        -- customer
      ,[customer_state]       -- customer
      ,[customer_zip]         -- customer
      ,[customer_region]      -- custoemr
      ,[customer_segment]     -- customer
      ,[customer_gender]      -- customer
      ,[customer_age]         -- customer
      ,[customer_age_group]   -- customer

      ,[product_id]           -- product
      ,[product_name]         -- prodcut
      ,[sku]                  -- product
      ,[brand]                -- product
      ,[category]             -- product
      ,[sub_category]         -- product
      ,[department]           -- product
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


--#############################################################################################
--#################################### TRANSACTION CLEAN DATA #################################
--#############################################################################################
SELECT st.transaction_id
      ,st.order_id
      ,st.order_line_number
      ,st.order_date
      ,st.order_year
      ,st.order_month
      ,st.order_month_name
      ,st.order_quarter
      ,st.order_day_of_week
      ,st.ship_date
      ,st.delivery_date

      ,st.customer_id     as customer_id          -- customer 
      ,c.first_name       as customer_first_name  -- customer
      ,c.last_name        as customer_last_name   -- customer
      ,c.email            as customer_email       -- customer
      ,c.phone            as customer_phone       -- customer
      ,c.city             as customer_city        -- customer
      ,c.state            as customer_state       -- customer
      ,c.zip_code         as customer_zip         -- customer
      ,c.region           as customer_region      -- custoemr
      ,c.customer_segment as customer_segment     -- customer
      ,c.gender           as customer_gender      -- customer
      ,c.date_of_birth    as birth_date           -- customer

      ,st.product_id                              -- product
      ,P.product_name as product_name             -- prodcut
      ,P.sku          as prodcut_sku              -- product
      ,P.brand        as prodcut_brand            -- product
      ,P.category     as prodcut_category         -- product
      ,P.sub_category as prodcut_sub_category     -- product
      ,P.department   as prodcut_department       -- product

      ,st.quantity_ordered     
      ,st.unit_list_price      
      ,st.discount_pct         
      ,st.unit_selling_price   
      ,st.line_total_before_tax
      ,st.tax_rate_pct
      ,st.tax_amount
      ,st.line_total_with_tax

      ,s.store_id   as store_id                  -- store
      ,s.store_name as store_name                -- store
      ,s.city       as store_city                -- store   
      ,s.state_full as store_state               -- store    
      ,s.region     as store_region              -- store   
      ,s.store_type as store_type                -- store   

      ,st.employee_id                            -- employees
      ,CONCAT(e.first_name,
       ' ',
        e.last_name
        ) as employee_name                       -- employees 
      ,e.job_title as employee_job_title         -- employees 

      ,st.promo_id
      ,st.promo_name
      ,st.sales_channel
      ,st.payment_method
      ,st.shipping_method
      ,st.order_status
      ,st.is_returned
      ,st.cost_price
      ,st.gross_profit
      ,st.data_source
      ,st.record_created_ts
      ,st.last_modified_ts
FROM .bronze.sales_transactions as st 
LEFT JOIN silver.customers as c  
ON st.customer_id = c.customer_id 
LEFT JOIN silver.stores AS s
ON st.store_id = s.store_id 
LEFT JOIN silver.employees as e  
ON st.employee_id = e.employee_id 
LEFT JOIN silver.products as p  
ON st.product_id = p.product_id 
; 


--#############################################################################################
--#################################### TRANSACTION CLEAN DATA #################################
--#############################################################################################
SELECT 
       st.transaction_id
      ,st.order_id
      ,st.customer_id
      ,st.product_id 
      ,st.store_id 
      ,st.employee_id 
      ,st.promo_id

      ,st.promo_name
      ,st.sales_channel
      ,st.payment_method
      ,st.shipping_method
      ,st.order_status
      ,st.is_returned
      
      ,st.order_line_number
      ,st.quantity_ordered     
      ,st.unit_list_price      
      ,st.discount_pct         
      ,st.unit_selling_price   
      ,st.line_total_before_tax
      ,st.tax_rate_pct
      ,st.tax_amount
      ,st.line_total_with_tax

      ,st.data_source
      ,st.cost_price
      ,st.gross_profit


      ,st.order_date
      ,st.order_year
      ,st.order_month
      ,st.order_month_name
      ,st.order_quarter
      ,st.order_day_of_week
      ,st.ship_date
      ,st.delivery_date
      ,st.record_created_ts
      ,st.last_modified_ts
FROM .bronze.sales_transactions as st 
; 

--#############################################################################################
--####################################### ID'S VALIDATION  ####################################
--#############################################################################################
-- transaction and foreign key null validation
SELECT 
      transaction_id,
      order_id,
      customer_id,
      product_id,
      store_id,
      employee_id,
      promo_id
FROM bronze.sales_transactions 
WHERE transaction_id IS NULL
OR order_id IS NULL
OR customer_id IS NULL
OR product_id IS NULL
OR store_id IS NULL
OR employee_id IS NULL; 

-- customer foreign key validation
SELECT 
      st.customer_id,
      c.customer_id as customer_id_silver
FROM bronze.sales_transactions st 
LEFT JOIN silver.customers c
ON st.customer_id = c.customer_id
WHERE st.customer_id IS NULL
OR c.customer_id IS NULL;

-- customer orphan key validation
SELECT 
      st.customer_id
FROM bronze.sales_transactions as st 
WHERE st.customer_id IS NOT NULL 
AND NOT EXISTS(
      SELECT 1 FROM silver.customers c
      WHERE st.customer_id = c.customer_id
) ;

-- product foreign key validation
SELECT 
      st.product_id,
      p.product_id as product_id_silver
FROM bronze.sales_transactions st 
LEFT JOIN silver.products as p
      ON st.product_id = p.product_id
WHERE st.product_id IS NULL
      OR p.product_id IS NULL;

-- product orphan key validation
SELECT 
      st.product_id
FROM bronze.sales_transactions as st 
WHERE st.product_id IS NOT NULL 
AND NOT EXISTS(
      SELECT 1 FROM silver.products p
      WHERE st.product_id = p.product_id
) ;

-- store foreign key validation
SELECT 
      st.store_id,
      s.store_id as store_id_silver
FROM bronze.sales_transactions st 
LEFT JOIN silver.stores as s
      ON st.store_id = s.store_id
WHERE st.store_id IS NULL
      OR s.store_id IS NULL;

-- store orphan key validation
SELECT 
      st.store_id
FROM bronze.sales_transactions as st 
WHERE st.store_id IS NOT NULL 
AND NOT EXISTS(
      SELECT 1 FROM silver.stores s
      WHERE st.store_id = s.store_id
) ;

-- employee foreign key validation 
SELECT 
      st.employee_id,
      e.employee_id as employee_id_silver
FROM bronze.sales_transactions st 
LEFT JOIN silver.employees as e
      ON st.employee_id = e.employee_id
WHERE st.employee_id IS NULL
      OR e.employee_id IS NULL;

-- employee orphan key validation
SELECT 
      st.employee_id
FROM bronze.sales_transactions as st 
WHERE st.employee_id IS NOT NULL 
AND NOT EXISTS(
      SELECT 1 FROM silver.employees e
      WHERE st.employee_id = e.employee_id
) ;

--#############################################################################################
--################################### promo_name validation  ##################################
--#############################################################################################
SELECT DISTINCT 
TRIM(LOWER(promo_name)) as promo_name
FROM bronze.sales_transactions ; 

with promo_name_analysis as 
(
SELECT
CASE TRIM(LOWER(promo_name))
    WHEN 'winter clearance' THEN 'Winter Clearance'
    WHEN 'bundle deal' THEN 'Bundle Deal'
    WHEN 'no promo' THEN 'No Promo'
    WHEN 'flash sale' THEN 'Flash Sale'
    WHEN 'black friday' THEN 'Black Friday'
    WHEN 'holiday special' THEN 'Holiday Special'
    WHEN 'weekend deal' THEN 'Weekend Deal'
    WHEN 'loyalty reward' THEN 'Loyalty Reward'
    WHEN 'cyber monday' THEN 'Cyber Monday'
    ELSE TRIM(promo_name)
END AS promo_name
FROM bronze.sales_transactions 
)
SELECT 
      promo_name,
      COUNT(*) as promo_name_count,
      CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' as percentages
FROM promo_name_analysis
      GROUP BY promo_name
      ORDER BY promo_name_count DESC ;

--#############################################################################################
--################################# sales_channel validation  #################################
--#############################################################################################
SELECT DISTINCT 
TRIM(LOWER(sales_channel)) as sales_channel
FROM bronze.sales_transactions ;

SELECT DISTINCT 
CASE 
    WHEN TRIM(LOWER(sales_channel)) IN ('app', 'mobile', 'mobile app')   THEN 'Mobile App'
    WHEN TRIM(LOWER(sales_channel)) IN ('store', 'in store', 'in-store') THEN 'In Store'
    WHEN TRIM(LOWER(sales_channel)) IN ('online', 'web')                 THEN 'Website'
    WHEN TRIM(LOWER(sales_channel)) IN ('phone')                         THEN 'Phone Call'
    WHEN TRIM(LOWER(sales_channel)) IN ('catalog')                       THEN 'Catalog'
    ELSE 'Unknown'
END AS sales_channel
FROM bronze.sales_transactions ;

--#############################################################################################
--################################# payment_method validation  ################################
--#############################################################################################
SELECT DISTINCT 
TRIM(payment_method) as payment_method
FROM bronze.sales_transactions ;

SELECT DISTINCT 
CASE TRIM(LOWER(payment_method))
    WHEN 'debit card'        THEN 'Debit Card'
    WHEN 'credit card'       THEN 'Credit Card'
    WHEN 'google pay'        THEN 'Google Pay'
    WHEN 'apple pay'         THEN 'Apple Pay'
    WHEN 'bank transfer'     THEN 'Bank Transfer'
    WHEN 'buy now pay later' THEN 'Buy Now Pay Later'
    WHEN 'bnpl'              THEN 'Buy Now Pay Later'
    WHEN 'gift card'         THEN 'Gift Card'
    WHEN 'paypal'            THEN 'PayPal'
    WHEN 'cash'              THEN 'Cash'
    ELSE TRIM(payment_method)
END AS payment_method
FROM bronze.sales_transactions ;



SELECT DISTINCT
TRIM(LOWER(shipping_method)) as shipping_method
FROM bronze.sales_transactions ;

SELECT DISTINCT
CASE 
    WHEN TRIM(LOWER(shipping_method)) IN ('pickup', 'in-store pickup')       THEN 'Store Pickup'
    WHEN TRIM(LOWER(shipping_method)) IN ('overnight', 'overnight shipping') THEN 'Overnight Shipping'
    WHEN TRIM(LOWER(shipping_method)) IN ('same day', 'same day delivery')   THEN 'Same Day Delivery'
    WHEN TRIM(LOWER(shipping_method)) IN ('express', 'express shipping')     THEN 'Express Shipping'
    WHEN TRIM(LOWER(shipping_method)) IN ('standard', 'standard shipping')   THEN 'Standard Shipping'
    WHEN TRIM(LOWER(shipping_method)) IN ('free ship', 'free shipping')      THEN 'Free Shipping'
    ELSE TRIM(shipping_method)
END AS shipping_method
FROM bronze.sales_transactions ;


--#############################################################################################
--#################################### order_status validation  ###############################
--#############################################################################################
SELECT DISTINCT
order_status as order_status
FROM bronze.sales_transactions ;

SELECT DISTINCT 
      CASE TRIM(LOWER(order_status))
            WHEN 'pending'    THEN 'Pending'
            WHEN 'processing' THEN 'Processing'
            WHEN 'shipped'    THEN 'Shipped'
            WHEN 'delivered'  THEN 'Delivered'
            WHEN 'returned'   THEN 'Returned'
            WHEN 'cancelled'  THEN 'Cancelled'
            ELSE TRIM(order_status)
      END AS order_status
FROM bronze.sales_transactions ;

--#############################################################################################
--#################################### is_return validation  ##################################
--#############################################################################################
SELECT DISTINCT
      is_returned
FROM bronze.sales_transactions ;

SELECT DISTINCT
CASE 
    WHEN TRIM(LOWER(is_returned)) IN ('yes', 'y', 'true', '1') THEN 'True'
    WHEN TRIM(LOWER(is_returned)) IN ('no', 'n', 'false', '0') THEN 'False'
    ELSE 'Unknown'
END AS is_returned
FROM bronze.sales_transactions ;

--#############################################################################################
--#################################### data_source validation  ################################
--#############################################################################################
SELECT DISTINCT 
data_source
FROM bronze.sales_transactions ;

SELECT DISTINCT
CASE TRIM(LOWER(data_source))
    WHEN 'crm'    THEN 'CRM'
    WHEN 'web'    THEN 'Web'
    WHEN 'pos'    THEN 'POS'
    WHEN 'manual' THEN 'Manual'
    WHEN 'erp'    THEN 'ERP'
    ELSE 'Unknown'
END AS data_source
FROM bronze.sales_transactions ;
--#############################################################################################
--#################################### TRANSACTION CLEAN DATA #################################
--#############################################################################################
SELECT
order_date,
order_month,
order_day_of_week,
order_year,
order_month_name,
order_quarter
FROM bronze.sales_transactions ; 


SELECT 
CONCAT(order_year, '-', order_month_name,'-', order_day_of_week) as order_date
FROM bronze.sales_transactions ;



WITH pattern_analysis AS 
(
SELECT 
      TRANSLATE(
            order_date,
            '0123456789abcdefghijklmnopqrstuvwxyz',
            '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
      ) as date_pattern 
FROM bronze.sales_transactions 
)
SELECT 
      date_pattern ,
      COUNT(*) as pattern_count,
      CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM pattern_analysis 
GROUP BY date_pattern
ORDER BY pattern_count DESC ;
 

SELECT DISTINCT
      order_month,
      order_month_name
FROM bronze.sales_transactions 
ORDER BY order_month ; 


--#############################################################################################
--#################################### TRANSACTION CLEAN DATA #################################
--#############################################################################################

SELECT 
       st.transaction_id
      ,st.order_id
      ,st.customer_id
      ,st.product_id 
      ,st.store_id 
      ,st.employee_id 
      ,st.promo_id

      ,CASE TRIM(LOWER(promo_name))
            WHEN 'winter clearance' THEN 'Winter Clearance'
            WHEN 'bundle deal'      THEN 'Bundle Deal'
            WHEN 'no promo'         THEN 'No Promo'
            WHEN 'flash sale'       THEN 'Flash Sale'
            WHEN 'black friday'     THEN 'Black Friday'
            WHEN 'holiday special'  THEN 'Holiday Special'
            WHEN 'weekend deal'     THEN 'Weekend Deal'
            WHEN 'loyalty reward'   THEN 'Loyalty Reward'
            WHEN 'cyber monday'     THEN 'Cyber Monday'
            ELSE TRIM(promo_name)
      END AS promo_name

      ,CASE 
            WHEN TRIM(LOWER(sales_channel)) IN ('app', 'mobile', 'mobile app')   THEN 'Mobile App'
            WHEN TRIM(LOWER(sales_channel)) IN ('store', 'in store', 'in-store') THEN 'In Store'
            WHEN TRIM(LOWER(sales_channel)) IN ('online', 'web')                 THEN 'Website'
            WHEN TRIM(LOWER(sales_channel)) IN ('phone')                         THEN 'Phone Call'
            WHEN TRIM(LOWER(sales_channel)) IN ('catalog')                       THEN 'Catalog'
            ELSE 'Unknown'
      END AS sales_channel

      ,CASE TRIM(LOWER(payment_method))
            WHEN 'debit card'        THEN 'Debit Card'
            WHEN 'credit card'       THEN 'Credit Card'
            WHEN 'google pay'        THEN 'Google Pay'
            WHEN 'apple pay'         THEN 'Apple Pay'
            WHEN 'bank transfer'     THEN 'Bank Transfer'
            WHEN 'buy now pay later' THEN 'Buy Now Pay Later'
            WHEN 'bnpl'              THEN 'Buy Now Pay Later'
            WHEN 'gift card'         THEN 'Gift Card'
            WHEN 'paypal'            THEN 'PayPal'
            WHEN 'cash'              THEN 'Cash'
            ELSE TRIM(payment_method)
      END AS payment_method

      ,CASE 
            WHEN TRIM(LOWER(shipping_method)) IN ('pickup', 'in-store pickup')       THEN 'Store Pickup'
            WHEN TRIM(LOWER(shipping_method)) IN ('overnight', 'overnight shipping') THEN 'Overnight Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('same day', 'same day delivery')   THEN 'Same Day Delivery'
            WHEN TRIM(LOWER(shipping_method)) IN ('express', 'express shipping')     THEN 'Express Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('standard', 'standard shipping')   THEN 'Standard Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('free ship', 'free shipping')      THEN 'Free Shipping'
            ELSE TRIM(shipping_method)
      END AS shipping_method

      ,CASE TRIM(LOWER(order_status))
            WHEN 'pending'    THEN 'Pending'
            WHEN 'processing' THEN 'Processing'
            WHEN 'shipped'    THEN 'Shipped'
            WHEN 'delivered'  THEN 'Delivered'
            WHEN 'returned'   THEN 'Returned'
            WHEN 'cancelled'  THEN 'Cancelled'
            ELSE TRIM(order_status)
      END AS order_status

      ,CASE 
            WHEN TRIM(LOWER(is_returned)) IN ('yes', 'y', 'true', '1') THEN 'True'
            WHEN TRIM(LOWER(is_returned)) IN ('no', 'n', 'false', '0') THEN 'False'
            ELSE 'Unknown'
      END AS is_returned

      ,CASE TRIM(LOWER(data_source))
            WHEN 'crm'    THEN 'CRM'
            WHEN 'web'    THEN 'Web'
            WHEN 'pos'    THEN 'POS'
            WHEN 'manual' THEN 'Manual'
            WHEN 'erp'    THEN 'ERP'
            ELSE 'Unknown'
      END AS data_source

      ,st.order_line_number
      ,st.quantity_ordered     
      ,st.unit_list_price      
      ,st.discount_pct         
      ,st.unit_selling_price   
      ,st.line_total_before_tax
      ,st.tax_rate_pct
      ,st.tax_amount
      ,st.line_total_with_tax
      ,st.cost_price
      ,st.gross_profit

      ,st.order_date
      ,st.order_year
      ,st.order_month
      ,st.order_day_of_week
      ,st.ship_date
      ,st.delivery_date
      ,st.record_created_ts
      ,st.last_modified_ts
FROM bronze.sales_transactions as st ; 