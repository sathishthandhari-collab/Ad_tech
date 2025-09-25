{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['month', 'placement_name'],
    schema='thd_site_spends_prod'
) }}
select * from {{ ref('monthly__spends_and_pacing') }}
where
    site_name = 'DV360'

    {% if is_incremental() %}
        and month >= date_trunc('month', current_date) - interval '1 month'
        {% endif %}