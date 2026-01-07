drop table if exists dwh.dim_seller;
create table dwh.dim_seller as
select distinct * from stg.sellers;
