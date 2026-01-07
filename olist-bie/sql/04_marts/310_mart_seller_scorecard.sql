drop table if exists mart.seller_scorecard;

create table mart.seller_scorecard as
with base as (
  -- one row per (seller_id, order_id) to avoid double counting
  select
    i.seller_id,
    o.order_id,
    o.purchase_ts::date as order_date,
    o.is_delivered,
    o.is_late,
    o.delay_days,
    o.days_late,
    o.avg_review_score,
    coalesce(o.order_gmv, 0) as order_gmv_booked
  from dwh.fact_order_items i
  join dwh.fact_orders o using(order_id)
  group by 1,2,3,4,5,6,7,8,9
)
select
  seller_id,

  count(distinct order_id) as orders,
  round(sum(order_gmv_booked)::numeric, 2) as gmv_booked,
  round(avg(order_gmv_booked)::numeric, 2) as aov_booked,

  count(distinct order_id) filter (where is_delivered) as delivered_orders,

  -- late rate among delivered orders
  round(
    (
      (count(distinct order_id) filter (where is_delivered and is_late))::numeric
      / nullif(count(distinct order_id) filter (where is_delivered), 0)
    )::numeric
  , 4) as late_rate,

  -- this is "delivered - estimated" (can be negative = early). Keep if you want context.
  round(avg(delay_days) filter (where is_delivered)::numeric, 2) as avg_days_vs_estimate,

  -- severity when late: only positive late days
  round(avg(days_late) filter (where days_late is not null)::numeric, 2) as avg_days_late_when_late,

  round(avg(avg_review_score) filter (where avg_review_score is not null)::numeric, 2) as avg_review_score
from base
group by 1;

create index if not exists ix_seller_scorecard_gmv on mart.seller_scorecard(gmv_booked);
create index if not exists ix_seller_scorecard_late on mart.seller_scorecard(late_rate);

select seller_id, orders, gmv_booked, late_rate, avg_days_late_when_late, avg_review_score
from mart.seller_scorecard
order by gmv_booked desc
limit 10;
