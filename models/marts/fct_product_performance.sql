{# Fact Product Performance #}
with orders as (
    select * from {{ ref('int_orders_enriched') }}
)

select
    part_key,
    part_name,
    product_category,
    product_brand,
    manufacturer,
    count(distinct order_key) as total_orders,
    count(distinct customer_key) as unique_customers,
    sum(quantity) as total_quantity_sold,
    sum(revenue) as total_revenue,
    sum(profit) as total_profit,
    {{ profit_margin('sum(revenue)', 'sum(supply_cost)') }} as profit_margin_pct,
    sum(revenue) / nullif(count(distinct customer_key), 0) as revenue_per_customer
from orders
group by 1, 2, 3, 4, 5
