CREATE OR ALTER VIEW gold.dim_products AS
SELECT
    product_id,
    sku,
    department,
    category,
    sub_category,
    product_name,
    brand,
    is_available,
    supplier_name,
    supplier_country,
    base_price_usd,
    cost_price_usd,
    gross_margin_pct,
    weight_kg,
    stock_quantity,
    reorder_level,
    warranty_years,
    rating_avg,
    review_count,
    product_url,
    launched_date
FROM silver.products ; 
GO
