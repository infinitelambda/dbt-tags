{% macro get_masking_policy_for_tag(tag_key) -%}
  {{ return(adapter.dispatch('get_masking_policy_for_tag', 'dbt_tags')(tag_key=tag_key)) }}
{%- endmacro %}

{% macro default__get_masking_policy_for_tag(tag_key) %}

  {% set call_masking_policy_macro = context.get("create_masking_policy__" ~ tag_key, none) -%}
  {%- if call_masking_policy_macro is none -%}
    {%- do dbt_tags.log_warning('Masking policy for tag ' ~ tag_key ~ ' is not found') %}
  {%- endif %}

  {{ return(call_masking_policy_macro) }}

{% endmacro %}
