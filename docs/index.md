<!-- markdownlint-disable no-inline-html no-alt-text ul-indent code-block-style -->
# dbt-tags

<img align="right" width="150" height="150" src="./assets/img/il-logo.png">

[![dbt-hub](https://img.shields.io/badge/Visit-dbt--hub%20↗️-FF694B?logo=dbt&logoColor=FF694B)](https://hub.getdbt.com/infinitelambda/dbt_tags?ref=infinitelambda)
[![support-snowflake](https://img.shields.io/badge/support-Snowflake-7faecd?logo=snowflake&logoColor=7faecd)](https://docs.snowflake.com?ref=infinitelambda)
[![support-dbt](https://img.shields.io/badge/support-dbt%20v1.6+-FF694B?logo=dbt&logoColor=FF694B)](https://docs.getdbt.com?ref=infinitelambda)

Tag-based masking policies management in Snowflake ❄️

**_Who is this for?_**

TODO

## Core Concept 🌟

TODO

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
  - git: "https://github.com/infinitelambda/dbt-tags"
    revision: 1.0.0 # 1.0.0b1
```

- (Optional) Configure database & schema in `dbt_project.yml` file:

```yml
vars:
  # (optional) default to `target.database` if not specified
  dbt_tags__database: COMMON
  # (optional) default to `target.schema` if not specified
  dbt_tags__schema: TAGS
```

- Create the `dbt_tags`'s DDL resources

```bash
dbt deps
dbt run -s dbt_tags
```

## Quick Start

TODO

## Demo

TODO

## Variables

!!! tip "See `dbt_project.yml` file"
    Go to `vars` section [here](https://github.com/infinitelambda/dbt-tags/blob/main/dbt_project.yml#L12) 🏃

    We managed to provide the inline comments only for now, soon to have the dedicated page for more detail explanation.

Here are the full list of built-in variables:

- `dbt_tags__database`
- `dbt_tags__schema`
- TODO

## How to Contribute ❤️

`dbt-tags` is an open-source dbt package. Whether you are a seasoned open-source contributor or a first-time committer, we welcome and encourage you to contribute code, documentation, ideas, or problem statements to this project.

👉 See [CONTRIBUTING guideline](https://dbt-tags.iflambda.com/latest/nav/dev/contributing.html) for more details or check out [CONTRIBUTING.md](https://github.com/infinitelambda/dbt-tags/tree/main/CONTRIBUTING.md)

🌟 And then, kudos to **our beloved Contributors**:

<a href="https://github.com/infinitelambda/dbt-tags/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=infinitelambda/dbt-tags" alt="Contributors" />
</a>

⭐ Special Credits to [👱 Attila Berecz](https://www.linkedin.com/in/attila-berecz-a0bb5ba2/) who is the OG Contributor of the Core Concept and all the Snowflake Stored Procedures

## Features comparison to the alternative packages

| Feature               | Supported Package                                          | Notes                                 |
|:----------------------|:-----------------------------------------------------------|:-----------------|
| Key diff              | <ul><li>`dbt_dbt_tags`</li><li>[`dbt_tags`](https://github.com/datafold/dbt_tags)</li><li>[`dbt_audit_helper`](https://github.com/dbt-labs/dbt_audit_helper)</li></ul> | ✅ all available |
| Schema diff           | <ul><li>`dbt_dbt_tags`</li><li>[`dbt_tags`(*)](https://github.com/datafold/dbt_tags)</li><li>[`dbt_audit_helper`](https://github.com/dbt-labs/dbt_audit_helper)</li></ul> | (*): Only available in the paid-version 💰 |
| Content diff          | <ul><li>`dbt_dbt_tags`</li><li>[`dbt_tags`(*)](https://github.com/datafold/dbt_tags)</li><li>[`dbt_audit_helper`](https://github.com/dbt-labs/dbt_audit_helper)</li></ul> | (*): Only available in the paid-version 💰 |
| Yaml Configuration    | <ul><li>`dbt_dbt_tags`</li></ul>                           | `dbt_tags` will use the `toml` file, `dbt_audit_helper` will require to create new models for each comparison |
| Query & Execution log  | <ul><li>`dbt_dbt_tags`</li></ul>                           | Except for dbt's log, this package to be very transparent on which diff queries executed which are exposed in [`log_for_validation`](https://github.com/infinitelambda/dbt-tags/tree/main/models/log_for_validation.yml) model |
| Snowflake-native Stored Proc | <ul><li>`dbt_dbt_tags`</li></ul>                      | Purely built as Snowflake SQL native stored procedures |
| Parallelism           | <ul><li>`dbt_dbt_tags`</li><li>[`dbt_tags`](https://github.com/datafold/dbt_tags)</li><li>[`dbt_audit_helper`](https://github.com/dbt-labs/dbt_audit_helper)</li></ul> | `dbt_dbt_tags` leverages Snowflake Task DAG, the others use python threading |
| Asynchronous          | <ul><li>`dbt_dbt_tags`</li></ul>                           | Trigger run & go away. Decide to continously poll the run status and waiting until finished if needed |
| Multi-warehouse supported | <ul><li>`dbt_dbt_tags`(*)</li><li>[`dbt_tags`](https://github.com/datafold/dbt_tags)</li><li>[`dbt_audit_helper`](https://github.com/dbt-labs/dbt_audit_helper)</li></ul> | (*): Future Consideration 🏃 |

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
