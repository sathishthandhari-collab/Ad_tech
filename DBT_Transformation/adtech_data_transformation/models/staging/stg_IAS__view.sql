{{ config(materialized='incremental',
         unique_key=['date', 'placement_name'],
         incremental_strategy='delete+insert',
         on_schema_change='append_new_columns',
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
    video_completions
from {{ source('ias', 'ias_raw_data' ) }}
where date >= current_date - 90


{% if target.name == 'dev' %}
    LIMIT {{ var('dev_sample_size') }}
{% endif %}