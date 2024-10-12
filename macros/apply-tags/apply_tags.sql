{% macro apply_tags(resource) -%}
  {{ return(adapter.dispatch('apply_tags', 'dbt_tags')(resource)) }}
{%- endmacro %}

{% macro default__apply_tags(resource) %}

  {% set tag_ns = dbt_tags.get_resource_ns() %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% set query %}

    {% for key, value in resource.columns.items() -%}
      {% if value.tags is defined -%}
        {% for column_tag in value.tags if dbt_tags.is_allowed_tags(column_tag.split(tag_name_separator)[0]) %}

          {%- set relation -%}
            {{ resource.database }}.{{ resource.schema }}.{{ resource.alias or resource.name }}
          {%- endset %}

          alter table {{ relation }}
            alter column {{ key }}
            set tag {{ tag_ns }}.{{ column_tag.split(tag_name_separator)[0] }} =
            {%- if tag_name_separator in column_tag -%}
              '{{ column_tag.split(tag_name_separator)[1] }}';
            {%- else -%}
              '{{ key }}';
            {%- endif %}
          {{- log("dbt_tags.apply_tags - Set tag [" ~ tag_ns ~ "." ~ column_tag  ~ "] on column [" ~ relation ~ ":" ~ key ~ "]", info=True) -}}

        {%- endfor %}
      {%- endif %}
    {%- endfor %}

  {% endset %}

  {{ return(query) }}

{% endmacro %}
