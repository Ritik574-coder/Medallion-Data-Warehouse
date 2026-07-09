CREATE OR ALTER VIEW gold.dim_sales AS 
SELECT 
    st.transaction_id,
    st.order_id,
    st.customer_id,
    st.product_id,
    st.store_id,
    st.employee_id,
    st.promo_id,
    st.promo_name,
    c.full_name as customer_name,
    e.employee_name,
    p.product_name,
    s.store_name,
    st.sales_channel,
    st.payment_method,
    st.shipping_method,
    st.order_status,
    st.is_returned,
    st.data_source,
    st.order_date,
    st.ship_date,
    st.delivery_date,
    st.record_created,
    st.last_modified
FROM silver.sales_transactions as st 
    LEFT JOIN gold.dim_customers as c  
ON c.customer_id = st.customer_id 
    LEFT JOIN gold.dim_employees as e  
ON e.employee_id = st.employee_id  
    LEFT JOIN gold.dim_products as p  
ON p.product_id = st.product_id 
    LEFT JOIN gold.dim_stores as s  
ON s.store_id = st.store_id ; 
GO
