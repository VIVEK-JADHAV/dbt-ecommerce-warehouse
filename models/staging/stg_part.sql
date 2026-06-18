with source as (
    select * from {{ source('raw_data', 'part') }}
),

renamed as (
    select
        p_partkey    as part_key,
        p_name       as part_name,
        p_mfgr       as manufacturer,
        p_category   as category,
        p_brand1     as brand,
        p_color      as color,
        p_type       as part_type,
        p_size       as part_size,
        p_container  as container
    from source
)

select * from renamed
