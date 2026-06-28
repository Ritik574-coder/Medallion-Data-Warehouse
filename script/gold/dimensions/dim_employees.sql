WITH product_enriched AS
(
SELECT 
    employee_id,
    manager_id,
    store_id,
    TRIM(CONCAT(first_name, ' ', last_name)) as employee_name ,
    job_title,
    department,
    store_name,
    store_city,
    email,
    phone,
    is_active,
    performance_rating,
    years_employed,
    annual_salary_usd,
    commission_rate_pct,
    hire_date
FROM silver.employees 
)
SELECT
    employee_id,
    manager_id,
    store_id,
    employee_name ,
    job_title,
    department,
    store_name,
    store_city,
    email,
    phone,
    is_active,
    performance_rating,
    CASE 
        WHEN is_active = 'True' THEN 
            DATEDIFF(YEAR, hire_date, GETDATE()) -
            CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, hire_date, GETDATE()), hire_date) > GETDATE()
            THEN 1 ELSE 0 END 
        ELSE years_employed
    END as years_employed,
    annual_salary_usd,
    commission_rate_pct,
    hire_date
FROM product_enriched ; 