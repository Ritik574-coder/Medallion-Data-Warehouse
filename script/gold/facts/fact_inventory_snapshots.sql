CREATE OR ALTER VIEW gold.fact_inventory_snapshots AS
SELECT
    inventory_snapshot_key,

    snapshot_date,
    product_id,
    store_id,

    stock_on_hand,
    stock_reserved,
    stock_available,
    reorder_level,
    unit_cost,
    unit_price,
    inventory_value
FROM gold.v_inventory_snapshot_base;
GO 