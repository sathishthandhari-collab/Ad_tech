{{ config(materialized='view') }}

with cm360_daily as (
    select
        cm360.date,
        cm360.campaign_id,
        cm360.campaign_name,
        cm360.site_name,
        cm360.placement_name,
        cm360.creative_concept,
        cm360.creative_type,
        sum(cm360.total_impressions_cm360) as impressions,
        sum(cm360.clicks_cm360) as clicks
    from {{ ref('stg_CM360__view') }} as cm360
    group by 1, 2, 3, 4, 5, 6, 7
),

ias_daily as (
    select
        ias.date,
        ias.placement_name,
        sum(ias.impressions) as ias_impressions,
        sum(ias.viewable_ads) as ias_viewable_ads,
        sum(ias.brand_safety_ads) as ias_brand_safety_ads,
        sum(ias.out_of_geo_ads) as ias_out_of_geo_ads,
        sum(ias.page_views) as ias_page_views,
        sum(ias.video_completions) as ias_video_completions
    from {{ ref('stg_IAS__view') }} as ias
    group by 1, 2
),

site_daily as (
    select
        site.date,
        site.placement_name,
        any_value(site.state) as state,
        any_value(site.region) as region,
        any_value(site.sex) as sex,
        any_value(site.device_type) as device_type
    from {{ ref('stg_sites__data_unified') }} as site
    group by 1, 2
)

select
    c.date,
    c.campaign_id,
    c.campaign_name,
    c.site_name,
    c.placement_name,
    c.creative_concept,
    c.creative_type,
    s.state,
    s.region,
    s.sex,
    s.device_type,
    date_trunc('month', c.date) as month,
    coalesce(c.impressions, 0) as impressions,
    coalesce(c.clicks, 0) as clicks,
    coalesce(i.ias_impressions, 0) as ias_impressions,
    coalesce(i.ias_viewable_ads, 0) as ias_viewable_ads,
    coalesce(i.ias_brand_safety_ads, 0) as ias_brand_safety_ads,
    coalesce(i.ias_out_of_geo_ads, 0) as ias_out_of_geo_ads,
    coalesce(i.ias_page_views, 0) as ias_page_views,
    coalesce(i.ias_video_completions, 0) as ias_video_completions
from cm360_daily as c
left join ias_daily as i
    on
        c.placement_name = i.placement_name
        and c.date = i.date
left join site_daily as s
    on
        c.placement_name = s.placement_name
        and c.date = s.date
