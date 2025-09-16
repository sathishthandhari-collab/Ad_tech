

select 
        DAY AS DATE,
        CAMPAIGN_NAME,
        SPLIT_PART(CAMPAIGN_NAME, '_', 4) AS CAMPAIGN_GROUP,
        CAMPAIGN_ID AS CM360_CAMPAIGN_ID,
        SITE_NAME,
        PLACEMENT_NAME,
        CREATIVE_TYPE,
        IMPRESSIONS * uniform(0.8632, 1.265, random()) as planned_impressions
from adtech_analytics.staging.stg_cm360_raw_data