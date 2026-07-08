CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
    transaction_id,
    order_id,
    order_line_number,
    customer_id,
    product_id,
    store_id,
    employee_id,
    promo_id,
    DENSE_RANK() OVER (
        ORDER BY sales_channel, payment_method, shipping_method
    ) AS channel_key,
    CAST(CONVERT(CHAR(8), order_date, 112) AS INT) AS order_date_key,
    CAST(CONVERT(CHAR(8), ship_date, 112) AS INT) AS ship_date_key,
    CAST(CONVERT(CHAR(8), delivery_date, 112) AS INT) AS delivery_date_key,
    sales_channel,
    payment_method,
    shipping_method,
    order_status,
    is_returned,
    data_source,
    quantity_ordered,
    unit_list_price,
    discount_pct,
    unit_selling_price,
    line_total_before_tax,
    tax_rate_pct,
    tax_amount,
    line_total_with_tax,
    record_created,
    last_modified
FROM silver.sales_transactions;
GO
