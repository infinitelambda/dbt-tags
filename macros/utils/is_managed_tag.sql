{% macro is_managed_tag(tag_name) -%}
  {{ return(adapter.dispatch('is_managed_tag', 'dbt_tags')(tag_name=tag_name)) }}
{%- endmacro %}

{% macro default__is_managed_tag(tag_name) %}
  {{ return(dbt_tags.get_tag_fqn(tag_name) == dbt_tags.get_resource_ns() ~ '.' ~ tag_name) }}
{% endmacro %}
