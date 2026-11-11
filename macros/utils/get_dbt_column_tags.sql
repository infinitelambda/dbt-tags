{% macro get_dbt_column_tags(relation, with_value=False) -%}
  {{ return(adapter.dispatch('get_dbt_column_tags', 'dbt_tags')(relation=relation, with_value=with_value)) }}
{%- endmacro %}

{% macro default__get_dbt_column_tags(relation, with_value=False) %}

  {% set found_tags = [] %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% for key, value in relation.columns.items() %}
    {% for column_tag in dbt_tags.extract_dbt_object_tags(obj=value) %}
      {% set tag_name = column_tag.partition(tag_name_separator)[0] %}
      {% if dbt_tags.is_allowed_tags(tag_name) %}
        {% do found_tags.append({"name": value.name, "tag": column_tag if with_value else tag_name, "model_fqn": relation.relation_name, "quote": value.quote}) %}
      {% endif %}
    {% endfor %}
  {% endfor %}

  {{ return(found_tags) }}

{% endmacro %}
