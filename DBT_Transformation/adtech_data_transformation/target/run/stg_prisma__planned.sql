
  
    

        create or replace transient table adtech_analytics.staging.stg_prisma__planned
         as
        (

select 
        date_trunc(month, day) AS month,
        CAMPAIGN_ID AS CM360_CAMPAIGN_ID,
        CAMPAIGN_NAME,
        SPLIT_PART(CAMPAIGN_NAME, '_', 4) AS CAMPAIGN_GROUP,
        SITE_NAME,
        PLACEMENT_NAME,
        CREATIVE_TYPE,
        sum(IMPRESSIONS * uniform(0.8632, 1.265, random()))::int as planned_impressions,
        round(uniform(7.00, 23.00, random()),2) as contracted_rate
from adtech_analytics.staging.stg_cm360_raw_data
group by 1,2,3,4,5,6,7
order by month
        );
      
  