-- created_at: 2025-09-19T19:44:29.168923100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: list_relations_in_parallel
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."THD_ANALYTICS_PROD" LIMIT 10000;
-- created_at: 2025-09-19T19:44:29.519352300+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: list_relations_in_parallel
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."THD_BILLING_PROD" LIMIT 10000;
-- created_at: 2025-09-19T19:44:30.137826600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: list_relations_in_parallel
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."THD_SITE_SPENDS_PROD" LIMIT 10000;
-- created_at: 2025-09-19T19:44:37.064757600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: execute adapter call
show terse schemas in database adtech_analytics
    limit 10000
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev"} */;
-- created_at: 2025-09-19T19:44:38.245001200+00:00
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
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev"} */;
-- created_at: 2025-09-19T19:44:39.191555300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_sites__data_unified
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-19T19:44:39.461388200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_IAS__view
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-19T19:44:39.853778400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_IAS__view
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.stg_IAS__view
  
   as (
     select
        date::date              as date,
        publisher,
        campaign                as campaign_name,
        placement               as placement_name,
        ad_format               as creative_type,
        monitored_ads           as impressions,
        viewable_ads::int       as viewable_ads,
        brand_safety_ads::int   as brand_safety_ads,
        out_of_geo_ads::int     as out_of_geo_ads,
        views                   as page_views,
        video_completions
from adtech_analytics.staging.STG_ias_raw_data
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.stg_IAS__view"} */;
-- created_at: 2025-09-19T19:44:40.216298300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-19T19:44:40.607164800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-19T19:44:40.959020100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-19T19:44:41.100657200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_webmd_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-19T19:44:41.267934800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_INMOBI_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-19T19:44:41.605285100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-19T19:44:41.626859400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_webmd_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-19T19:44:41.933190700+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-19T19:44:41.936000100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_webmd_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-19T19:44:42.067712400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_youtube_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-19T19:44:42.247822400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_WEBMD_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-19T19:44:42.406461600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-19T19:44:42.445017500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_youtube_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-19T19:44:42.722922900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-19T19:44:43.048193300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_youtube_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-19T19:44:43.092761100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_ttd_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-19T19:44:43.100996700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_inmobi_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_inmobi_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_inmobi_spends"} */;
-- created_at: 2025-09-19T19:44:43.151365+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-19T19:44:43.403338800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_YOUTUBE_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-19T19:44:43.473338600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_ttd_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-19T19:44:43.710403400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-19T19:44:43.782782500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-19T19:44:43.789290+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_ttd_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-19T19:44:43.965518+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_avzu_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-19T19:44:44.052924300+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-19T19:44:44.101431200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_TTD_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-19T19:44:44.130932100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_webmd_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_webmd_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_webmd_spends"} */;
-- created_at: 2025-09-19T19:44:44.400433300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-19T19:44:44.411238700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_avzu_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-19T19:44:44.455409900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-19T19:44:44.656015100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_criteo_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-19T19:44:44.710186300+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-19T19:44:44.795957900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_avzu_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-19T19:44:44.982529800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_youtube_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_youtube_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_youtube_spends"} */;
-- created_at: 2025-09-19T19:44:45.268731900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_AVZU_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-19T19:44:45.281646300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_criteo_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-19T19:44:45.353234400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_toi_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-19T19:44:45.523675+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-19T19:44:45.593418300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-19T19:44:45.653041200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_criteo_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-19T19:44:45.769957400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_toi_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-19T19:44:45.897318700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_ttd_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_ttd_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_ttd_spends"} */;
-- created_at: 2025-09-19T19:44:45.933566400+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-19T19:44:46.050705700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_miq_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-19T19:44:46.090361300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_toi_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-19T19:44:46.182502+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_CRITEO_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-19T19:44:46.531386500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-19T19:44:46.756825400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_miq_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-19T19:44:46.803685400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_TOI_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-19T19:44:46.915889900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_CM360__view
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-19T19:44:46.932503+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-19T19:44:47.009538600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_avzu_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_avzu_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_avzu_spends"} */;
-- created_at: 2025-09-19T19:44:47.098049500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_miq_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-19T19:44:47.104273700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-19T19:44:47.326119400+00:00
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
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.stg_CM360__view"} */;
-- created_at: 2025-09-19T19:44:47.389790700+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-19T19:44:47.619952100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_MIQ_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-19T19:44:47.730696600+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-19T19:44:47.810913700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_dv360_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-19T19:44:47.944955+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-19T19:44:47.992064400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-19T19:44:48.200411800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-19T19:44:48.289721900+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-19T19:44:48.358550200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_dv360_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-19T19:44:48.497840500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_magnite_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-19T19:44:48.618862400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_toi_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_toi_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_toi_spends"} */;
-- created_at: 2025-09-19T19:44:48.693621400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_dv360_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-19T19:44:48.713566500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_criteo_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_criteo_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_criteo_spends"} */;
-- created_at: 2025-09-19T19:44:48.837485+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-19T19:44:49.019250300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_DV360_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-19T19:44:49.030559100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_magnite_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-19T19:44:49.363633300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-19T19:44:49.440075200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_miq_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_miq_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_miq_spends"} */;
-- created_at: 2025-09-19T19:44:49.455006800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-19T19:44:49.676082100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_magnite_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-19T19:44:49.755919500+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-19T19:44:50.015189100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_MAGNITE_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-19T19:44:50.293936400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-19T19:44:50.378747500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_amazon_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-19T19:44:50.666689700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-19T19:44:50.678788400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-19T19:44:50.786469100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_amazon_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-19T19:44:50.825858900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-19T19:44:50.982028100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_SHARETHROUGH_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-19T19:44:51.035059600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_dv360_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_dv360_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_dv360_spends"} */;
-- created_at: 2025-09-19T19:44:51.142610500+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-19T19:44:51.290939200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-19T19:44:51.354956300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_amazon_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-19T19:44:51.449911200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-19T19:44:51.596349900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-19T19:44:51.618026600+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-19T19:44:51.663214600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_AMAZON_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-19T19:44:51.958412800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_magnite_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_magnite_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_magnite_spends"} */;
-- created_at: 2025-09-19T19:44:52.095574800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-19T19:44:52.099307+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-19T19:44:52.363505600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-19T19:44:52.570244+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-19T19:44:52.729392300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-19T19:44:52.747350600+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-19T19:44:52.896596400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-19T19:44:52.923546300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_sharethrough_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_sharethrough_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_sharethrough_spends"} */;
-- created_at: 2025-09-19T19:44:53.017373600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-19T19:44:53.076424400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_PUBMATIC_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-19T19:44:53.210411+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-19T19:44:53.290360900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-19T19:44:53.466797800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-19T19:44:53.505544+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-19T19:44:53.661721900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_REMEZCLA_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-19T19:44:53.705934+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_amazon_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_amazon_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_amazon_spends"} */;
-- created_at: 2025-09-19T19:44:53.717450200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_site_spends_prod.monthly_bingads_spends__dbt_tmp
  
   as (
    


    
    
    
    
    
        
    



    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-19T19:44:53.830430500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-19T19:44:53.860327900+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-19T19:44:54.007873300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-19T19:44:54.302257700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_HINDHU_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-19T19:44:54.385270800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_bingads_spends__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-19T19:44:54.654668400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-19T19:44:54.760957600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_prisma__planned
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "ADTECH_ANALYTICS"."STAGING" LIMIT 10000;
-- created_at: 2025-09-19T19:44:54.763310300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
describe table adtech_analytics.thd_site_spends_prod.monthly_bingads_spends
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-19T19:44:54.901857400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-19T19:44:54.943311900+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-19T19:44:54.987316200+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-19T19:44:55.289192300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.stg_prisma__planned
-- desc: execute adapter call
create or replace transient table adtech_analytics.staging.stg_prisma__planned
         as
        (

select 
        date_trunc(month, day) AS month,
        CAMPAIGN_ID AS CM360_CAMPAIGN_ID,
        CAMPAIGN_NAME,
        SPLIT_PART(CAMPAIGN_NAME, '_', 4) AS CAMPAIGN_GROUP,
        SITE_NAME,
        PLACEMENT_NAME,
        CREATIVE_TYPE,
        sum(IMPRESSIONS * uniform(0.8632, 1.265, random()))::int as planned_impressions,
        round(uniform(7.00, 23.00, random()),2) as contracted_rate
from adtech_analytics.staging.stg_cm360_raw_data
group by 1,2,3,4,5,6,7
order by month
        )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.stg_prisma__planned"} */;
-- created_at: 2025-09-19T19:44:55.326162+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_SITE_SPENDS_PROD.MONTHLY_BINGADS_SPENDS
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-19T19:44:55.386483800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_pubmatic_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_pubmatic_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_pubmatic_spends"} */;
-- created_at: 2025-09-19T19:44:55.451096+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_AMAZON_RAW_DATA";
-- created_at: 2025-09-19T19:44:55.576529400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-19T19:44:55.698404+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-19T19:44:55.756646600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-19T19:44:56.279454600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_PUBMATIC_RAW_DATA";
-- created_at: 2025-09-19T19:44:56.533156200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_hindhu_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_hindhu_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_hindhu_spends"} */;
-- created_at: 2025-09-19T19:44:56.563145100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_BINGADS_RAW_DATA";
-- created_at: 2025-09-19T19:44:56.565973400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.int_pacing_and_billing__model
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.int_pacing_and_billing__model
  
   as (
    with cm360_monthly as (
    select 
        DATE_TRUNC('month', DATE) AS MONTH,
        CAMPAIGN_NAME,
        CAMPAIGN_GROUP,
        CAMPAIGN_ID,
        SITE_NAME,
        PLACEMENT_NAME,
        CREATIVE_CONCEPT,
        CREATIVE_TYPE,
        sum(TOTAL_IMPRESSIONS_CM360) AS TOTAL_IMPRESSIONS_CM360,
        sum(CLICKS_CM360) AS CLICKS_CM360
    from adtech_analytics.staging.stg_CM360__view
    group by 1,2,3,4,5,6,7,8
),

    IAS_MONTHLY AS (
        select 
            DATE_TRUNC('month', DATE) AS MONTH,
            CAMPAIGN_NAME,
            PLACEMENT_NAME,
            SUM(VIEWABLE_ADS) AS VIEWABLE_ADS_IAS,
            SUM(BRAND_SAFETY_ADS) AS BRAND_SAFETY_ADS_IAS,
            SUM(OUT_OF_GEO_ADS) AS OUT_OF_GEO_ADS_IAS,
            SUM(PAGE_VIEWS) AS PAGE_VIEWS_IAS,
            sum(IMPRESSIONS) - SUM(BRAND_SAFETY_ADS) AS FRAUD_ADS_IAS   --- JUST TO HAVE FRAUD ADS
        from adtech_analytics.staging.stg_IAS__view
        group by 1,2,3
)

SELECT 
    cm360.MONTH,
    cm360.CAMPAIGN_NAME,
    cm360.CAMPAIGN_GROUP,
    cm360.CAMPAIGN_ID,
    cm360.SITE_NAME,
    cm360.PLACEMENT_NAME,
    cm360.CREATIVE_CONCEPT,
    cm360.CREATIVE_TYPE,
    prisma.PLANNED_IMPRESSIONS,
    prisma.CONTRACTED_RATE,
    cm360.TOTAL_IMPRESSIONS_CM360,
    cm360.CLICKS_CM360,
    ias.VIEWABLE_ADS_IAS,
    ias.BRAND_SAFETY_ADS_IAS,
    ias.OUT_OF_GEO_ADS_IAS,
    ias.PAGE_VIEWS_IAS,
    IAS.FRAUD_ADS_IAS
FROM cm360_monthly AS cm360
    LEFT JOIN IAS_MONTHLY AS ias
        ON cm360.CAMPAIGN_NAME = ias.CAMPAIGN_NAME
            AND cm360.PLACEMENT_NAME = ias.PLACEMENT_NAME
            AND cm360.MONTH = ias.MONTH
    LEFT JOIN adtech_analytics.staging.stg_prisma__planned AS prisma
        ON cm360.CAMPAIGN_NAME = prisma.CAMPAIGN_NAME
            AND cm360.PLACEMENT_NAME = prisma.PLACEMENT_NAME
            AND cm360.MONTH = prisma.MONTH
WHERE cm360.CAMPAIGN_NAME IS NOT NULL
    AND cm360.PLACEMENT_NAME IS NOT NULL
    AND cm360.MONTH IS NOT NULL
ORDER BY cm360.MONTH
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.int_pacing_and_billing__model"} */;
-- created_at: 2025-09-19T19:44:56.566913900+00:00
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
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","SPEND_AMOUNT" = DBT_INTERNAL_SOURCE."SPEND_AMOUNT"
    

    when not matched then insert
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")
    values
        ("MONTH", "SITE_NAME", "PLACEMENT_NAME", "SPEND_AMOUNT")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-19T19:44:56.655072100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_remezcla_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_remezcla_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_remezcla_spends"} */;
-- created_at: 2025-09-19T19:44:56.778103800+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_TOI_RAW_DATA";
-- created_at: 2025-09-19T19:44:56.885958+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_AVZU_RAW_DATA";
-- created_at: 2025-09-19T19:44:57.183733+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-19T19:44:57.216675100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_MAGNITE_RAW_DATA";
-- created_at: 2025-09-19T19:44:57.448201500+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_SHARETHROUGH_RAW_DATA";
-- created_at: 2025-09-19T19:44:57.568838400+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_MIQ_RAW_DATA";
-- created_at: 2025-09-19T19:44:57.606149100+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_bingads_spends
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_site_spends_prod.monthly_bingads_spends__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_bingads_spends"} */;
-- created_at: 2025-09-19T19:44:57.796982900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_INMOBI_RAW_DATA";
-- created_at: 2025-09-19T19:44:57.918435900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_HINDHU_RAW_DATA";
-- created_at: 2025-09-19T19:44:58.132474200+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_TTD_RAW_DATA";
-- created_at: 2025-09-19T19:44:58.244500400+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_WEBMD_RAW_DATA";
-- created_at: 2025-09-19T19:44:58.361104800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_billing_prod.monthly__spends_and_pacing__dbt_tmp
  
   as (
    


with billable_and_nonbillable as (
    select
        *,
        (OUT_OF_GEO_ADS_IAS + FRAUD_ADS_IAS)      as total_non_billable,
        TOTAL_IMPRESSIONS_CM360
          - (OUT_OF_GEO_ADS_IAS + FRAUD_ADS_IAS) as total_billable_impressions,

        round(
            viewable_ads_ias * 100.0
            / nullif(TOTAL_IMPRESSIONS_CM360, 0),
            2
        )                                            as viewable_rate_pct,

        round(
            TOTAL_IMPRESSIONS_CM360
            / nullif(planned_impressions,0),
            2
        )                                            as delivery_rate,

        (contracted_rate * planned_impressions) as planned_spend,
        (contracted_rate * planned_impressions) * 1.1                      as adjusted_spend
    from adtech_analytics.staging.int_pacing_and_billing__model
   
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
                else case
                        when viewable_rate_pct >= 70
                            then total_billable_impressions * contracted_rate / 1000
                        else 0.70 * total_billable_impressions * contracted_rate / 1000
                     end
            end,
            2
        ) as final_billable_payment

    
    from billable_and_nonbillable

    where month >= date_trunc('month', current_date) - interval '1 month'


  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-19T19:44:58.484877200+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_YOUTUBE_RAW_DATA";
-- created_at: 2025-09-19T19:44:58.588672200+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_CRITEO_RAW_DATA";
-- created_at: 2025-09-19T19:44:58.809043100+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_REMEZCLA_RAW_DATA";
-- created_at: 2025-09-19T19:44:58.942415900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_DV360_RAW_DATA";
-- created_at: 2025-09-19T19:44:59.003764300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
describe table adtech_analytics.thd_billing_prod.monthly__spends_and_pacing__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-19T19:44:59.335717700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
describe table adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-19T19:44:59.652920900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_BILLING_PROD.MONTHLY__SPENDS_AND_PACING
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-19T19:44:59.674429600+00:00
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
                'STG_DV360_RAW_DATA' AS source_table
            FROM adtech_analytics.STAGING.STG_DV360_RAW_DATA
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
            
        
    
)

SELECT * FROM unified_site_data
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.stg_sites__data_unified"} */;
-- created_at: 2025-09-19T19:45:00.543996900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-19T19:45:00.885680900+00:00
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
-- created_at: 2025-09-19T19:45:00.905980400+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."THD_ANALYTICS_PROD"."DAILY_REPORT_UNIFIED";
-- created_at: 2025-09-19T19:45:01.044840600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.int_business_analytics__model_eph
-- desc: execute adapter call
create or replace   view adtech_analytics.staging.int_business_analytics__model_eph
  
   as (
    

with cte as (
    select  cm360.date,
        date_trunc('month', cm360.date)         as month,
        cm360.campaign_id,
        cm360.campaign_name,
        cm360.site_name,
        cm360.placement_name,
        cm360.creative_concept,
        cm360.creative_type,
        cm360.TOTAL_IMPRESSIONS_CM360           as impressions,
        cm360.clicks_cm360                      as clicks,
        ias.impressions                         as IAS_impressions,
        ias.viewable_ads                        as IAS_viewable_ads,
        ias.brand_safety_ads                    as IAS_brand_safety_ads,
        ias.out_of_geo_ads                      as IAS_out_of_geo_ads,
        ias.page_views                          as IAS_page_views,
        ias.video_completions                   as IAS_video_completions,
        site.state,
        site.region,
        site.sex,
        site.device_type
        from adtech_analytics.staging.stg_CM360__view       as cm360
            left join adtech_analytics.staging.stg_IAS__view as ias
                on cm360.placement_name = ias.placement_name
                    and cm360.date = ias.date
            left join adtech_analytics.staging.stg_sites__data_unified as site
                on cm360.placement_name = site.placement_name
                    and cm360.date = site.date)
select * from cte       
    order by date
        
    
        
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.int_business_analytics__model_eph"} */;
-- created_at: 2025-09-19T19:45:01.918640900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_analytics_prod.monthly_campaign__level_report__dbt_tmp
  
   as (
    

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

where month >= date_trunc('month', current_date) - interval '1 month'

order by month
  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
-- created_at: 2025-09-19T19:45:01.957202800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
create or replace  temporary view adtech_analytics.thd_analytics_prod.daily_report_unified__dbt_tmp
  
   as (
    

-- pull through everything from the parent
select *
from adtech_analytics.staging.int_business_analytics__model_eph


  -- optional: filter only new months if you have a reliable max(month)
  where date > (select max(month) from adtech_analytics.thd_analytics_prod.daily_report_unified)

  )
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-19T19:45:02.539312200+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-19T19:45:03.044726300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call
describe table adtech_analytics.thd_analytics_prod.monthly_campaign__level_report__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
-- created_at: 2025-09-19T19:45:03.046704300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
describe table adtech_analytics.thd_analytics_prod.daily_report_unified__dbt_tmp
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-19T19:45:03.110373500+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly__spends_and_pacing
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_billing_prod.monthly__spends_and_pacing__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly__spends_and_pacing"} */;
-- created_at: 2025-09-19T19:45:03.399773300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call
describe table adtech_analytics.thd_analytics_prod.monthly_campaign__level_report
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
-- created_at: 2025-09-19T19:45:03.404693300+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
describe table adtech_analytics.thd_analytics_prod.daily_report_unified
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-19T19:45:03.745401900+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_ANALYTICS_PROD.MONTHLY_CAMPAIGN__LEVEL_REPORT
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
-- created_at: 2025-09-19T19:45:03.996520700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
describe table ADTECH_ANALYTICS.THD_ANALYTICS_PROD.DAILY_REPORT_UNIFIED
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-19T19:45:04.135428+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
-- created_at: 2025-09-19T19:45:04.328826700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-19T19:45:04.503557600+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_analytics_prod.monthly_campaign__level_report as DBT_INTERNAL_DEST
        using adtech_analytics.thd_analytics_prod.monthly_campaign__level_report__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.month = DBT_INTERNAL_DEST.month
                ) and (
                    DBT_INTERNAL_SOURCE.campaign_id = DBT_INTERNAL_DEST.campaign_id
                ) and (
                    DBT_INTERNAL_SOURCE.site_name = DBT_INTERNAL_DEST.site_name
                ) and (
                    DBT_INTERNAL_SOURCE.creative_concept = DBT_INTERNAL_DEST.creative_concept
                )

    
    when matched then update set
        "MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","STATE" = DBT_INTERNAL_SOURCE."STATE","REGION" = DBT_INTERNAL_SOURCE."REGION","SEX" = DBT_INTERNAL_SOURCE."SEX","DEVICE_TYPE" = DBT_INTERNAL_SOURCE."DEVICE_TYPE","IMPRESSIONS" = DBT_INTERNAL_SOURCE."IMPRESSIONS","CLICKS" = DBT_INTERNAL_SOURCE."CLICKS","CTR" = DBT_INTERNAL_SOURCE."CTR","IAS_IMPRESSIONS" = DBT_INTERNAL_SOURCE."IAS_IMPRESSIONS","IAS_VIEWABLE_ADS" = DBT_INTERNAL_SOURCE."IAS_VIEWABLE_ADS","IAS_BRAND_SAFETY_ADS" = DBT_INTERNAL_SOURCE."IAS_BRAND_SAFETY_ADS","IAS_OUT_OF_GEO_ADS" = DBT_INTERNAL_SOURCE."IAS_OUT_OF_GEO_ADS","IAS_PAGE_VIEWS" = DBT_INTERNAL_SOURCE."IAS_PAGE_VIEWS","IAS_VIDEO_COMPLETIONS" = DBT_INTERNAL_SOURCE."IAS_VIDEO_COMPLETIONS"
    

    when not matched then insert
        ("MONTH", "CAMPAIGN_ID", "CAMPAIGN_NAME", "SITE_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "STATE", "REGION", "SEX", "DEVICE_TYPE", "IMPRESSIONS", "CLICKS", "CTR", "IAS_IMPRESSIONS", "IAS_VIEWABLE_ADS", "IAS_BRAND_SAFETY_ADS", "IAS_OUT_OF_GEO_ADS", "IAS_PAGE_VIEWS", "IAS_VIDEO_COMPLETIONS")
    values
        ("MONTH", "CAMPAIGN_ID", "CAMPAIGN_NAME", "SITE_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "STATE", "REGION", "SEX", "DEVICE_TYPE", "IMPRESSIONS", "CLICKS", "CTR", "IAS_IMPRESSIONS", "IAS_VIEWABLE_ADS", "IAS_BRAND_SAFETY_ADS", "IAS_OUT_OF_GEO_ADS", "IAS_PAGE_VIEWS", "IAS_VIDEO_COMPLETIONS")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
-- created_at: 2025-09-19T19:45:04.681682+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call

    
        
            
                
                
            
                
                
            
        
    

    

    merge into adtech_analytics.thd_analytics_prod.daily_report_unified as DBT_INTERNAL_DEST
        using adtech_analytics.thd_analytics_prod.daily_report_unified__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.date = DBT_INTERNAL_DEST.date
                ) and (
                    DBT_INTERNAL_SOURCE.placement_name = DBT_INTERNAL_DEST.placement_name
                )

    
    when matched then update set
        "DATE" = DBT_INTERNAL_SOURCE."DATE","MONTH" = DBT_INTERNAL_SOURCE."MONTH","CAMPAIGN_ID" = DBT_INTERNAL_SOURCE."CAMPAIGN_ID","CAMPAIGN_NAME" = DBT_INTERNAL_SOURCE."CAMPAIGN_NAME","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","PLACEMENT_NAME" = DBT_INTERNAL_SOURCE."PLACEMENT_NAME","CREATIVE_CONCEPT" = DBT_INTERNAL_SOURCE."CREATIVE_CONCEPT","CREATIVE_TYPE" = DBT_INTERNAL_SOURCE."CREATIVE_TYPE","IMPRESSIONS" = DBT_INTERNAL_SOURCE."IMPRESSIONS","CLICKS" = DBT_INTERNAL_SOURCE."CLICKS","IAS_IMPRESSIONS" = DBT_INTERNAL_SOURCE."IAS_IMPRESSIONS","IAS_VIEWABLE_ADS" = DBT_INTERNAL_SOURCE."IAS_VIEWABLE_ADS","IAS_BRAND_SAFETY_ADS" = DBT_INTERNAL_SOURCE."IAS_BRAND_SAFETY_ADS","IAS_OUT_OF_GEO_ADS" = DBT_INTERNAL_SOURCE."IAS_OUT_OF_GEO_ADS","IAS_PAGE_VIEWS" = DBT_INTERNAL_SOURCE."IAS_PAGE_VIEWS","IAS_VIDEO_COMPLETIONS" = DBT_INTERNAL_SOURCE."IAS_VIDEO_COMPLETIONS","STATE" = DBT_INTERNAL_SOURCE."STATE","REGION" = DBT_INTERNAL_SOURCE."REGION","SEX" = DBT_INTERNAL_SOURCE."SEX","DEVICE_TYPE" = DBT_INTERNAL_SOURCE."DEVICE_TYPE"
    

    when not matched then insert
        ("DATE", "MONTH", "CAMPAIGN_ID", "CAMPAIGN_NAME", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "IMPRESSIONS", "CLICKS", "IAS_IMPRESSIONS", "IAS_VIEWABLE_ADS", "IAS_BRAND_SAFETY_ADS", "IAS_OUT_OF_GEO_ADS", "IAS_PAGE_VIEWS", "IAS_VIDEO_COMPLETIONS", "STATE", "REGION", "SEX", "DEVICE_TYPE")
    values
        ("DATE", "MONTH", "CAMPAIGN_ID", "CAMPAIGN_NAME", "SITE_NAME", "PLACEMENT_NAME", "CREATIVE_CONCEPT", "CREATIVE_TYPE", "IMPRESSIONS", "CLICKS", "IAS_IMPRESSIONS", "IAS_VIEWABLE_ADS", "IAS_BRAND_SAFETY_ADS", "IAS_OUT_OF_GEO_ADS", "IAS_PAGE_VIEWS", "IAS_VIDEO_COMPLETIONS", "STATE", "REGION", "SEX", "DEVICE_TYPE")


/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-19T19:45:05.717424+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-19T19:45:06.162871700+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call

    commit
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
-- created_at: 2025-09-19T19:45:06.200105800+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.daily_report_unified
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_analytics_prod.daily_report_unified__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.daily_report_unified"} */;
-- created_at: 2025-09-19T19:45:06.734471400+00:00
-- dialect: snowflake
-- node_id: model.adtech_data_transformation.monthly_campaign__level_report
-- desc: execute adapter call
drop view if exists adtech_analytics.thd_analytics_prod.monthly_campaign__level_report__dbt_tmp cascade
/* {"app":"dbt","dbt_version":"2.0.0","profile_name":"adtech_data_transformation","target_name":"dev","node_id":"model.adtech_data_transformation.monthly_campaign__level_report"} */;
