CREATE OR ALTER VIEW gold.dim_return_reasons AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY return_reason, refund_method, return_channel, return_status, restocked
    ) AS return_reason_key,
    return_reason,
    refund_method,
    return_channel,
    return_status,
    restocked
FROM (
    SELECT DISTINCT
        return_reason,
        refund_method,
        return_channel,
        return_status,
        restocked
    FROM silver.returns
) d;
GO
