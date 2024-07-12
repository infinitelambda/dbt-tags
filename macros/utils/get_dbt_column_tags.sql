{% macro get_dbt_column_tags(relation, with_value=False, debug=False) -%}
  {{ return(adapter.dispatch('get_dbt_column_tags', 'dbt_tags')(relation=relation, with_value=with_value, debug=debug)) }}
{%- endmacro %}

{% macro default__get_dbt_column_tags(relation, with_value=False, debug=False) %}

  {% set found_tags = [] %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% for key, value in relation.columns.items() %}

    {# {{ log("column" ~ "-" ~ value.name ~ "-tags:" ~ value.tags, info=True) if debug }} #}
    {% if value.tags is defined %}

      {% for column_tag in value.tags if dbt_tags.is_allowed_tags(column_tag.split(tag_name_separator)[0]) %}
        {% if with_value %}
          {% set found_tag = {"level": relation.resource_type ~ "." ~ relation.name ~ ".column", "name": value.name, "tag": column_tag} %}
        {% else %}
          {% set found_tag = {"level": relation.resource_type ~ "." ~ relation.name ~ ".column", "name": value.name, "tag": column_tag.split(tag_name_separator)[0]} %}
          {# {{ log(found_tag, info=True) if debug}} #}
        {% endif %}
        {% do found_tags.append(found_tag) %}

      {% endfor %}

    {% endif %}

  {% endfor %}

  {{ return(found_tags) }}

{% endmacro %}
