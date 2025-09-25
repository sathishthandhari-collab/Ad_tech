

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
    sum(IAS_impressions) as ias_impressions,
    sum(IAS_viewable_ads) as ias_viewable_ads,
    sum(IAS_brand_safety_ads) as ias_brand_safety_ads,
    sum(IAS_out_of_geo_ads) as ias_out_of_geo_ads,
    sum(IAS_page_views) as ias_page_views,
    sum(IAS_video_completions) as ias_video_completions
    
  from adtech_analytics.staging.int_business_analytics__model_eph
  group by 1,2,3,4,5,6,7,8,9,10
)

select * from base

order by month