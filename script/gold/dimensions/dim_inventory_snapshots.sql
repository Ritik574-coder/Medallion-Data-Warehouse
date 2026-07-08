CREATE OR ALTER VIEW gold.dim_inventory_snapshots AS
SELECT
    inventory_snapshot_key,

    store_id,
    snapshot_date,

    product_name,
    sku,
    category,
    warehouse_location
FROM gold.v_inventory_snapshot_base;
GO