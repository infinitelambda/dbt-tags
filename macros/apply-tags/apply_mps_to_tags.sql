{% macro apply_mps_to_tags(ns=none, debug=False) -%}
  {{ return(adapter.dispatch('apply_mps_to_tags', 'dbt_tags')(ns=ns, debug=debug)) }}
{%- endmacro %}

{% macro default__apply_mps_to_tags(ns=none, debug=False) %}

  {% set ns = ns or dbt_tags.get_resource_ns() %}
  {% set tags = dbt_tags.get_dbt_tags(debug=debug) %}
  {% set column_tags = [] %}
  {% set unique_column_tags = [] %}
  {% set policy_data_types_list = var('dbt_tags__policy_data_types', []) -%}

  {% for tag in tags if ".column" in tag["level"] %}
      {% do column_tags.append(tag) %}
  {% endfor %}

  {% for item in column_tags if item.tag not in unique_column_tags %}
    {{ unique_column_tags.append(item.tag) }}
  {% endfor %}

  {% set query -%}

    {% for tag in unique_column_tags %}
      {%- if dbt_tags.get_masking_policy_for_tag(tag) %}
        {%- for policy_data_types in policy_data_types_list if tag in policy_data_types.keys() %}
          {%- for datatype in policy_data_types.values() | first %}
            alter tag {{ ns }}.{{ tag }} set masking policy {{ ns }}.{{ tag }}_{{ datatype }} force;
          {% endfor %}
        {%- else %}
            alter tag {{ ns }}.{{ tag }} set masking policy {{ ns }}.{{ tag }} force;
        {% endfor %}
      {%- endif -%}
    {% endfor %}

  {%- endset %}

  {{ log_query(query) if execute }}
  {% if not debug %}

    {{ log("[RUN]: dbt_tags.apply_mp_to_column_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
