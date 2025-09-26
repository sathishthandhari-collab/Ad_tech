import os
import snowflake.connector
from datetime import datetime

# -----------------------------
# Config
# -----------------------------
FOLDER_PATH = r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\load\Snow_pipe"
FAILED_FOLDER = os.path.join(FOLDER_PATH, "failed")

# Create failed folder if it doesn't exist
if not os.path.exists(FAILED_FOLDER):
    os.makedirs(FAILED_FOLDER)

WAREHOUSE = "projects"
DATABASE = "adtech_analytics"
SCHEMA = "staging"

# TODO: Update these stage names based on your ACTUAL pipe configurations
# Run "DESC PIPE adtech_analytics.staging.CM360_PIPE;" to find the correct stage
STAGE_MAP = {
    "AMAZON": "amazon_stage",      # Replace with actual stage name
    "AVZU": "avzu_stage",
    "BINGADS": "bingads_stage",
    "CM360": "cm360_stage",        # Replace with actual stage name
    "CRITEO": "criteo_stage",
    "DV360": "dv360_stage",
    "HINDHU": "hindhu_stage",
    "INMOBI": "inmobi_stage",
    "MAGNITE": "magnite_stage",
    "MIQ": "miq_stage",
    "PUBMATIC": "pubmatic_stage",
    "REMEZCLA": "remezcla_stage",
    "SHARETHROUGH": "sharethrough_stage",
    "TOI": "toi_stage",
    "TTD": "ttd_stage",
    "WEBMD": "webmd_stage",
    "YOUTUBE": "youtube_stage",
    "IAS": "ias_stage"
}

def log_to_snowflake(cursor, file_name, stage_name, status):
    """Insert log entry into Snowflake control table."""
    # Use the column name that EXISTS in your table
    log_query = """
        INSERT INTO staging.file_upload_log (file_name, pipe_name, status, uploaded_at)
        VALUES (%s, %s, %s, CURRENT_TIMESTAMP)
    """
    try:
        cursor.execute(log_query, (file_name, stage_name, status))
    except Exception as log_error:
        print(f"[ERROR] Failed to log: {log_error}")

def upload_files_to_snowpipe():
    """Check folder for files, upload to correct stage, log in Snowflake, delete after success."""
    conn = snowflake.connector.connect(
        connection_name='dev',
        warehouse=WAREHOUSE,
        database=DATABASE,
        schema=SCHEMA
    )
    cursor = conn.cursor()

    try:
        for file in os.listdir(FOLDER_PATH):
            file_path = os.path.join(FOLDER_PATH, file)
            if not os.path.isfile(file_path):
                continue

            first_word = file.split("_")[0].upper()
            if first_word in STAGE_MAP:
                stage_name = STAGE_MAP[first_word]

                try:
                    print(f"[INFO] Uploading {file} -> @{stage_name}")

                    # Convert Windows path to forward slashes for Snowflake
                    normalized_path = file_path.replace('\\', '/')

                    # PUT to named stage (no quotes needed)
                    put_query = f"PUT 'file://{normalized_path}' @{stage_name} AUTO_COMPRESS=TRUE"
                    cursor.execute(put_query)

                    # Remove file only after successful upload
                    os.remove(file_path)
                    print(f"[INFO] Successfully uploaded and deleted {file}")

                    # Log success
                    log_to_snowflake(cursor, file, stage_name, "SUCCESS")

                except Exception as e:
                    print(f"[ERROR] Failed uploading {file} -> @{stage_name}: {e}")

                    # Log failure (but don't let logging errors crash the main process)
                    log_to_snowflake(cursor, file, stage_name, f"FAILED: {str(e)}")

                    # Move failed file to failed folder
                    try:
                        failed_file_path = os.path.join(FAILED_FOLDER, file)
                        os.rename(file_path, failed_file_path)
                        print(f"[INFO] Moved failed file to: {failed_file_path}")
                    except Exception as move_error:
                        print(f"[ERROR] Could not move failed file: {move_error}")

            else:
                print(f"[WARN] No matching stage for {file}, skipping")
                log_to_snowflake(cursor, file, None, "NO_MATCH")

    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    upload_files_to_snowpipe()
