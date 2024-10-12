{% macro apply_column_tags() -%}
  {{ return(adapter.dispatch('apply_column_tags', 'dbt_tags')()) }}
{%- endmacro %}

{% macro default__apply_column_tags() %}

  {% if not execute %}
    {{ return("") }}
  {% endif %}

  {% set tag_ns = dbt_tags.get_resource_ns() %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% set query %}
    {{dbt_tags.apply_tags(model)}}
  {% endset %}

  {{ return(query) }}

{% endmacro %}
