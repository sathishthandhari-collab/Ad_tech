with __dbt__cte__int_business_analytics__model_eph as (
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

    
    



select placement_name
from __dbt__cte__int_business_analytics__model_eph
where placement_name is null



--EPHEMERAL-SELECT-WRAPPER-END
)