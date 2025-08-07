{% macro extract_dbt_object_tags(obj, debug=False) -%}
  {{ return(adapter.dispatch('extract_dbt_object_tags', 'dbt_tags')(obj=obj, debug=debug)) }}
{%- endmacro %}

{% macro default__extract_dbt_object_tags(obj, debug=False) %}

  {% set obj_tags = [] %}
  {% if obj.tags is defined %}
    {% do obj_tags.extend(obj.tags) %}
  {% endif %}
  {% if obj.config.tags is defined %}
    {% do obj_tags.extend(obj.config.tags) %}
  {% endif %}

  {{ return(obj_tags | unique | list) }}

{% endmacro %}
