{% macro create_masking_policy__pii_null(ns) -%}

  create masking policy if not exists {{ ns }}.pii_null_varchar as (val string)
    returns string ->
    case
      when is_role_in_session('ROLE_DBT_TAGS') then val
      else null
    end;

  create masking policy if not exists {{ ns }}.pii_null_number as (val number)
    returns number ->
    case
      when is_role_in_session('ROLE_DBT_TAGS') then val
      else null
    end;

{%- endmacro %}
