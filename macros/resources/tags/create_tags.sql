{% macro create_tags(debug=False) -%}
  {{ return(adapter.dispatch('create_tags', 'dbt_tags')(debug=debug)) }}
{%- endmacro %}

{% macro default__create_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set found_tags = dbt_tags.get_dbt_tags(debug=debug) %}
  {% set unique_dbt_tags = [] %}

  {% for tag in found_tags | map(attribute='tag') | unique %}
    {% if dbt_tags.is_managed_tag(tag) %}
      {% do unique_dbt_tags.append(tag) %}
    {% else %}
      {% do dbt_tags.log_info("dbt_tags.create_tags - Ignored tag [" ~ tag ~ "]: outside of the configured namespace [" ~ ns ~ "]") %}
    {% endif %}
  {% endfor %}

  {% set query -%}

    {% for tag in unique_dbt_tags -%}
      {% if loop.first %}
        create schema if not exists {{ ns }};
      {%- endif %}
      create tag if not exists {{ ns }}.{{ tag }}
        with comment = '{{ target.name | upper }} - {{ project_name }}''s dbt managed tags';
    {% endfor %}

  {%- endset %}

  {{ log_query(query) if execute }}
  {% if not debug and unique_dbt_tags %}

    {{ log("[RUN]: dbt_tags.create_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
