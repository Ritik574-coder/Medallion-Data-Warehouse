INSERT INTO silver.stores
(
    store_id        ,
    store_name      ,
    store_type      ,
    address         ,
    city            ,
    state           ,
    state_full      ,
    zip_code        ,
    country         ,
    region          ,
    district        ,
    phone           ,
    manager_name    ,
    opened_date     ,
    sq_footage      ,
    num_employees   ,
    annual_rent_usd ,
    is_active       ,
    has_parking     ,
    has_cafe          
)
SELECT
       store_id
      ,store_name
      ,store_type
      ,address
      ,city
      ,state
      ,state_full
      ,zip_code
      ,country
      ,region
      ,district
      ,phone
      ,manager_name
      ,opened_date
      ,sq_footage
      ,num_employees
      ,annual_rent_usd
      ,is_active
      ,has_parking
      ,has_cafe
FROM 
(
    SELECT 
        store_id

        ,CASE 
            WHEN store_name IS NULL OR LEN(TRIM(store_name)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(store_name))
        END as store_name

        ,CASE 
            WHEN store_type IS NULL OR LEN(TRIM(store_type)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(store_type))
        END as store_type

        ,CASE 
            WHEN address IS NULL OR TRIM(address) = '' OR LEN(address) < 5 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(address))
        END address

        ,CASE 
            WHEN city IS NULL OR TRIM(city) = '' OR LEN(TRIM(city)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(city))
        END as city 

        ,CASE 
            WHEN TRIM(state) = 'California'  THEN 'CA'
            WHEN TRIM(state) = 'Texas'       THEN 'TX'
            WHEN TRIM(state) = 'Arizona'     THEN 'AZ'
            WHEN TRIM(state) = 'Colorado'    THEN 'CO'
            WHEN TRIM(state) = 'Maryland'    THEN 'MD'
            WHEN TRIM(state) = 'Wisconsin'   THEN 'WI'
            WHEN TRIM(state) = 'Illinois'    THEN 'IL'
            WHEN TRIM(state) = 'Georgia'     THEN 'GA'
            WHEN TRIM(state) = 'Tennessee'   THEN 'TN'
            WHEN TRIM(state) = 'New Mexico'  THEN 'NM'
            WHEN TRIM(state) = 'Ohio'        THEN 'OH'
            WHEN state IS NULL OR TRIM(state) = '' OR LEN(TRIM(state))  < 2 THEN 'Unknown'
            ELSE state
        END as state    

        ,CASE 
            WHEN state_full IS NULL OR TRIM(state_full) = '' OR LEN(TRIM(state_full)) < 4 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(state_full))
        END as state_full

        ,CASE 
            WHEN zip_code IS NULL OR TRY_CONVERT(INT, zip_code) IS NULL OR LEN(zip_code) < 5 THEN NULL 
            ELSE TRY_CONVERT(INT, zip_code)
        END as zip_code

        ,CASE 
            WHEN TRIM(LOWER(country)) IN ('us', 'usa', 'united states', 'u.s.a', 'u.s') THEN 'United States'
            WHEN country IS NULL OR TRIM(country) = '' OR LEN(TRIM(country)) < 2        THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(country))
        END as country 

        ,CASE 
            WHEN region IS NULL OR TRIM(region) = '' OR LEN(TRIM(region)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(region))
        END as region

        ,CASE 
            WHEN district IS NULL OR TRIM(district) = '' OR LEN(TRIM(district)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(district))
        END as district

        ,CASE 
            WHEN TRIM(phone) LIKE '(___) ___-____' THEN CONCAT('+1 ',  SUBSTRING(TRIM(phone), 1, 14))
            WHEN TRIM(phone) LIKE '+___________'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ', SUBSTRING(TRIM(phone), 6, 3),'-',  SUBSTRING(TRIM(phone), 9,4))
            WHEN TRIM(phone) LIKE '___-___-____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 8))
            WHEN TRIM(phone) LIKE '___.___.____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-', SUBSTRING(TRIM(phone), 9, 4))
            WHEN TRIM(phone) LIKE '__________'     THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 4, 3), '-', SUBSTRING(TRIM(phone), 7, 4))
            ELSE TRIM(phone)
        END as phone

        ,CASE 
            WHEN manager_name IS NULL OR TRIM(manager_name) = '' OR LEN(TRIM(manager_name)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(manager_name))
        END as manager_name

        ,CASE 
            WHEN opened_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,opened_date)
        
            WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 101)
            WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 103)
            WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 110)
            WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 105)
            ELSE TRY_CONVERT(DATE, opened_date)
        END as opened_date

        ,CASE 
            WHEN sq_footage IS NULL OR sq_footage < 0 THEN NULL
            ELSE TRY_CONVERT(INT, sq_footage)
        END as sq_footage

        ,CASE 
            WHEN num_employees IS NULL OR num_employees < 0 THEN NULL
            ELSE TRY_CONVERT(INT, num_employees)
        END as num_employees

        ,CASE 
            WHEN annual_rent_usd < 1 OR annual_rent_usd  IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, annual_rent_usd)
        END as annual_rent_usd 

        ,CASE 
            WHEN TRIM(LOWER(is_active)) IN ('true', 'yes', 'y', '1', 'active')     THEN 'True'
            WHEN TRIM(LOWER(is_active)) IN ('false', 'no', 'n', '0', 'not active') THEN 'False'
            ELSE 'Unknown'
        END as is_active

        ,CASE 
            WHEN TRIM(LOWER(has_parking)) IN ('true', 'yes', 'y', '1') THEN 'True'
            WHEN TRIM(LOWER(has_parking)) IN ('false', 'no', 'n', '0') THEN 'False'
            ELSE 'Unknown'
        END as has_parking

        ,CASE 
            WHEN REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') IN ('1', 'yes', 'y','true') THEN 'True'
            WHEN REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') IN ('0', 'no', 'n','false') THEN 'False'
            ELSE 'Unknown'
        END as has_cafe
    FROM [bronze].[stores]
)t ; 