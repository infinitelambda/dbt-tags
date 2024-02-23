{% macro is_allowed_tags(tag_key) %}

  {% set allow_tags = var('dbt_tags__allowed_tags', []) %}
  {{ return((allow_tags | length == 0) or (tag_key in allow_tags)) }}

{% endmacro %}