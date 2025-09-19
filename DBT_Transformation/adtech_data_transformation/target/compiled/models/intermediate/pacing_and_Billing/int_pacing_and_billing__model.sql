with cm360_monthly as (
    select 
        DATE_TRUNC('month', DATE) AS MONTH,
        CAMPAIGN_NAME,
        CAMPAIGN_GROUP,
        CAMPAIGN_ID,
        SITE_NAME,
        PLACEMENT_NAME,
        CREATIVE_CONCEPT,
        CREATIVE_TYPE,
        sum(TOTAL_IMPRESSIONS_CM360) AS TOTAL_IMPRESSIONS_CM360,
        sum(CLICKS_CM360) AS CLICKS_CM360
    from adtech_analytics.staging.stg_CM360__view
    group by 1,2,3,4,5,6,7,8
),

    IAS_MONTHLY AS (
        select 
            DATE_TRUNC('month', DATE) AS MONTH,
            CAMPAIGN_NAME,
            PLACEMENT_NAME,
            SUM(VIEWABLE_ADS) AS VIEWABLE_ADS_IAS,
            SUM(BRAND_SAFETY_ADS) AS BRAND_SAFETY_ADS_IAS,
            SUM(OUT_OF_GEO_ADS) AS OUT_OF_GEO_ADS_IAS,
            SUM(PAGE_VIEWS) AS PAGE_VIEWS_IAS,
            sum(IMPRESSIONS) - SUM(BRAND_SAFETY_ADS) AS FRAUD_ADS_IAS   --- JUST TO HAVE FRAUD ADS
        from adtech_analytics.staging.stg_IAS__view
        group by 1,2,3
)

SELECT 
    cm360.MONTH,
    cm360.CAMPAIGN_NAME,
    cm360.CAMPAIGN_GROUP,
    cm360.CAMPAIGN_ID,
    cm360.SITE_NAME,
    cm360.PLACEMENT_NAME,
    cm360.CREATIVE_CONCEPT,
    cm360.CREATIVE_TYPE,
    prisma.PLANNED_IMPRESSIONS,
    prisma.CONTRACTED_RATE,
    cm360.TOTAL_IMPRESSIONS_CM360,
    cm360.CLICKS_CM360,
    ias.VIEWABLE_ADS_IAS,
    ias.BRAND_SAFETY_ADS_IAS,
    ias.OUT_OF_GEO_ADS_IAS,
    ias.PAGE_VIEWS_IAS,
    IAS.FRAUD_ADS_IAS
FROM cm360_monthly AS cm360
    LEFT JOIN IAS_MONTHLY AS ias
        ON cm360.CAMPAIGN_NAME = ias.CAMPAIGN_NAME
            AND cm360.PLACEMENT_NAME = ias.PLACEMENT_NAME
            AND cm360.MONTH = ias.MONTH
    LEFT JOIN adtech_analytics.staging.stg_prisma__planned AS prisma
        ON cm360.CAMPAIGN_NAME = prisma.CAMPAIGN_NAME
            AND cm360.PLACEMENT_NAME = prisma.PLACEMENT_NAME
            AND cm360.MONTH = prisma.MONTH
WHERE cm360.CAMPAIGN_NAME IS NOT NULL
    AND cm360.PLACEMENT_NAME IS NOT NULL
    AND cm360.MONTH IS NOT NULL
ORDER BY cm360.MONTH