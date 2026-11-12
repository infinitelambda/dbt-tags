/*
depends on:
- {{ ref('customers') }}
- {{ ref('orders') }}
- {{ ref('orders_snapshot') }}
*/

{{
  config(
    materialized = 'table',
    transient = true
  )
}}

{% set dbt_project_tags = [] %}
{% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
{% if execute %}
  {% set dbt_project_tags = dbt_tags.get_dbt_tags(with_value=True) %}
{% endif %}

{% set expected_tags = {} %}
{% for item in dbt_project_tags %}
  {% set tag_name, _, tag_value = item.tag.partition(tag_name_separator) %}
  {% do expected_tags.update({(item.model_fqn, item.name, dbt_tags.get_tag_fqn(tag_name)): tag_value or item.name}) %}
{% endfor %}

with dbt_project_tags as (
  {% for key, tag_value in expected_tags.items() %}

    select  lower('{{ key[2] | replace('"', '') }}') as tag_name,
            lower('{{ tag_value }}') as tag_value,
            lower('{{ key[0] }}') as model_name,
            lower('{{ key[1] }}') as column_name,

    {% if not loop.last %}
      union all
    {% endif %}

  {% endfor %}
),

column_tag_references as (

  {% for item in dbt_project_tags %}

    select  lower(tag_database || '.' || tag_schema || '.' || tag_name) as tag_name,
            lower(tag_value) as tag_value,
            lower(object_database || '.' || object_schema || '.' || object_name) as model_name,
            lower(column_name) as column_name,

    from    table(
      information_schema.tag_references(
        '{{ item.model_fqn }}.{% if item.quote %}{{ adapter.quote(item.name) }}{% else %}{{ item.name }}{% endif %}', 'COLUMN'
      )
    )

    {% if not loop.last %}
      union
    {% endif %}

  {% endfor %}

)

select    distinct
          config.model_name || '.' || config.column_name || ': ' || config.tag_name as config_tag_name,
          config.tag_value as config_tag_value,
          actual.model_name || '.' || actual.column_name || ': ' || actual.tag_name as actual_tag_name,
          actual.tag_value as actual_tag_value
from      dbt_project_tags as config
full join column_tag_references as actual
  on      actual.tag_name     = config.tag_name
  and     actual.tag_value    = config.tag_value
  and     actual.model_name   = replace(config.model_name, '"', '') -- testing "rawDummy" in particular
  and     actual.column_name  = config.column_name
