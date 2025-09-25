-- created_at: 2025-09-25T08:06:15.116769500+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: list_relations_in_parallel
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."THD_ANALYTICS_PROD" LIMIT 10000;
-- created_at: 2025-09-25T08:06:15.508673500+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: list_relations_in_parallel
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."THD_BILLING_PROD" LIMIT 10000;
-- created_at: 2025-09-25T08:06:16.506056900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: list_relations_in_parallel
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."THD_SITE_SPENDS_PROD" LIMIT 10000;
-- created_at: 2025-09-25T08:06:18.985529200+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: execute adapter call
show terse schemas in database adtech_analytics
    limit 10000
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","connection_name":""} */;
-- created_at: 2025-09-25T08:06:20.396304300+00:00
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
        and table_name not ilike ''
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","connection_name":""} */;
-- created_at: 2025-09-25T08:06:21.632144500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_sites__data_unified
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-25T08:06:21.806930400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_IAS__view
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-25T08:06:22.242612500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_IAS__view
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.stg_IAS__view
  
   as (
    with base as(
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
),

deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY date, campaign_name, publisher, placement_name, creative_type
            ORDER BY date
        ) as rn
    FROM base
)

select * from deduplicated
where rn =1
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.stg_IAS__view"} */;
-- created_at: 2025-09-25T08:06:22.634872600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_CM360__view
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-25T08:06:23.012796800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_CM360__view
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.stg_CM360__view
  
   as (
    with source as (
    select
        day as date,
        campaign_name,
        campaign_id,
        site_name,
        placement_name,
        creative_type,
        impressions as total_impressions_cm360,
        clicks as clicks_cm360,
        SPLIT_PART(campaign_name, '_', 4) as campaign_group,
        SPLIT_PART(placement_name, '_', -3) as creative_concept
    from adtech_analytics.staging.stg_cm360_raw_data
),
deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY date, campaign_id, site_name, placement_name, creative_type
            ORDER BY date
        ) as rn
    FROM source
)

select * from deduplicated
where rn =1
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.stg_CM360__view"} */;
-- created_at: 2025-09-25T08:06:23.520885300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_prisma__planned
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-25T08:06:24.007108800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_prisma__planned
-- desc: execute adapter call
create or replace transient table adtech_analytics.staging.stg_prisma__planned
         as
        (

with base as
    (select
        date_trunc(month, day) as month,
        campaign_id as cm360_campaign_id,
        campaign_name,
        split_part(campaign_name, '_', 4) as campaign_group,
        site_name,
        placement_name,
        creative_type,
        sum(impressions * uniform(0.8632, 1.265, random()))::int
            as planned_impressions,
        round(uniform(7.00, 23.00, random()), 2) as contracted_rate
    from adtech_analytics.staging.stg_cm360_raw_data
    group by 1, 2, 3, 4, 5, 6, 7
    ),

deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY month, cm360_campaign_id, site_name, placement_name, creative_type
            ORDER BY month
        ) as rn
    FROM base
)

select * from deduplicated
where rn =1
        )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.stg_prisma__planned"} */;
-- created_at: 2025-09-25T08:06:24.487685100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_AVZU_RAW_DATA";
-- created_at: 2025-09-25T08:06:24.817827100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_PUBMATIC_RAW_DATA";
-- created_at: 2025-09-25T08:06:25.416758600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_REMEZCLA_RAW_DATA";
-- created_at: 2025-09-25T08:06:25.626214900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_AMAZON_RAW_DATA";
-- created_at: 2025-09-25T08:06:25.734139800+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_INMOBI_RAW_DATA";
-- created_at: 2025-09-25T08:06:25.967895200+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_SHARETHROUGH_RAW_DATA";
-- created_at: 2025-09-25T08:06:26.107774600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_YOUTUBE_RAW_DATA";
-- created_at: 2025-09-25T08:06:26.441166+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_HINDHU_RAW_DATA";
-- created_at: 2025-09-25T08:06:26.500726100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_TOI_RAW_DATA";
-- created_at: 2025-09-25T08:06:26.771821400+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_WEBMD_RAW_DATA";
-- created_at: 2025-09-25T08:06:26.817020400+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_MIQ_RAW_DATA";
-- created_at: 2025-09-25T08:06:27.097233600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_CRITEO_RAW_DATA";
-- created_at: 2025-09-25T08:06:27.164605600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_BINGADS_RAW_DATA";
-- created_at: 2025-09-25T08:06:27.374654600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_billing_prod.monthly__spends_and_pacing__dbt_tmp
  
   as (
    with __dbt__cte__int_pacing_and_billing__model as (
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
--EPHEMERAL-SELECT-WRAPPER-START
select * from (


with billable_and_nonbillable as (
    select
        *,
        (out_of_geo_ads_ias + fraud_ads_ias) as total_non_billable,
        total_impressions_cm360
        - (out_of_geo_ads_ias + fraud_ads_ias) as total_billable_impressions,

        round(
            viewable_ads_ias * 100.0
            / nullif(total_impressions_cm360, 0),
            2
        ) as viewable_rate_pct,

        round(
            total_impressions_cm360
            / nullif(planned_impressions, 0),
            2
        ) as delivery_rate,

        (contracted_rate * planned_impressions) as planned_spend,
        (contracted_rate * planned_impressions) * 1.1 as adjusted_spend
    from __dbt__cte__int_pacing_and_billing__model

)

       select
    *,
    round(
        case
            when viewable_rate_pct >= 70
                then total_billable_impressions * contracted_rate / 1000
            else 0.70 * total_billable_impressions * contracted_rate / 1000
        end,
        2
    ) as billable_spend,
    round(
        case
            when delivery_rate >= 1.10
                then adjusted_spend
            when viewable_rate_pct >= 70
                then total_billable_impressions * contracted_rate / 1000
            else 0.70 * total_billable_impressions * contracted_rate / 1000
        end,
        2
    ) as final_billable_payment

from billable_and_nonbillable

    where month >= date_trunc('month', current_date) - interval '1 month'

--EPHEMERAL-SELECT-WRAPPER-END
)
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-25T08:06:27.431016+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_DV360_RAW_DATA";
-- created_at: 2025-09-25T08:06:27.494050800+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_MAGNITE_RAW_DATA";
-- created_at: 2025-09-25T08:06:27.828814700+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_TTD_RAW_DATA";
-- created_at: 2025-09-25T08:06:28.034169700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
describe table adtech_analytics.thd_billing_prod.monthly__spends_and_pacing__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-25T08:06:28.395132900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
describe table adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-25T08:06:28.690433800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_sites__data_unified
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.stg_sites__data_unified
  
   as (
    

WITH unified_site_data AS (
    
        
        
        
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
            
            -- Exclude CM360, IAS, and common backup table patterns
            
                
                    
                
            
        
    

    
        
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
                'STG_MIQ_RAW_DATA' AS source_table
            FROM adtech_analytics.STAGING.STG_MIQ_RAW_DATA
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
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
            WHERE date IS NOT NULL  -- Basic data quality filter
            
        
    
),

-- Simple deduplication: Keep only one record per unique combination
deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY date, campaign, cm360_campaign_id, publisher, placement_name, creative_type
            ORDER BY 
                CASE WHEN source_table LIKE '%LATEST%' THEN 1 ELSE 2 END,  -- Prioritize "LATEST" tables
                source_table DESC  -- Then by table name descending
        ) as rn
    FROM unified_site_data
)

SELECT 
    date,
    campaign,
    cm360_campaign_id,
    publisher,
    placement_name,
    creative_type,
    impressions,
    clicks,
    pageviews,
    state,
    region,
    age_group,
    sex,
    device_type,
    video_completions,
    source_table
FROM deduplicated
WHERE rn = 1  -- Keep only the first record for each unique combination
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.stg_sites__data_unified"} */;
-- created_at: 2025-09-25T08:06:29.071578600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_BILLING_PROD.MONTHLY__SPENDS_AND_PACING
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-25T08:06:29.682847800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-25T08:06:29.948243700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call
create or replace transient table adtech_analytics.thd_analytics_prod.monthly_campaign__level_report
         as
        (with __dbt__cte__int_business_analytics__model_eph as (
with cte as (
    select
        date_trunc('month', cm360.date) as month,
        cm360.date,
        cm360.campaign_id,
        cm360.campaign_name,
        cm360.site_name,
        cm360.placement_name,
        cm360.creative_concept,
        cm360.creative_type,
        site.state,
        site.region,
        site.sex,
        site.device_type,
        sum(cm360.total_impressions_cm360) as impressions,
        sum(cm360.clicks_cm360) as clicks,
        sum(ias.impressions )as ias_impressions,
        sum(ias.viewable_ads) as ias_viewable_ads,
        sum(ias.brand_safety_ads )as ias_brand_safety_ads,
        sum(ias.out_of_geo_ads) as ias_out_of_geo_ads,
        sum(ias.page_views) as ias_page_views,
        sum(ias.video_completions) as ias_video_completions,
        
    from adtech_analytics.staging.stg_CM360__view as cm360
    left join adtech_analytics.staging.stg_IAS__view as ias
        on
            cm360.placement_name = ias.placement_name
            and cm360.date = ias.date
    left join adtech_analytics.staging.stg_sites__data_unified as site
        on
            cm360.placement_name = site.placement_name
            and cm360.date = site.date
    group by 1,2,3,4,5,6,7,8,9,10,11,12
)

select * from cte
order by date
)
--EPHEMERAL-SELECT-WRAPPER-START
select * from (


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

    from __dbt__cte__int_business_analytics__model_eph
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)

select * from base

order by month
--EPHEMERAL-SELECT-WRAPPER-END
)
        )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
-- created_at: 2025-09-25T08:06:30.106707200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_billing_prod.monthly__spends_and_pacing as DBT_INTERNAL_DEST
        using adtech_analytics.thd_billing_prod.monthly__spends_and_pacing__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-25T08:06:31.528045400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
create or replace transient table adtech_analytics.thd_analytics_prod.daily_report_unified
         as
        (with __dbt__cte__int_business_analytics__model_eph as (
with cte as (
    select
        date_trunc('month', cm360.date) as month,
        cm360.date,
        cm360.campaign_id,
        cm360.campaign_name,
        cm360.site_name,
        cm360.placement_name,
        cm360.creative_concept,
        cm360.creative_type,
        site.state,
        site.region,
        site.sex,
        site.device_type,
        sum(cm360.total_impressions_cm360) as impressions,
        sum(cm360.clicks_cm360) as clicks,
        sum(ias.impressions )as ias_impressions,
        sum(ias.viewable_ads) as ias_viewable_ads,
        sum(ias.brand_safety_ads )as ias_brand_safety_ads,
        sum(ias.out_of_geo_ads) as ias_out_of_geo_ads,
        sum(ias.page_views) as ias_page_views,
        sum(ias.video_completions) as ias_video_completions,
        
    from adtech_analytics.staging.stg_CM360__view as cm360
    left join adtech_analytics.staging.stg_IAS__view as ias
        on
            cm360.placement_name = ias.placement_name
            and cm360.date = ias.date
    left join adtech_analytics.staging.stg_sites__data_unified as site
        on
            cm360.placement_name = site.placement_name
            and cm360.date = site.date
    group by 1,2,3,4,5,6,7,8,9,10,11,12
)

select * from cte
order by date
)
--EPHEMERAL-SELECT-WRAPPER-START
select * from (


select *
from __dbt__cte__int_business_analytics__model_eph


--EPHEMERAL-SELECT-WRAPPER-END
)
        )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-25T08:06:32.313237100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-25T08:06:32.830961100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_billing_prod.monthly__spends_and_pacing__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-25T08:06:33.218845800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'PUBMATIC'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-25T08:06:33.218866800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'REMEZCLA'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-25T08:06:33.219438700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'SHARETHROUGH'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-25T08:06:33.721177+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-25T08:06:34.328118900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-25T08:06:34.402420800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_magnite_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'MAGNITE'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-25T08:06:34.442903100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-25T08:06:34.657856700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-25T08:06:34.957990500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-25T08:06:35.034731+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_magnite_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-25T08:06:35.272101700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_amazon_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'Amazon'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-25T08:06:35.324740700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_PUBMATIC_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-25T08:06:35.364847700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_SHARETHROUGH_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-25T08:06:35.604787400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_magnite_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-25T08:06:35.766569900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_analytics_prod.daily_report_unified__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-25T08:06:35.873090100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_amazon_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-25T08:06:35.923282+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-25T08:06:36.160610+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-25T08:06:36.177705400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-25T08:06:36.194889900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_youtube_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'YOUTUBE'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-25T08:06:36.465258700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_amazon_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-25T08:06:36.478713900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_MAGNITE_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-25T08:06:36.516185700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-25T08:06:36.782799700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-25T08:06:36.787893900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_AMAZON_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-25T08:06:36.817134100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-25T08:06:36.947302900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_youtube_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-25T08:06:37.091923300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_REMEZCLA_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-25T08:06:37.126402400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_webmd_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'WEBMD'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-25T08:06:37.287792300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_magnite_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_magnite_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-25T08:06:37.416912300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_youtube_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-25T08:06:37.628346700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-25T08:06:37.798282600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'INMOBI'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-25T08:06:37.939320800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_YOUTUBE_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-25T08:06:38.100319900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-25T08:06:38.154729+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-25T08:06:38.279723100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-25T08:06:38.408551800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-25T08:06:38.437197400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-25T08:06:38.823461+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_webmd_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-25T08:06:39.008813100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-25T08:06:39.087091200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_miq_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'MIQ'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-25T08:06:39.275642500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-25T08:06:39.349940200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_webmd_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-25T08:06:39.474876600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-25T08:06:39.710386700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-25T08:06:39.792188300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_WEBMD_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-25T08:06:39.830277200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_miq_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-25T08:06:39.902518900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_magnite_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-25T08:06:39.934269800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_toi_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'TOI'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-25T08:06:40.116462+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-25T08:06:40.160268200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-25T08:06:40.340938100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-25T08:06:40.552427100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_INMOBI_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-25T08:06:40.620708100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_webmd_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_webmd_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-25T08:06:40.670764400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_amazon_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_amazon_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-25T08:06:41.195449800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_dv360_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'DV360'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-25T08:06:41.260360100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_toi_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-25T08:06:41.365468300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-25T08:06:41.684751800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_toi_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-25T08:06:41.808256300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_dv360_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-25T08:06:41.809433700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-25T08:06:41.810169300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-25T08:06:41.932429700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_ttd_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'TTD'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-25T08:06:42.122395700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_TOI_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-25T08:06:42.147878900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-25T08:06:42.288929900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_miq_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-25T08:06:42.846578600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-25T08:06:42.888418900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_ttd_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-25T08:06:42.991872800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_webmd_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-25T08:06:42.993135700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-25T08:06:43.015477700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_avzu_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'AVZU'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-25T08:06:43.205231300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_MIQ_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-25T08:06:43.295819500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_youtube_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_youtube_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-25T08:06:43.354857600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_dv360_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-25T08:06:43.592018700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_amazon_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-25T08:06:43.676611700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_ttd_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-25T08:06:43.814276300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'HINDHU'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-25T08:06:44.039810300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_DV360_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-25T08:06:44.257724600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_avzu_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-25T08:06:44.364554500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_toi_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_toi_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-25T08:06:44.548341+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_criteo_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'CRITEO'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-25T08:06:44.586277900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-25T08:06:45.023389700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-25T08:06:45.155262+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_criteo_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-25T08:06:45.195363300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_bingads_spends__dbt_tmp
  
   as (
    
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'BINGADS'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-25T08:06:45.347155700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_miq_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_miq_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-25T08:06:45.479872100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_avzu_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-25T08:06:45.521746700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-25T08:06:45.624769900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-25T08:06:45.799495700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_TTD_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-25T08:06:45.830288200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_youtube_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-25T08:06:46.073249700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_AVZU_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-25T08:06:46.112135200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_criteo_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-25T08:06:46.268979700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_toi_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-25T08:06:46.428386700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-25T08:06:46.554244500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-25T08:06:46.583389800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_CRITEO_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-25T08:06:47.027459500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-25T08:06:47.172131100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-25T08:06:47.227025200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-25T08:06:47.367331100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-25T08:06:47.480384800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-25T08:06:47.516978300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_avzu_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_avzu_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-25T08:06:47.934453100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_dv360_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_dv360_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-25T08:06:47.935398300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_bingads_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-25T08:06:47.940110500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-25T08:06:48.431428300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_ttd_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_ttd_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-25T08:06:48.841222500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_criteo_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_criteo_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-25T08:06:48.848355500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_HINDHU_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-25T08:06:49.250945300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-25T08:06:49.453165600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_miq_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-25T08:06:49.460537200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_bingads_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-25T08:06:49.667846400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-25T08:06:50.085217700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_BINGADS_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-25T08:06:50.696556600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_avzu_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-25T08:06:50.696676900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-25T08:06:50.696686900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-25T08:06:50.896030300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-25T08:06:51.114339500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-25T08:06:51.321395400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-25T08:06:51.925075400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_site_spends_prod.monthly_bingads_spends as DBT_INTERNAL_DEST
        using adtech_analytics.thd_site_spends_prod.monthly_bingads_spends__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","CAMPAIGN_GROUP" = DBT_INTERNAL_SOURCE."CAMPAIGN_GROUP","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","PLANNED_IMPRESSIONS" = DBT_INTERNAL_SOURCE."PLANNED_IMPRESSIONS","CONTRACTED_RATE" = DBT_INTERNAL_SOURCE."CONTRACTED_RATE","TOTAL_IMPRESSIONS_CM360" = DBT_INTERNAL_SOURCE."TOTAL_IMPRESSIONS_CM360","CLICKS_CM360" = DBT_INTERNAL_SOURCE."CLICKS_CM360","VIEWABLE_ADS_IAS" = DBT_INTERNAL_SOURCE."VIEWABLE_ADS_IAS","BRAND_SAFETY_ADS_IAS" = DBT_INTERNAL_SOURCE."BRAND_SAFETY_ADS_IAS","OUT_OF_GEO_ADS_IAS" = DBT_INTERNAL_SOURCE."OUT_OF_GEO_ADS_IAS","PAGE_VIEWS_IAS" = DBT_INTERNAL_SOURCE."PAGE_VIEWS_IAS","FRAUD_ADS_IAS" = DBT_INTERNAL_SOURCE."FRAUD_ADS_IAS","TOTAL_NON_BILLABLE" = DBT_INTERNAL_SOURCE."TOTAL_NON_BILLABLE","TOTAL_BILLABLE_IMPRESSIONS" = DBT_INTERNAL_SOURCE."TOTAL_BILLABLE_IMPRESSIONS","VIEWABLE_RATE_PCT" = DBT_INTERNAL_SOURCE."VIEWABLE_RATE_PCT","DELIVERY_RATE" = DBT_INTERNAL_SOURCE."DELIVERY_RATE","PLANNED_SPEND" = DBT_INTERNAL_SOURCE."PLANNED_SPEND","ADJUSTED_SPEND" = DBT_INTERNAL_SOURCE."ADJUSTED_SPEND","BILLABLE_SPEND" = DBT_INTERNAL_SOURCE."BILLABLE_SPEND","FINAL_BILLABLE_PAYMENT" = DBT_INTERNAL_SOURCE."FINAL_BILLABLE_PAYMENT"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")
    values
        ("MONTH", "CAMPAIGN_NAME", "CAMPAIGN_GROUP", "CAMPAIGN_ID", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "PLANNED_IMPRESSIONS", "CONTRACTED_RATE", "TOTAL_IMPRESSIONS_CM360", "CLICKS_CM360", "VIEWABLE_ADS_IAS", "BRAND_SAFETY_ADS_IAS", "OUT_OF_GEO_ADS_IAS", "PAGE_VIEWS_IAS", "FRAUD_ADS_IAS", "TOTAL_NON_BILLABLE", "TOTAL_BILLABLE_IMPRESSIONS", "VIEWABLE_RATE_PCT", "DELIVERY_RATE", "PLANNED_SPEND", "ADJUSTED_SPEND", "BILLABLE_SPEND", "FINAL_BILLABLE_PAYMENT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-25T08:06:51.927142100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_dv360_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-25T08:06:51.927142200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_criteo_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-25T08:06:52.742505900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_ttd_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-25T08:06:52.947283+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-25T08:06:52.947295900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-25T08:06:53.448421700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-25T08:06:53.583112700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_bingads_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
