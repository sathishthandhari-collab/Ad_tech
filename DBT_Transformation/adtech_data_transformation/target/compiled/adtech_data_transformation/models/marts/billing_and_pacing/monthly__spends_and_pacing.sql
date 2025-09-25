

with  __dbt__cte__int_pacing_and_billing__model as (
with cm360_monthly as (
    select
        DATE_TRUNC('month', date) as month,
        campaign_name,
        campaign_group,
        campaign_id,
        site_name,
        placement_name,
        creative_concept,
        creative_type,
        SUM(total_impressions_cm360) as total_impressions_cm360,
        SUM(clicks_cm360) as clicks_cm360
    from adtech_analytics.staging.stg_CM360__view
    group by 1, 2, 3, 4, 5, 6, 7, 8
),

ias_monthly as (
    select
        DATE_TRUNC('month', date) as month,
        campaign_name,
        placement_name,
        SUM(viewable_ads) as viewable_ads_ias,
        SUM(brand_safety_ads) as brand_safety_ads_ias,
        SUM(out_of_geo_ads) as out_of_geo_ads_ias,
        SUM(page_views) as page_views_ias,
        --- JUST TO HAVE FRAUD ADS
        SUM(impressions) - SUM(brand_safety_ads) as fraud_ads_ias
    from adtech_analytics.staging.stg_IAS__view
    group by 1, 2, 3
)

select
    cm360.month,
    cm360.campaign_name,
    cm360.campaign_group,
    cm360.campaign_id,
    cm360.site_name,
    cm360.placement_name,
    cm360.creative_concept,
    cm360.creative_type,
    prisma.planned_impressions,
    prisma.contracted_rate,
    cm360.total_impressions_cm360,
    cm360.clicks_cm360,
    ias.viewable_ads_ias,
    ias.brand_safety_ads_ias,
    ias.out_of_geo_ads_ias,
    ias.page_views_ias,
    ias.fraud_ads_ias
from cm360_monthly as cm360
left join ias_monthly as ias
    on
        cm360.campaign_name = ias.campaign_name
        and cm360.placement_name = ias.placement_name
        and cm360.month = ias.month
left join adtech_analytics.staging.stg_prisma__planned as prisma
    on
        cm360.campaign_name = prisma.campaign_name
        and cm360.placement_name = prisma.placement_name
        and cm360.month = prisma.month
where
    cm360.campaign_name is not NULL
    and cm360.placement_name is not NULL
    and cm360.month is not NULL
order by cm360.month
), billable_and_nonbillable as (
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
    from __dbt__cte__int_pacing_and_billing__model

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

    where month >= date_trunc('month', current_date) - interval '1 month'
