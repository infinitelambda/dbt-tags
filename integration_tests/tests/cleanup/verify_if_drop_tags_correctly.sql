{{
  config(
    tags = ['cleanup'],
  )
}}
select  *
from    {{ ref('verify_if_tags_created_correctly') }}
where   dbt_project_tag in ('{{ var("dbt_tags__allowed_tags", []) | join("','") }}')
  and   adapter_tag is not null
