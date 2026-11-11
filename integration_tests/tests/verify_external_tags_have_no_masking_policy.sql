{% set external_tags = [] %}
{% for tag in dbt_tags.get_dbt_tags() | map(attribute='tag') | unique if not dbt_tags.is_managed_tag(tag) %}
  {% do external_tags.append(dbt_tags.get_tag_fqn(tag)) %}
{% endfor %}

select null as tag_name, null as policy_name where false
{% for tag_fqn in external_tags | unique %}
union all
select  '{{ tag_fqn }}', policy_name
from    table(information_schema.policy_references(ref_entity_name => '{{ tag_fqn }}', ref_entity_domain => 'tag'))
{% endfor %}
