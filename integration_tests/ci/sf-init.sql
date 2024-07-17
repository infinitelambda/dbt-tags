use role sysadmin;
use warehouse compute_wh;
create or replace database dbt_tags with comment = 'Database for dbt_tags';

use role accountadmin;
create or replace resource monitor rm_dbt_tags with
  credit_quota = 1
  frequency = daily
  start_timestamp = immediately
  notify_users = ("<YOUR_USER>")
  triggers
    on 100 percent do suspend_immediate
;

create or replace warehouse wh_dbt_tags with
  warehouse_type = 'standard'
  warehouse_size = 'xsmall'
  auto_suspend = 60
  auto_resume = true
  initially_suspended = true
  resource_monitor = rm_dbt_tags
  comment = 'Warehouse for dbt_tags';

use role securityadmin;
create or replace role role_dbt_tags with comment = 'Role for dbt_tags';

grant usage on warehouse wh_dbt_tags to role role_dbt_tags;
grant usage on database dbt_tags to role role_dbt_tags;
grant all privileges on database dbt_tags to role role_dbt_tags;
grant all privileges on all schemas in database dbt_tags to role role_dbt_tags;
grant all privileges on future schemas in database dbt_tags to role role_dbt_tags;
grant all privileges on all tables in database dbt_tags to role role_dbt_tags;
grant all privileges on future tables in database dbt_tags to role role_dbt_tags;
grant all privileges on all views in database dbt_tags to role role_dbt_tags;
grant all privileges on future views in database dbt_tags to role role_dbt_tags;
grant usage, create schema on database dbt_tags to role role_dbt_tags;
grant role role_dbt_tags to role sysadmin;

use role accountadmin;
grant apply masking policy on account to role role_dbt_tags;
grant apply tag on account to role role_dbt_tags;

use role role_dbt_tags;
use database dbt_tags;
