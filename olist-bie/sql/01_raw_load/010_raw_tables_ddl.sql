-- This file contains the DDL statements to create raw tables
-- in the 'raw' schema of the data warehouse.

create schema if not exists raw;

drop table if exists raw.olist_customers;
create table raw.olist_customers (
  customer_id text,
  customer_unique_id text,
  customer_zip_code_prefix text,
  customer_city text,
  customer_state text
);

drop table if exists raw.olist_geolocation;
create table raw.olist_geolocation (
  geolocation_zip_code_prefix text,
  geolocation_lat text,
  geolocation_lng text,
  geolocation_city text,
  geolocation_state text
);

drop table if exists raw.olist_order_items;
create table raw.olist_order_items (
  order_id text,
  order_item_id text,
  product_id text,
  seller_id text,
  shipping_limit_date text,
  price text,
  freight_value text
);

drop table if exists raw.olist_order_payments;
create table raw.olist_order_payments (
  order_id text,
  payment_sequential text,
  payment_type text,
  payment_installments text,
  payment_value text
);

drop table if exists raw.olist_order_reviews;
create table raw.olist_order_reviews (
  review_id text,
  order_id text,
  review_score text,
  review_comment_title text,
  review_comment_message text,
  review_creation_date text,
  review_answer_timestamp text
);

drop table if exists raw.olist_orders;
create table raw.olist_orders (
  order_id text,
  customer_id text,
  order_status text,
  order_purchase_timestamp text,
  order_approved_at text,
  order_delivered_carrier_date text,
  order_delivered_customer_date text,
  order_estimated_delivery_date text
);

drop table if exists raw.olist_products;
create table raw.olist_products (
  product_id text,
  product_category_name text,
  product_name_lenght text,
  product_description_lenght text,
  product_photos_qty text,
  product_weight_g text,
  product_length_cm text,
  product_height_cm text,
  product_width_cm text
);

drop table if exists raw.olist_sellers;
create table raw.olist_sellers (
  seller_id text,
  seller_zip_code_prefix text,
  seller_city text,
  seller_state text
);

drop table if exists raw.product_category_name_translation;
create table raw.product_category_name_translation (
  product_category_name text,
  product_category_name_english text
);
