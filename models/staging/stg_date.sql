with source as (
    select * from {{ source('raw_data', 'dwdate') }}
),

renamed as (
    select
        d_datekey          as date_key,
        d_date             as full_date,
        d_dayofweek        as day_of_week,
        d_month            as month_name,
        d_year             as year,
        d_yearmonthnum     as year_month_num,
        d_yearmonth        as year_month,
        d_daynuminweek     as day_num_in_week,
        d_daynuminmonth    as day_num_in_month,
        d_daynuminyear     as day_num_in_year,
        d_monthnuminyear   as month_num_in_year,
        d_weeknuminyear    as week_num_in_year,
        d_sellingseason    as selling_season,
        d_lastdayinweekfl  as is_last_day_in_week,
        d_lastdayinmonthfl as is_last_day_in_month,
        d_holidayfl        as is_holiday,
        d_weekdayfl        as is_weekday
    from source
)

select * from renamed
