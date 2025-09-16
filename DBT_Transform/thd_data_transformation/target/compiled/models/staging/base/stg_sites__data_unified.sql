

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