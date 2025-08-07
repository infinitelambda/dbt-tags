{% macro get_dbt_column_tags(relation, with_value=False, debug=False) -%}
  {{ return(adapter.dispatch('get_dbt_column_tags', 'dbt_tags')(relation=relation, with_value=with_value, debug=debug)) }}
{%- endmacro %}

{% macro default__get_dbt_column_tags(relation, with_value=False, debug=False) %}

  {% set found_tags = [] %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% for key, value in relation.columns.items() %}
    
    {% set value_tags = dbt_tags.extract_dbt_object_tags(obj=value) %}
    {# {{ log("column" ~ "-" ~ value.name ~ "-tags:" ~ value_tags, info=True) if debug }} #}
    {% if (value_tags | length) > 0 %}

      {% for column_tag in value_tags if dbt_tags.is_allowed_tags(column_tag.split(tag_name_separator)[0]) %}
        {% if with_value %}
          {% set found_tag = {"level": relation.resource_type ~ "." ~ relation.name ~ ".column", "name": value.name, "tag": column_tag, "model_fqn": relation.relation_name, "quote": value.quote} %}
        {% else %}
          {% set found_tag = {"level": relation.resource_type ~ "." ~ relation.name ~ ".column", "name": value.name, "tag": column_tag.split(tag_name_separator)[0], "model_fqn": relation.relation_name, "quote": value.quote} %}
          {# {{ log(found_tag, info=True) if debug}} #}
        {% endif %}
        {% do found_tags.append(found_tag) %}

      {% endfor %}

    {% endif %}

  {% endfor %}

  {{ return(found_tags) }}

{% endmacro %}
