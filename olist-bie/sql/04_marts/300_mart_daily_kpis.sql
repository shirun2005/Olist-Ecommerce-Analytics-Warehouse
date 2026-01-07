drop table if exists mart.daily_kpis;

create table mart.daily_kpis as
select
  date_trunc('day', purchase_ts)::date as dt,

  count(*) as orders,
  count(*) filter (where is_delivered) as delivered_orders,
  count(*) filter (where order_status = 'canceled') as canceled_orders,
  (count(*) filter (where order_status = 'canceled'))::numeric / nullif(count(*),0) as cancel_rate,

  -- "booked" GMV (treat null as 0 so days with only cancellations show 0)
  sum(coalesce(order_gmv,0)) as gmv_booked,
  avg(coalesce(order_gmv,0)) as aov_booked,

  -- delivered GMV (often what ecommerce teams care about)
  sum(coalesce(order_gmv,0)) filter (where is_delivered) as gmv_delivered,
  avg(order_gmv) filter (where is_delivered and order_gmv is not null) as aov_delivered,

  avg(delay_days) filter (where is_delivered) as avg_delay_days,
  (count(*) filter (where is_delivered and is_late))::numeric
    / nullif(count(*) filter (where is_delivered),0) as late_rate,

  avg(avg_review_score) filter (where avg_review_score is not null) as avg_review_score
from dwh.fact_orders
group by 1
order by 1;

--Check
select dt, orders, canceled_orders, gmv_booked, aov_booked
from mart.daily_kpis
order by dt
limit 10;
