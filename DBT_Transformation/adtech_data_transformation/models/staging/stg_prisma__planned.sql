{{ config(materialized='view') }}

select
    date_trunc(month, day) as month,
    campaign_id as cm360_campaign_id,
    campaign_name,
    {{extract_campaign_attribute('campaign_name', 4) }} as campaign_group,
    site_name,
    placement_name,
    creative_type
from {{ source('cm360', 'stg_cm360_raw_data') }}
where day >= current_date - 90
group by 1, 2, 3, 4, 5, 6, 7
