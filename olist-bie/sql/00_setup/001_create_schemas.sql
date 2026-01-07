-- Create necessary schemas for the data warehouse
create schema if not exists raw;
create schema if not exists stg;
create schema if not exists dwh;

-- Verify that the schemas were created successfully
select schema_name
from information_schema.schemata
where schema_name in ('raw','stg','dwh');
