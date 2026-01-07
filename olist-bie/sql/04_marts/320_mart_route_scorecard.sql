-- 320: Route Scorecard Mart (seller_state -> customer_state)

create schema if not exists mart;

drop table if exists mart.route_scorecard;

create table mart.route_scorecard as
with base as (
  -- one row per order with a single seller attribution + customer state
  select
    o.order_id,
    s.seller_state,
    c.customer_state,
    o.is_delivered,
    o.is_late,
    o.days_late
  from dwh.fact_orders o
  join dwh.dim_customer c
    on o.customer_id = c.customer_id
  join (
    -- deterministic seller attribution per order to avoid double counting
    select
      i.order_id,
      min(i.seller_id) as seller_id
    from dwh.fact_order_items i
    group by 1
  ) os using(order_id)
  join dwh.dim_seller s
    on os.seller_id = s.seller_id
)
select
  seller_state,
  customer_state,
  count(*) as orders,
  count(*) filter (where is_delivered) as delivered_orders,
  round(
    (
      (count(*) filter (where is_delivered and is_late))::numeric
      / nullif(count(*) filter (where is_delivered), 0)
    )::numeric
  , 4) as late_rate,
  round(avg(days_late) filter (where days_late is not null)::numeric, 2) as avg_days_late_when_late
from base
group by 1,2;

create index if not exists ix_route_scorecard_states
  on mart.route_scorecard(seller_state, customer_state);

-- Quick checks
select count(*) as route_pairs from mart.route_scorecard;

select *
from mart.route_scorecard
where delivered_orders >= 200
order by late_rate desc
limit 20;


-- Impact core
-- Impact = devlivered orders x late rate 
select
  seller_state,
  customer_state,
  delivered_orders,
  late_rate,
  round(delivered_orders * late_rate, 0) as expected_late_orders,
  avg_days_late_when_late
from mart.route_scorecard
where delivered_orders >= 200
order by expected_late_orders desc
limit 20;