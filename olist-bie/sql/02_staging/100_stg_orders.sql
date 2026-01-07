drop table if exists stg.orders;
create table stg.orders as
select
  order_id,
  customer_id,
  order_status,
  nullif(order_purchase_timestamp,'')::timestamp as purchase_ts,
  nullif(order_approved_at,'')::timestamp as approved_ts,
  nullif(order_delivered_carrier_date,'')::timestamp as delivered_carrier_ts,
  nullif(order_delivered_customer_date,'')::timestamp as delivered_customer_ts,
  nullif(order_estimated_delivery_date,'')::timestamp as estimated_delivery_ts
from raw.olist_orders;
