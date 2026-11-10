{{
  config(
    tags = ['cleanup'],
  )
}}

{% set ns = dbt_tags.get_resource_ns() %}
{% set external_tags = [] %}
{% for item in dbt_tags.get_dbt_tags() if ".column" in item.level and dbt_tags.get_tag_fqn(item.tag) != ns ~ '.' ~ item.tag %}
  {% do external_tags.append(item) %}
{% endfor %}

with expected as (
  select null as tag_name, null as model_name, null as column_name where false
  {% for item in external_tags %}
  union all
  select  lower('{{ dbt_tags.get_tag_fqn(item.tag) | replace('"', '') }}'),
          lower('{{ item.model_fqn | replace('"', '') }}'),
          lower('{{ item.name }}')
  {% endfor %}
),

actual as (
  select null as tag_name, null as model_name, null as column_name where false
  {% for item in external_tags %}
  union all
  select  lower(tag_database || '.' || tag_schema || '.' || tag_name),
          lower(object_database || '.' || object_schema || '.' || object_name),
          lower(column_name)
  from    table(
    information_schema.tag_references(
      '{{ item.model_fqn }}.{% if item.quote %}{{ adapter.quote(item.name) }}{% else %}{{ item.name }}{% endif %}', 'COLUMN'
    )
  )
  {% endfor %}
)

select    expected.*
from      expected
left join actual
  on      actual.tag_name = expected.tag_name
  and     actual.model_name = expected.model_name
  and     actual.column_name = expected.column_name
where     actual.tag_name is null
