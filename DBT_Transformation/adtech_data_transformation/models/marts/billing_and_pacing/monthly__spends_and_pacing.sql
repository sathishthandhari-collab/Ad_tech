WITH monthly_spends AS (
  SELECT
    month,
    campaign_id,
    campaign_name,
    site_name,
    placement_name,
    creative_concept,
    creative_type,
    cm360_delivered_impressions,
    cm360_clicks,
    ias_out_of_geo_ads,
    ias_viewable_ads,
    fraud_ads,
    ias_out_of_geo_ads + fraud_ads,
    cm360_delivered_impressions - (ias_out_of_geo_ads + fraud_ads) AS billable_impressions,
    ROUND(
          ias_viewable_ads * 100.0 
        / 
          NULLIF(cm360_delivered_impressions, 0),
      2) AS viewable_rate_pct,

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
