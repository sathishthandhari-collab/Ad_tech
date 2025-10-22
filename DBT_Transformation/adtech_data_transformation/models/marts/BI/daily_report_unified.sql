{{
  config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key=['day', 'placement_name'],
    schema='thd_analytics_prod'
  )
}}

with base as (
  select *,
    impressions * contracted_rate / 1000 as media_cost
  from {{ ref('int_business_analytics__metrics_model') }}

  {% if is_incremental() %}
      -- optional: filter only new months if you have a reliable max(month)
      where day > (select max(day) from {{ this }})
  {% endif %}
),

performance_metrics as (
  select
    *,
    ias_video_completions / nullif(impressions,0) as video_completion_rate,
    media_cost / ias_video_completions as CPCV,
    clicks / nullif(impressions,0) as CTR,
    media_cost / nullif(clicks,0) as CPC,
    sum(impressions) over(partition by region)/ nullif(sum(impressions) over(),0) as region_impression_share

  from base
),

running_agg as (
  select
    *,
    avg(ctr) over(
      partition by placement_name 
      order by month 
      range between interval '3' month preceding and current row
    ) as ctr_3month_avg,
    
    avg(video_completion_rate) over(
      partition by placement_name 
      order by day 
      range between interval '90' day preceding and current row
    ) as vcr_3month_avg,
    
    avg(cpc) over(
      partition by placement_name 
      order by day 
      range between interval '90' day preceding and current row
    ) as cpc_3month_avg,
    
    avg(cpcv) over(
      partition by placement_name 
      order by day 
      range between interval '90' day preceding and current row
    ) as cpcv_3month_avg

  from performance_metrics
)


select * from running_agg
order by day