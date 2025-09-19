import os
import re

# --------- CONFIGURE THESE VALUES ---------
DBT_PROJECT_DIR = r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\DBT_Transformation\adtech_data_transformation"
TARGET_FOLDER   = os.path.join(DBT_PROJECT_DIR, "models", "marts", "billing_and_pacing", "monthly_site_level_spend__details")
BASE_MODEL      = "monthly__spends_and_pacing"
# ------------------------------------------

sites = [
    'DV360','TTD','WebMD','Amazon','Youtube','PubMatic','Magnite',
    'InMobi','Criteo','Sharethrough','BingAds','MIQ','Hindhu','TOI','remezcla','AVZU'
]

os.makedirs(TARGET_FOLDER, exist_ok=True)

template = """
select *
from {{{{ ref('{base}') }}}}
where site_name = '{site}'
"""

for site in sites:
    safe = re.sub(r"[^0-9a-zA-Z_]+", "_", site.lower())
    filename = os.path.join(TARGET_FOLDER, f"monthly_{safe}__spends.sql")
    with open(filename, "w", encoding="utf-8") as f:
        f.write(template.format(base=BASE_MODEL, site=site))
    print(f"Created model: {filename}")

print("✅ Done! Now run: dbt run --select marts.billing_and_pacing.site_level_spend_details")
