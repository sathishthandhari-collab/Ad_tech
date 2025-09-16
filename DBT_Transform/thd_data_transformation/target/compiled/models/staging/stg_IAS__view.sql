 select
        date::date as date,
        publisher,
        campaign as campaign_name,
        campaignId as campaign_id,
        placement as placement_name,
        ad_format as creative_type,
        monitored_ads as impressions,
        viewable_ads,
        brand_safety_ads,
        out_of_geo_ads,
        clk as clicks,
        views as pageviews,
        video_completions
from adtech_analytics.staging.STG_ias_raw_data