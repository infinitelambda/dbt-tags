{% macro drop_tags(debug=False) -%}
  {{ return(adapter.dispatch('drop_tags', 'dbt_tags')(debug=debug)) }}
{%- endmacro %}

{% macro default__drop_tags(debug=False) %}

  {% set ns = dbt_tags.get_resource_ns() %}
  {% set found_tags = dbt_tags.get_dbt_tags() %}
  {% set policy_data_types_list = var('dbt_tags__policy_data_types', none) -%}
  {% set unique_tags = [] -%}

  {% for tag in found_tags | map(attribute='tag') | unique -%}
    {%- if not dbt_tags.is_managed_tag(tag) -%}
      {% do dbt_tags.log_info("dbt_tags.drop_tags - Ignored tag [" ~ tag ~ "]: outside of the configured namespace [" ~ ns ~ "]") -%}
    {%- elif dbt_tags.get_masking_policy_for_tag(tag) -%}
      {% for policy_data_types in policy_data_types_list if tag in policy_data_types.keys() -%}
        {% for datatype in policy_data_types.values() | first -%}
          {% set tag_info = (tag, tag ~ "_" ~ datatype) -%}
          {% do unique_tags.append(tag_info) -%}
        {% endfor -%}
      {% else -%}
        {% set tag_info = (tag, tag) -%}
        {% do unique_tags.append(tag_info) -%}
      {% endfor -%}
    {% else -%}
      {% set tag_info = (tag, none) -%}
      {% do unique_tags.append(tag_info) -%}
    {%- endif -%}
  {% endfor -%}

  {% set query -%}

    {%- for item in unique_tags if item[1] is not none %}
      alter tag {{ ns }}.{{ item[0] }} unset masking policy {{ ns }}.{{ item[1] }};
    {%- endfor %}
    {%- for tag in unique_tags | map('first') | unique %}
      drop tag if exists {{ ns }}.{{ tag }};
    {%- endfor %}

  {%- endset %}

  {{ log_query(query if unique_tags else "<nothing runs>") if execute }}
  {% if not debug and unique_tags %}

    {{ log("[RUN]: dbt_tags.drop_tags", info=True) }}
    {% set results = run_query(query) %}
    {{ log("Completed", info=True) }}

  {% endif %}

{% endmacro %}
