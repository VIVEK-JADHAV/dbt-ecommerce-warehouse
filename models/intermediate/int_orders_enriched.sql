{{
    config(
        materialized='incremental',
        unique_key=['order_key', 'line_number'],
        incremental_strategy='delete+insert'
    )
}}

with orders as (
    select * from {{ ref('stg_lineorder') }}
    {% if is_incremental() %}
        where order_date_key >= (select max(order_date_key) - 3 from {{ this }})
    {% endif %}
),

customers as (
    select * from {{ ref('stg_customer') }}
),

parts as (
    select * from {{ ref('stg_part') }}
),

suppliers as (
    select * from {{ ref('stg_supplier') }}
),

dates as (
    select * from {{ ref('stg_date') }}
),

enriched as (
    select
        orders.order_key,
        orders.line_number,
        orders.order_priority,
        orders.ship_mode,
        orders.quantity,
        orders.extended_price,
        orders.order_total_price,
        orders.discount_pct,
        orders.revenue,
        orders.supply_cost,
        orders.tax_pct,
        orders.revenue - orders.supply_cost as profit,

        customers.customer_key,
        customers.customer_name,
        customers.city as customer_city,
        customers.nation as customer_nation,
        customers.region as customer_region,
        customers.market_segment,

        parts.part_key,
        parts.part_name,
        parts.category as product_category,
        parts.brand as product_brand,
        parts.manufacturer,

        suppliers.supplier_key,
        suppliers.supplier_name,
        suppliers.nation as supplier_nation,
        suppliers.region as supplier_region,

        dates.date_key as order_date_key,
        dates.full_date as order_date,
        dates.year as order_year,
        dates.month_name as order_month,
        dates.month_num_in_year as order_month_num,
        dates.day_of_week as order_day_of_week,
        dates.selling_season,
        dates.is_holiday

    from orders
    left join customers on orders.customer_key = customers.customer_key
    left join parts on orders.part_key = parts.part_key
    left join suppliers on orders.supplier_key = suppliers.supplier_key
    left join dates on orders.order_date_key = dates.date_key
)

select * from enriched
