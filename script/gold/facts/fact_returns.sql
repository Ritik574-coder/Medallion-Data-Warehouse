CREATE OR ALTER VIEW gold.fact_returns AS
SELECT
    return_id,
    original_txn_id,
    original_order_id,
    customer_id,
    product_id,
    handled_by_emp_id AS employee_id,
    DENSE_RANK() OVER (
        ORDER BY return_reason, refund_method, return_channel, return_status, restocked
    ) AS return_reason_key,
    CAST(CONVERT(CHAR(8), return_date, 112) AS INT) AS return_date_key,
    quantity_returned,
    refund_amount,
    return_reason,
    refund_method,
    return_channel,
    return_status,
    restocked,
    notes
FROM silver.returns;
GO
