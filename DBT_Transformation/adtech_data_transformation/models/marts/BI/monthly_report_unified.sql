

select month,
        campaign_id,
        campaign_name,
        site_name,
        placement_name,
        creative_concept,
        creative_type,
        impressions,
        clicks,
        IAS_impressions,
        IAS_viewable_ads,
        IAS_brand_safety_ads,
        IAS_out_of_geo_ads,
        IAS_page_views,
        IAS_video_completions,
        state,
        region,
        sex,
        device_type
from {{ ref('int_business_analytics__model_eph') }}
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
order by month
