{{
    config(
        materialized='incremental',
        unique_key='product_hash_key'
    )
}}

{%- set src = ref('stg_vault_orders') -%}

select distinct
    product_hash_key,
    part_key,
    load_date,
    record_source
from {{ src }}

{% if is_incremental() %}
    where product_hash_key not in (select product_hash_key from {{ this }})
{% endif %}
