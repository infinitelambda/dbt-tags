{% macro apply_column_tags_query(resource) -%}
  {{ return(adapter.dispatch('apply_column_tags_query', 'dbt_tags')(resource)) }}
{%- endmacro %}

{% macro default__apply_column_tags_query(resource) %}

  {% set tag_ns = dbt_tags.get_resource_ns() %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% set log_list = [] %}
  {% set query %}

    {% for key, value in resource.columns.items() -%}
      {% set value_tags = dbt_tags.extract_dbt_object_tags(obj=value) %}
      {% if (value_tags | length) > 0 -%}
        {% for column_tag in value_tags if dbt_tags.is_allowed_tags(column_tag.split(tag_name_separator)[0]) %}

          {%- set relation -%}
            {{ resource.database }}.{{ resource.schema }}.{{ resource.identifier or resource.alias or resource.name }}
          {%- endset %}

          alter table {{ relation }}
            alter column {% if value.get('quote', false) %}{{ adapter.quote(key) }}{% else %}{{ key }}{% endif %}
            set tag {{ tag_ns }}.{{ column_tag.split(tag_name_separator)[0] }} =
            {%- if tag_name_separator in column_tag -%}
              '{{ column_tag.split(tag_name_separator)[1] }}';
            {%- else -%}
              '{{ key }}';
            {%- endif %}
          {%- do log_list.append("dbt_tags.apply_column_tags_query - Set tag [" ~ tag_ns ~ "." ~ column_tag  ~ "] on column [" ~ relation ~ ":" ~ key ~ "]") -%}

        {%- endfor %}
      {%- endif %}
    {%- endfor %}

  {% endset %}
  {{ dbt_tags.log_apply_column_tags(log_list) }}
  {{ return(query) }}

{% endmacro %}
