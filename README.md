<!-- markdownlint-disable no-inline-html no-alt-text -->
# dbt-tags

<img align="right" width="150" height="150" src="./docs/assets/img/il-logo.png">

[![dbt-hub](https://img.shields.io/badge/Visit-dbt--hub%20↗️-FF694B?logo=dbt&logoColor=FF694B)](https://hub.getdbt.com/infinitelambda/dbt_tags)
[![support-snowflake](https://img.shields.io/badge/support-Snowflake-7faecd?logo=snowflake&logoColor=7faecd)](https://docs.snowflake.com?ref=infinitelambda)
[![support-dbt](https://img.shields.io/badge/support-dbt%20v1.6+-FF694B?logo=dbt&logoColor=FF694B)](https://docs.getdbt.com?ref=infinitelambda)

Tag-based masking policies management in Snowflake ❄️

> [!TIP]
> 📖 For more details, please help to visit [the documentation site](https://dbt-tags.iflambda.com/latest/) (or go to the [docs/index.md](./docs/index.md)) for more details

TODO: add image

## Installation

- Add to `packages.yml` file:

```yml
packages:
  - package: infinitelambda/dbt_tags
    version: [">=1.0.0", "<1.1.0"]
```

Or use the latest version from git:

```yml
packages:
  - git: "https://github.com/infinitelambda/dbt-tags.git"
    revision: 1.0.0 # 1.0.0b1, main
```

And run `dbt deps` to install the package!

## Getting Started

### 1. (Optional) Configure database & schema in `dbt_project.yml` file

```yml
vars:
  # dbt_tags__database: MY_DB # (optional) default to `target.database` if not specified
  dbt_tags__schema: COMMON # (optional) default to `target.schema` if not specified
```

### 2. (Optional) Decide to allow the specific tags only

  Skip this step if all dbt tags are allowed. Otherwise, see the sample below:

  ```yml
  vars:
    dbt_tags__allowed_tags:
      - pii_name
      - pii_email
      - ...
  ```

### 3. Commit masking policies' definition

ℹ️ Skip this step if you decide not to use masking policies, but only tags!

Masking Policies' functions vary depending on the dbt project, so it's your responsibility to implement them in advance.

In the dbt root directory, let's create a new one within `/macros` e.g. `/macros/mp-ddl`.

For each tag name, we need a corresponding macro that holds the masking policy definition.

Given a sample, we have a tag named `pii_name`, we'll create a macro file as below:

```sql
-- File: /marcos/mp-ddl/create_masking_policy__pii_name.sql
{% macro create_masking_policy__pii_name(ns) -%}

  create masking policy if not exists {{ ns }}.pii_name as (val string)
    returns string ->
    case --/ your definition start here /--
      when is_role_in_session('ROLE_HAS_PII_ACCESS') then val
      else sha2(val)
    end;

{%- endmacro %}
```

ℹ️ `{{ ns }}` or `ns` stands for the schema namespace, let's copy the same!

### 4. Deploy resources (tags, masking policies)

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

### 5. Apply masking policies to tags

ℹ️ Skip this step if you decide not to use masking policies, but only tags!

```bash
dbt run-operation TODO --args '{debug: true}'
```

## Quick Demo

TODO

## How to Contribute

`dbt-tags` is an open-source dbt package. Whether you are a seasoned open-source contributor or a first-time committer, we welcome and encourage you to contribute code, documentation, ideas, or problem statements to this project.

👉 See [CONTRIBUTING guideline](https://dbt_tags.iflambda.com/latest/nav/dev/contributing.html) for more details or check out [CONTRIBUTING.md](./CONTRIBUTING.md)

🌟 And then, kudos to **our beloved Contributors**:

<a href="https://github.com/infinitelambda/dbt-tags/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=infinitelambda/dbt-tags" alt="Contributors" />
</a>

## About Infinite Lambda

Infinite Lambda is a cloud and data consultancy. We build strategies, help organizations implement them, and pass on the expertise to look after the infrastructure.

We are an Elite Snowflake Partner, a Platinum dbt Partner, and a two-time Fivetran Innovation Partner of the Year for EMEA.

Naturally, we love exploring innovative solutions and sharing knowledge, so go ahead and:

🔧 Take a look around our [Git](https://github.com/infinitelambda)

✏️ Browse our [tech blog](https://infinitelambda.com/category/tech-blog/)

We are also chatty, so:

👀 Follow us on [LinkedIn](https://www.linkedin.com/company/infinite-lambda/)

👋🏼 Or just [get in touch](https://infinitelambda.com/contacts/)

[<img src="https://raw.githubusercontent.com/infinitelambda/cdn/1.0.0/general/images/GitHub-About-Section-1080x1080.png" alt="About IL" width="500">](https://infinitelambda.com/)
