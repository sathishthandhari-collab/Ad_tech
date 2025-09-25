

select
    date_trunc(month, day) as month,
    campaign_id as cm360_campaign_id,
    campaign_name,
    split_part(campaign_name, '_', 4) as campaign_group,
    site_name,
    placement_name,
    creative_type,
    sum(impressions * uniform(0.8632, 1.265, random()))::int
        as planned_impressions,
    round(uniform(7.00, 23.00, random()), 2) as contracted_rate
from adtech_analytics.staging.stg_cm360_raw_data
group by 1, 2, 3, 4, 5, 6, 7
order by month