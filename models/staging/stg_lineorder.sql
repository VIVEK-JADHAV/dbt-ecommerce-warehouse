with source as (
    select * from {{ source('raw_data', 'lineorder') }}
),

renamed as (
    select
        lo_orderkey         as order_key,
        lo_linenumber       as line_number,
        lo_custkey          as customer_key,
        lo_partkey          as part_key,
        lo_suppkey          as supplier_key,
        lo_orderdate        as order_date_key,
        lo_orderpriority    as order_priority,
        lo_shippriority     as ship_priority,
        lo_quantity         as quantity,
        lo_extendedprice    as extended_price,
        lo_ordertotalprice  as order_total_price,
        lo_discount         as discount_pct,
        lo_revenue          as revenue,
        lo_supplycost       as supply_cost,
        lo_tax              as tax_pct,
        lo_commitdate       as commit_date_key,
        lo_shipmode         as ship_mode
    from source
)

select * from renamed
