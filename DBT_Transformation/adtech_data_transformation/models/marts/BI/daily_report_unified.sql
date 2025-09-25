{{ 
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['date', 'placement_name'],
    schema='thd_analytics_prod'
  ) 
}}

select *
from {{ ref('int_business_analytics__model_eph') }}

{% if is_incremental() %}
    -- optional: filter only new months if you have a reliable max(month)
    where date > (select max(date) from {{ this }})
{% endif %}