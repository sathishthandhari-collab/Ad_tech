{{config(
    materialized='incremental',
    on_schema_change='append_new_columns',
    incremental_strategy='delete+insert',
    unique_key=['date', 'placement_name'],
    schema='staging'
)}}

WITH source_data AS (

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'AMAZON_RAW_DATA' AS source_table
    FROM {{ source('sites', 'AMAZON_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'AVZU_RAW_DATA' AS source_table
    FROM {{ source('sites', 'AVZU_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'BINGADS_RAW_DATA' AS source_table
    FROM {{ source('sites', 'BINGADS_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'CRITEO_RAW_DATA' AS source_table
    FROM {{ source('sites', 'CRITEO_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'DV360_RAW_DATA' AS source_table
    FROM {{ source('sites', 'DV360_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'HINDHU_RAW_DATA' AS source_table
    FROM {{ source('sites', 'HINDHU_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'INMOBI_RAW_DATA' AS source_table
    FROM {{ source('sites', 'INMOBI_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'MAGNITE_RAW_DATA' AS source_table
    FROM {{ source('sites', 'MAGNITE_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'MIQ_RAW_DATA' AS source_table
    FROM {{ source('sites', 'MIQ_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'PUBMATIC_RAW_DATA' AS source_table
    FROM {{ source('sites', 'PUBMATIC_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'REMEZCLA_RAW_DATA' AS source_table
    FROM {{ source('sites', 'REMEZCLA_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'SHARETHROUGH_RAW_DATA' AS source_table
    FROM {{ source('sites', 'SHARETHROUGH_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'TOI_RAW_DATA' AS source_table
    FROM {{ source('sites', 'TOI_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'TTD_RAW_DATA' AS source_table
    FROM {{ source('sites', 'TTD_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'WEBMD_RAW_DATA' AS source_table
    FROM {{ source('sites', 'WEBMD_RAW_DATA') }}

    UNION ALL

    SELECT
        date::date AS date,
        campaign,
        campaignId AS cm360_campaign_id,
        publisher,
        placement AS placement_name,
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
        'YOUTUBE_RAW_DATA' AS source_table
    FROM {{ source('sites', 'YOUTUBE_RAW_DATA') }}

)

SELECT * FROM source_data

{% if is_incremental() %}
    WHERE (date, placement_name) NOT IN (
        SELECT date, placement_name FROM {{ this }}
    )
{% endif %}
