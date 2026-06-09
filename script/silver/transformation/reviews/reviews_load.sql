CREATE TABLE silver.reviews
(
    review_id          ,
    txn_id             ,
    customer_id        ,
    customer_name      ,
    product_id         ,
    product_name       ,
    rating             ,
    rating_text        ,
    review_date        ,
    verified_purchase  ,
    helpful_votes      ,
    review_channel     ,
    review_title        
)
SELECT
       review_id
      ,txn_id
      ,customer_id
      ,customer_name
      ,product_id
      ,product_name
      ,rating
      ,rating_text
      ,review_date
      ,verified_purchase
      ,helpful_votes
      ,review_channel
      ,review_title
FROM 
(
    SELECT
         review_id
        ,txn_id
        ,customer_id
        ,customer_name
        ,product_id
        ,product_name
        ,rating
        ,rating_text

        ,CASE 
            WHEN review_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,review_date)
        
            WHEN review_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(review_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, review_date, 101)
            WHEN review_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(review_date, 2))         > 12 THEN TRY_CONVERT(DATE, review_date, 103)
            WHEN review_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(review_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, review_date, 110)
            WHEN review_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(review_date, 2))         > 12 THEN TRY_CONVERT(DATE, review_date, 105)
            ELSE TRY_CONVERT(DATE, review_date)
        END as review_date

        ,CASE 
            WHEN TRIM(LOWER(verified_purchase)) IN ('1', 'y', 'yes', 'true', 'verified') THEN 'Verified'
            WHEN TRIM(LOWER(verified_purchase)) IN ('0', 'n', 'no', 'false')             THEN 'Not Verified'    
            ELSE 'Unknown'
        END AS verified_purchase

        ,[helpful_votes]

        ,CASE 
            WHEN TRIM(LOWER(review_channel)) IN ('app', 'mobile app', 'mobile')   THEN 'Mobile App'
            WHEN TRIM(LOWER(review_channel)) IN ('in store', 'in-store', 'store') THEN 'In Store'
            WHEN TRIM(LOWER(review_channel)) IN ('online', 'web')                 THEN 'Online'
            WHEN TRIM(LOWER(review_channel)) = 'phone'                            THEN 'Phone Call'
            WHEN TRIM(LOWER(review_channel)) = 'catalog'                          THEN 'Catalog'
            ELSE 'Unknown'
        END AS review_channel

        ,CASE
            WHEN REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''), CHAR(10), '') = '' THEN 'Unknown'
            ELSE REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''), CHAR(10), '')
        END as review_title
    FROM [bronze].[reviews]
)t ;
