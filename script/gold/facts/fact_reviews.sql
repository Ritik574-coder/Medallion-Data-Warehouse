CREATE OR ALTER VIEW gold.fact_reviews AS
SELECT
    review_id,
    txn_id AS transaction_id,
    customer_id,
    product_id,
    CAST(CONVERT(CHAR(8), review_date, 112) AS INT) AS review_date_key,
    rating,
    rating_text,
    verified_purchase,
    helpful_votes,
    review_channel,
    review_title
FROM silver.reviews;
GO
