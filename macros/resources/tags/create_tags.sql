{% macro create_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set dbt_tags = dbt_tags.get_dbt_tags(debug=debug) %}

  {% set query -%}
  
    {% for item in dbt_tags -%}
      {% if loop.first %}
        create schema if not exists {{ ns }};
      {%- endif %}
      create tag if not exists {{ ns }}.{{ item.tag }}
        with comment = '{{ target.name | upper }} - {{ project_name }}''s dbt managed tags | context: {{ item | tojson }}';
    {% endfor %}

  {%- endset %}

  {{ log("query: " ~ query, info=True) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.create_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}
    
  {% endif %}

{% endmacro %}