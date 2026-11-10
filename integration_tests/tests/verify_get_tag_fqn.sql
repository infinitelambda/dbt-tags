{% set naming_config = var("dbt_tags__opt_in_default_naming_config", true) %}
{% set ns = "dbt_tags." ~ (target.schema ~ "_common" if naming_config else "common") %}
{% set cases = [
  ("pii_name", ns ~ ".pii_name"),
  ('"pii.quoted"', ns ~ '."pii.quoted"'),
  ("governance.pii_external", "dbt_tags.governance.pii_external"),
  ('governance."pii.quoted"', 'dbt_tags.governance."pii.quoted"'),
  ("dbt_tags.core.semantic_category", "dbt_tags.core.semantic_category"),
  ('"my.db".core."semantic.category"', '"my.db".core."semantic.category"'),
] %}

{% for tag_name, expected_fqn in cases %}
select  '{{ tag_name }}' as tag_name,
        '{{ dbt_tags.get_tag_fqn(tag_name) }}' as actual_fqn,
        '{{ expected_fqn }}' as expected_fqn
where   lower(actual_fqn) != lower(expected_fqn)
{% if not loop.last %}union all{% endif %}
{% endfor %}
