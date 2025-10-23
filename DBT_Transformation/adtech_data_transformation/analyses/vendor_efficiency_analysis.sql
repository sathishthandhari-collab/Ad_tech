with vendor_metrics as (
    select
        site_name as vendor,
        count(distinct month) as active_months,
        sum(total_impressions_cm360) as total_impressions,
        sum(viewable_ads_ias) as total_viewable,
        sum(brand_safety_ads_ias) as total_brand_safe,
        sum(final_billable_payment) as total_spend,
        avg(delivery_rate) as avg_delivery_rate,
        avg(viewable_rate_pct) as avg_viewability_rate
    from {{ ref('mart_monthly__spends_and_pacing') }}
    where
        month >= current_date - interval '6 months'
        and final_billable_payment > 0
    group by 1
),

vendor_rankings as (
    select
        *,
        total_spend / nullif(total_impressions, 0) * 1000 as effective_cpm,
        total_brand_safe::float
        / nullif(total_impressions, 0)
        * 100 as brand_safety_rate,
        rank() over (order by avg_viewability_rate desc) as viewability_rank,
        rank() over (order by brand_safety_rate desc) as safety_rank,
        rank() over (order by avg_delivery_rate desc) as delivery_rank
    from vendor_metrics
)

select
    vendor,
    active_months,
    total_impressions,
    viewability_rank,
    safety_rank,
    delivery_rank,
    round(total_spend, 0) as total_spend,
    round(effective_cpm, 2) as effective_cpm,
    round(avg_viewability_rate, 1) as avg_viewability_rate,
    round(brand_safety_rate, 1) as brand_safety_rate,
    round(avg_delivery_rate, 2) as avg_delivery_rate,
    round((viewability_rank + safety_rank + delivery_rank) / 3.0, 1)
        as overall_score
from vendor_rankings
order by overall_score asc;
