{% macro profit_margin(revenue_col, cost_col) %}
    case
        when {{ revenue_col }} = 0 then 0
        else round(({{ revenue_col }} - {{ cost_col }}) * 100.0 / {{ revenue_col }}, 2)
    end
{% endmacro %}
