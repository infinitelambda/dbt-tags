{% macro apply_source_column_tags() -%}
  {{ return(adapter.dispatch('apply_source_column_tags', 'dbt_tags')()) }}
{%- endmacro %}

{% macro default__apply_source_column_tags() %}

  {% if not execute %}
    {{ return("") }}
  {% endif %}

  {% set query %}
  {%- for source in graph.sources.values() -%}
    {{dbt_tags.apply_tags(source)}}
  {%- endfor %}
  {%- endset %}
  {{return(query)}}

{% endmacro %}
