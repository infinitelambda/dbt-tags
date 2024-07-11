{% macro drop_tags(debug=False) -%}
  {{ return(adapter.dispatch('drop_tags', 'dbt_tags')(debug=debug)) }}
{%- endmacro %}

{% macro default__drop_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set adapter_tags = dbt_tags.get_adapter_tags(ns=ns) %}
  {% set query -%}

    {% for item in adapter_tags %}
      {%- if get_masking_policy_for_tag(item.tag) %}
        {% for policy_data_types in policy_data_types_list if item.tag in policy_data_types.keys() %}
          {% for datatype in policy_data_types.values() | first %}
            alter tag {{ ns }}.{{ item.tag }} unset masking policy {{ ns }}.{{ item.tag }}_{{ datatype }};
          {% endfor %}
        {% else %}
          alter tag {{ ns }}.{{ item.tag }} unset masking policy {{ ns }}.{{ item.tag }};
        {% endfor %}
      {%- endif -%}
      drop tag {{ item }};
    {% endfor %}

  {%- endset %}

  {{ log("query: " ~ (query or "nothing runs"), info=True) if execute }}
  {% if not debug and adapter_tags %}

    {{ log("[RUN]: dbt_tags.drop_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
