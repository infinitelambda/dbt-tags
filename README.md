<!-- markdownlint-disable no-inline-html no-alt-text -->
# dbt-tags

<img align="right" width="150" height="150" src="https://raw.githubusercontent.com/infinitelambda/dbt-tags/main/docs/assets/img/il-logo.png">

[![dbt-hub](https://img.shields.io/badge/Visit-dbt--hub%20↗️-FF694B?logo=dbt&logoColor=FF694B)](https://hub.getdbt.com/infinitelambda/dbt_tags)
[![support-snowflake](https://img.shields.io/badge/support-Snowflake-7faecd?logo=snowflake&logoColor=7faecd)](https://docs.snowflake.com?ref=infinitelambda)
[![support-dbt](https://img.shields.io/badge/support-dbt%20v1.6+-FF694B?logo=dbt&logoColor=FF694B)](https://docs.getdbt.com?ref=infinitelambda)

Tag-based masking policies management in Snowflake ❄️ 🏷️

> [!TIP]
> 📖 For more details, please help to visit the ⭐ [Documentation site](https://dbt-tags.iflambda.com/latest/) (or go to the [docs/index.md](./docs/index.md)) for more details

- [dbt-tags](#dbt-tags)
  - [Installation](#installation)
  - [Quick Demo](#quick-demo)
  - [How to Contribute](#how-to-contribute)
  - [About Infinite Lambda](#about-infinite-lambda)

## Installation

- Add to `packages.yml` file:

```yml
packages:
  - package: infinitelambda/dbt_tags
    version: [">=1.3.0", "<1.4.0"]
    # keep an eye on the latest version, and change it accordingly
```

Or use the latest version from git:

```yml
packages:
  - git: "https://github.com/infinitelambda/dbt-tags"
    revision: <release version or tag>
```

And run `dbt deps` to install the package!

## Quick Demo

👉 Jump into the [Getting Started](https://dbt-tags.iflambda.com/latest/getting-started.html) page for more details on how to start using this package.

📹 Here is a quick live demo:

<div>
  <a href="https://www.loom.com/share/afd6015f3fde4c7bb232741244c744cf">
    <p>Quick run through dbt-tags package - Watch Video</p>
  </a>
  <a href="https://www.loom.com/share/afd6015f3fde4c7bb232741244c744cf">
    <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/afd6015f3fde4c7bb232741244c744cf-1710220296731-with-play.gif">
  </a>
</div>

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
