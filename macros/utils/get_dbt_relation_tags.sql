{% macro get_dbt_relation_tags(relation, inc_column=True, debug=False) %}

  {% set found_tags = [] %}
  {{ log(relation.resource_type ~ "-" ~ relation.name ~ "-tags:" ~ relation.tags, info=True) if debug}}
  {% if relation.tags is defined %}
    {% for relation_tag in relation.tags if dbt_tags.is_allowed_tags(relation_tag) %}
      {% set found_tag = {"level": relation.resource_type, "name": relation.name, "tag": relation_tag} %}
      {{ log(found_tag, info=True) if debug}}
      {% do found_tags.append(found_tag) %}
    {% endfor %}
  {% endif %}

  {% if inc_column %}
    {% do found_tags.extend(dbt_tags.get_dbt_column_tags(relation=relation, debug=debug)) %}
  {% endif %}

  {{ return(found_tags) }}

{% endmacro %}