# Decide to Unset Masking Policies

`dbt-tags` supports a macro to help us to perform _Unset Masking Policy_ operation (1) from the Object Tags easily for a clean up purpose. Please note that we shouldn't run it (1) prior to _Set Masking Policy_ operation (2) because we always run (2) with **_Force_**.

`unapply_mps_from_tags` ([source](https://github.com/infinitelambda/dbt-tags/blob/main/macros/apply-tags/unapply_mps_from_tags.sql))

## Usage

```bash
dbt run-operation unapply_mps_from_tags [\
  --args '{ns: "database.schema", debug: true}']
```

> See [doc in yml](https://github.com/infinitelambda/dbt-tags/blob/main/macros/apply-tags/unapply_mps_from_tags.yml)

## How does it work?

For example, you'd like to Unset Masking Policy from the tags that were created in the schema named `analytics.demo`.

Let's run the command below:

```bash
dbt run-opertion unapply_mps_from_tags \
  --vars '{ns: "analytics.demo"}'
```

- It scans all the Object Tags that were created in `analytics.demo` schema. Behind the scene script is:

    ```sql
    show tags in schema analytics.demo;
    select  "database_name" || '.' || "schema_name" || '.' || "name" as tag_name
    from    table(result_scan(last_query_id()))
    where   "database_name" || '.' || "schema_name" ilike 'analytics.demo';
    ```

- If exists any tags:
  - Checks if masking policy has multiple data types
    - Unset masking policy from tag with

- Done!
