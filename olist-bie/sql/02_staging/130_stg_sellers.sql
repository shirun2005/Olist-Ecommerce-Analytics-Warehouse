drop table if exists stg.sellers;
create table stg.sellers as
select
  seller_id,
  seller_zip_code_prefix,
  seller_city,
  seller_state
from raw.olist_sellers;