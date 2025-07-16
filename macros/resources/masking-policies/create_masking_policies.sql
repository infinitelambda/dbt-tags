{% macro create_masking_policies(debug=False) -%}
  {{ return(adapter.dispatch('create_masking_policies', 'dbt_tags')(debug=debug)) }}
{%- endmacro %}

{% macro default__create_masking_policies(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set tags = dbt_tags.get_dbt_tags() %}
  {% set unique_dbt_tags = [] %}

  {% for item in tags if item.tag not in unique_dbt_tags %}
    {{ unique_dbt_tags.append(item.tag) }}
  {% endfor %}

  {% set query -%}

    {% for tag in unique_dbt_tags -%}

      {%- if loop.first -%}
        create schema if not exists {{ ns }};
      {%- endif %}

      {%- if get_masking_policy_for_tag(tag) %}
        {{ get_masking_policy_for_tag(tag)(ns) }}
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
