
  
    

create or replace transient table adtech_analytics.thd_analytics_prod.monthly_campaign__level_report
    
    
    
    as (

with  __dbt__cte__int_business_analytics__model_eph as (
with cte as (
    select
        cm360.date,
        cm360.campaign_id,
        cm360.campaign_name,
        cm360.site_name,
        cm360.placement_name,
        cm360.creative_concept,
        cm360.creative_type,
        cm360.total_impressions_cm360 as impressions,
        cm360.clicks_cm360 as clicks,
        ias.impressions as ias_impressions,
        ias.viewable_ads as ias_viewable_ads,
        ias.brand_safety_ads as ias_brand_safety_ads,
        ias.out_of_geo_ads as ias_out_of_geo_ads,
        ias.page_views as ias_page_views,
        ias.video_completions as ias_video_completions,
        site.state,
        site.region,
        site.sex,
        site.device_type,
        date_trunc('month', cm360.date) as month
    from adtech_analytics.staging.stg_CM360__view as cm360
    left join adtech_analytics.staging.stg_IAS__view as ias
        on
            cm360.placement_name = ias.placement_name
            and cm360.date = ias.date
    left join adtech_analytics.staging.stg_sites__data_unified as site
        on
            cm360.placement_name = site.placement_name
            and cm360.date = site.date
)

select * from cte
order by date
), base as (
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
    )
;


  