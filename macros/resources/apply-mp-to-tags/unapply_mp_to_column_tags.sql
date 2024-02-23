{% macro unapply_mp_to_column_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set tags = dbt_tags.get_adapter_tags(ns=ns) %}

  {% set query -%}
  
    {% for item in tags %}
      {% if loop.first %}
        create or replace masking policy {{ ns }}.dbt_tags__dummy as (val string) returns string -> val;
      {% endif %}

      alter tag xxx set masking policy {{ ns }}.dbt_tags__dummy force;
      alter tag xxx unset masking policy {{ ns }}.dbt_tags__dummy;

      {% if loop.last %}
        drop masking policy {{ ns }}.dbt_tags__dummy;
      {% endif %}
    {% endfor %}

  {%- endset %}

  {{ log("query: " ~ query, info=True) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.unapply_mp_to_column_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}
    
  {% endif %}

{% endmacro %}