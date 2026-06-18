with source as (
    select * from {{ source('raw_data', 'customer') }}
),

renamed as (
    select
        c_custkey      as customer_key,
        c_name         as customer_name,
        c_address      as address,
        c_city         as city,
        c_nation       as nation,
        c_region       as region,
        c_phone        as phone,
        c_mktsegment   as market_segment
    from source
)

select * from renamed
