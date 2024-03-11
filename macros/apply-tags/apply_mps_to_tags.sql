{% macro apply_mps_to_tags(ns=none, debug=False) -%}
  {{ return(adapter.dispatch('apply_mps_to_tags', 'dbt_tags')(ns=ns, debug=debug)) }}
{%- endmacro %}

{% macro default__apply_mps_to_tags(ns=none, debug=False) %}

  {% set ns = ns or dbt_tags.get_resource_ns() %}
  {% set tags = dbt_tags.get_dbt_tags(debug=debug) %}
  {% set column_tags = [] %}

  {% for tag in tags if ".column" in tag["level"] %}
      {% do column_tags.append(tag) %}
  {% endfor %}

  {% set query -%}

    {% for item in column_tags %}
      {%- if get_masking_policy_for_tag(item.tag) %}
        alter tag {{ ns }}.{{ item.tag }} set masking policy {{ ns }}.{{ item.tag }} force;
      {%- endif -%}
    {% endfor %}

  {%- endset %}

  {{ log("query: " ~ query, info=True) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.apply_mp_to_column_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
