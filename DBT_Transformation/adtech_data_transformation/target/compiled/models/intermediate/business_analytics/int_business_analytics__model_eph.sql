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
        
    
        