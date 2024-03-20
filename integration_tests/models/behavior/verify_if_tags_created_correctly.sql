/*
depends on:
- {{ ref('customers') }}
- {{ ref('orders') }}
*/

{% set show -%}
  show tags in schema {{ dbt_tags.get_resource_ns() }};
{%- endset %}

{{
  config(
    materialized = 'table',
    transient = true,
    sql_header = show
  )
}}

{% set dbt_project_tags = [] %}
{% if execute %}
  {% set dbt_project_tags = dbt_tags.get_dbt_tags() %}
{% endif %}

with dbt_project_tags as (
  {% for item in dbt_project_tags %}
    select lower('{{ item.tag }}') as tag_name
    {% if not loop.last %}
      union all
    {% endif %}
  {% endfor %}
),

adapter_tags as (
  select  lower("name") as tag_name
  from    table (result_scan(last_query_id()))
)

select    dbt_project_tags.tag_name as dbt_project_tag,
          adapter_tags.tag_name as adapter_tag
from      dbt_project_tags
full join adapter_tags using (tag_name)
