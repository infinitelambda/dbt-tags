{% macro unapply_mps_from_tags(ns=none, debug=False) -%}
  {{ return(adapter.dispatch('unapply_mps_from_tags', 'dbt_tags')(ns=ns, debug=debug)) }}
{%- endmacro %}


{% macro default__unapply_mps_from_tags(ns=none, debug=False) %}

  {% set ns = ns or dbt_tags.get_resource_ns() %}
  {% set tags = dbt_tags.get_adapter_tags(ns=ns) %}
  {% set column_tags = [] %}
  {% set policy_data_types_list = var('dbt_tags__policy_data_types', none) -%}

  {% for tag in tags if ".column" in tag["level"] %}
      {% do column_tags.append(tag) %}
  {% endfor %}

  {% set query -%}

    {% for item in column_tags %}
      {%- if get_masking_policy_for_tag(item.tag) %}
        {% for policy_data_types in policy_data_types_list if item.tag in policy_data_types.keys() %}
          {% for datatype in policy_data_types.values() | first %}
            alter tag {{ ns }}.{{ item.tag }} unset masking policy {{ ns }}.{{ item.tag }}_{{ datatype }};
          {% endfor %}
        {% else %}
          alter tag {{ ns }}.{{ item.tag }} unset masking policy {{ ns }}.{{ item.tag }};
        {% endfor %}
      {%- endif -%}
    {% endfor %}

  {%- endset %}

  {{ log("query: " ~ query, info=True) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.unapply_mps_from_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
