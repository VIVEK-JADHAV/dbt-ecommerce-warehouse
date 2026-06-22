{{
    config(
        materialized='view'
    )
}}

with source as (
    select
        customer_key,
        customer_name,
        city,
        nation,
        region,
        market_segment,
        phone,
        address
    from {{ ref('stg_customer') }}
),

hashed as (
    select
        *,
        md5(cast(customer_key as varchar)) as customer_hash_key,
        md5(coalesce(cast(customer_name as varchar), '') || '||' || coalesce(cast(city as varchar), '') || '||' || coalesce(cast(nation as varchar), '') || '||' || coalesce(cast(region as varchar), '') || '||' || coalesce(cast(market_segment as varchar), '')) as hash_diff,
        'raw_data.customer' as record_source,
        current_timestamp as load_date
    from source
)

select * from hashed
