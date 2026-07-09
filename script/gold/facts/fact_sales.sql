CREATE OR ALTER VIEW gold.fact_sales_transactions AS 
SELECT 
    transaction_id,
    order_id,
    product_id,
    store_id,
    order_line_number,
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