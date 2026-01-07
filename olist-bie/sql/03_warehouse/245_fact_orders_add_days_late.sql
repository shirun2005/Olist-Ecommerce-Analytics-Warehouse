-- Adds late severity metric: days_late (only when delivered late; positive number)

alter table dwh.fact_orders
  add column if not exists days_late numeric;

update dwh.fact_orders
set days_late = case
  when is_delivered
   and estimated_delivery_ts is not null
   and delivered_customer_ts is not null
   and delivered_customer_ts > estimated_delivery_ts
  then extract(epoch from (delivered_customer_ts - estimated_delivery_ts))/86400.0
  else null
end;


select
  count(*) filter (where days_late is not null) as late_orders_with_days_late,
  avg(days_late) as avg_days_late
from dwh.fact_orders;
