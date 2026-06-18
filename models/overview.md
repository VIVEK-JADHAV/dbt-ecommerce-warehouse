{% docs __overview__ %}

# ShopStream Data Warehouse

This dbt project transforms raw SSB (Star Schema Benchmark) data into analytics-ready tables for the ShopStream e-commerce platform.

## Data Flow

```
raw_data (source tables)
    │
    ▼
staging (clean names, type casts)
    │
    ▼
intermediate (joins, enrichment)
    │
    ▼
marts (aggregated business metrics)
```

## Layers

| Layer | Schema | Purpose | Materialization |
|-------|--------|---------|-----------------|
| Sources | raw_data | Raw data loaded from S3 | Tables (loaded via COPY) |
| Staging | dev_staging | Renamed columns, cleaned types | Views |
| Intermediate | dev_intermediate | Joined + enriched | Tables |
| Marts | dev_marts | Business metrics for analysts | Tables |

## Key Marts

- **fct_monthly_revenue** — Revenue trends by month, region, and product category
- **fct_customer_lifetime_value** — CLV metrics per customer (total revenue, orders, years active)
- **fct_product_performance** — Product metrics (revenue, profit margin, unique customers)

## Data Scale

- 600M+ order line items
- 3M customers across 5 regions
- 1.4M products across multiple categories
- 200K suppliers
- 7 years of date dimensions

{% enddocs %}
