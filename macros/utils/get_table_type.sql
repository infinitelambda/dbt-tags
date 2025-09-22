{% macro get_table_type(resource) -%}
  {{ return(adapter.dispatch('get_table_type', 'dbt_tags')(resource)) }}
{%- endmacro %}

{% macro default__get_table_type(resource) %}
  {% if var('dbt_tags__enable_iceberg_support', true) == false %}
    {{ return('standard') }}
  {% elif resource.config.get('table_format') == 'iceberg' %}
    {{ return('iceberg') }}
  {% else %}
    {{ return('standard') }}
  {% endif %}
{% endmacro %}
