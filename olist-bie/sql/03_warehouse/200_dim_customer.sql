drop table if exists dwh.dim_customer;
create table dwh.dim_customer as
select distinct * from stg.customers;
