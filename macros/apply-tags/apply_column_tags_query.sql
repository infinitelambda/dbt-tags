{% macro apply_column_tags_query(resource) -%}
  {{ return(adapter.dispatch('apply_column_tags_query', 'dbt_tags')(resource)) }}
{%- endmacro %}

{% macro default__apply_column_tags_query(resource) %}
  {% set tag_ns = dbt_tags.get_resource_ns() %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% set log_list = [] %}

  -- Build the fully qualified name
  {% set database = resource.database %}
  {% set schema = resource.schema %}
  {% set identifier = resource.identifier or resource.alias or resource.name %}

  -- Apply quoting to each part if needed
  {% set resource_quoting = resource.quoting if "quoting" in resource else resource.config.quoting %}
  {% if resource_quoting.database %}
    {% set database = adapter.quote(database) %}
  {% endif %}
  {% if resource_quoting.schema %}
    {% set schema = adapter.quote(schema) %}
  {% endif %}
  {% if resource_quoting.identifier %}
    {% set identifier = adapter.quote(identifier) %}
  {% endif %}

  {%- set relation -%}
    {{ database }}.{{ schema }}.{{ identifier }}
  {%- endset %}

  -- Determine ALTER syntax based on table type
  {% set table_type = dbt_tags.get_table_type(resource) %}
  {% set command_dict = namespace(
    standard=namespace(alter_table='ALTER TABLE', alter_column='ALTER COLUMN'),
    iceberg=namespace(alter_table='ALTER ICEBERG TABLE', alter_column='MODIFY COLUMN')
  ) %}

  {% set alter_command = command_dict[table_type].alter_table %}
  {% set column_command = command_dict[table_type].alter_column %}
  --

  {% set query %}
    {% for key, value in resource.columns.items() -%}
      {% set value_tags = dbt_tags.extract_dbt_object_tags(obj=value) %}
      {% if (value_tags | length) > 0 -%}
        {% for column_tag in value_tags if dbt_tags.is_allowed_tags(column_tag.split(tag_name_separator)[0]) %}

          {{ alter_command }} {{ relation }}
            {{ column_command }} {% if value.get('quote', false) %}{{ adapter.quote(key) }}{% else %}{{ key }}{% endif %}
            SET TAG {{ tag_ns }}.{{ column_tag.split(tag_name_separator)[0] }} =
            {%- if tag_name_separator in column_tag -%}
              '{{ column_tag.split(tag_name_separator)[1] }}';
            {%- else -%}
              '{{ key }}';
            {%- endif %}

          {%- do log_list.append("dbt_tags.apply_column_tags_query - Set tag [" ~ tag_ns ~ "." ~ column_tag  ~ "] on " ~ table_type ~ " table column [" ~ relation ~ ":" ~ key ~ "]") -%}

        {%- endfor %}
      {%- endif %}
    {%- endfor %}
  {% endset %}

  {{ dbt_tags.log_apply_column_tags(log_list) }}
  {{ return(query) }}
{% endmacro %}
