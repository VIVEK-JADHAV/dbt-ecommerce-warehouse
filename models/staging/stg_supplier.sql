with source as (
    select * from {{ source('raw_data', 'supplier') }}
),

renamed as (
    select
        s_suppkey   as supplier_key,
        s_name      as supplier_name,
        s_address   as address,
        s_city      as city,
        s_nation    as nation,
        s_region    as region,
        s_phone     as phone
    from source
)

select * from renamed
