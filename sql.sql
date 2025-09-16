-- Create a project-specific database
CREATE DATABASE IF NOT EXISTS ADTECH_ANALYTICS;

-- Create schema for staging layer
CREATE SCHEMA IF NOT EXISTS ADTECH_ANALYTICS.STAGING;

--  create a file format for stage

CREATE OR REPLACE FILE FORMAT adtech_csv_gz_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null', '');

  --  create a stage

  CREATE OR REPLACE STAGE adtech_stage
  FILE_FORMAT = adtech_csv_gz_format;

  -- Create staging tables

  -- CM360

-- Load CSV


-- Upload a file first (UI or PUT command)
PUT file://"C:\Users\Sathish\Downloads\avazu-ctr-prediction\test.gz" @adtech_stage AUTO_COMPRESS=False;

-- Load into Snowflake
COPY INTO STAGING.stg_avazu_raw
FROM @adtech_stage/test.gz
FILE_FORMAT = (FORMAT_NAME = adtech_csv_gz_format);


