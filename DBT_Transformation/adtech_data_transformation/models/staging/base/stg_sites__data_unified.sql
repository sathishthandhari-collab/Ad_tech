{{ config(materialized='view', static_analysis='unsafe') }}

WITH unified_site_data AS (
    {% if execute %}
        {% set site_tables = dbt_utils.get_relations_by_pattern(
            schema_pattern='STAGING',
            table_pattern='%_RAW_%'
        ) %}
        
        {% set valid_tables = [] %}
        {% for table in site_tables %}
            {% set tbl_name = table.identifier | lower %}
            {% if 'cm360' not in tbl_name and 'ias' not in tbl_name %}
                {% if adapter.get_relation(database=table.database, schema=table.schema, identifier=table.identifier) is not none %}
                    {% do valid_tables.append(table) %}
                {% endif %}
            {% endif %}
        {% endfor %}
    {% else %}
        {% set valid_tables = [] %}
    {% endif %}

    {% if valid_tables|length > 0 %}
        {% for table in valid_tables %}
            SELECT
                date::date AS date,
                campaign,
                campaignId AS cm360_campaign_id,
                publisher,
                placement as placement_name,
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
        {% endfor %}
    {% else %}
        -- Fallback empty result with correct schema
        SELECT
            CAST(NULL AS DATE) AS date,
            CAST(NULL AS VARCHAR) AS campaign,
            CAST(NULL AS VARCHAR) AS cm360_campaign_id,
            CAST(NULL AS VARCHAR) AS publisher,
            CAST(NULL AS VARCHAR) AS placement_name,
            CAST(NULL AS VARCHAR) AS creative_type,
            CAST(NULL AS INTEGER) AS impressions,
            CAST(NULL AS INTEGER) AS clicks,
            CAST(NULL AS INTEGER) AS pageviews,
            CAST(NULL AS VARCHAR) AS state,
            CAST(NULL AS VARCHAR) AS region,
            CAST(NULL AS VARCHAR) AS age_group,
            CAST(NULL AS VARCHAR) AS sex,
            CAST(NULL AS VARCHAR) AS device_type,
            CAST(NULL AS INTEGER) AS video_completions,
            CAST(NULL AS VARCHAR) AS source_table
        WHERE FALSE  -- Ensures empty result set
    {% endif %}
)

SELECT * FROM unified_site_data
