-- created_at: 2025-09-17T19:12:55.714530900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: execute adapter call
show terse schemas in database adtech_analytics
    limit 10000;
-- created_at: 2025-09-17T19:12:56.969599400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."THD_ANALYTICS_PROD" LIMIT 10000;
-- created_at: 2025-09-17T19:12:57.674486700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
create or replace transient table adtech_analytics.thd_analytics_prod.daily_report_unified
         as
        (

select * from adtech_analytics.staging.int_business_analytics__model_eph
        );
-- created_at: 2025-09-17T19:12:58.689724200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_report_unified
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."THD_ANALYTICS_PROD" LIMIT 10000;
-- created_at: 2025-09-17T19:12:59.011756100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_report_unified
-- desc: execute adapter call
create or replace transient table adtech_analytics.thd_analytics_prod.monthly_report_unified
         as
        (

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
from adtech_analytics.staging.int_business_analytics__model_eph
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
order by month
        );
