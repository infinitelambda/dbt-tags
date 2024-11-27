{% macro apply_column_tags() -%}
  {{ return(adapter.dispatch('apply_column_tags', 'dbt_tags')()) }}
{%- endmacro %}

{% macro default__apply_column_tags() %}

  {% if not execute %}
    {{ return("") }}
  {% endif %}

  {% set query %}
    {{ dbt_tags.apply_column_tags_query(model) }}
  {% endset %}

  {{ return(query) }}

{% endmacro %}
