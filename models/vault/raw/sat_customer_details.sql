{{
    config(
        materialized='incremental',
        unique_key=['customer_hash_key', 'load_date']
    )
}}

{%- set src = ref('stg_vault_customers') -%}

with source_data as (
    select
        customer_hash_key,
        customer_name,
        city,
        nation,
        region,
        market_segment,
        hash_diff,
        load_date,
        record_source
    from {{ src }}
)

{% if is_incremental() %}

, latest_records as (
    select
        customer_hash_key,
        hash_diff
    from (
        select
            customer_hash_key,
            hash_diff,
            row_number() over (
                partition by customer_hash_key
                order by load_date desc
            ) as rn
        from {{ this }}
    )
    where rn = 1
)

select
    src.customer_hash_key,
    src.customer_name,
    src.city,
    src.nation,
    src.region,
    src.market_segment,
    src.hash_diff,
    src.load_date,
    src.record_source
from source_data src
left join latest_records lr
    on src.customer_hash_key = lr.customer_hash_key
where lr.customer_hash_key is null
   or src.hash_diff != lr.hash_diff

{% else %}

select
    customer_hash_key,
    customer_name,
    city,
    nation,
    region,
    market_segment,
    hash_diff,
    load_date,
    record_source
from source_data

{% endif %}
