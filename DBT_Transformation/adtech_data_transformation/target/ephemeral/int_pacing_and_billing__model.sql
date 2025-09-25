__dbt__cte__int_pacing_and_billing__model as (
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
)