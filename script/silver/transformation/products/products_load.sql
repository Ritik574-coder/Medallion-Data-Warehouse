INSERT INTO silver.products
(
    product_id       ,
    sku              ,
    product_name     ,
    brand            ,
    category         ,
    sub_category     ,
    department       ,
    base_price_usd   ,
    cost_price_usd   ,
    gross_margin_pct ,
    weight_kg        ,
    is_available     ,
    stock_quantity   ,
    reorder_level    ,
    supplier_name    ,
    supplier_country ,
    warranty_years   ,
    rating_avg       ,
    review_count     ,
    launched_date    ,
    product_url         
)
SELECT 
     product_id
    ,sku
    ,product_name
    ,brand
    ,category
    ,sub_category
    ,department
    ,base_price_usd
    ,cost_price_usd
    ,gross_margin_pct
    ,weight_kg
    ,is_available
    ,stock_quantity
    ,reorder_level
    ,supplier_name
    ,supplier_country
    ,warranty_years
    ,rating_avg
    ,review_count
    ,launched_date
    ,product_url
FROM 
(
    SELECT
        CASE 
            WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, product_id)
        END as product_id

        ,CASE 
            WHEN TRIM(sku) = '' OR sku IS NULL OR LEN(TRIM(sku)) != 13 THEN 'Unknown'
            ELSE TRIM(UPPER(sku))
        END as sku

        ,CASE 
            WHEN TRIM(product_name) = '' OR product_name IS NULL THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(product_name))
        END as product_name

        ,CASE 
            WHEN TRIM(brand) = '' OR brand IS NULL THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(brand))
        END as brand

        ,CASE 
            WHEN category IS NULL OR TRIM(category) = '' THEN 'Unknown'
            ELSE TRIM(dbo.titleCase(category))
        END AS category

        ,CASE 
            WHEN sub_category IS NULL OR TRIM(sub_category) = '' THEN 'Unknown'
            ELSE dbo.TitleCase(TRIM(sub_category))
        END AS sub_category

        ,CASE 
            WHEN department IS NULL OR TRIM(department) = '' THEN 'Unknown'
            ELSE dbo.TitleCase(TRIM(department))
        END AS department

        ,CASE 
            WHEN base_price_usd IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', ''))
        END AS base_price_usd

        ,CASE 
            WHEN cost_price_usd IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', ''))
        END AS cost_price_usd

        ,CASE 
            WHEN gross_margin_pct IS NULL OR TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) > 100 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(5,1), gross_margin_pct)
        END AS gross_margin_pct

        ,CASE 
            WHEN TRY_CONVERT(DECIMAL(5,2), weight_kg) IS NULL OR TRY_CONVERT(DECIMAL(5,2), weight_kg) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(5,2), weight_kg)
        END as weight_kg

        ,CASE
            WHEN LOWER(TRIM(is_available)) IN ('a','y','ye','1','t','tr','in','i') THEN 'Available'
            WHEN LOWER(TRIM(is_available)) IN ('n','no','o','ou') THEN 'Not Available'
            WHEN LOWER(TRIM(is_available)) IN ('d','di') THEN 'Discontinued'
            ELSE 'Unknown'
        END AS is_available

        ,CASE 
            WHEN stock_quantity IS NULL OR TRY_CONVERT(INT , stock_quantity) IS NULL OR TRY_CONVERT(INT , stock_quantity) < 0 THEN NULL
            ELSE TRY_CONVERT(INT , stock_quantity)
        END AS stock_quantity

        ,CASE 
            WHEN reorder_level IS NULL OR TRY_CONVERT(INT , reorder_level) IS NULL OR TRY_CONVERT(INT , reorder_level) < 0 THEN NULL
            ELSE TRY_CONVERT(INT , reorder_level)
        END AS reorder_level

        ,CASE 
            WHEN supplier_name IS NULL OR TRIM(supplier_name) = '' THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(supplier_name))
        END as supplier_name

        ,CASE 
            WHEN supplier_country IS NULL OR TRIM(supplier_country) = '' THEN 'Unknown'
            WHEN supplier_country = 'USA' THEN 'United States'
            ELSE TRIM(dbo.TitleCase(supplier_country))
        END as supplier_country

        ,CASE 
            WHEN TRY_CONVERT(INT, warranty_years) IS NULL OR TRY_CONVERT(INT, warranty_years) < 0  OR TRY_CONVERT(INT, warranty_years) > 20 THEN NULL 
            ELSE TRY_CONVERT(INT, warranty_years)
        END as warranty_years

        ,CASE 
            WHEN TRY_CONVERT(DECIMAL(3,1), rating_avg) IS NULL OR TRY_CONVERT(DECIMAL(3,1), rating_avg) < 0 OR TRY_CONVERT(DECIMAL(3,1), rating_avg) > 5 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(3,1), rating_avg)
        END as rating_avg

        ,CASE 
            WHEN TRY_CONVERT(INT, review_count) IS NULL OR TRY_CONVERT(INT, review_count) < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, review_count)
        END as review_count

        ,CASE 
            WHEN launched_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,launched_date)
        
            WHEN launched_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(launched_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, launched_date, 101)
            WHEN launched_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(launched_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, launched_date, 110)
            WHEN launched_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(launched_date, 2))         > 12 THEN TRY_CONVERT(DATE, launched_date, 103)
            WHEN launched_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(launched_date, 2))         > 12 THEN TRY_CONVERT(DATE, launched_date, 105)
            ELSE TRY_CONVERT(DATE, launched_date)
        END as launched_date

        ,CASE 
            WHEN product_url IS NULL OR TRIM(product_url) = '' OR product_url NOT LIKE 'https://%' THEN 'Unknown'
            ELSE REPLACE(REPLACE(TRIM(LOWER(product_url)), CHAR(13), ''),CHAR(10), '')
        END as product_url

    FROM [bronze].[products]
)t ;
