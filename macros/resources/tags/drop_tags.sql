{% macro drop_tags(debug=False) -%}
  {{ return(adapter.dispatch('drop_tags', 'dbt_tags')(debug=debug)) }}
{%- endmacro %}

{% macro default__drop_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set adapter_tags = dbt_tags.get_dbt_tags(debug=debug) %}
  {% set policy_data_types_list = var('dbt_tags__policy_data_types', none) -%}
  {% set query -%}

    {% set unique_tags = [] -%}
    {% for item in adapter_tags -%}
      {%- if dbt_tags.get_masking_policy_for_tag(item.tag) -%}
        {% for policy_data_types in policy_data_types_list if item.tag in policy_data_types.keys() -%}
          {% for datatype in policy_data_types.values() | first -%}
            {% set tag_info = (item.tag, item.tag ~ "_" ~ datatype) -%}
            {% do unique_tags.append(tag_info) if tag_info not in unique_tags -%}
          {% endfor -%}
          {% else -%}
            {% set tag_info = (item.tag, item.tag) -%}
            {% do unique_tags.append(tag_info) if tag_info not in unique_tags -%}
        {% endfor -%}
        {% else -%}
          {% set tag_info = (item.tag, none) -%}
          {% do unique_tags.append(tag_info) if tag_info not in unique_tags -%}
      {%- endif -%}
    {% endfor -%}

    {%- for item in unique_tags if item[1] is not none %}
      alter tag {{ ns }}.{{ item[0] }} unset masking policy {{ ns }}.{{ item[1] }};
    {%- endfor %}
    {%- for item in unique_tags %}
      drop tag if exists {{ ns }}.{{ item[0] }};
    {%- endfor %}

  {%- endset %}

  {{ log_query(query or "<nothing runs>") if execute }}
  {% if not debug and adapter_tags %}

    {{ log("[RUN]: dbt_tags.drop_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
