{{ config(materialized='view',
          schema='staging') }}

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
    {{ extract_campaign_attribute('placement_name', -3) }} as creative_concept,
    current_timestamp::timestamp_ntz as dbt_loaded_at
from {{ source('cm360', 'cm360_raw_data') }}
{% if is_incremental() %}
    WHERE _loaded_at > (SELECT MAX(ingestion_loaded_at) FROM {{ this }})
{% endif %}

{% if target.name == 'dev' %}
    LIMIT {{ var('dev_sample_size') }}
{% endif %}
