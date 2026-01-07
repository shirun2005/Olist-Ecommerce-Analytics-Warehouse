drop table if exists stg.products;
create table stg.products as
select
  product_id,
  product_category_name,
  nullif(product_weight_g,'')::numeric as product_weight_g,
  nullif(product_length_cm,'')::numeric as product_length_cm,
  nullif(product_height_cm,'')::numeric as product_height_cm,
  nullif(product_width_cm,'')::numeric as product_width_cm
from raw.olist_products;
