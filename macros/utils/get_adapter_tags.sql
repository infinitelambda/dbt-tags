{% macro get_adapter_tags(ns=none, debug=False) %}

  {% if not execute %}
    {{ return([]) }}
  {% endif %}

  {% set ns = ns or dbt_tags.get_resource_ns() %}
  {% set query_adapter_tags_in_ns %}
  
    show tags in schema {{ ns }};
    select  "database_name" || '.' || "schema_name" || '.' || "name" as tag_name
    from    table(result_scan(last_query_id()))
    where   "database_name" || '.' || "schema_name" ilike '{{ ns }}';

  {% endset %}
  {% set adapter_tags = dbt_utils.get_query_results_as_dict(query_adapter_tags_in_ns) %}
  {% set adapter_tags = adapter_tags['TAG_NAME'] | unique | list %}
  {{ log("adapter_tags: " ~ adapter_tags, info=True) if debug }}

  {{ return(adapter_tags) }}

{% endmacro %}