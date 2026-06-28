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
FROM silver.employees ; 