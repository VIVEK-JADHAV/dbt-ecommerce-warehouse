{% snapshot snp_supplier %}

{{
    config(
        target_schema='snapshots',
        unique_key='supplier_key',
        strategy='check',
        check_cols=['supplier_name', 'city', 'nation', 'region']
    )
}}

select * from {{ ref('stg_supplier') }}

{% endsnapshot %}
