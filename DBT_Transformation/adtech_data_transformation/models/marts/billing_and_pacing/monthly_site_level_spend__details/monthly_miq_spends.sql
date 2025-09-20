{{ config(
    materialized='incremental',
    unique_key=['month', 'placement_name']
) }}
select * from {{ ref('monthly__spends_and_pacing') }} 
where site_name = 'MIQ'

    
    {% if is_incremental() %}
    and month >= date_trunc('month', current_date) - interval '1 month'
    {% endif %}
