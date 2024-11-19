{% macro get_resource_ns(debug=False) -%}
  {{ return(adapter.dispatch('get_resource_ns', 'dbt_tags')()) }}
{%- endmacro %}

{% macro default__get_resource_ns() %}
  {% if var("dbt_tags__opt_in_default_naming_config", true) %}
    {{ return(generate_database_name(var("dbt_tags__database", target.database)) ~ "." ~ generate_schema_name(var("dbt_tags__schema", target.schema))) }}
  {% else %}
    {{ return(var("dbt_tags__database", target.database) ~ "." ~ var("dbt_tags__schema", target.schema)) }}
  {% endif %}

{% endmacro %}
