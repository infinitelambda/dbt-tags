{% macro get_dbt_tags(with_value=False, debug=False) -%}
  {{ return(adapter.dispatch('get_dbt_tags', 'dbt_tags')(with_value=with_value, debug=debug)) }}
{%- endmacro %}

{% macro default__get_dbt_tags(with_value=False, debug=False) %}
  {% if not execute %}
    {{ return([]) }}
  {% endif %}

  {% set resource_types = var('dbt_tags__resource_types') %}
  {% set found_tags = [] %}

  {% for relation in graph.nodes.values() if (relation.resource_type | lower) in resource_types %}
    {% do found_tags.extend(dbt_tags.get_dbt_relation_tags(relation=relation, with_value=with_value, debug=debug)) %}
  {% endfor %}

  {% for relation in graph.sources.values() if (relation.resource_type | lower) in resource_types %}
    {% do found_tags.extend(dbt_tags.get_dbt_relation_tags(relation=relation, with_value=with_value, debug=debug)) %}
  {% endfor %}

  {{ return(found_tags) }}
{% endmacro %}
