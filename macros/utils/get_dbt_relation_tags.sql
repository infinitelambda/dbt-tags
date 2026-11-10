{% macro get_dbt_relation_tags(relation, inc_column=True, with_value=False, debug=False) -%}
  {{ return(adapter.dispatch('get_dbt_relation_tags', 'dbt_tags')(relation=relation, inc_column=inc_column, with_value=with_value, debug=debug)) }}
{%- endmacro %}

{% macro default__get_dbt_relation_tags(relation, inc_column=True, with_value=False, debug=False) %}

  {% set found_tags = [] %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}

  {% set relation_tags = dbt_tags.extract_dbt_object_tags(obj=relation) %}
  {# {{ log(relation.resource_type ~ "-" ~ relation.name ~ "-tags:" ~ relation_tags, info=True) if debug}} #}
  {% if (relation_tags | length) > 0 %}
    {% for relation_tag in relation_tags %}
      {% set tag_name = relation_tag.partition(tag_name_separator)[0] %}
      {% if dbt_tags.is_allowed_tags(tag_name) %}
        {% do found_tags.append({"level": relation.resource_type, "name": relation.name, "tag": relation_tag if with_value else tag_name, "model_fqn": relation.relation_name}) %}
      {% endif %}
    {% endfor %}
  {% endif %}

  {% if inc_column %}
    {% do found_tags.extend(dbt_tags.get_dbt_column_tags(relation=relation, with_value=with_value, debug=debug)) %}
  {% endif %}

  {{ return(found_tags) }}

{% endmacro %}
