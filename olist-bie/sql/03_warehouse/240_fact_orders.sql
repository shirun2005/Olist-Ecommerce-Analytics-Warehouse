drop table if exists dwh.fact_orders;
create table dwh.fact_orders as
with order_gmv as (
  select order_id, sum(item_revenue) as order_gmv
  from dwh.fact_order_items
  group by 1
),
order_review as (
  select order_id, avg(review_score)::numeric(4,2) as avg_review_score
  from stg.reviews
  group by 1
)
select
  o.order_id,
  o.customer_id,
  o.order_status,
  o.purchase_ts,
  o.approved_ts,
  o.delivered_carrier_ts,
  o.delivered_customer_ts,
  o.estimated_delivery_ts,

  (o.delivered_customer_ts is not null) as is_delivered,

  case when o.delivered_customer_ts is not null
    then extract(epoch from (o.delivered_customer_ts - o.purchase_ts))/86400.0
  end as delivery_days,

  case when o.delivered_customer_ts is not null and o.estimated_delivery_ts is not null
    then extract(epoch from (o.delivered_customer_ts - o.estimated_delivery_ts))/86400.0
  end as delay_days,

  case when o.delivered_customer_ts is not null and o.estimated_delivery_ts is not null
    then (o.delivered_customer_ts > o.estimated_delivery_ts)
  else null end as is_late,

  g.order_gmv,
  r.avg_review_score
from stg.orders o
left join order_gmv g using(order_id)
left join order_review r using(order_id);



