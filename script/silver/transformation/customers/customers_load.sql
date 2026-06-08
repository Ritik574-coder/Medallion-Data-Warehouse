INSERT INTO silver.customers
(
    customer_id          ,
    title                ,
    first_name           ,
    last_name            ,
    gender               ,
    date_of_birth        ,
    email                ,
    phone                ,
    address              ,
    city                 ,
    state_abbr           ,
    state                ,
    zip_code             ,
    country              ,
    region               ,
    customer_segment     ,
    loyalty_points       ,
    is_active            ,
    account_created_date ,
    preferred_channel    ,
    annual_income_usd    ,
    company              
)
SELECT  
    customer_id
    ,TRIM(title) as title
    ,CASE
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ', '')) = 2 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ', '')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
    END AS first_name,
        PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 1) AS last_name

    ,CASE TRIM(LOWER(gender))
        WHEN 'f' THEN 'Female'
        WHEN 'female' THEN 'Female'
        WHEN 'm' THEN 'Male'
        WHEN 'male' THEN 'Male'
        WHEN 'nb' THEN 'Non-Binary'
        WHEN 'non-binary' THEN 'Non-Binary'
        WHEN 'other' THEN 'Other'
        WHEN 'prefer not to say' THEN 'Other'
        ELSE 'Unknown'
    END as gender
        
    ,CASE
        WHEN TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
        WHEN TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
        WHEN TRIM(date_of_birth) LIKE '____-__-__'                     THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
        WHEN TRIM(date_of_birth) LIKE '____/__/__'                     THEN TRY_CONVERT(DATE, TRIM(date_of_birth))

        WHEN TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12 THEN TRY_CONVERT(DATE, TRIM(date_of_birth), 101)
        WHEN TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(TRIM(date_of_birth), 2)) > 12         THEN TRY_CONVERT(DATE , TRIM(date_of_birth), 103)

        WHEN TRIM(date_of_birth) LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12 THEN TRY_CONVERT(DATE, TRIM(date_of_birth), 110)
        WHEN TRIM(date_of_birth) LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(TRIM(date_of_birth), 2)) > 12         THEN TRY_CONVERT(DATE , TRIM(date_of_birth), 105)
        ELSE TRY_CONVERT(DATE, TRIM(date_of_birth), 101)
    END date_of_birth

    ,CASE
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Unknown'
        WHEN TRIM(LOWER(email)) NOT LIKE '%@%' THEN 'Unknown'
        WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0 THEN
                LEFT(TRIM(LOWER(email)),CHARINDEX('@', TRIM(LOWER(email))) - 1)
                + '@' +
                REPLACE(
                    SUBSTRING(
                        TRIM(LOWER(email)),
                        CHARINDEX('@', TRIM(LOWER(email))) + 1,
                        LEN(email)),'@','')
        ELSE
            CONCAT(
                LEFT(TRIM(LOWER(email)),CHARINDEX('@', TRIM(LOWER(email))) - 1), '@',
                CASE
                    WHEN RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'yahoocom' THEN 'yahoo.com'
                    WHEN RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'iclod.com' THEN 'icloud.com'
                    WHEN RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'outook.com' THEN 'outlook.com'
                    WHEN RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'ahoo.com' THEN 'yahoo.com'
                    ELSE RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email)))
                END
        )
    END AS email

    ,CASE 
        WHEN TRIM(phone) LIKE '+1__________'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ', SUBSTRING(TRIM(phone), 6, 3),'-',   SUBSTRING(TRIM(phone),9,4))
        WHEN TRIM(phone) LIKE '__________'     THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1 ,3), ') ', SUBSTRING(TRIM(phone), 4 ,3), '-',  SUBSTRING(TRIM(phone), 7, 4))
        WHEN TRIM(phone) LIKE '___-___-____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3),       SUBSTRING(TRIM(phone), 8 ,5))
        WHEN TRIM(phone) LIKE '___.___.____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-',  SUBSTRING(TRIM(phone),9, 4))
        WHEN TRIM(phone) LIKE '(___) ___-____' THEN CONCAT('+1 ',  SUBSTRING(TRIM(phone), 1, 14))
        WHEN TRIM(phone) IS NULL OR TRIM(phone) = '' THEN 'Unknown'
        ELSE 'Unknown'
    END  as phone

    ,CASE 
        WHEN [address] IS NULL OR [address] = '' THEN 'Unknown'
        ELSE [address]
    END as address

    ,CASE 
        WHEN TRIM(LOWER(city)) = 'an diego'     THEN dbo.TitleCase('san diego')
        WHEN TRIM(LOWER(city)) = 'chiago'       THEN dbo.TitleCase('chicago')
        WHEN TRIM(LOWER(city)) = 'chrlotte'     THEN dbo.TitleCase('charlotte')
        WHEN TRIM(LOWER(city)) = 'dalla'        THEN dbo.TitleCase('dallas')
        WHEN TRIM(LOWER(city)) = 'inneapolis'   THEN dbo.TitleCase('minneapolis')
        WHEN TRIM(LOWER(city)) = 'louiville'    THEN dbo.TitleCase('louisville')
        WHEN TRIM(LOWER(city)) = 'milwakee'     THEN dbo.TitleCase('milwaukee')
        WHEN TRIM(LOWER(city)) = 'mnneapolis'   THEN dbo.TitleCase('minneapolis')
        WHEN TRIM(LOWER(city)) = 'oklahoma cty' THEN dbo.TitleCase('oklahoma city')
        WHEN TRIM(LOWER(city)) = 'ortland'      THEN dbo.TitleCase('portland')
        WHEN TRIM(LOWER(city)) = 'sa diego'     THEN dbo.TitleCase('san diego')
        WHEN TRIM(LOWER(city)) = 'san ntonio'   THEN dbo.TitleCase('san antonio')
        WHEN TRIM(LOWER(city)) = 'sn antonio'   THEN dbo.TitleCase('san antonio')
        WHEN TRIM(city) = ''                    THEN 'Unknown'
        WHEN city IS NULL                       THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(city))
    END AS city

    ,CASE 
        WHEN TRIM(UPPER(state_abbr)) IS NULL OR TRIM(UPPER(state_abbr)) = '' THEN 'Unknown'
        WHEN LEN(TRIM(UPPER(state_abbr))) != 2 THEN 'Unknown'
        ELSE TRIM(UPPER(state_abbr))
    END as state_abbr
      
    ,CASE 
        WHEN TRIM(state_full) IS NULL OR TRIM(state_full) = '' THEN 'Unknown'
        ELSE TRIM(state_full)
    END as state

    ,CASE 
        WHEN zip_code IS NULL THEN 0
        WHEN LEN(zip_code) != 5 THEN 0
        WHEN TRY_CAST(zip_code AS INT) IS NULL THEN 0
        ELSE TRY_CAST(zip_code AS INT)
    END as zip_code

    ,CASE 
         WHEN TRIM(LOWER(country)) IN ('u.s.a', 'us', 'usa', 'united states') THEN 'United States'
         ELSE 'Unknown'
    END as country

    ,CASE 
         WHEN region IS NULL OR TRIM(region) = '' THEN 'Unknown'
         ELSE TRIM(region)
    END as region

    ,CASE 
        WHEN customer_segment IS NULL OR customer_segment = '' THEN 'Unknown'
        ELSE customer_segment
    END as customer_segment

        ,TRY_CAST(loyalty_points AS INT) as loyalty_points

    ,CASE 
         WHEN TRIM(LOWER(is_active)) IN ('1', 'active', 'true', 'y', 'yes')   THEN 'True'
         WHEN TRIM(LOWER(is_active)) IN ('0', 'inactive', 'false', 'n', 'no') THEN 'False'
         ELSE 'Unknown'
    END AS is_active

    ,CASE
        WHEN TRIM(account_created_date) LIKE '[A-Z][a-z][a-z] __, ____'       THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '____/__/__'                     THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '____-__-__'                     THEN CONVERT(DATE,account_created_date)

        WHEN TRIM(account_created_date) LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(account_created_date,2)) > 12          THEN TRY_CONVERT(DATE, account_created_date, 105)
        WHEN TRIM(account_created_date) LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(account_created_date,4,2)) > 12   THEN TRY_CONVERT(DATE, account_created_date, 110)
        WHEN TRIM(account_created_date) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(account_created_date,2)) > 12          THEN TRY_CONVERT(DATE, account_created_date, 103)
        WHEN TRIM(account_created_date) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(account_created_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, account_created_date, 101)
        ELSE TRY_CONVERT(DATE, account_created_date,101)
    END as account_created_date 

    ,CASE TRIM(LOWER(preferred_channel))
        WHEN 'app'        THEN 'Mobile App'
        WHEN 'mobile app' THEN 'Mobile App'
        WHEN 'mobile'     THEN 'Mobile App'
        WHEN 'in store'   THEN 'In Store'
        WHEN 'in-store'   THEN 'In Store'
        WHEN 'store'      THEN 'In Store'
        WHEN 'catalog'    THEN 'Catalog'
        WHEN 'online'     THEN 'Website'
        WHEN 'web'        THEN 'Website'
        WHEN 'phone'      THEN 'Phone Call'
        ELSE 'Unknown'
    END as preferred_channel
        
    ,COALESCE(
        annual_income_usd,
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY annual_income_usd)
        OVER (PARTITION BY customer_segment)
    ) as annual_income_usd

    ,CASE 
        WHEN company IS NULL OR company = '' THEN 'Unknown'
        WHEN TRIM(REPLACE(REPLACE(company, CHAR(13), ''), CHAR(10), '')) = '' THEN 'Unknown'
        ELSE TRIM(REPLACE(REPLACE(company, CHAR(13), ''), CHAR(10), ''))
    END as company
FROM [bronze].[customers]
