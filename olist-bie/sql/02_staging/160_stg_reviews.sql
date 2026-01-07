drop table if exists stg.reviews;
create table stg.reviews as
select
  review_id,
  order_id,
  nullif(review_score,'')::int as review_score,
  nullif(review_creation_date,'')::timestamp as review_creation_ts,
  nullif(review_answer_timestamp,'')::timestamp as review_answer_ts
from raw.olist_order_reviews;