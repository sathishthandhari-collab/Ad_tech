{{ config(
    materialized='table',
) }}

with base as (
    select
        month,
        campaign_id,
        campaign_name,
        site_name,
        creative_concept,
        creative_type,
        state,
        region,
        sex,
        device_type,
        sum(impressions) as impressions,
        sum(clicks) as clicks,
        sum(clicks) / nullif(sum(impressions), 0) as ctr,
        sum(ias_impressions) as ias_impressions,
        sum(ias_viewable_ads) as ias_viewable_ads,
        sum(ias_brand_safety_ads) as ias_brand_safety_ads,
        sum(ias_out_of_geo_ads) as ias_out_of_geo_ads,
        sum(ias_page_views) as ias_page_views,
        sum(ias_video_completions) as ias_video_completions

    from {{ ref('int_business_analytics__model_eph') }}
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)

select * from base
{% if is_incremental() %}
    where month >= date_trunc('month', current_date) - interval '1 month'
{% endif %}
order by month
