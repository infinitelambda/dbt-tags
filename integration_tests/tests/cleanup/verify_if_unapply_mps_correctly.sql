{{
  config(
    tags = ['cleanup'],
  )
}}

select  *
from    {{ ref('verify_if_masking_policies_applied_correctly') }}
where   adapter_tag is not null
