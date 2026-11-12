{% macro apply_column_tags_query(resource) -%}
  {{ return(adapter.dispatch('apply_column_tags_query', 'dbt_tags')(resource)) }}
{%- endmacro %}

{% macro default__apply_column_tags_query(resource) %}
  {% set tag_name_separator = var('dbt_tags__tag_name_separator','~') %}
  {% set log_list = [] %}
  {% set column_tags_map = {} %}

  {% set database = resource.database %}
  {% set schema = resource.schema %}
  {% set identifier = resource.identifier or resource.alias or resource.name %}

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

  {% set table_type = dbt_tags.get_table_type(resource) %}
  {% set command_dict = namespace(
    standard=namespace(alter_table='ALTER TABLE', alter_column='ALTER COLUMN'),
    iceberg=namespace(alter_table='ALTER ICEBERG TABLE', alter_column='MODIFY COLUMN')
  ) %}

  {% set alter_command = command_dict[table_type].alter_table %}
  {% set column_command = command_dict[table_type].alter_column %}

  -- Multiple tags on the same column must be combined: SET TAG tag1 = 'val1', tag2 = 'val2'
  {% for key, value in resource.columns.items() -%}
    {% set col_name = adapter.quote(key) if value.get('quote', false) else key %}
    {% set tag_assignments = {} %}
    {% for column_tag in dbt_tags.extract_dbt_object_tags(obj=value) %}
      {% set tag_name, _, tag_value = column_tag.partition(tag_name_separator) %}
      {% if dbt_tags.is_allowed_tags(tag_name) %}
        {% set tag_value = tag_value or key %}
        {% set tag_fqn = dbt_tags.get_tag_fqn(tag_name) %}
        {% set tag_assignment = tag_fqn ~ " = '" ~ tag_value ~ "'" %}
        {% if tag_assignments.get(tag_fqn, tag_assignment) != tag_assignment %}
          {{ exceptions.raise_compiler_error("Conflicting values for tag [" ~ tag_fqn ~ "] on column [" ~ relation ~ ":" ~ key ~ "]: " ~ tag_assignments[tag_fqn] ~ " vs " ~ tag_assignment) }}
        {% endif %}
        {%- do tag_assignments.update({tag_fqn: tag_assignment}) -%}
        {%- do log_list.append("dbt_tags.apply_column_tags_query - Set tag [" ~ tag_fqn ~ " = " ~ tag_value ~ "] on " ~ table_type ~ " table column [" ~ relation ~ ":" ~ key ~ "]") -%}
      {% endif %}
    {%- endfor %}
    {% if tag_assignments %}
      {%- do column_tags_map.update({col_name: tag_assignments}) -%}
    {% endif %}
  {%- endfor %}

  {% set column_modifications = [] %}
  {% for col_name, tag_assignments in column_tags_map.items() %}
    {# First modification uses full command (ALTER COLUMN/MODIFY COLUMN), subsequent ones use just COLUMN #}
    {% set prefix = column_command if loop.first else 'COLUMN' %}
    {% set modification = prefix ~ ' ' ~ col_name ~ ' SET TAG ' ~ tag_assignments.values() | join(', ') %}
    {%- do column_modifications.append(modification) -%}
  {%- endfor %}

  {% set query %}
    {% if column_modifications %}
      {{ alter_command }} {{ relation }}
        {{ column_modifications | join(',\n        ') }};
    {% endif %}
  {% endset %}

  {{ dbt_tags.log_apply_column_tags(log_list) }}
  {{ return(query) }}
{% endmacro %}
