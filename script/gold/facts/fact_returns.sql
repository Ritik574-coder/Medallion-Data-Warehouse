CREATE OR ALTER VIEW gold.fact_returns AS 
SELECT 
    return_id,
    quantity_returned,
    refund_amount
FROM silver.returns ;