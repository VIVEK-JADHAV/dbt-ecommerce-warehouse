{{
    config(
        materialized='view'
    )
}}

with source as (
    select
        customer_key,
        part_key,
        order_key,
        line_number,
        quantity,
        revenue,
        discount_pct,
        supply_cost,
        order_date_key,
        ship_mode,
        order_priority
    from {{ ref('stg_lineorder') }}
),

hashed as (
    select
        *,
        md5(cast(customer_key as varchar)) as customer_hash_key,
        md5(cast(part_key as varchar)) as product_hash_key,
        md5(cast(customer_key as varchar) || '||' || cast(part_key as varchar) || '||' || cast(order_key as varchar)) as order_product_hash_key,
        'raw_data.lineorder' as record_source,
        current_timestamp as load_date
    from source
)

select * from hashed
