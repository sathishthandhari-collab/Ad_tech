{{ config(materialized='view') }}

select
    day as date,
    campaign_name,
    campaign_id,
    site_name,
    placement_name,
    creative_type,
    impressions as total_impressions_cm360,
    clicks as clicks_cm360,
    {{extract_campaign_attribute('campaign_name', 4) }} as campaign_group,
    {{ extract_campaign_attribute('placement_name', -3) }} as creative_concept
from {{ source('cm360', 'stg_cm360_raw_data') }}
where day >= current_date - 90
