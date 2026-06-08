SELECT 
       return_id
      ,original_txn_id
      ,original_order_id
      ,customer_id
      ,customer_name
      ,product_id
      ,product_name
      ,quantity_returned
      ,return_date
      ,return_reason
      ,refund_amount
      ,refund_method
      ,return_channel
      ,restocked
      ,return_status
      ,handled_by_emp_id
      ,notes
FROM 
(
      SELECT 
            CASE 
                  WHEN TRY_CONVERT(INT, return_id) < 1 OR TRY_CONVERT(INT, return_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, return_id)
            END as return_id

            ,CASE 
                  WHEN original_txn_id IS NULL THEN NULL
                  WHEN UPPER(TRIM(original_txn_id)) NOT LIKE 'TXN-%' THEN NULL
                  WHEN LEN(UPPER(TRIM(original_txn_id))) < 10 THEN NULL
                  ELSE UPPER(TRIM(original_txn_id))
            END as original_txn_id

            ,CASE 
                  WHEN original_order_id IS NULL OR TRY_CONVERT(INT, original_order_id) < 1 OR TRY_CONVERT(INT, original_order_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, original_order_id)
            END as original_order_id

            ,CASE 
                  WHEN customer_id IS NULL OR TRY_CONVERT(INT, customer_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, customer_id)
            END as customer_id

            ,CASE 
                  WHEN customer_name IS NULL OR TRIM(customer_name) = '' THEN 'Unknown'
                  ELSE dbo.TitleCase(TRIM(customer_name))
            END as customer_name

            ,CASE 
                  WHEN product_id IS NULL OR TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, product_id)
            END as product_id

            ,CASE 
                  WHEN product_name IS NULL OR TRIM(product_name) = '' THEN 'Unknown'
                  ELSE dbo.TitleCase(TRIM(product_name))
            END as product_name

            ,CASE 
                  WHEN quantity_returned IS NULL OR TRY_CONVERT(INT, quantity_returned) IS NULL OR TRY_CONVERT(INT, quantity_returned) < 1 THEN NULL 
                  ELSE TRY_CONVERT(INT, quantity_returned)
            END as quantity_returned

            ,CASE 
                WHEN return_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,return_date)
                WHEN return_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,return_date)
                WHEN return_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,return_date)
                WHEN return_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,return_date)

                WHEN return_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(return_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, return_date, 101)
                WHEN return_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(return_date, 2))         > 12 THEN TRY_CONVERT(DATE, return_date, 103)
                WHEN return_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(return_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, return_date, 110)
                WHEN return_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(return_date, 2))         > 12 THEN TRY_CONVERT(DATE, return_date, 105)
                ELSE TRY_CONVERT(DATE, return_date)
            END as return_date

            ,CASE 
                  WHEN return_reason IS NULL OR TRIM(return_reason) = '' THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(return_reason))
            END as return_reason

            ,CASE 
                  WHEN TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) IS NULL THEN NULL
                  WHEN refund_amount IS NULL OR TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) < 0 THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', ''))
            END as refund_amount

            ,CASE 
                  WHEN refund_method IS NULL OR TRIM(refund_method) = '' THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(refund_method))
            END as refund_method

            ,CASE 
                WHEN TRIM(LOWER(return_channel)) IN ('app', 'mobile app', 'mobile')   THEN 'Mobile App'
                WHEN TRIM(LOWER(return_channel)) IN ('in store', 'in-store', 'store') THEN 'In Store'
                WHEN TRIM(LOWER(return_channel)) IN ('online', 'web')                 THEN 'Online'
                WHEN TRIM(LOWER(return_channel)) = 'phone'                            THEN 'Phone Call'
                WHEN TRIM(LOWER(return_channel)) = 'catalog'                          THEN 'Catalog'
                ELSE 'Unknown'
            END AS return_channel

            ,CASE 
                  WHEN TRIM(LOWER(restocked)) IN ('yes', 'y', '1') THEN 'Yes'
                  WHEN TRIM(LOWER(restocked)) IN ('no', 'n', '0')  THEN 'No'
                  ELSE 'Unknown'
            END AS restocked

            ,CASE 
                  WHEN return_status IS NULL THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(return_status))
            END as return_status

            ,CASE 
                  WHEN handled_by_emp_id IS NULL OR TRY_CONVERT(INT, handled_by_emp_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, handled_by_emp_id)
            END as handled_by_emp_id

            ,CASE 
                  WHEN notes IS NULL OR LEN(TRIM(notes)) < 3 OR TRIM(notes) = '' THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(REPLACE(REPLACE(notes, CHAR(10), ''), CHAR(13), '')))
            END as notes

      FROM [bronze].[returns]
)t ; 