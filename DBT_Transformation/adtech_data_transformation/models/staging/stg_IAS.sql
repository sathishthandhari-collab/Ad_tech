{{ config(materialized='view',
          schema='staging') }}
select
    date::date as date,
    publisher,
    campaign as campaign_name,
    placement as placement_name,
    ad_format as creative_type,
    monitored_ads as impressions,
    viewable_ads::int as viewable_ads,
    brand_safety_ads::int as brand_safety_ads,
    out_of_geo_ads::int as out_of_geo_ads,
    views as page_views,
    video_completions,
    current_timestamp::timestamp_ntz as dbt_loaded_at
from {{ source('ias', 'ias_raw_data' ) }}

{% if target.name == 'dev' %}
    LIMIT {{ var('dev_sample_size') }}
{% endif %}
