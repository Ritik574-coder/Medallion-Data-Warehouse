INSERT INTO [TestDB].[silver].[employees]
(
    employee_id         , 
    first_name          ,
    last_name           ,
    email               ,
    phone               ,
    job_title           ,
    department          ,
    store_id            ,
    store_name          ,
    store_city          ,
    hire_date           ,
    years_employed      ,
    annual_salary_usd   ,
    commission_rate_pct ,
    is_active           ,
    performance_rating  ,
    manager_id          
)
SELECT
       [employee_id]

    ,CASE 
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ','')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
    END as first_name,

        PARSENAME(REPLACE(TRIM(full_name),' ','.'),1) as last_name

    ,CASE 
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Unknown'
        WHEN email NOT LIKE '%@%' THEN 'Unknown'
        WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0 THEN 
        LEFT(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) -1)
        + '@' + REPLACE(SUBSTRING(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) +1,
        LEN(TRIM(LOWER(email)))), '@' ,'')
        ELSE TRIM(LOWER(email))
    END as email

    ,CASE 
        WHEN phone LIKE '+___________'   THEN  CONCAT('+1 (', SUBSTRING(phone, 3, 3), ') ',  SUBSTRING(phone, 6, 3), '-', SUBSTRING(phone, 9,4))
        WHEN phone LIKE '___.___.____'   THEN  CONCAT('+1 (', SUBSTRING(phone, 1,3), ') ' ,  SUBSTRING(phone,5, 3), '-',  SUBSTRING(phone,9,4))
        WHEN phone LIKE '__________'     THEN  CONCAT('+1 (', SUBSTRING(phone, 1,3), ') ' ,  SUBSTRING(phone, 4,3), '-',  SUBSTRING(phone,7,4))
        WHEN phone LIKE '___-___-____'   THEN  CONCAT('+1 (', SUBSTRING(phone,1, 3), ') ' ,  SUBSTRING(phone, 5,8))
        WHEN phone LIKE '(___) ___-____' THEN  CONCAT('+1 ',  SUBSTRING(phone, 1,14))
    END as phone

    ,CASE 
        WHEN job_title IS NULL OR job_title = '' THEN 'Unknown'
        ELSE TRIM(job_title) 
    END as job_title

    ,CASE 
        WHEN department IS NULL OR department = '' THEN 'Unknown'
        ELSE TRIM(department)
    END as department

    ,CASE 
        WHEN store_id < 0 OR TRY_CONVERT(INT, store_id) IS NULL THEN NULL
        ELSE TRY_CONVERT(INT, store_id) 
    END as store_id 

    ,CASE 
        WHEN store_name IS NULL OR store_name = '' THEN 'Unknown'
        ELSE TRIM(store_name)
    END as store_name

    ,CASE 
        WHEN store_city IS NULL OR LEN(store_city) < 4 OR store_city = '' THEN 'Unknown'
        ELSE TRIM(store_city)
    END store_city

    ,CASE 
        WHEN hire_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE,hire_date )
        WHEN hire_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE, hire_date)
        WHEN hire_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE, hire_date)
        WHEN hire_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE, hire_date)

        WHEN hire_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 THEN  TRY_CONVERT(DATE, hire_date,103)
        WHEN hire_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 105)
        
        WHEN hire_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 THEN  TRY_CONVERT(DATE, hire_date,101)
        WHEN hire_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 110)
        ELSE TRY_CONVERT(DATE, hire_date)
    END hire_date

    ,CASE 
        WHEN years_employed IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), years_employed) IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), years_employed) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(4,2), TRY_CONVERT(DECIMAL(4,2), years_employed))
    END years_employed

    ,CASE 
        WHEN annual_salary_usd IS NULL 
        OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) IS NULL 
        OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) < 0 THEN NULL
        ELSE TRY_CONVERT(DECIMAL(18,2), annual_salary_usd)
    END AS annual_salary_usd

    ,CASE 
        WHEN commission_rate_pct IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) < 0 THEN NULL
        ELSE TRY_CONVERT(DECIMAL(4,2), commission_rate_pct)
    END AS commission_rate_pct

    ,CASE
        WHEN TRIM(LOWER(is_active)) IN ('active', 'y', 'yes', '1', 'true')     THEN 'True'
        WHEN TRIM(LOWER(is_active)) IN ('terminated', 'n', 'no', '0', 'false') THEN 'False'
        ELSE NULL
    END AS is_active

    ,CASE
        WHEN TRIM(LOWER(performance_rating)) IN ('excellent', 'a', '5')     THEN 'Excellent'
        WHEN TRIM(LOWER(performance_rating)) IN ('good', 'b', '4')          THEN 'Good'
        WHEN TRIM(LOWER(performance_rating)) IN ('average', 'c', '3')       THEN 'Average'
        WHEN TRIM(LOWER(performance_rating)) IN ('below average', 'd', '2') THEN 'Below Average'
        WHEN performance_rating IS NULL OR TRIM(performance_rating) = ''    THEN 'Unknown'
        ELSE 'Unknown'
    END AS performance_rating

    ,CASE 
        WHEN TRY_CONVERT(INT ,manager_id) IS NULL THEN NULL 
        ELSE manager_id 
    END as manager_id

FROM [TestDB].[bronze].[employees]