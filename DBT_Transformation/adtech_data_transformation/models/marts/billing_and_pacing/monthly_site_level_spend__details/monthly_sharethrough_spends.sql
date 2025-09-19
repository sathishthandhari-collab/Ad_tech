{{ config(
    materialized='incremental',
    unique_key=['month', 'placement_name']
) }}

{% if execute %}
    {% set source_relation = adapter.get_relation(
        database='adtech_analytics',
        schema='THD_site_spends_prod',
        identifier='monthly__spends_and_pacing'
    ) %}
    
    {% set source_exists = source_relation is not none %}
    
    {% if source_exists %}
        {% set row_count_query %}
            select count(*) as row_count 
            from {{ ref('monthly__spends_and_pacing') }} 
            where site_name = 'Sharethrough'
        {% endset %}
        
        {% set results = run_query(row_count_query) %}
        {% set row_count = results.columns[0].values()[0] %}
        {% set has_data = row_count > 0 %}
    {% else %}
        {% set has_data = false %}
    {% endif %}
{% else %}
    {% set source_exists = false %}
    {% set has_data = false %}
{% endif %}

{% if source_exists and has_data %}
    select * 
    from {{ ref('monthly__spends_and_pacing') }} 
    where site_name = 'Sharethrough'
    
    {% if is_incremental() %}
    and month >= date_trunc('month', current_date) - interval '1 month'
    {% endif %}
{% else %}
    select 
        cast(null as date) as month,
        cast(null as varchar) as site_name,
        cast(null as varchar) as placement_name,
        cast(null as decimal) as spend_amount
    where false
{% endif %}
