{% macro create_tags(debug=False) -%}
  {{ return(adapter.dispatch('create_tags', 'dbt_tags')(debug=debug)) }}
{%- endmacro %}

{% macro default__create_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set found_tags = dbt_tags.get_dbt_tags(debug=debug) %}
  {% set unique_dbt_tags = [] %}

  {% for item in found_tags if item.tag not in unique_dbt_tags and dbt_tags.get_tag_fqn(item.tag) == ns ~ '.' ~ item.tag %}
    {{ unique_dbt_tags.append(item.tag) }}
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
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.create_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
