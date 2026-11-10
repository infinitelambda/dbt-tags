{% macro get_masking_policy_for_tag(tag_key) -%}
  {{ return(adapter.dispatch('get_masking_policy_for_tag', 'dbt_tags')(tag_key=tag_key)) }}
{%- endmacro %}

{% macro default__get_masking_policy_for_tag(tag_key) %}

  {% if not dbt_tags.is_managed_tag(tag_key) %}
    {% do dbt_tags.log_info("dbt_tags.get_masking_policy_for_tag - Ignored tag [" ~ tag_key ~ "]: outside of the configured namespace [" ~ dbt_tags.get_resource_ns() ~ "]") %}
    {{ return(none) }}
  {% endif %}

  {% set call_masking_policy_macro = context.get("create_masking_policy__" ~ tag_key, none) -%}
  {%- if call_masking_policy_macro is none -%}
    {%- do dbt_tags.log_warning('Masking policy for tag ' ~ tag_key ~ ' is not found') %}
  {%- endif %}

  {{ return(call_masking_policy_macro) }}

{% endmacro %}
