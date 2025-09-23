{% macro get_table_type(resource) -%}
  {{ return(adapter.dispatch('get_table_type', 'dbt_tags')(resource)) }}
{%- endmacro %}


{% macro default__get_table_type(resource) %}
  {% if (var('dbt_tags__enable_iceberg_support',true) | lower) in ['true', 'yes', '1'] %}
    {% if resource.config.get('table_format') == 'iceberg' %}
      {{ return('iceberg') }}
    {% endif %}
  {% endif %}
    {{ return('standard') }}
{% endmacro %}
