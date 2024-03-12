# Decide to Drop the Object Tags

`dbt-tags` supports a macro to help us to clean up the DWH Object Tags which might be redundant or accidentally created:

`drop_tags` ([source](https://github.com/infinitelambda/dbt-tags/blob/main/macros/resources/tags/drop_tags.sql))

## Usage

```bash
dbt run-opertion drop_tags [--args '{debug: true}']
```

> See [doc in yml](https://github.com/infinitelambda/dbt-tags/blob/main/macros/resources/tags/drop_tags.yml)

## How does it work?

For example, you'd like to drop tags that were wrongly created in the schema named `analytics.demo`.

Let's run the command below:

```bash
dbt run-opertion drop_tags \
  --vars '{dbt_tags__database: analytics, dbt_tags__schema: demo}'
```

- It scans all the Object Tags that were created in `analytics.demo` schema. Behind the scene script is:

    ```sql
    show tags in schema analytics.demo;
    select  "database_name" || '.' || "schema_name" || '.' || "name" as tag_name
    from    table(result_scan(last_query_id()))
    where   "database_name" || '.' || "schema_name" ilike 'analytics.demo';
    ```

- If exists any tags:
    - Create a dummy masking policy function (A)
    - For each object tag:
        - Set masking policy to tag with the above (A) with _Force_
        - Unset masking policy from tag with (A)
        - Drop the tag
    - Drop (A)

- Done!
