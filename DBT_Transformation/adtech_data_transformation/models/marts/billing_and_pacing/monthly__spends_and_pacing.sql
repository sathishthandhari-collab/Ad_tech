{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['month', 'placement_name'],
    schema='thd_billing_prod'
) }}

with billable_and_nonbillable as (
    select
        *,
        (out_of_geo_ads_ias + fraud_ads_ias) as total_non_billable,
        total_impressions_cm360
        - (out_of_geo_ads_ias + fraud_ads_ias) as total_billable_impressions,

        round(
            viewable_ads_ias * 100.0
            / nullif(total_impressions_cm360, 0),
            2
        ) as viewable_rate_pct,

        round(
            total_impressions_cm360
            / nullif(planned_impressions, 0),
            2
        ) as delivery_rate,

        (contracted_rate * planned_impressions) as planned_spend,
        (contracted_rate * planned_impressions) * 1.1 as adjusted_spend
    from {{ ref('int_pacing_and_billing__model') }}

)

       select
    *,
    round(
        case
            when viewable_rate_pct >= 70
                then total_billable_impressions * contracted_rate / 1000
            else 0.70 * total_billable_impressions * contracted_rate / 1000
        end,
        2
    ) as billable_spend,
    round(
        case
            when delivery_rate >= 1.10
                then adjusted_spend
            when viewable_rate_pct >= 70
                then total_billable_impressions * contracted_rate / 1000
            else 0.70 * total_billable_impressions * contracted_rate / 1000
        end,
        2
    ) as final_billable_payment

from billable_and_nonbillable
{% if is_incremental() %}
    where month >= date_trunc('month', current_date) - interval '1 month'
{% endif %}