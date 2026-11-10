{% macro get_tag_fqn(tag_name) -%}
  {{ return(adapter.dispatch('get_tag_fqn', 'dbt_tags')(tag_name=tag_name)) }}
{%- endmacro %}

{% macro default__get_tag_fqn(tag_name) %}

  {% set parts = modules.re.findall('"[^"]*"|[^.]+', tag_name) %}
  {% set ns = dbt_tags.get_resource_ns() %}

  {% if parts | length == 1 %}
    {{ return(ns ~ '.' ~ tag_name) }}
  {% elif parts | length == 2 %}
    {{ return(ns.split('.')[0] ~ '.' ~ tag_name) }}
  {% elif parts | length == 3 %}
    {{ return(tag_name) }}
  {% endif %}

  {{ exceptions.raise_compiler_error("Invalid tag name [" ~ tag_name ~ "]: expected <tag>, <schema>.<tag> or <database>.<schema>.<tag>") }}

{% endmacro %}
