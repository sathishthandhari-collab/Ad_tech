import os
import snowflake.connector
from datetime import datetime, timezone

# -----------------------------
# Config
# -----------------------------
FOLDER_PATH = r"S:\Adtech_data2\snowpile"
FAILED_FOLDER = os.path.join(FOLDER_PATH, "failed")

# Create failed folder if it doesn't exist
if not os.path.exists(FAILED_FOLDER):
    os.makedirs(FAILED_FOLDER)

WAREHOUSE = "projects"
DATABASE = "adtech_analytics_dev"
SCHEMA = "raw"

STAGE_MAP = {
    "AMAZON": "amazon_stage",
    "AVZU": "avzu_stage",
    "BINGADS": "bingads_stage",
    "CM360": "cm360_stage",
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
    log_query = """
        INSERT INTO raw.file_upload_log (file_name, pipe_name, status, uploaded_at)
        VALUES (%s, %s, %s, CURRENT_TIMESTAMP)
    """
    try:
        cursor.execute(log_query, (file_name, stage_name, status))
    except Exception as log_error:
        print(f"[ERROR] Failed to log: {log_error}")

def add_ingested_at_column(file_path):
    # Detect and process only CSV files (modify for other formats as needed)
    if file_path.lower().endswith('.csv'):
        temp_file_path = file_path + ".tmp"
        with open(file_path, 'r', encoding='utf-8') as infile, open(temp_file_path, 'w', encoding='utf-8') as outfile:
            now_str = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
            header = infile.readline().strip()
            outfile.write(header + ",_Ingested_at\n")
            for line in infile:
                outfile.write(line.strip() + f",{now_str}\n")
        os.replace(temp_file_path, file_path)
    # For other file types, you can add logic accordingly

def upload_files_to_snowpipe():
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
                    print(f"[INFO] Processing {file}: Adding _Ingested_at column")
                    add_ingested_at_column(file_path)

                    print(f"[INFO] Uploading {file} -> @{stage_name}")
                    normalized_path = file_path.replace('\\', '/')
                    put_query = f"PUT 'file://{normalized_path}' @{stage_name} AUTO_COMPRESS=TRUE"
                    cursor.execute(put_query)

                    os.remove(file_path)
                    print(f"[INFO] Successfully uploaded and deleted {file}")
                    log_to_snowflake(cursor, file, stage_name, "SUCCESS")

                except Exception as e:
                    print(f"[ERROR] Failed uploading {file} -> @{stage_name}: {e}")
                    log_to_snowflake(cursor, file, stage_name, f"FAILED: {str(e)}")
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
