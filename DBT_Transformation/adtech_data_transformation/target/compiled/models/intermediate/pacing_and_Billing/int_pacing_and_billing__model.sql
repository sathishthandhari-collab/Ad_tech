 with cm360_monthly as(
    select
        date_trunc('month', date)           as month,
        campaign_id,
        campaign_name,
        site_name,
        placement_name,
        creative_concept,
        creative_type,
        sum(total_impressions_cm360)         as CM360_Delivered_Impressions,
        sum(clicks_cm360)                    as CM360_clicks
        from adtech_analytics.staging.stg_CM360__view 
            group by 1,2,3,4,5,6,7
        ),

  ias_monthly as(
    select
        date_trunc('month', date)           as month,
        campaign_name,
        publisher                            as site_name,
        placement_name,
        creative_type,
        sum(out_of_geo_ads)                  as IAS_out_of_geo_ads,
        sum(viewable_ads)                    as IAS_viewable_ads,
        sum(brand_safety_ads)                as IAS_brand_safety_ads
    from adtech_analytics.staging.stg_IAS__view
        group by 1,2,3,4,5
        ),
cte as (select
    cm360.*,
    ias.ias_out_of_geo_ads,
    ias.ias_viewable_ads,
    ias.ias_brand_safety_ads,
    prisma.planned_impressions,
    prisma.contracted_rate                  as contracted_cpm,
    prisma.planned_impressions * prisma.contracted_rate / 1000 as planned_spend,
    cm360.CM360_Delivered_Impressions - ias.ias_brand_safety_ads as fraud_ads
    
from cm360_monthly                          as cm360
left join ias_monthly                         as ias
        on cm360.month = ias.month
        and cm360.campaign_name = ias.campaign_name
        and cm360.placement_name = ias.placement_name
left join adtech_analytics.staging.stg_prisma__planned as prisma
        on cm360.month = prisma.month
        and cm360.campaign_name = prisma.campaign_name
        and cm360.placement_name = prisma.placement_name
)
select * from cte
order by month



        