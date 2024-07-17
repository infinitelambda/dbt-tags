{{
  config(
    materialized = 'table'
  )
}}


{% if execute %}
    {%- set dbt_project_tags = dbt_tags.get_dbt_tags() %}
{% endif %}
{% set policy_data_types_list = var('dbt_tags__policy_data_types', []) -%}
{%- set ns = dbt_tags.get_resource_ns() %}
{%- set database_name = ns.split('.')[0] %}
{%- set schema_name = ns.split('.')[1] %}

with dbt_project_tags as (

    {%- for item in dbt_project_tags if (".column" in item['level'] and dbt_tags.get_masking_policy_for_tag(item.tag)) -%}

    {%- set masking_policy = dbt_tags.get_masking_policy_for_tag(item.tag) %}
      {%- if masking_policy %}
        {% for policy_data_types in policy_data_types_list if item.tag in policy_data_types.keys() %}
          {% for datatype in policy_data_types.values() | first %}
            {%- set masking_policy_name = masking_policy.get_name().split('__')[1] ~ "_" ~ datatype %}

    select
      lower('{{ item.tag }}') as tag,
      lower('{{ masking_policy_name }}') as masking_policy_name,
      lower('{{ database_name }}') as database_name,
      lower('{{ schema_name }}') as schema_name

            {%- if not loop.last %}
    union all
            {%- endif %}
          {% endfor %}
        {% else %}
          {%- set masking_policy_name = masking_policy.get_name().split('__')[1] %}

    select
      lower('{{ item.tag }}') as tag,
      lower('{{ masking_policy_name }}') as masking_policy_name,
      lower('{{ database_name }}') as database_name,
      lower('{{ schema_name }}') as schema_name
        {% endfor %}

        {%- if not loop.last %}
    union all
        {%- endif %}
      {%- endif %}

  {%- endfor %}
),

adapter_tags as (

    {%- for item in dbt_project_tags if (".column" in item['level'] and dbt_tags.get_masking_policy_for_tag(item.tag)) %}

      {%- set masking_policy = dbt_tags.get_masking_policy_for_tag(item.tag) %}
      {%- if masking_policy %}
        {% for policy_data_types in policy_data_types_list if item.tag in policy_data_types.keys() %}
          {% for datatype in policy_data_types.values() | first %}
    select
        lower(ref_entity_name) as tag,
        lower(policy_name) as masking_policy_name,
        lower(ref_database_name) as database_name,
        lower(ref_schema_name) as schema_name
    from table(information_schema.policy_references(policy_name => '{{ database_name }}.{{ schema_name }}.{{ item.tag }}_{{ datatype }}'))
    where true
      and ref_entity_domain = 'TAG'
      and lower(ref_entity_name) = '{{ item.tag }}'

          {%- if not loop.last %}
            union all
            {%- endif %}
          {% endfor %}
        {% else %}
    select
        lower(ref_entity_name) as tag,
        lower(policy_name) as masking_policy_name,
        lower(ref_database_name) as database_name,
        lower(ref_schema_name) as schema_name
    from table(information_schema.policy_references(policy_name => '{{ database_name }}.{{ schema_name }}.{{ item.tag }}'))
    where true
      and ref_entity_domain = 'TAG'
      and lower(ref_entity_name) = '{{ item.tag }}'
        {% endfor %}
        {%- if not loop.last %}
    union all
        {%- endif %}
      {%- endif %}

    {%- endfor %}

)

select  distinct
        config.database_name || '.' || config.schema_name || '.' || config.masking_policy_name as masking_policy,
        config.database_name || '.' || config.schema_name || '.' || config.tag as dbt_project_tag,
        actual.database_name || '.' || actual.schema_name || '.' || actual.tag as adapter_tag
from      dbt_project_tags as config
full join adapter_tags as actual
  on      actual.database_name = config.database_name
  and     actual.schema_name = config.schema_name
  and     actual.masking_policy_name = config.masking_policy_name
