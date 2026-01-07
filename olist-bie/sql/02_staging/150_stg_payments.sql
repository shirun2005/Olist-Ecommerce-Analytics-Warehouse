drop table if exists stg.payments;
create table stg.payments as
select
  order_id,
  nullif(payment_sequential,'')::int as payment_seq,
  payment_type,
  nullif(payment_installments,'')::int as installments,
  nullif(payment_value,'')::numeric as payment_value
from raw.olist_order_payments;