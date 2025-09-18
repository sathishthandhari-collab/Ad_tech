
  create or replace   view adtech_analytics.staging.stg_IAS__view
  
   as (
     select
        date::date as date,
        publisher,
        campaign as campaign_name,
        placement as placement_name,
        ad_format as creative_type,
        monitored_ads as impressions,
        viewable_ads::int as viewable_ads,
        brand_safety_ads::int as brand_safety_ads,
        out_of_geo_ads::int as out_of_geo_ads,
        views as page_views,
        video_completions
from adtech_analytics.staging.STG_ias_raw_data
  );

