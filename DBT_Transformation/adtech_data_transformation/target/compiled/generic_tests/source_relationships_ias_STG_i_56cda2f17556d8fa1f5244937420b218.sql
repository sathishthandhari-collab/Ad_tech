
    
    

with child as (
    select placement as from_field
    from adtech_analytics.staging.STG_ias_raw_data
    where placement is not null
),

parent as (
    select placement_name as to_field
    from adtech_analytics.staging.stg_cm360_raw_data
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


