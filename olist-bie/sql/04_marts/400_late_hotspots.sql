-- A) Late-rate hotspots by seller state → customer state
select
  s.seller_state,
  c.customer_state,
  count(distinct o.order_id) as delivered_orders,
  (count(distinct o.order_id) filter (where o.is_late))::numeric
    / nullif(count(distinct o.order_id),0) as late_rate,
  avg(o.delay_days) as avg_delay_days
from dwh.fact_orders o
join dwh.dim_customer c on o.customer_id = c.customer_id
join dwh.fact_order_items i on o.order_id = i.order_id
join dwh.dim_seller s on i.seller_id = s.seller_id
where o.is_delivered
group by 1,2
having count(distinct o.order_id) >= 200
order by late_rate desc, delivered_orders desc
limit 20;

