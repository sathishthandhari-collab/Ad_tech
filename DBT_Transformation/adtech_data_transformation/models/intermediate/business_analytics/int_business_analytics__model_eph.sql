

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
        from {{ ref('stg_CM360__view') }}       as cm360
            join {{ ref('stg_IAS__view') }} as ias
                on cm360.placement_name = ias.placement_name
                    and cm360.date = ias.date
            join {{ ref('stg_sites__data_unified') }} as site
                on cm360.placement_name = site.placement_name
                    and cm360.date = site.date)
select * from cte       
    order by date
        
    
        
