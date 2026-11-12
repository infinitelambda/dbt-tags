{% snapshot orders_snapshot %}

{{
  config(
    unique_key = 'order_id',
    strategy = 'check',
    check_cols = ['status'],
  )
}}

select order_id, status from {{ ref('orders') }}

{% endsnapshot %}
