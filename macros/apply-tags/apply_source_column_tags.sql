{% macro apply_source_column_tags() -%}
  {{ return(adapter.dispatch('apply_source_column_tags', 'dbt_tags')()) }}
{%- endmacro %}

{% macro default__apply_source_column_tags() %}

  {% if not execute or not var('dbt_tags__tag_source_columns',true)%}
    {{ return("") }}
  {% endif %}

  {% set query %}
    {%- for source in graph.sources.values() -%}
      {{ dbt_tags.apply_column_tags_query(source) }}
    {%- endfor %}
  {%- endset %}
  {{return(query)}}

{% endmacro %}
