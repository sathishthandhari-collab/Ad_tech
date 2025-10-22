{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['month', 'placement_name'],
    schema='thd_billing_prod'
) }}
with base as (
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
        avg(ctr) as ctr,
        avf(video_completion_rate) as vcr,
        avg(cpc) as cpc,
        avg(cpcv) as cpcv,
        avg(ctr_3month_avg) as ctr_3month_avg,
        avg(vcr_3month_avg) as vcr_3month_avg,
        avg(cpc_3month_avg) as cpc_3month_avg,
        avg(cpcv_3month_avg) as cpcv_3month_avg

    from {{ ref('int_business_analytics__metrics_model') }}
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)

select * from base
order by month
