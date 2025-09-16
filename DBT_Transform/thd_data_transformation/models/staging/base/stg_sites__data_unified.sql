{{ config(materialized='view', static_analysis='unsafe') }}

WITH unified_site_data AS (

    {% set site_tables = dbt_utils.get_relations_by_pattern(
        schema_pattern='STAGING',
        table_pattern='%_RAW_%'
    ) %}

    {% for table in site_tables %}
        {% set tbl_name = table.identifier | lower %}
        {% if 'cm360' not in tbl_name and 'ias' not in tbl_name %}

        SELECT
            date::date AS date,
            campaign,
            campaignId AS cm360_campaign_id,
            publisher,
            placement,
            ad_format AS creative_type,
            imp AS impressions,
            clk AS clicks,
            views AS pageviews,
            state,
            region,
            age_group,
            sex,
            device_type,
            video_completions,
            '{{ table.identifier }}' AS source_table
        FROM {{ table }}

        {% if not loop.last %} UNION ALL {% endif %}

        {% endif %}
    {% endfor %}
)

SELECT * FROM unified_site_data
