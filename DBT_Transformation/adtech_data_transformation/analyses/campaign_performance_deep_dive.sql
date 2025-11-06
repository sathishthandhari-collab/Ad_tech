with campaign_performance as (
    select
        campaign_name,
        campaign_group,
        site_name,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks,
        sum(viewable_impressions) as total_viewable,
        round(avg(ctr), 4) as avg_ctr,
        sum(impressions * 0.001 * 15) as estimated_spend -- Assuming $15 CPM
    from {{ ref('mart_monthly_campaign__level_report') }}
    group by 1, 2, 3
),

performance_benchmarks as (
    select
        percentile_cont(0.25) within group (order by avg_ctr) as ctr_p25,
        percentile_cont(0.50) within group (order by avg_ctr) as ctr_p50,
        percentile_cont(0.75) within group (order by avg_ctr) as ctr_p75
    from campaign_performance
)

select
    cp.campaign_name,
    cp.campaign_group,
    cp.site_name,
    cp.total_impressions,
    cp.total_clicks,
    cp.avg_ctr,
    cp.estimated_spend,
    round(cp.total_viewable::float / cp.total_impressions * 100, 2)
        as viewability_rate,
    case
        when cp.avg_ctr >= pb.ctr_p75 then 'High Performer'
        when cp.avg_ctr >= pb.ctr_p50 then 'Average Performer'
        when cp.avg_ctr >= pb.ctr_p25 then 'Below Average'
        else 'Poor Performer'
    end as performance_tier,
    case
        when
            cp.avg_ctr < pb.ctr_p25 and cp.estimated_spend > 50000
            then 'INVESTIGATE'
        when
            cp.total_viewable::float / cp.total_impressions < 0.50
            then 'VIEWABILITY_ISSUE'
        else 'OK'
    end as action_required

from campaign_performance as cp
cross join performance_benchmarks as pb
order by cp.estimated_spend desc;
