# Getting Started with `dbt-tags` package

In order to start the Tag-based masking journey in our dbt project, we have **6 essential steps** as follows:

!!! Notes
    - Before diving into steps, it's recommended to learn more on [Tag-based masking polcies](https://docs.snowflake.com/en/user-guide/tag-based-masking-policies) (skip if you knew it already 💯)
    - Also, please be noted that you will need the Snowflake [Enterprise Edition](https://docs.snowflake.com/en/user-guide/intro-editions?ref=infintelambda) as the prerequisite

Now, let's go 🏃:

## 1. Configure the namespace (databse, schema)

Firstly, we should let dbt know where we would like to store the Tag objects (as well as the Masking Policies' definitions).

We'll put the `dbt_tags`'s variables in `dbt_project.yml` file as below:

```yml
vars:
  # dbt_tags__database: MY_DB # (optional) default to `target.database` if not specified
  dbt_tags__schema: COMMON # (optional) default to `target.schema` if not specified
```

## 2. Decide to allow the specific tags only

ℹ️ Skip this step if all dbt tags are allowed. Otherwise, see the sample below:

```yml
vars:
  dbt_tags__allowed_tags:
    - pii_name
    - pii_email
    - ...
```

## 3. Decide to commit masking policies' definition

ℹ️ Skip this step if you decide not to use masking policies, but only tags!

Masking Policies' functions vary depending on the dbt project, so it's your responsibility to implement them in advance.

In the dbt root directory, let's create a new one within `/macros` folder e.g. `/macros/mp-ddl`.

For each tag name, we need a corresponding macro that holds the masking policy definition.

Given a sample, we have a tag named `pii_name`, we'll create a macro file as below:

```sql
-- File path: /marcos/mp-ddl/create_masking_policy__pii_name.sql
{% macro create_masking_policy__pii_name(ns) -%}

  create masking policy if not exists {{ ns }}.pii_name as (val string)
    returns string ->
    case --/ your definition start here /--
      when is_role_in_session('ROLE_HAS_PII_ACCESS') then val
      else sha2(val)
    end;

{%- endmacro %}
```

> `{{ ns }}` or `ns` stands for the schema namespace, let's copy the same!

## 4. Deploy resources (tags, masking policies)

❗We don't want to repeat this step on every dbt run(s).

Instead, let's do it as a step in the Production Release process (or manually).

> Remove `--args '{debug: true}'` for a live run

- Deploy the `dbt tags` to DWH:

  ```bash
  dbt run-operation create_tags --args '{debug: true}'
  ```

- Deploy the tag-based masking policy functions to DWH:

  ℹ️ Skip this step if you decide not to use masking policies, but only tags!

  ```bash
  dbt run-operation create_masking_policies --args '{debug: true}'
  ```

## 5. Apply tags to columns

ℹ️ Currently, only column tags are supported!

Add a new `post-hook` to the model level:

```yml
models:
  my_project:
    post-hook:
      - > # customize below `if` condition following your need
        {% if flags.WHICH in ('run', 'build') %}
          {{ dbt_tags.apply_column_tags() }}
        {% endif %}
```

## 6. Apply masking policies to tags

ℹ️ Skip this step if you decide not to use masking policies, but only tags!

> Remove `--args '{debug: true}'` for a live run

```bash
dbt run-operation apply_mps_to_tags --args '{debug: true}'
```

Now, go to Snowflake and check the result! 🚀

**_Happy Masking_ 🎉**
