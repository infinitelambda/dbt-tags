{% macro get_dbt_column_tags(relation, debug=False) %}

  {% set found_tags = [] %}
  {% for key, value in relation.columns.items() %}

    {{ log("column" ~ "-" ~ value.name ~ "-tags:" ~ value.tags, info=True) if debug}}
    {% if value.tags is defined %}

      {% for column_tag in value.tags if dbt_tags.is_allowed_tags(column_tag) %}

        {% set found_tag = {"level": relation.resource_type ~ "." ~ relation.name ~ ".column", "name": value.name, "tag": column_tag} %}
        {{ log(found_tag, info=True) if debug}}

        {% do found_tags.append(found_tag) %}

      {% endfor %}

    {% endif %}
    
  {% endfor %}

  {{ return(found_tags) }}

{% endmacro %}