-- created_at: 2025-09-19T07:34:25.862667400+00:00
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
-- created_at: 2025-09-19T07:34:27.657038800+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_INMOBI_RAW_DATA";
-- created_at: 2025-09-19T07:34:27.972104700+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_HINDHU_RAW_DATA";
-- created_at: 2025-09-19T07:34:28.555901+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_AVZU_RAW_DATA";
-- created_at: 2025-09-19T07:34:28.616352800+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_SHARETHROUGH_RAW_DATA";
-- created_at: 2025-09-19T07:34:28.872403300+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_PUBMATIC_RAW_DATA";
-- created_at: 2025-09-19T07:34:28.947803500+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_MIQ_RAW_DATA";
-- created_at: 2025-09-19T07:34:29.198543900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_REMEZCLA_RAW_DATA";
-- created_at: 2025-09-19T07:34:29.269718900+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_YOUTUBE_RAW_DATA";
-- created_at: 2025-09-19T07:34:29.608756600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_TTD_RAW_DATA";
-- created_at: 2025-09-19T07:34:29.660558300+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_AMAZON_RAW_DATA";
-- created_at: 2025-09-19T07:34:29.867787700+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_BINGADS_RAW_DATA";
-- created_at: 2025-09-19T07:34:29.985207600+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_WEBMD_RAW_DATA";
-- created_at: 2025-09-19T07:34:30.065861500+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_MAGNITE_RAW_DATA";
-- created_at: 2025-09-19T07:34:30.191180700+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_DV360_RAW_DATA";
-- created_at: 2025-09-19T07:34:30.280821700+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_TOI_RAW_DATA";
-- created_at: 2025-09-19T07:34:30.387283700+00:00
-- dialect: snowflake
-- node_id: not available
-- desc: Get table schema
SHOW COLUMNS IN TABLE "ADTECH_ANALYTICS"."STAGING"."STG_CRITEO_RAW_DATA";
