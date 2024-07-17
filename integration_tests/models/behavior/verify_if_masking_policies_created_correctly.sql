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

with dbt_project_masking_policies as (

    {%- for item in dbt_project_tags if (".column" in item['level'] and dbt_tags.get_masking_policy_for_tag(item.tag))  %}
    {%- set masking_policy = dbt_tags.get_masking_policy_for_tag(item.tag) %}
        {% for policy_data_types in policy_data_types_list if item.tag in policy_data_types.keys() %}
          {% for datatype in policy_data_types.values() | first %}
            {%- set masking_policy_name = masking_policy.get_name().split('__')[1] ~ "_" ~ datatype %}
    select
        lower('{{ item.tag }}') as tag,
        lower('{{ masking_policy_name }}') as masking_policy_name,
        iff(masking_policy_name = '', null, lower('{{ database_name }}')) as database_name,
        iff(masking_policy_name = '', null, lower('{{ schema_name }}')) as schema_name

            {%- if not loop.last %}
    union all
            {%- endif %}
          {% endfor %}
        {% else %}

        {%- set masking_policy_name = masking_policy.get_name().split('__')[1] if masking_policy else "" %}
    select
        lower('{{ item.tag }}') as tag,
        lower('{{ masking_policy_name }}') as masking_policy_name,
        iff(masking_policy_name = '', null, lower('{{ database_name }}')) as database_name,
        iff(masking_policy_name = '', null, lower('{{ schema_name }}')) as schema_name
          {% endfor %}
        {%- if not loop.last %}
        union all
        {%- endif %}

  {%- endfor %}
),

adapter_masking_policies as (

    {%- if execute -%}
        {%- set query = 'show masking policies in ' ~ database_name ~ '.' ~ schema_name %}
        {%- do run_query(query) %}
        {%- set last_query %}
            select *
            from table(result_scan(last_query_id()))
        {%- endset %}
        {%- set result = run_query(last_query) %}
    {%- endif -%}

    {%- for item in result.rows %}
    select
        lower('{{ item["name"] }}') as masking_policy_name,
        lower('{{ item["database_name"] }}') as database_name,
        lower('{{ item["schema_name"] }}') as schema_name

    {%- if not loop.last %}
      union all
    {%- endif %}

    {%- endfor %}

)

select  distinct
        config.tag as tag,
        config.database_name || '.' || config.schema_name || '.' || config.masking_policy_name as dbt_project_masking_policy,
        actual.database_name || '.' || actual.schema_name || '.' || actual.masking_policy_name as adapter_masking_policy
from      dbt_project_masking_policies as config
full join adapter_masking_policies as actual
  on      actual.database_name     = config.database_name
  and     actual.schema_name    = config.schema_name
  and     actual.masking_policy_name   = config.masking_policy_name
