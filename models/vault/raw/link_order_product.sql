{{
    config(
        materialized='incremental',
        unique_key='order_product_hash_key'
    )
}}

{%- set src = ref('stg_vault_orders') -%}

select distinct
    order_product_hash_key,
    customer_hash_key,
    product_hash_key,
    order_key,
    load_date,
    record_source
from {{ src }}

{% if is_incremental() %}
    where order_product_hash_key not in (select order_product_hash_key from {{ this }})
{% endif %}
