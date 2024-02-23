{% macro apply_mp_to_column_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set tags = dbt_tags.get_dbt_tags(debug=debug) %} {# TODO filter column only #}

  {% set query -%}
  
    TODO
    {% for item in tags %}
      alter tag xxx set masking policy xxx force;
    {% endfor %}

  {%- endset %}

  {{ log("query: " ~ query, info=True) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.apply_mp_to_column_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}
    
  {% endif %}

{% endmacro %}