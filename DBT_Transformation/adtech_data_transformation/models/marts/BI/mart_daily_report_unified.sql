{{
  config(
    materialized='incremental',
    on_schema_change='append_new_columns',
    incremental_strategy='delete+insert',
    unique_key=['day', 'placement_name'],
    schema='thd_analytics_prod'
  )
}}

with base as (
    select
        b.*,
        b.impressions * b.contracted_rate / 1000 as media_cost
    from {{ ref('int_business_analytics__metrics_model') }} as b

    {% if is_incremental() %}
        where b.day > (select max(day) from {{ this }})
    {% endif %}
),

performance_metrics as (
    select
        *,
        ias_video_completions
        / nullif(impressions, 0)::float as video_completion_rate,
        media_cost / nullif(ias_video_completions, 0) as cpcv,
        clicks / nullif(impressions, 0)::float as ctr,
        media_cost / nullif(clicks, 0) as cpc,
        sum(impressions) over (partition by region)
        / nullif(sum(impressions) over (), 0)::float as region_impression_share

    from base
),

running_agg as (
    select
        *,
        avg(ctr) over (
            partition by placement_name
            order by day
            rows between 89 preceding and current row
        ) as ctr_3month_avg,

        avg(video_completion_rate) over (
            partition by placement_name
            order by day
            rows between 89 preceding and current row
        ) as vcr_3month_avg,

        avg(cpc) over (
            partition by placement_name
            order by day
            rows between 89 preceding and current row
        ) as cpc_3month_avg,

        avg(cpcv) over (
            partition by placement_name
            order by day
            rows between 89 preceding and current row
        ) as cpcv_3month_avg

    from performance_metrics
)

select * from running_agg
order by day
