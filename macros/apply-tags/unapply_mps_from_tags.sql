{% macro unapply_mps_from_tags(ns=none, debug=False) -%}
  {{ return(adapter.dispatch('unapply_mps_from_tags', 'dbt_tags')(ns=ns, debug=debug)) }}
{%- endmacro %}


{% macro default__unapply_mps_from_tags(ns=none, debug=False) %}

  {% set ns = ns or dbt_tags.get_resource_ns() %}
  {% set tags = dbt_tags.get_dbt_tags() %}
  {% set column_tags = [] %}
  {% set policy_data_types_list = var('dbt_tags__policy_data_types', []) -%}

  {% for tag in tags if ".column" in tag["level"] %}
      {% do column_tags.append(tag.tag) %}
  {% endfor %}

  {% set query -%}

    {% for tag in column_tags | unique %}
      {%- if dbt_tags.get_masking_policy_for_tag(tag) %}
        {% for policy_data_types in policy_data_types_list if tag in policy_data_types.keys() %}
          {% for datatype in policy_data_types.values() | first %}
            alter tag {{ ns }}.{{ tag }} unset masking policy {{ ns }}.{{ tag }}_{{ datatype }};
          {% endfor %}
        {% else %}
          alter tag {{ ns }}.{{ tag }} unset masking policy {{ ns }}.{{ tag }};
        {% endfor %}
      {%- endif -%}
    {% endfor %}

  {%- endset %}

  {{ log_query(query) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.unapply_mps_from_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
