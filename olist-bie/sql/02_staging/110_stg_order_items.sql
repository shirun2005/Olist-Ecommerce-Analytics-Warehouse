drop table if exists stg.order_items;
create table stg.order_items as
select
  order_id,
  nullif(order_item_id,'')::int as order_item_id,
  product_id,
  seller_id,
  nullif(shipping_limit_date,'')::timestamp as shipping_limit_ts,
  nullif(price,'')::numeric as price,
  nullif(freight_value,'')::numeric as freight_value,
  (nullif(price,'')::numeric + nullif(freight_value,'')::numeric) as item_revenue
from raw.olist_order_items;
