{% macro create_masking_policies(debug=False) -%}
  {{ return(adapter.dispatch('create_masking_policies', 'dbt_tags')(debug=debug)) }}
{%- endmacro %}

{% macro default__create_masking_policies(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set tags = dbt_tags.get_dbt_tags() %}

  {% set query -%}

    {% for item in tags -%}

      {%- if loop.first -%}
        create schema if not exists {{ ns }};
      {%- endif %}

      {% set call_masking_policy_macro = context.get("create_masking_policy__" ~ item.tag, none) -%}
      {%- if call_masking_policy_macro is not none -%}
        {{ call_masking_policy_macro(ns) }}
      {%- endif %}

    {%- endfor %}

  {%- endset %}

  {{ log("query: " ~ query, info=True) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.create_masking_policies", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
