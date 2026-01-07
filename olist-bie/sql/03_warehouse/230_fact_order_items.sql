drop table if exists dwh.fact_order_items;
create table dwh.fact_order_items as
select
  order_id,
  order_item_id,
  product_id,
  seller_id,
  shipping_limit_ts,
  price,
  freight_value,
  item_revenue
from stg.order_items;