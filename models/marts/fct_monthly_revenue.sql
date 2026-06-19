{{
    config(
        materialized='incremental',
        unique_key=['order_year', 'order_month_num', 'customer_region', 'product_category'],
        incremental_strategy='delete+insert'
    )
}}

with orders as (
    select * from {{ ref('int_orders_enriched') }}
    {% if is_incremental() %}
        where order_date_key >= (select max(order_date_key) - 3 from {{ ref('int_orders_enriched') }})
    {% endif %}
)

select
    order_year,
    order_month_num,
    order_month,
    customer_region,
    product_category,
    count(distinct order_key) as total_orders,
    sum(quantity) as total_quantity,
    sum(revenue) as total_revenue,
    sum(profit) as total_profit,
    avg(discount_pct) as avg_discount_pct,
    sum(revenue) / nullif(count(distinct order_key), 0) as revenue_per_order
from orders
group by 1, 2, 3, 4, 5
