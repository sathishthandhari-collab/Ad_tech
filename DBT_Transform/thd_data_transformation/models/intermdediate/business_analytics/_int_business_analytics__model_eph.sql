select  cm360.date,
        cm360.campaign_id,
        cm360.campaign_name,
        cm360.site_name,
        cm360.placement_name,
        cm360.creative_concept,
        cm360.creative_type,
        cm360.clicks,
        cm360.total_impressions_cm360 as impressions,
        cm360.clicks_cm360 as clicks,
        cm360.total_conversions,
        cm360.revenue,
        cm360.media_cost,
        ias.impressions as IAS_impressions,
        ias.viewable_ads as IAS_viewable_ads,
        ias.brand_safety_ads as IAS_brand_safety_ads,
        ias.out_of_geo_ads as IAS_out_of_geo_ads,
        ias.page_views as IAS_page_views,
        ias.video_completions as IAS_video_completions,
        site.region,
        site.state,
        site.age_group,
        site.sex as gender,
        site.device_type
        from {{ ref('stg_cm360__view') }} as cm360
            left join {{ ref('stg_ias__view') }} as ias
                on cm360.placemnet_name = ias.placement_name
                    and cm360.date = ias.date
            left join {{ ref('stg_sites__data_unified') }} as site
                on cm360.placement_name = site.placement_name
                    and cm360.date = site.date

        group by 1,2,3,4,5,6,7
        order by date
        
    
        
