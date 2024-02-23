{% macro drop_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set adapter_tags = dbt_tags.get_adapter_tags(ns=ns) %}
  {% set query -%}
    
    {% for item in adapter_tags -%}
      {% if loop.first %}
        create or replace masking policy {{ ns }}.dbt_tags__dummy as (val string) returns string -> val;
      {% endif %}
  
      alter tag {{ item }} set masking policy {{ ns }}.dbt_tags__dummy force;
      alter tag {{ item }} unset masking policy {{ ns }}.dbt_tags__dummy;
      drop tag {{ item }};

      {% if loop.last %}
        drop masking policy {{ ns }}.dbt_tags__dummy;
      {% endif %}
      
    {%- endfor %}

  {%- endset %}

  {{ log("query: " ~ (query or "nothing runs"), info=True) if execute }}
  {% if not debug and adapter_tags %}

    {{ log("[RUN]: dbt_tags.drop_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}
    
  {% endif %}

{% endmacro %}