--#############################################################################
-- Staging Model: src_transactions
-- Purpose: Clean and deduplicate raw bronze.sales_transactions
--#############################################################################

WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'sales_transactions') }}
),

deduplicated AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY transaction_id
            ORDER BY transaction_id
        ) AS _row_flag
    FROM source
    WHERE transaction_id IS NOT NULL
)

SELECT
    UPPER(TRIM(transaction_id)) AS transaction_id,

    CASE WHEN TRY_CAST(order_id AS INT) IS NULL OR LEN(TRIM(order_id)) < 5 THEN NULL ELSE TRY_CAST(order_id AS INT) END AS order_id,

    TRY_CAST(order_line_number AS INT) AS order_line_number,

    CASE
        WHEN TRIM(order_date) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE, order_date)
        WHEN TRIM(order_date) LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE, order_date)
        WHEN TRIM(order_date) LIKE '____-__-__'                     THEN TRY_CONVERT(DATE, order_date)
        WHEN TRIM(order_date) LIKE '____/__/__'                     THEN TRY_CONVERT(DATE, order_date)
        WHEN TRIM(order_date) LIKE '__/__/____'
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(order_date), 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 101)
        WHEN TRIM(order_date) LIKE '__/__/____'
            AND TRY_CONVERT(INT, LEFT(TRIM(order_date), 2)) > 12         THEN TRY_CONVERT(DATE, order_date, 103)
        WHEN TRIM(order_date) LIKE '__-__-____'
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(order_date), 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 110)
        WHEN TRIM(order_date) LIKE '__-__-____'
            AND TRY_CONVERT(INT, LEFT(TRIM(order_date), 2)) > 12         THEN TRY_CONVERT(DATE, order_date, 105)
        ELSE TRY_CONVERT(DATE, order_date)
    END AS order_date,
    
    order_year, order_month, order_month_name, order_quarter, order_day_of_week,
    TRY_CAST(customer_id AS INT) AS customer_id,
    customer_full_name, customer_first_name, customer_last_name, customer_email,
    customer_phone, customer_city, customer_state,
    CASE WHEN TRY_CAST(customer_zip AS INT) IS NULL OR LEN(customer_zip) != 5 THEN NULL ELSE TRY_CAST(customer_zip AS INT) END AS customer_zip,
    customer_region, customer_segment, customer_gender, customer_age, customer_age_group,
    product_id, product_name, sku, brand, category, sub_category, department,
    quantity_ordered,
    unit_list_price, discount_pct, unit_selling_price,
    line_total_before_tax, tax_rate_pct, tax_amount, line_total_with_tax,
    store_id, store_name, store_city, store_state, store_region, store_type,
    employee_id, employee_name, employee_job_title,
    promo_id, promo_name,
    LOWER(TRIM(sales_channel)) AS sales_channel,
    payment_method, shipping_method, order_status, is_returned,
    cost_price, gross_profit, data_source, record_created_ts, last_modified_ts
FROM deduplicated
WHERE _row_flag = 1;


