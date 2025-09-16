import os
import logging
import snowflake.connector
import toml
import shutil
from datetime import datetime
from pathlib import Path

# ---------------- CONFIG ----------------
LOCAL_FOLDER = Path(r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\DATA\to_cm360_stage")
TOML_PATH = Path(r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\.venv\connections.toml")
PROFILE_NAME = "dev"  # section under [connections]
STAGE_NAME = "adtech_analytics.staging.CM360_stage"
# -----------------------------------------

# Setup logging
log_file = Path(__file__).with_name("upload_log.log")
logging.basicConfig(
    filename=str(log_file),
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# Success statuses from Snowflake PUT we treat as success
SUCCESS_STATUSES = {"UPLOADED", "OVERWRITTEN"}

# fallback folder (created if removal fails)
FALLBACK_FOLDER = LOCAL_FOLDER / "uploaded"
FALLBACK_FOLDER.mkdir(parents=True, exist_ok=True)

def detect_statuses_from_rows(rows, description):
    """
    Return list of statuses (uppercased strings) extracted from result rows.
    Tries to find a 'status' column via description; if not available, scans row values.
    """
    statuses = []
    # try to find status column index from description
    if description:
        col_names = [col[0].lower() for col in description]  # description -> list of tuples
        # common name is 'status'
        if "status" in col_names:
            idx = col_names.index("status")
            for r in rows:
                statuses.append(str(r[idx]).upper())
            return statuses

    # fallback: scan each row for a known status substring
    for r in rows:
        found = False
        for cell in r:
            if cell is None:
                continue
            cell_str = str(cell).upper()
            for s in ("UPLOADED", "OVERWRITTEN", "SKIPPED", "FAILED"):
                if s in cell_str:
                    statuses.append(s)
                    found = True
                    break
            if found:
                break
        if not found:
            statuses.append("UNKNOWN")
    return statuses

def upload_files():
    logging.info("=== Starting file upload ===")
    conn = None
    try:
        config = toml.load(str(TOML_PATH))
        profile = config["connections"][PROFILE_NAME]

        conn = snowflake.connector.connect(
            user=profile["user"],
            password=profile["password"],
            account=profile["account"],
            warehouse=("projects"),
            database=("adtech_analytics"),
            schema=("staging")
        )

        cursor = conn.cursor()

        for file in os.listdir(LOCAL_FOLDER):
            file_path = LOCAL_FOLDER / file
            if not file_path.is_file():
                continue

            put_cmd = f"PUT file://{file_path} @{STAGE_NAME} AUTO_COMPRESS=TRUE OVERWRITE=FALSE"
            try:
                cursor.execute(put_cmd)
                rows = cursor.fetchall()            # result rows
                desc = cursor.description          # column metadata (may be None)
                logging.info(f"PUT cmd: {put_cmd}")
                logging.info(f"PUT result rows for {file}: {rows}")
                # detect statuses
                statuses = detect_statuses_from_rows(rows, desc)
                logging.info(f"Parsed statuses for {file}: {statuses}")

                # Consider overall success only if every returned row is a success
                if statuses and all(s in SUCCESS_STATUSES for s in statuses):
                    # attempt to remove file
                    try:
                        os.remove(file_path)
                        logging.info(f"Deleted local file: {file_path}")
                        print(f"✅ Uploaded & deleted {file}")
                    except Exception as e_remove:
                        # fallback: move to uploaded folder (avoid losing file)
                        try:
                            target = FALLBACK_FOLDER / file
                            shutil.move(str(file_path), str(target))
                            logging.warning(f"Could not delete {file_path} ({e_remove}); moved to {target}")
                            print(f"⚠️ Uploaded but couldn't delete — moved {file} -> uploaded folder")
                        except Exception as e_move:
                            logging.error(f"Failed to delete or move {file_path}: {e_move}")
                            print(f"❌ Uploaded but failed to delete/move {file}: {e_move}")
                else:
                    logging.warning(f"Not deleting {file} since statuses={statuses}")
                    print(f"⚠️ Not deleted {file} (upload statuses: {statuses})")

            except Exception as e:
                logging.error(f"Failed to upload {file}: {str(e)}")
                print(f"❌ Failed {file}: {str(e)}")

        cursor.close()
        logging.info("=== Upload finished ===")

    except Exception as e:
        logging.error(f"Connection/Upload failed: {str(e)}")
        print("❌ Snowflake connection failed:", str(e))

    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    upload_files()
