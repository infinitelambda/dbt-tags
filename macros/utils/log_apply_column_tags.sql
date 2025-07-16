{% macro log_apply_column_tags(log_list) -%}
  {{ return(adapter.dispatch('log_apply_column_tags', 'dbt_tags')(log_list)) }}
{%- endmacro %}

{% macro default__log_apply_column_tags(log_list) %}
  {% for log_item in log_list %}
    {% do dbt_tags.log_info(log_item) %}
  {% endfor %}
{% endmacro %}
