-- created_at: 2025-09-17T18:25:42.973657600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: execute adapter call
show terse schemas in database adtech_analytics
    limit 10000;
-- created_at: 2025-09-17T18:25:44.140070700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_sites__data_unified
-- desc: execute adapter call
select distinct
            table_schema as "table_schema",
            table_name as "table_name",
            
            case table_type
                when 'BASE TABLE' then 'table'
                when 'EXTERNAL TABLE' then 'external'
                when 'MATERIALIZED VIEW' then 'materializedview'
                else lower(table_type)
            end as "table_type"

        from adtech_analytics.information_schema.tables
        where table_schema ilike 'STAGING'
        and table_name ilike '%_RAW_%'
        and table_name not ilike '';
-- created_at: 2025-09-17T18:25:45.724560600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_IAS__view
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-17T18:25:46.121809600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_IAS__view
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.stg_IAS__view
  
   as (
     select
        date::date as date,
        publisher,
        campaign as campaign_name,
        placement as placement_name,
        ad_format as creative_type,
        monitored_ads as impressions,
        viewable_ads,
        brand_safety_ads,
        out_of_geo_ads,
        views as page_views,
        video_completions
from adtech_analytics.staging.STG_ias_raw_data
  );
-- created_at: 2025-09-17T18:25:46.448653100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_CM360__view
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-17T18:25:46.857940+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_CM360__view
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.stg_CM360__view
  
   as (
    select 
        DAY AS DATE,
        CAMPAIGN_NAME,
        SPLIT_PART(CAMPAIGN_NAME, '_', 4) AS CAMPAIGN_GROUP,
        CAMPAIGN_ID,
        SITE_NAME,
        PLACEMENT_NAME,
        SPLIT_PART(PLACEMENT_NAME, '_', -3) AS CREATIVE_CONCEPT,
        CREATIVE_TYPE,
        IMPRESSIONS AS  TOTAL_IMPRESSIONS_CM360,
        CLICKS AS CLICKS_CM360
from adtech_analytics.staging.stg_cm360_raw_data
  );
-- created_at: 2025-09-17T18:25:47.580652200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_prisma__planned
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-17T18:25:48.079211+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_prisma__planned
-- desc: execute adapter call
create or replace transient table adtech_analytics.staging.stg_prisma__planned
         as
        (

select 
        DAY AS DATE,
        CAMPAIGN_NAME,
        SPLIT_PART(CAMPAIGN_NAME, '_', 4) AS CAMPAIGN_GROUP,
        CAMPAIGN_ID AS CM360_CAMPAIGN_ID,
        SITE_NAME,
        PLACEMENT_NAME,
        CREATIVE_TYPE,
        IMPRESSIONS * uniform(0.8632, 1.265, random()) as planned_impressions,
        uniform(7.00, 23.00, random()) as contracted_rate
from adtech_analytics.staging.stg_cm360_raw_data
        );
-- created_at: 2025-09-17T18:25:48.442088600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_TOI_RAW_DATA";
-- created_at: 2025-09-17T18:25:48.765333300+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_AMAZON_RAW_DATA";
-- created_at: 2025-09-17T18:25:49.080387400+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_YOUTUBE_RAW_DATA";
-- created_at: 2025-09-17T18:25:49.225628900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_BINGADS_RAW_DATA";
-- created_at: 2025-09-17T18:25:49.440251100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_DV360_RAW_DATA";
-- created_at: 2025-09-17T18:25:49.534906100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_MIQ_RAW_DATA";
-- created_at: 2025-09-17T18:25:49.812902400+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_INMOBI_RAW_DATA";
-- created_at: 2025-09-17T18:25:49.906328600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_TTD_RAW_DATA";
-- created_at: 2025-09-17T18:25:50.121847100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_PUBMATIC_RAW_DATA";
-- created_at: 2025-09-17T18:25:50.230128200+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_CRITEO_RAW_DATA";
-- created_at: 2025-09-17T18:25:50.442159300+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_HINDHU_RAW_DATA";
-- created_at: 2025-09-17T18:25:50.569260300+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_WEBMD_RAW_DATA";
-- created_at: 2025-09-17T18:25:50.915753100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_SHARETHROUGH_RAW_DATA";
-- created_at: 2025-09-17T18:25:51.208214+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_MAGNITE_RAW_DATA";
-- created_at: 2025-09-17T18:25:51.508229600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_REMEZCLA_RAW_DATA";
-- created_at: 2025-09-17T18:25:51.553356900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_AVZU_RAW_DATA";
-- created_at: 2025-09-17T18:25:52.309326100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_sites__data_unified
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.stg_sites__data_unified
  
   as (
    

WITH unified_site_data AS (

    

    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_MIQ_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_MIQ_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_YOUTUBE_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_YOUTUBE_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_PUBMATIC_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_PUBMATIC_RAW_DATA

         UNION ALL 

        
    
        
        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_TTD_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_TTD_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_INMOBI_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_INMOBI_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_BINGADS_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_BINGADS_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_MAGNITE_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_MAGNITE_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_CRITEO_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_CRITEO_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_TOI_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_TOI_RAW_DATA

         UNION ALL 

        
    
        
        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_AVZU_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_AVZU_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_AMAZON_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_AMAZON_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_REMEZCLA_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_REMEZCLA_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_SHARETHROUGH_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_SHARETHROUGH_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_HINDHU_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_HINDHU_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_WEBMD_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_WEBMD_RAW_DATA

         UNION ALL 

        
    
        
        

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement as placement_name,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            'STG_DV360_RAW_DATA' AS source_table
        FROM adtech_analytics.STAGING.STG_DV360_RAW_DATA

        

        
    
)

SELECT * FROM unified_site_data
  );
-- created_at: 2025-09-17T18:25:53.747061800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.int_business_analytics__model_eph
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.int_business_analytics__model_eph
  
   as (
    select  cm360.date,
        cm360.campaign_id,
        cm360.campaign_name,
        cm360.site_name,
        cm360.placement_name,
        cm360.creative_concept,
        cm360.creative_type,
        cm360.TOTAL_IMPRESSIONS_CM360 as impressions,
        cm360.clicks_cm360 as clicks,
        ias.impressions as IAS_impressions,
        ias.viewable_ads as IAS_viewable_ads,
        ias.brand_safety_ads as IAS_brand_safety_ads,
        ias.out_of_geo_ads as IAS_out_of_geo_ads,
        ias.page_views as IAS_page_views,
        ias.video_completions as IAS_video_completions,
        site.state,
        site.region,
        site.sex,
        site.device_type
        from adtech_analytics.staging.stg_CM360__view as cm360
            left join adtech_analytics.staging.stg_IAS__view as ias
                on cm360.placement_name = ias.placement_name
                    and cm360.date = ias.date
            left join adtech_analytics.staging.stg_sites__data_unified as site
                on cm360.placement_name = site.placement_name
                    and cm360.date = site.date
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
            order by date
        
    
        
  );
-- created_at: 2025-09-17T18:25:53.896455700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.int_pacing_and_billing__model
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.int_pacing_and_billing__model
  
   as (
     select  
    cm360.date,
    cm360.campaign_id,
    cm360.campaign_name,
    cm360.site_name,
    cm360.placement_name,
    cm360.creative_concept,
    cm360.creative_type,
    cm360.total_impressions_cm360 as CM360_Delivered_Impressions,
    cm360.clicks_cm360 as CM360_clicks,
    prisma.planned_impressions,
    prisma.contracted_rate as contracted_cpm,
    prisma.contracted_rate * prisma.planned_impressions/1000 as planned_spend
from 
    adtech_analytics.staging.stg_CM360__view as cm360
    join adtech_analytics.staging.stg_prisma__planned  as prisma
        on cm360.placement_name = prisma.placement_name
            and cm360.date = prisma.date 
group by 1,2,3,4,5,6,7,8,9,10,11,12
order by date

        
  );
