with orders as (
    select * from {{ ref('int_orders_enriched') }}
)

select
    customer_key,
    customer_name,
    customer_nation,
    customer_region,
    market_segment,
    count(distinct order_key) as total_orders,
    sum(revenue) as lifetime_revenue,
    sum(profit) as lifetime_profit,
    min(order_year) as first_order_year,
    max(order_year) as last_order_year,
    max(order_year) - min(order_year) + 1 as years_active,
    sum(revenue) / nullif(count(distinct order_key), 0) as avg_order_value,
    count(distinct product_category) as categories_purchased
from orders
group by 1, 2, 3, 4, 5
