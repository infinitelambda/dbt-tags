/*
depends on:
- {{ ref('customers') }}
- {{ ref('orders') }}
*/

{{
  config(
    materialized = 'table',
    transient = true
  )
}}

{% set dbt_project_tags = [] %}
{% if execute %}
  {% set dbt_project_tags = dbt_tags.get_dbt_tags() %}
{% endif %}

with dbt_project_tags as (
  {% for item in dbt_project_tags if ".column" in item["level"]  %}

    {% set model_fqn -%}
      {{ target.database }}.{{ target.schema }}.{{ item.level.split(".")[1] }}
    {%- endset %}

    select  lower('{{ item.tag }}') as tag_name,
            lower('{{ item.name }}') as tag_value,
            lower('{{ model_fqn }}') as model_name,
            lower('{{ item.name }}') as column_name,

    {% if not loop.last %}
      union all
    {% endif %}

  {% endfor %}
),

column_tag_references as (

  {% for item in dbt_project_tags if ".column" in item.level %}

    {% set model_fqn -%}
      {{ target.database }}.{{ target.schema }}.{{ item.level.split(".")[1] }}
    {%- endset %}

    select  lower(tag_name) as tag_name,
            lower(tag_value) as tag_value,
            lower(object_database || '.' || object_schema || '.' || object_name) as model_name,
            lower(column_name) as column_name,

    from    table(
      information_schema.tag_references(
        '{{ model_fqn }}.{{ item.name }}', 'COLUMN'
      )
    )

    {% if not loop.last %}
      union
    {% endif %}

  {% endfor %}

)

select    config.model_name || '.' || config.column_name || ': ' || config.tag_name as config,
          actual.model_name || '.' || actual.column_name || ': ' || actual.tag_name as actual,
from      dbt_project_tags as config
full join column_tag_references as actual
  on      actual.tag_name     = config.tag_name
  and     actual.tag_value    = config.tag_value
  and     actual.model_name   = config.model_name
  and     actual.column_name  = config.column_name
