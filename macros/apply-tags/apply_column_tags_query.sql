{% macro apply_column_tags_query(resource) -%}
  {{ return(adapter.dispatch('apply_column_tags_query', 'dbt_tags')(resource)) }}
{%- endmacro %}

{% macro default__apply_column_tags_query(resource) %}
  {% set tag_ns = dbt_tags.get_resource_ns() %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% set log_list = [] %}
  {% set column_tags_map = {} %}

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

  -- Collect all tags grouped by column for batch processing
  -- Multiple tags on the same column must be combined: SET TAG tag1 = 'val1', tag2 = 'val2'
  {% for key, value in resource.columns.items() -%}
    {% set value_tags = dbt_tags.extract_dbt_object_tags(obj=value) %}
    {% if (value_tags | length) > 0 -%}
      {% set col_name = adapter.quote(key) if value.get('quote', false) else key %}
      {% set tag_assignments = [] %}
      {% for column_tag in value_tags if dbt_tags.is_allowed_tags(column_tag.split(tag_name_separator)[0]) %}
        {% set tag_name = column_tag.split(tag_name_separator)[0] %}
        {% set tag_value = column_tag.split(tag_name_separator)[1] if tag_name_separator in column_tag else key %}
        {% set tag_assignment = tag_ns ~ '.' ~ tag_name ~ " = '" ~ tag_value ~ "'" %}
        {%- do tag_assignments.append(tag_assignment) -%}
        {%- do log_list.append("dbt_tags.apply_column_tags_query - Set tag [" ~ tag_ns ~ "." ~ column_tag  ~ "] on " ~ table_type ~ " table column [" ~ relation ~ ":" ~ key ~ "]") -%}
      {%- endfor %}
      {% if tag_assignments | length > 0 %}
        {%- do column_tags_map.update({col_name: tag_assignments}) -%}
      {% endif %}
    {%- endif %}
  {%- endfor %}

  -- Build column modifications with combined tags per column
  {% set column_modifications = [] %}
  {% for col_name, tag_assignments in column_tags_map.items() %}
    {# First modification uses full command (ALTER COLUMN/MODIFY COLUMN), subsequent ones use just COLUMN #}
    {% set prefix = column_command if column_modifications | length == 0 else 'COLUMN' %}
    {% set modification = prefix ~ ' ' ~ col_name ~ ' SET TAG ' ~ tag_assignments | join(', ') %}
    {%- do column_modifications.append(modification) -%}
  {%- endfor %}

  -- Generate a single consolidated ALTER statement if there are modifications
  {% set query %}
    {% if (column_modifications | length) > 0 %}
      {{ alter_command }} {{ relation }}
        {{ column_modifications | join(',\n        ') }};
    {% endif %}
  {% endset %}

  {{ dbt_tags.log_apply_column_tags(log_list) }}
  {{ return(query) }}
{% endmacro %}
