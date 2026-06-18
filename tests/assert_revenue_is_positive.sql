select
    order_key,
    revenue
from {{ ref('stg_lineorder') }}
where revenue < 0
limit 10
