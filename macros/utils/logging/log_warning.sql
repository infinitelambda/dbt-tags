{% macro log_warning(message) -%}
  {{ return(adapter.dispatch('log_warning', 'dbt_tags')(message=message)) }}
{%- endmacro %}


{% macro default__log_warning(message) %}

  {% set yellow = "\x1b[33m" %}
  {% set reset = "\x1b[0m" %}

  {{ log(yellow ~ "⚠️  WARNING: " ~ message ~ reset, info=True) }}

{% endmacro %}