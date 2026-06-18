{% snapshot snp_customer %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_key',
        strategy='check',
        check_cols=['city', 'nation', 'region', 'market_segment']
    )
}}

select * from {{ ref('stg_customer') }}

{% endsnapshot %}
