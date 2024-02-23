{% macro get_dbt_tags(debug=False) %}

  {% set resource_types = var('dbt_tags__resource_types') %}
  {% set found_tags = [] %}

  {% for relation in graph.nodes.values() if (relation.resource_type | lower) in resource_types %}
    {% do found_tags.extend(dbt_tags.get_dbt_relation_tags(relation=relation, debug=debug)) %}
  {% endfor %}

  {% for relation in graph.sources.values() if (relation.resource_type | lower) in resource_types %}
    {% do found_tags.extend(dbt_tags.get_dbt_relation_tags(relation=relation, debug=debug)) %}
  {% endfor %}

  {{ return(found_tags) }}

{% endmacro %}