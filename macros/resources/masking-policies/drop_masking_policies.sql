{% macro drop_masking_policies(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}

  {% set query -%}
  
    TODO

  {%- endset %}

  {{ log("query: " ~ query, info=True) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.drop_masking_policies", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}
    
  {% endif %}

{% endmacro %}