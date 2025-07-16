{% macro log_query(message) -%}
  {{ return(adapter.dispatch('log_query', 'dbt_tags')(message=message)) }}
{%- endmacro %}


{% macro default__log_query(message) %}

  {% set blue = "\x1b[34m" %}
  {% set reset = "\x1b[0m" %}

  {{ log("ℹ️  Query:\n " ~ blue ~ message ~ reset, info=True) }}

{% endmacro %}