WITH monthly_spends AS (
  SELECT
    month,
    campaign_id,
    campaign_name,
    site_name,
    placement_name,
    creative_concept,
    creative_type,
    SUM(cm360_delivered_impressions) AS cm360_delivered_impressions,
    SUM(cm360_clicks)                AS cm360_clicks,
    SUM(ias_out_of_geo_ads)          AS ias_out_of_geo_ads,
    SUM(ias_viewable_ads)            AS ias_viewable_ads,
    SUM(fraud_ads)                   AS fraud_ads,
    SUM(ias_out_of_geo_ads) + SUM(fraud_ads) AS unbillable_ads,
    SUM(cm360_delivered_impressions) - (SUM(ias_out_of_geo_ads) + SUM(fraud_ads)) AS billable_ads,

    -- Use fraction 0–1 for logic; expose percent for reporting if needed
    SUM(ias_viewable_ads) / NULLIF(SUM(cm360_delivered_impressions), 0) AS viewable_rate_frac,
    ROUND(
      SUM(ias_viewable_ads) * 100.0 / NULLIF(SUM(cm360_delivered_impressions), 0),
      2
    ) AS viewable_rate_pct,

    ROUND(
      SUM(cm360_delivered_impressions) / NULLIF(SUM(planned_impressions), 0),
      2
    ) AS delivery_rate,

    SUM(planned_impressions) AS planned_impressions,

    -- Effective CPM from spend & impressions (USD per 1000 imps)
    SUM(planned_spend) / NULLIF(SUM(planned_impressions), 0) * 1000 AS contracted_cpm,

    SUM(planned_spend)       AS planned_spend,
    SUM(planned_spend) * 1.1 AS adjusted_spend
  FROM {{ ref('int_pacing_and_billing__model') }}
  GROUP BY 1,2,3,4,5,6,7
)

SELECT
  m.*,
  ROUND(
    CASE
      WHEN m.viewable_rate_frac >= 0.70
        THEN m.billable_ads * m.contracted_cpm / 1000
      ELSE 0.70 * m.billable_ads * m.contracted_cpm / 1000
    END,
    2
  ) AS billable_spend,
  ROUND(
    CASE
      WHEN m.delivery_rate >= 1.10
        THEN m.adjusted_spend
      ELSE
        CASE
          WHEN m.viewable_rate_frac >= 0.70
            THEN m.billable_ads * m.contracted_cpm / 1000
          ELSE 0.70 * m.billable_ads * m.contracted_cpm / 1000
        END
    END,
    2
  ) AS final_billable_payment
FROM monthly_spends m
ORDER BY m.month, m.campaign_id, m.placement_name;
