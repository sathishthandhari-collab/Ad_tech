# AdTech Data Transformation - dbt Project

## Overview

This dbt project, **adtech_data_transformation**, is a comprehensive data pipeline designed for digital advertising analytics and billing operations. It transforms raw advertising data from multiple sources into actionable business intelligence reports and billing calculations.

## Project Structure

The project follows dbt's best practices with a modular approach:

```
adtech_data_transformation/
├── models/
│   ├── staging/          # Raw data cleaning and standardization
│   ├── intermediate/     # Business logic transformations  
│   └── marts/           # Final analytics and reporting tables
├── macros/              # Reusable SQL functions
└── dbt_project.yml      # Project configuration
```

## Data Sources

The pipeline integrates data from multiple advertising platforms and measurement systems:

### Primary Data Sources
- **CM360 (Campaign Manager 360)**: Core campaign performance data including impressions, clicks, and campaign metadata
- **IAS (Integral Ad Science)**: Viewability and brand safety metrics
- **Prisma**: Planning and pacing data for campaign delivery tracking
- **Site-Level Data**: Unified publisher performance data with demographic breakdowns

## Model Architecture

### Staging Layer (`staging/`)
Raw data is cleaned and standardized from source systems:

- **`stg_CM360__view.sql`**: Standardizes Campaign Manager 360 data with campaign attribution logic
- **`stg_IAS__view.sql`**: Processes viewability and brand safety metrics from IAS
- **`stg_prisma__planned.sql`**: Extracts planned campaign data and budgets
- **`stg_sites__data_unified.sql`**: Dynamically discovers and unifies publisher site data across multiple raw tables

### Intermediate Layer (`intermediate/`)
Business logic is applied to create reusable data models:

- **`int_business_analytics__metrics_model_view.sql`**: Combines CM360, IAS, and site data for daily analytics
- **`int_pacing_and_billing__model.sql`**: Calculates delivery pacing, viewability adjustments, and billing metrics

### Marts Layer (`marts/`)
Final business-ready tables for reporting and operations:

#### Business Intelligence (`marts/BI/`)
- **`daily_report_unified.sql`**: Comprehensive daily performance report with all key metrics
- **`monthly_campaign__level_report.sql`**: Monthly aggregated campaign performance with demographic breakdowns

#### Billing & Pacing (`marts/billing_and_pacing/`)
- **`monthly__spends_and_pacing.sql`**: Monthly billing calculations with viewability and delivery adjustments
- **`monthly_site_level_spend__details.sql`**: Detailed site-level spend tracking for publisher payments

## Key Features

### Dynamic Data Discovery
The `stg_sites__data_unified.sql` model automatically discovers and processes new publisher data tables, making the pipeline self-adapting to new data sources.

### Campaign Attribution
Custom macros extract campaign attributes and creative concepts from naming conventions for enhanced reporting granularity.

### Fraud & Quality Filtering
Integrated brand safety, viewability, and geographic filtering ensures billing accuracy and campaign quality.

### Incremental Processing
Daily and monthly models use incremental strategies with merge operations for efficient processing of large datasets.

## Data Quality & Testing

The project includes comprehensive data quality checks:

- **Uniqueness Tests**: Ensures no duplicate records in key reporting tables
- **Range Validations**: Validates metric ranges (e.g., viewability rates 0-100%)
- **Null Checks**: Enforces required fields across all models
- **Referential Integrity**: Maintains consistency across joined datasets

## Deployment Configuration

### Materialization Strategy
- **Staging Models**: Materialized as views for flexibility
- **Intermediate Models**: Ephemeral for performance optimization
- **Marts Models**: Tables and incremental tables for production use

### Schema Organization
- `thd_analytics_prod`: Business intelligence reports
- `thd_billing_prod`: Billing and pacing data
- `thd_site_spends_prod`: Publisher-specific spend tracking
- `int_models_eph`: Intermediate processing models

## Getting Started

### Prerequisites
- dbt Core 1.0+
- Access to source data warehouses (Snowflake/BigQuery)
- Appropriate database permissions for schema creation

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd adtech_data_transformation

# Install dependencies
dbt deps

# Configure profiles.yml with your database connection
```

### Running the Pipeline
```bash
# Test connection
dbt debug

# Run data quality tests
dbt test

# Build all models
dbt run

# Generate documentation
dbt docs generate
dbt docs serve
```

## Usage Examples

### Daily Campaign Performance
```sql
SELECT 
    date,
    campaign_name,
    impressions,
    clicks,
    ias_viewable_ads,
    ctr
FROM thd_analytics_prod.daily_report_unified
WHERE date >= '2024-01-01'
ORDER BY date DESC;
```

### Monthly Billing Summary
```sql
SELECT 
    month,
    placement_name,
    billable_spend,
    viewable_rate_pct,
    delivery_rate
FROM thd_billing_prod.monthly__spends_and_pacing
WHERE month = '2024-01-01';
```

## Monitoring & Maintenance

### Key Metrics to Monitor
- **Data Freshness**: Ensure daily models update within SLA
- **Data Quality**: Monitor test failures and null rates
- **Billing Accuracy**: Validate spend calculations against source systems
- **Performance**: Track model run times and optimize as needed

### Regular Maintenance Tasks
- Review and update campaign attribution logic
- Add new data sources to unified staging models
- Optimize incremental model performance
- Update data quality tests for new business rules

## Contributing

When adding new models or modifying existing ones:

1. Follow dbt naming conventions (`stg_`, `int_`, `fct_`, `dim_`)
2. Add appropriate materialization configurations
3. Include data quality tests in schema.yml files
4. Document model purpose and business logic
5. Test changes in development environment before merging

## Support

For questions or issues:
- Review model documentation: `dbt docs serve`
- Check data lineage for upstream dependencies
- Validate source data quality in staging models
- Contact the data engineering team for pipeline issues