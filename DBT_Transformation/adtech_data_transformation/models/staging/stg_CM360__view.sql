{{ config(materialized='incremental',
         unique_key=['date', 'placement_name'],
         incremental_strategy='delete+insert',
         on_schema_change='append_new_columns',
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
    {{ extract_campaign_attribute('placement_name', -3) }} as creative_concept
from {{ source('cm360', 'cm360_raw_data') }}
where day >= current_date - 90

{% if target.name == 'dev' %}
    LIMIT {{ var('dev_sample_size') }}
{% endif %}
