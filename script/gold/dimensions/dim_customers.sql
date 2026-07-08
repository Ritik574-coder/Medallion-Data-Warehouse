ALTER VIEW gold.dim_customers AS 
WITH customer_enriched AS 
(
SELECT 
    customer_id,
    TRIM(CONCAT(title, ' ', first_name, ' ', last_name)) as full_name,
    gender,

    date_of_birth,

    DATEDIFF(YEAR, date_of_birth, GETDATE())
    -
    CASE 
        WHEN DATEADD(YEAR,
        DATEDIFF(YEAR, date_of_birth, GETDATE()),date_of_birth) > GETDATE()
        THEN 1 
        ELSE 0
    END as age,

    email,
    phone,
    address,
    city,
    state,
    state_abbr,
    zip_code,
    country,
    region,
    customer_segment,
    loyalty_points,
    is_active,
    account_created_date,
    preferred_channel,
    annual_income_usd,
    company
FROM silver.customers 
)
SELECT 
    customer_id,
    full_name,
    gender,
    date_of_birth,
    age,
    CASE 
        WHEN age IS NULL THEN 'Unknown'
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END as age_group,
    email,
    phone,
    address,
    city,
    state,
    state_abbr,
    zip_code,
    country,
    region,
    customer_segment,
    loyalty_points,
    is_active,
    preferred_channel,
    annual_income_usd,
    company,
    account_created_date
FROM customer_enriched  ; 
GO
