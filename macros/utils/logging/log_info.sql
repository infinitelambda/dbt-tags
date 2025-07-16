{% macro log_info(message) -%}
  {{ return(adapter.dispatch('log_info', 'dbt_tags')(message=message)) }}
{%- endmacro %}


{% macro default__log_info(message) %}

  {% set gray = "\x1b[90m" %}
  {% set reset = "\x1b[0m" %}

  {{ log(gray ~ message ~ reset, info=True) }}

{% endmacro %}