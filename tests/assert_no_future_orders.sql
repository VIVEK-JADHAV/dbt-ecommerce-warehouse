select
    order_key,
    order_date_key
from {{ ref('stg_lineorder') }}
where order_date_key > cast(to_char(current_date, 'YYYYMMDD') as integer)
limit 10
