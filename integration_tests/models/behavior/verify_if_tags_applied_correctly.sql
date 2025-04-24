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
{% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
{% if execute %}
  {% set dbt_project_tags = dbt_tags.get_dbt_tags(with_value=True) %}
{% endif %}

with dbt_project_tags as (
  {% for item in dbt_project_tags if ".column" in item["level"]  %}

    {% set tag_name = item.tag.split(tag_name_separator)[0] %}
    {% if not item.tag.split(tag_name_separator)[1] %}
      {% set tag_value = item.name %}
    {%- else %}
      {% set tag_value = item.tag.split(tag_name_separator)[1] %}
    {% endif %}
    {{- log("Item:" ~ item ~ " tag_name: " ~ tag_name  ~ " tag_value: " ~ tag_value, info=True) -}}

    select  lower('{{ tag_name }}') as tag_name,
            lower('{{ tag_value }}') as tag_value,
            lower('{{ item.model_fqn }}') as model_name,
            lower('{{ item.name }}') as column_name,

    {% if not loop.last %}
      union all
    {% endif %}

  {% endfor %}
),

column_tag_references as (

  {% for item in dbt_project_tags if ".column" in item.level %}

    select  lower(tag_name) as tag_name,
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
  and     actual.model_name   = config.model_name
  and     actual.column_name  = config.column_name
