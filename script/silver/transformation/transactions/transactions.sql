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

      ,c.customer_id      as customer_id          -- customer 
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

      ,st.product_id           -- product
      ,st.product_name         -- prodcut
      ,st.sku                  -- product
      ,st.brand                -- product
      ,st.category             -- product
      ,st.sub_category         -- product
      ,st.department           -- product
      ,st.quantity_ordered     
      ,st.unit_list_price      
      ,st.discount_pct         
      ,st.unit_selling_price   
      ,st.line_total_before_tax
      ,st.tax_rate_pct
      ,st.tax_amount
      ,st.line_total_with_tax

      ,s.store_id   as store_id
      ,s.store_name as store_name
      ,s.city       as store_city
      ,s.state_full as store_state
      ,s.region     as store_region
      ,s.store_type as store_type

      ,st.employee_id
      ,st.employee_name
      ,st.employee_job_title

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
on st.store_id = s.store_id ; 


SELECT * from silver.stores ; 