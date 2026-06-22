{{
    config(
        materialized='table',
        tags=['daily', 'vault-fed']
    )
}}

with customers as (
    select * from {{ ref('hub_customers') }}
),

customer_details as (
    select
        customer_hash_key,
        customer_name,
        city,
        nation,
        region,
        market_segment,
        row_number() over (
            partition by customer_hash_key
            order by load_date desc
        ) as rn
    from {{ ref('sat_customer_details') }}
),

current_details as (
    select * from customer_details where rn = 1
),

order_links as (
    select * from {{ ref('link_order_product') }}
),

product_hubs as (
    select * from {{ ref('hub_products') }}
),

customer_orders as (
    select
        ol.customer_hash_key,
        count(distinct ol.order_key) as total_orders,
        count(distinct ol.product_hash_key) as unique_products
    from order_links ol
    group by 1
)

select
    c.customer_key,
    cd.customer_name,
    cd.region,
    cd.nation,
    cd.market_segment,
    coalesce(co.total_orders, 0) as total_orders,
    coalesce(co.unique_products, 0) as unique_products,
    case
        when co.total_orders >= 100 then 'platinum'
        when co.total_orders >= 50 then 'gold'
        when co.total_orders >= 20 then 'silver'
        else 'bronze'
    end as customer_tier
from customers c
inner join current_details cd
    on c.customer_hash_key = cd.customer_hash_key
left join customer_orders co
    on c.customer_hash_key = co.customer_hash_key
