SELECT 
    review_id,
    txn_id,
    customer_id,
    product_id,
    customer_name,
    product_name,
    verified_purchase,
    review_channel,
    review_title,
    rating_text,
    rating,
    helpful_votes,
    review_date
FROM silver.reviews ;