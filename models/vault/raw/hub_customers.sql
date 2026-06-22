{{
    config(
        materialized='incremental',
        unique_key='customer_hash_key'
    )
}}

{%- set src = ref('stg_vault_customers') -%}

select distinct
    customer_hash_key,
    customer_key,
    load_date,
    record_source
from {{ src }}

{% if is_incremental() %}
    where customer_hash_key not in (select customer_hash_key from {{ this }})
{% endif %}
