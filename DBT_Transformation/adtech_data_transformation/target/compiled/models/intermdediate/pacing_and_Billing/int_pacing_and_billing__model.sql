 select  
    cm360.date,
    cm360.campaign_id,
    cm360.campaign_name,
    cm360.site_name,
    cm360.placement_name,
    cm360.creative_concept,
    cm360.creative_type,
    cm360.total_impressions_cm360 as CM360_Delivered_Impressions,
    cm360.clicks_cm360 as CM360_clicks,
    prisma.planned_impressions,
    prisma.contracted_rate as contracted_cpm,
    prisma.contracted_rate * prisma.planned_impressions/1000 as planned_spend
from 
    adtech_analytics.staging.stg_CM360__view as cm360
    join adtech_analytics.staging.stg_prisma__planned  as prisma
        on cm360.placement_name = prisma.placement_name
            and cm360.date = prisma.date 
group by 1,2,3,4,5,6,7,8,9,10,11,12
order by date

        