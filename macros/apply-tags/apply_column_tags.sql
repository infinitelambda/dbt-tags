{% macro apply_column_tags() %}

  {% if not execute %}
    {{ return("") }}
  {% endif %}

  {% set tag_ns = dbt_tags.get_resource_ns() %}
  {% set query %}

    {% for key, value in model.columns.items() -%}
      {% if value.tags is defined -%}
        {% for column_tag in value.tags if dbt_tags.is_allowed_tags(column_tag) %}

          {%- set relation -%}
            {{ model.database }}.{{ model.schema }}.{{ model.alias or model.name }}
          {%- endset %}

          alter table {{ relation }}
            alter column {{ key }}
            set tag {{ tag_ns }}.{{ column_tag }} = '{{ key }}';
          {{- log("dbt_tags.apply_column_tags - Set tag [" ~ tag_ns ~ "." ~ column_tag  ~ "] on column [" ~ relation ~ ":" ~ key ~ "]", info=True) -}}

        {%- endfor %}
      {%- endif %}
    {%- endfor %}
    
  {% endset %}

  {{ return(query) }}
    
{% endmacro %}