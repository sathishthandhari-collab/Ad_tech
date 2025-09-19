{{ 
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = ['date', 'placement_name']
  ) 
}}

-- pull through everything from the parent
select *
from {{ ref('int_business_analytics__model_eph') }}

{% if is_incremental() %}
  -- optional: filter only new months if you have a reliable max(month)
  where date > (select max(month) from {{ this }})
{% endif %}
