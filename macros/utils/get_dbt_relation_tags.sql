{% macro get_dbt_relation_tags(relation, inc_column=True, with_value=False, debug=False) -%}
  {{ return(adapter.dispatch('get_dbt_relation_tags', 'dbt_tags')(relation=relation, inc_column=inc_column, with_value=with_value, debug=debug)) }}
{%- endmacro %}

{% macro default__get_dbt_relation_tags(relation, inc_column=True, with_value=False, debug=False) %}

  {% set found_tags = [] %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {# {{ log(relation.resource_type ~ "-" ~ relation.name ~ "-tags:" ~ relation.tags, info=True) if debug}} #}
  {% if relation.tags is defined %}
    {% for relation_tag in relation.tags if dbt_tags.is_allowed_tags(relation_tag.split(tag_name_separator)[0]) %}
      {% if with_value %}
        {% set found_tag = {"level": relation.resource_type, "name": relation.name, "tag": relation_tag, "model_fqn": relation.relation_name} %}
      {% else %}
        {% set found_tag = {"level": relation.resource_type, "name": relation.name, "tag": relation_tag.split(tag_name_separator)[0], "model_fqn": relation.relation_name} %}
        {# {{ log(found_tag, info=True) if debug}} #}
      {% endif %}
      {% do found_tags.append(found_tag) %}
    {% endfor %}
  {% endif %}

  {% if inc_column %}
    {% do found_tags.extend(dbt_tags.get_dbt_column_tags(relation=relation, with_value=with_value, debug=debug)) %}
  {% endif %}

  {{ return(found_tags) }}

{% endmacro %}
