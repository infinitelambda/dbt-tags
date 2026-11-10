{% macro create_masking_policies(debug=False) -%}
  {{ return(adapter.dispatch('create_masking_policies', 'dbt_tags')(debug=debug)) }}
{%- endmacro %}

{% macro default__create_masking_policies(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set unique_dbt_tags = dbt_tags.get_dbt_tags() | map(attribute='tag') | unique | list %}

  {% set query -%}

    {% for tag in unique_dbt_tags -%}

      {%- if loop.first -%}
        create schema if not exists {{ ns }};
      {%- endif %}

      {%- set masking_policy = dbt_tags.get_masking_policy_for_tag(tag) %}
      {%- if masking_policy %}
        {{ masking_policy(ns) }}
      {%- endif -%}

    {%- endfor %}

  {%- endset %}

  {{ log_query(query) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.create_masking_policies", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
