with source as (
    select
        day as date,
        campaign_name,
        campaign_id,
        site_name,
        placement_name,
        creative_type,
        impressions as total_impressions_cm360,
        clicks as clicks_cm360,
        SPLIT_PART(campaign_name, '_', 4) as campaign_group,
        SPLIT_PART(placement_name, '_', -3) as creative_concept
    from {{ source('cm360', 'stg_cm360_raw_data') }}
),
deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY date, campaign_id, site_name, placement_name, creative_type
            ORDER BY date
        ) as rn
    FROM source
)

select * from deduplicated
where rn =1
