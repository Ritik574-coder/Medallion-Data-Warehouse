CREATE OR ALTER VIEW gold.dim_returns AS 
SELECT 
    return_id,
    original_txn_id,
    original_order_id,
    customer_id,
    product_id,
    handled_by_emp_id,
    customer_name,
    product_name,
    return_reason,
    refund_method,
    return_channel,
    return_status,
    notes,
    restocked,
    return_date
FROM silver.returns ; 
GO 