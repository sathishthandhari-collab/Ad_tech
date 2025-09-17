import os
import random
import string
import pandas as pd
import datetime
import numpy as np

# -----------------------------
# Config (tweak as needed)
# -----------------------------
STATES = ["Telangana", "Maharashtra", "Tamil Nadu"]
TIER1_CITIES = {
    "Telangana": ["Hyderabad"],
    "Maharashtra": ["Mumbai", "Pune"],
    "Tamil Nadu": ["Chennai"]
}
AGE_GROUPS = ["18-24", "25-34", "35-44", "45-54", "55+"]
SEXES = ["Male", "Female"]
DEVICE_TYPES = ["Mobile", "Desktop", "Tablet"]

DEFAULT_SITES = [
    'DV360','TTD','WebMD','Amazon','Youtube','PubMatic','Magnite',
    'InMobi','Criteo','Sharethrough','BingAds','MIQ','Hindhu','TOI','remezcla','AVZU'
]

ADVERTISERS = ["THD"]
MARKET = "IND"

CONCEPTS = [
    "DiwaliOffer", "LoanFest", "Dussera", "Ugadi", "Christmas", "Ramadan",
    "Indipendence Day", "Republic day", "ShoppingFest", "NewYearSale", "SummerDeal", "Winter"
]

CREATIVE_TYPES = ["Display", "Instream Video", "Instream Audio", "Tracking"]
CREATIVE_SIZES = ["300x250", "728x90", "160x600", "300x600", "320x50"]
CREATIVE_DURATIONS = ["06s", "15s", "30s", "45s"]

# main generation ranges (large to create many rows)
PLACEMENTS_PER_CAMPAIGN_MIN = 350
PLACEMENTS_PER_CAMPAIGN_MAX = 1256

IMP_MIN = 5000
IMP_MAX = 150000

# -----------------------------
# Helpers
# -----------------------------
def rand_id(length=8):
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))

def sample_creatives_for_concept(concept, creative_type):
    """
    Return a list of creative names for given concept & creative_type.
    Format: <Concept>_<CreativeName>_<size_or_duration>
    Generate between 6-20 creatives for each concept+type combination.
    """
    count = random.randint(6, 20)
    creatives = []
    for i in range(1, count + 1):
        creative_base = f"{concept}_CR{i:02d}"
        if creative_type == "Display":
            size = random.choice(CREATIVE_SIZES)
            name = f"{concept}_{creative_base}_{size}"
        elif creative_type in ("Instream Video", "Instream Audio"):
            dur = random.choice(CREATIVE_DURATIONS)
            name = f"{concept}_{creative_base}_{dur}"
        else:
            name = f"{concept}_{creative_base}_TAG"
        creatives.append(name)
    return creatives

# Pre-generate creatives dictionary: concept -> creative_type -> list
CREATIVES = {}
for concept in CONCEPTS:
    CREATIVES[concept] = {}
    for ctype in CREATIVE_TYPES:
        CREATIVES[concept][ctype] = sample_creatives_for_concept(concept, ctype)

# -----------------------------
# Weekly CM360 Reports
# -----------------------------
def generate_weekly_cm360_reports(output_folder="cm360_reports",
                                  start_date=datetime.date(2025, 1, 1),
                                  end_date=datetime.date(2025, 12, 31),
                                  num_campaigns=510,
                                  market=MARKET,
                                  sites=DEFAULT_SITES):
    os.makedirs(output_folder, exist_ok=True)

    week_start = start_date
    while week_start <= end_date:
        file_date = week_start.strftime("%Y-%m-%d")
        output_file = os.path.join(output_folder, f"CM360_weekly_report_{file_date}.csv")

        rows = []
        for c in range(num_campaigns):
            campaign_id = random.randint(30000000, 39999999)
            advertiser = random.choice(ADVERTISERS)

            # --- restrict concepts by date ---
            month = week_start.month
            day = week_start.day
            valid_concepts = []
            for concept in CONCEPTS:
                if concept == "DiwaliOffer" and month == 10:
                    valid_concepts.append(concept)
                elif concept == "Dussera" and month in [9, 10]:
                    valid_concepts.append(concept)
                elif concept == "Indipendence Day" and ((month == 7 and day >= 25) or (month == 8 and day <= 6)):
                    valid_concepts.append(concept)
                elif concept == "SummerDeal" and month in [3, 4, 5, 6]:
                    valid_concepts.append(concept)
                elif concept == "Winter" and month in [11, 12]:
                    valid_concepts.append(concept)
                elif concept == "Ugadi" and month == 4:
                    valid_concepts.append(concept)
                elif concept == "Christmas" and month == 12:
                    valid_concepts.append(concept)
                elif concept == "Ramadan" and month == 3:
                    valid_concepts.append(concept)
                elif concept == "Republic day" and (month == 1 and day == 26):
                    valid_concepts.append(concept)
                elif concept == "NewYearSale" and (month == 1 and 1 <= day <= 7):
                    valid_concepts.append(concept)
                elif concept in ["ShoppingFest", "LoanFest"]:
                    valid_concepts.append(concept)

            if not valid_concepts:
                continue

            concept = random.choice(valid_concepts)
            campaign_name = f"2025_{market}_{advertiser}_{concept}_digital"

            # choose subset of campaign sites (2 to all)
            campaign_sites = random.sample(sites, random.randint(2, len(sites)))
            placements_per_campaign = random.randint(PLACEMENTS_PER_CAMPAIGN_MIN, PLACEMENTS_PER_CAMPAIGN_MAX)

            # To support optional packages per site, precompute packages_map per campaign-site
            # packages_map: { site: [pkg_id1, pkg_id2, ...] } where count is 0..10
            packages_map = {}
            for s in campaign_sites:
                pkg_count = random.randint(0, 10)  # site can have 0 to 10 packages
                if pkg_count == 0:
                    packages_map[s] = []  # empty -> we'll use NOPKG token per placement
                else:
                    # create pkg_count package ids (8 chars)
                    packages_map[s] = [rand_id(8) for _ in range(pkg_count)]

            # Build placements
            # We'll assign placements sequentially into packages when they exist (bucketing 1-10 placements per package)
            # For assignment we maintain per-site package counters
            pkg_assign_counters = {s: {"pkg_idx": 0, "used_in_current_pkg": 0} for s in campaign_sites}

            for p in range(placements_per_campaign):
                site = random.choice(campaign_sites)
                creative_type = random.choice(CREATIVE_TYPES)
                size_or_duration = random.choice(CREATIVE_DURATIONS if "Video" in creative_type or "Audio" in creative_type else CREATIVE_SIZES)

                # pick creative name from concept+creative_type
                creative_name = random.choice(CREATIVES[concept][creative_type])

                # decide package id for this placement
                pkg_list = packages_map.get(site, [])
                if not pkg_list:
                    package_random_id = "NOPKG" + rand_id(3)  # length 8-ish token for no-package
                else:
                    # choose current package for site
                    info = pkg_assign_counters[site]
                    current_pkg_idx = info["pkg_idx"]
                    package_random_id = pkg_list[current_pkg_idx]
                    # increment used count and roll to next package when used hits a random 1-10 limit
                    info["used_in_current_pkg"] += 1
                    # set a cap for placements in this package between 1 and 10
                    cap = random.randint(1, 10)
                    if info["used_in_current_pkg"] >= cap:
                        # move to next package index (wrap if at end)
                        info["pkg_idx"] = (info["pkg_idx"] + 1) % len(pkg_list)
                        info["used_in_current_pkg"] = 0

                placement_randid = rand_id(8)
                # placement name per requested schema:
                # Placement_{advertiser}_{market}_{campaign concept}_{site}_{package_randomID}_{creative_type}_{creative concept[:3]}_randomid_{creative name}
                placement_name = (
                    f"Placement_{advertiser}_{market}_{concept}_{site}_{package_random_id}_"
                    f"{creative_type}_{concept[:3]}_{placement_randid}_{creative_name}"
                )

                # Also create package name format if needed (not written as separate file here)
                # Package name format requested:
                # Placement_pkg_randomID_{advertiser}_{market}_{campaign concept}_{site}_{creative_type}_{creative concept[:3]}__{creative name}
                # (Note double underscore before creative name as requested)
                # This can be derived when needed.

                day_val = week_start + datetime.timedelta(days=random.randint(0, 6))
                impressions = random.randint(IMP_MIN, IMP_MAX)
                clicks = random.randint(100, max(100, impressions // 30))
                pageviews = random.randint(clicks, clicks * 3)

                rows.append([
                    day_val, campaign_name, campaign_id, site, placement_name,
                    creative_type, impressions, clicks, pageviews
                ])

        # Create DataFrame and write CSV (no creative_name or concept columns)
        df = pd.DataFrame(rows, columns=[
            "day", "campaign_name", "campaign_id", "site_name", "placement_name",
            "creative_type", "impressions", "clicks", "pageviews"
        ])
        df.to_csv(output_file, index=False)
        print(f"✅ CM360 weekly report generated: {output_file}")

        week_start += datetime.timedelta(days=7)

# -----------------------------
# Generate Site Reports + IAS Reports from CM360
# -----------------------------
def generate_all_site_and_ias_reports_from_cm360(cm360_folder="cm360_reports",
                                                 site_folder="site_reports",
                                                 ias_folder="ias_reports",
                                                 sites=DEFAULT_SITES):
    os.makedirs(site_folder, exist_ok=True)
    os.makedirs(ias_folder, exist_ok=True)

    cm360_files = sorted([f for f in os.listdir(cm360_folder) if f.endswith(".csv")])
    for cm360_file in cm360_files:
        cm360_path = os.path.join(cm360_folder, cm360_file)
        df = pd.read_csv(cm360_path, parse_dates=['day'])

        # For each site produce site CSV + IAS CSV
        for site_name in sites:
            site_df = df[df['site_name'] == site_name].copy()
            if site_df.empty:
                continue

            # rename columns for site reporting
            column_map = {
                "day": "date", "campaign_name": "campaign", "campaign_id": "campaignId",
                "site_name": "publisher", "placement_name": "placement", "creative_type": "ad_format",
                "impressions": "imp", "clicks": "clk", "pageviews": "views"
            }
            site_df = site_df.rename(columns=column_map)

            # demographics & device enrichment
            n = len(site_df)
            site_df["state"] = [random.choice(STATES) if random.random() > 0.1 else None for _ in range(n)]
            site_df["region"] = [random.choice(TIER1_CITIES[state]) if state and state in TIER1_CITIES else None for state in site_df["state"]]
            site_df["age_group"] = [random.choice(AGE_GROUPS) if random.random() > 0.05 else None for _ in range(n)]
            site_df["sex"] = [random.choice(SEXES) if random.random() > 0.05 else None for _ in range(n)]
            site_df["device_type"] = [random.choice(DEVICE_TYPES) if random.random() > 0.1 else None for _ in range(n)]

            # Add video_completions where ad_format contains Instream Video
            def compute_video_completions(imp, ad_fmt):
                try:
                    imp_int = int(imp)
                except Exception:
                    imp_int = 0
                if "Instream Video" in str(ad_fmt):
                    low = int(0.3 * imp_int)
                    high = max(imp_int, low)
                    return random.randint(low, high) if high >= low and high > 0 else 0
                else:
                    return 0

            site_df["video_completions"] = site_df.apply(
                lambda row: compute_video_completions(row.get("imp", 0), row.get("ad_format", "")),
                axis=1
            )

            # Small random variation applied to imp/clk/views to simulate publisher reporting differences
            # Use numpy arrays to avoid alignment/indexing issues and avoid calling int() on NaN
            for metric in ['imp', 'clk', 'views']:
                arr = site_df[metric].fillna(0).astype(float).to_numpy()
                variation_pct = np.random.uniform(-0.1, 0.1, size=arr.shape)
                new_arr = (arr * (1.0 + variation_pct)).astype(np.int64)  # elementwise int conversion
                # Ensure non-negative
                new_arr = np.maximum(0, new_arr)
                site_df[metric] = new_arr

            # Output site CSV (still no creative_name or concept columns)
            output_file = os.path.join(site_folder, cm360_file.replace("CM360", site_name))
            site_df.to_csv(output_file, index=False)
            print(f"✅ Site report generated: {output_file}")

            # Now generate IAS report for this site from site_df
            # Fields required: monitored_ads, brand_safety_ads, out_of_geo_ads, viewable_ads
            # Monitored ads = CM360 impressions * (1 ± random 1%-12%)
            ias_rows = []
            for idx, row in site_df.iterrows():
                base_imp = int(row.get("imp", 0))

                # monitored_ads: +/- 1% to 12%
                pct = random.uniform(0.01, 0.12)
                sign = random.choice([-1, 1])
                monitored = max(0, int(base_imp * (1 + sign * pct)))

                # viewable_ads: reasonable default 40% - 90% of impressions
                viewable_pct = random.uniform(0.40, 0.90)
                viewable = int(base_imp * viewable_pct)

                # brand_safety_ads: small portion 0.2% - 3.0% of impressions
                brand_safety = int(base_imp * random.uniform(0.002, 0.03))

                # out_of_geo_ads: 0.1% - 2.0% of impressions
                out_of_geo = int(base_imp * random.uniform(0.001, 0.02))

                ias_rows.append({
                    "date": row["date"],
                    "publisher": row["publisher"],
                    "campaign": row["campaign"],
                    "campaignId": row["campaignId"],
                    "placement": row["placement"],
                    "ad_format": row["ad_format"],
                    "imp_cm360": base_imp,
                    "monitored_ads": monitored,
                    "viewable_ads": viewable,
                    "brand_safety_ads": brand_safety,
                    "out_of_geo_ads": out_of_geo,
                    "clk": int(row.get("clk", 0)),
                    "views": int(row.get("views", 0)),
                    "video_completions": int(row.get("video_completions", 0))
                })

            ias_df = pd.DataFrame(ias_rows)
            ias_output_file = os.path.join(ias_folder, cm360_file.replace("CM360", f"IAS_{site_name}"))
            ias_df.to_csv(ias_output_file, index=False)
            print(f"🛡️ IAS report generated: {ias_output_file}")

# -----------------------------
# Entry point to run full workflow
# -----------------------------
def run_full_adtech_workflow(cm360_folder="cm360_reports",
                             site_folder="site_reports",
                             ias_folder="ias_reports",
                             start_date=datetime.date(2025,1,1),
                             end_date=datetime.date(2025,12,31),
                             num_campaigns=510,
                             sites=DEFAULT_SITES):
    print("Starting CM360 generation...")
    generate_weekly_cm360_reports(output_folder=cm360_folder,
                                  start_date=start_date,
                                  end_date=end_date,
                                  num_campaigns=num_campaigns,
                                  market=MARKET,
                                  sites=sites)
    print("Generating site & IAS reports from CM360 files...")
    generate_all_site_and_ias_reports_from_cm360(cm360_folder=cm360_folder,
                                                 site_folder=site_folder,
                                                 ias_folder=ias_folder,
                                                 sites=sites)
    print("Workflow finished.")

# Example run (edit paths if needed)
if __name__ == "__main__":
    run_full_adtech_workflow(
        cm360_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\cm360_reports",
        site_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\site_reports",
        ias_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\ias_reports",
        start_date=datetime.date(2025,1,1),
        end_date=datetime.date(2025,12,31),
        num_campaigns=510,
        sites=DEFAULT_SITES
    )
