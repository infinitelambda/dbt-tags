## Configuration

### Iceberg Table Support

dbt-tags supports applying tags to Snowflake Iceberg tables. This feature is enabled by default but can be configured:

- **Variable Configuration**:
  ```yml
  vars:
    dbt_tags__enable_iceberg_support: true  # Set to false to disable Iceberg support
  ```

- **Model Configuration**:
  To mark a specific model as an Iceberg table, add the following to your model config:
  ```yml
  {{ config(
    table_format='iceberg'
  ) }}
  ```

When Iceberg support is enabled and a model is configured with `table_format: 'iceberg'`, dbt-tags will use the appropriate Snowflake syntax for Iceberg tables:
- `ALTER ICEBERG TABLE` instead of `ALTER TABLE`
- `MODIFY COLUMN` instead of `ALTER COLUMN`