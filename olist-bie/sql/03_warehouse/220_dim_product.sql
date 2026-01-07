drop table if exists dwh.dim_product;
create table dwh.dim_product as
select distinct
  product_id,
  product_category_name,
  product_weight_g,
  product_length_cm,
  product_height_cm,
  product_width_cm
from stg.products;
