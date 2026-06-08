SELECT 
    snapshot_date
    ,product_id
    ,product_name
    ,sku
    ,category
    ,stock_on_hand
    ,stock_reserved
    ,stock_on_hand - stock_reserved as stock_available
    ,reorder_level
    ,unit_cost
    ,unit_price
    ,unit_price * stock_on_hand as inventory_value
    ,warehouse_location
    ,store_id
FROM 
(
    SELECT 
        CASE 
            WHEN snapshot_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,snapshot_date)
            WHEN snapshot_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,snapshot_date)
            WHEN snapshot_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,snapshot_date)
            WHEN snapshot_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,snapshot_date)
        
            WHEN snapshot_date LIKE '__/__/____' AND SUBSTRING(snapshot_date, 4, 2) > 12 THEN TRY_CONVERT(DATE, snapshot_date, 101)
            WHEN snapshot_date LIKE '__/__/____' AND LEFT(snapshot_date, 2) > 12         THEN TRY_CONVERT(DATE, snapshot_date, 103)
            WHEN snapshot_date LIKE '__-__-____' AND SUBSTRING(snapshot_date, 4, 2) > 12 THEN TRY_CONVERT(DATE, snapshot_date, 110)
            WHEN snapshot_date LIKE '__-__-____' AND LEFT(snapshot_date, 2) > 12         THEN TRY_CONVERT(DATE, snapshot_date, 105)
            ELSE TRY_CONVERT(DATE, snapshot_date)
        END as snapshot_date

        ,CASE 
            WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, product_id)
        END  as product_id

        ,CASE 
            WHEN product_name IS NULL OR product_name = '' THEN 'Unknown'
            ELSE TRIM(product_name)
        END as product_name

        ,CASE 
            WHEN sku IS NULL OR sku = '' THEN 'Unknown'
            ELSE TRIM(sku)
        END as sku

        ,CASE 
            WHEN TRIM(LOWER(category)) = 'electronics' THEN 'Electronics'
            WHEN TRIM(LOWER(category)) = 'clothing'    THEN 'Clothing'
            WHEN TRIM(LOWER(category)) = 'kitchen'     THEN 'Kitchen'
            WHEN TRIM(LOWER(category)) = 'office'      THEN 'Office'
            WHEN TRIM(LOWER(category)) = 'sports'      THEN 'Sports'
            WHEN TRIM(LOWER(category)) = 'health'      THEN 'Health'
            WHEN TRIM(LOWER(category)) = 'beauty'      THEN 'Beauty'
            WHEN TRIM(LOWER(category)) = 'footwear'    THEN 'Footwear'
            WHEN TRIM(LOWER(category)) = 'toys'        THEN 'Toys'
            WHEN TRIM(LOWER(category)) = 'bags'        THEN 'Bags'
            ELSE 'Unknown'
        END AS category
        
        ,CASE 
            WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR stock_on_hand < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, stock_on_hand)
        END AS stock_on_hand

        ,CASE 
            WHEN stock_reserved < 0 OR TRY_CONVERT(INT, stock_reserved) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, stock_reserved)
        END  as stock_reserved

        ,CASE 
            WHEN reorder_level IS NULL OR reorder_level < 0 OR TRY_CONVERT(INT, reorder_level) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, reorder_level)
        END as reorder_level

        ,CASE 
            WHEN unit_cost LIKE '$%' THEN TRY_CONVERT(DECIMAL(10, 2), SUBSTRING(unit_cost, 2, LEN(unit_cost)))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_cost)
        END as unit_cost

        ,CASE 
            WHEN TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL THEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_price, ',', ''), '$', ''))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_price)
        END as unit_price

        ,CASE 
            WHEN warehouse_location IS NULL OR warehouse_location = '' THEN 'Unknown'
            ELSE UPPER(warehouse_location)
        END as warehouse_location

        ,CASE 
            WHEN store_id IS NULL OR store_id = '' THEN NULL
            ELSE TRY_CONVERT(INT, store_id)
        END as store_id

    FROM [bronze].[inventory_snapshots]  
)t;
