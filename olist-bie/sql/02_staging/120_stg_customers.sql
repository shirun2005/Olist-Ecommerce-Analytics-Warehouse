drop table if exists stg.customers;
create table stg.customers as
select
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  customer_city,
  customer_state
from raw.olist_customers;