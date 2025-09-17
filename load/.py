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


# ------------------------------------------------------------
# 3-TIER CREATIVE HIERARCHY (STATIC LISTS → NAMES ON DEMAND)
# ------------------------------------------------------------

# 1️⃣ Campaign-level concepts (renamed from CONCEPTS)
CAMPAIGN_CONCEPTS = [
    "DiwaliOffer", "LoanFest", "Dussera", "Ugadi", "Christmas", "Ramadan",
    "Independence Day", "Republic Day", "ShoppingFest", "NewYearSale",
    "SummerDeal", "Winter"
]

# 2️⃣ Approved creative-concepts for each campaign
CAMPAIGN_TO_CREATIVE_CONCEPTS = {
    "DiwaliOffer": [
        "SparklingSavings", "FestiveLightsDeal", "DiwaliSuperSale",
        "GiftHappiness", "FestivalOfSavings", "DiwaliBonanza",
        "LightUpYourCart"
    ],
    "LoanFest": [
        "EasyLoanApproval", "ZeroProcessingFee", "FestiveFinanceBoost",
        "EMIHolidayOffer", "InstantApprovalDeal", "LoanFestSpecial",
        "BigDreamsEasyLoans"
    ],
    "Dussera": [
        "VictorySavings", "DussehraMegaSale", "FestiveComboDeals",
        "TriumphDiscounts", "CelebrateWithOffers", "DashainBonanza"
    ],
    "Ugadi": [
        "UgadiFreshStart", "NewBeginningsOffer", "UgadiSpecialDiscount",
        "FestiveHarvestDeal", "ProsperitySavings", "UgadiGiftPack"
    ],
    "Christmas": [
        "XmasMegaSale", "SantaSavings", "JingleBellDeals",
        "FestiveGiftingOffer", "WinterWonderDiscount",
        "ChristmasComboPack", "HolidayCheerSale"
    ],
    "Ramadan": [
        "RamadanKareemOffer", "IftarSpecialDeals", "EidCelebrationSale",
        "FestiveRamadanDiscount", "MidnightSavings", "RamadanBlessingsPromo"
    ],
    "Independence Day": [
        "FreedomSavings", "15AugMegaSale", "IndependenceDeals",
        "FlagshipOffers", "TirangaDiscounts", "FreedomFestival"
    ],
    "Republic Day": [
        "RepublicMegaSale", "PatrioticSavings", "ParadeOffers",
        "26JanSpecialDiscount", "RepublicDayBonanza", "NationPrideDeals"
    ],
    "ShoppingFest": [
        "MegaCartSavings", "ShopTillYouDrop", "FestiveShoppingRush",
        "WeekendMegaFest", "GreatBuyBonanza", "ShopaholicDeals",
        "EndlessSavingsFest"
    ],
    "NewYearSale": [
        "NYBigBangSale", "2025KickoffDeals", "ResolutionDiscounts",
        "MidnightCountdownOffer", "CelebrateNewYearSavings",
        "NewYearComboBonanza", "FreshStartSale"
    ],
    "SummerDeal": [
        "CoolSavingsSummer", "BeatTheHeatOffers", "SummerSplashSale",
        "HotDiscountFest", "ChillOutDeals", "SunnySeasonSale",
        "SummerComboPack"
    ],
    "Winter": [
        "WinterWarmthSale", "CozySavings", "SnowyDeals",
        "WinterWonderFest", "YearEndBonanza", "WarmWinterDiscount",
        "FrostySpecials"
    ]
}


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


# 3️⃣ Generate 15-50 creative names per creative-concept
def generate_creative_names(creative_concept, min_names=15, max_names=50):
    n = random.randint(min_names, max_names)
    return [f"{creative_concept}_Creative{i:02d}" for i in range(1, n + 1)]


# 🔧 Build hierarchy once at start-up
def build_campaign_hierarchy():
    hierarchy = {}
    for camp, creative_concepts in CAMPAIGN_TO_CREATIVE_CONCEPTS.items():
        # keep only 4-10 concepts as required
        selected = random.sample(
            creative_concepts,               # pool
            k=random.randint(4, min(10, len(creative_concepts)))
        )
        hierarchy[camp] = {
            cc: generate_creative_names(cc)
            for cc in selected
        }
    return hierarchy


CAMPAIGN_CREATIVE_HIERARCHY = build_campaign_hierarchy()

print("📊 Creative hierarchy ready – summary:")
for k, v in CAMPAIGN_CREATIVE_HIERARCHY.items():
    total_names = sum(len(x) for x in v.values())
    print(f"  {k}: {len(v)} creative concepts, {total_names} creative names")


# ------------------------------------------------------------
# Helper to sample a creative name (used inside placement loop)
# ------------------------------------------------------------
def sample_creative_name(campaign_concept, creative_type):
    """
    1. Pick a creative concept for the chosen campaign.
    2. Pick a creative name under that concept.
    3. Append size/duration/type suffix.
    """
    concept_dict = CAMPAIGN_CREATIVE_HIERARCHY[campaign_concept]
    creative_concept = random.choice(list(concept_dict.keys()))
    base_name = random.choice(concept_dict[creative_concept])

    if creative_type == "Display":
        suffix = random.choice(CREATIVE_SIZES)
    elif creative_type in ("Instream Video", "Instream Audio"):
        suffix = random.choice(CREATIVE_DURATIONS)
    else:
        suffix = "TAG"

    final_name = f"{base_name}_{suffix}"
    return final_name, creative_concept


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

            # --- restrict campaign concepts by date ---
            month = week_start.month
            day = week_start.day
            valid_campaign_concepts = []
            for campaign_concept in CAMPAIGN_CONCEPTS:
                if campaign_concept == "DiwaliOffer" and month == 10:
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "Dussera" and month in [9, 10]:
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "Independence Day" and ((month == 7 and day >= 25) or (month == 8 and day <= 6)):
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "SummerDeal" and month in [3, 4, 5, 6]:
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "Winter" and month in [11, 12]:
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "Ugadi" and month == 4:
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "Christmas" and month == 12:
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "Ramadan" and month == 3:
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "Republic Day" and (month == 1 and day == 26):
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept == "NewYearSale" and (month == 1 and 1 <= day <= 7):
                    valid_campaign_concepts.append(campaign_concept)
                elif campaign_concept in ["ShoppingFest", "LoanFest"]:
                    valid_campaign_concepts.append(campaign_concept)

            if not valid_campaign_concepts:
                continue

            campaign_concept = random.choice(valid_campaign_concepts)
            campaign_name = f"2025_{market}_{advertiser}_{campaign_concept}_digital"

            # choose subset of campaign sites (2 to all)
            campaign_sites = random.sample(sites, random.randint(2, len(sites)))
            placements_per_campaign = random.randint(PLACEMENTS_PER_CAMPAIGN_MIN, PLACEMENTS_PER_CAMPAIGN_MAX)

            # Package mapping logic
            packages_map = {}
            for s in campaign_sites:
                pkg_count = random.randint(0, 10)
                if pkg_count == 0:
                    packages_map[s] = []
                else:
                    packages_map[s] = [rand_id(8) for _ in range(pkg_count)]

            pkg_assign_counters = {s: {"pkg_idx": 0, "used_in_current_pkg": 0} for s in campaign_sites}

            for p in range(placements_per_campaign):
                site = random.choice(campaign_sites)
                creative_type = random.choice(CREATIVE_TYPES)

                # NEW: Sample from 3-tier hierarchy using specific creative concept names
                creative_name, creative_concept_used = sample_creative_name(campaign_concept, creative_type)

                # Package assignment logic
                pkg_list = packages_map.get(site, [])
                if not pkg_list:
                    package_random_id = "NOPKG" + rand_id(3)
                else:
                    info = pkg_assign_counters[site]
                    current_pkg_idx = info["pkg_idx"]
                    package_random_id = pkg_list[current_pkg_idx]
                    info["used_in_current_pkg"] += 1
                    cap = random.randint(1, 10)
                    if info["used_in_current_pkg"] >= cap:
                        info["pkg_idx"] = (info["pkg_idx"] + 1) % len(pkg_list)
                        info["used_in_current_pkg"] = 0

                placement_randid = rand_id(8)
                
                # Updated placement name with new hierarchy
                placement_name = (
                    f"Placement_{advertiser}_{market}_{campaign_concept}_{site}_{package_random_id}_"
                    f"{creative_type}_{campaign_concept[:3]}_{placement_randid}_{creative_name}"
                )

                day_val = week_start + datetime.timedelta(days=random.randint(0, 6))
                impressions = random.randint(IMP_MIN, IMP_MAX)
                clicks = random.randint(100, max(100, impressions // 30))
                pageviews = random.randint(clicks, clicks * 3)

                # Add creative concept and creative name columns
                rows.append([
                    day_val, campaign_name, campaign_id, site, placement_name,
                    creative_type, campaign_concept, creative_concept_used, creative_name,
                    impressions, clicks, pageviews
                ])

        # Updated DataFrame with new columns
        df = pd.DataFrame(rows, columns=[
            "day", "campaign_name", "campaign_id", "site_name", "placement_name",
            "creative_type", "campaign_concept", "creative_concept", "creative_name",
            "impressions", "clicks", "pageviews"
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

            # Updated column mapping to include new creative columns
            column_map = {
                "day": "date", "campaign_name": "campaign", "campaign_id": "campaignId",
                "site_name": "publisher", "placement_name": "placement", "creative_type": "ad_format",
                "impressions": "imp", "clicks": "clk", "pageviews": "views"
                # Keep campaign_concept, creative_concept, creative_name as-is
            }
            site_df = site_df.rename(columns=column_map)

            # Demographics & device enrichment
            n = len(site_df)
            site_df["state"] = [random.choice(STATES) if random.random() > 0.1 else None for _ in range(n)]
            site_df["region"] = [random.choice(TIER1_CITIES[state]) if state and state in TIER1_CITIES else None for state in site_df["state"]]
            site_df["age_group"] = [random.choice(AGE_GROUPS) if random.random() > 0.05 else None for _ in range(n)]
            site_df["sex"] = [random.choice(SEXES) if random.random() > 0.05 else None for _ in range(n)]
            site_df["device_type"] = [random.choice(DEVICE_TYPES) if random.random() > 0.1 else None for _ in range(n)]

            # Video completions logic
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

            # Random variation logic
            for metric in ['imp', 'clk', 'views']:
                arr = site_df[metric].fillna(0).astype(float).to_numpy()
                variation_pct = np.random.uniform(-0.1, 0.1, size=arr.shape)
                new_arr = (arr * (1.0 + variation_pct)).astype(np.int64)
                new_arr = np.maximum(0, new_arr)
                site_df[metric] = new_arr

            # Output site CSV with new creative columns
            output_file = os.path.join(site_folder, cm360_file.replace("CM360", site_name))
            site_df.to_csv(output_file, index=False)
            print(f"✅ Site report generated: {output_file}")

            # IAS report generation (updated to include new columns)
            ias_rows = []
            for idx, row in site_df.iterrows():
                base_imp = int(row.get("imp", 0))

                pct = random.uniform(0.01, 0.12)
                sign = random.choice([-1, 1])
                monitored = max(0, int(base_imp * (1 + sign * pct)))

                viewable_pct = random.uniform(0.40, 0.90)
                viewable = int(base_imp * viewable_pct)

                brand_safety = int(base_imp * random.uniform(0.002, 0.03))
                out_of_geo = int(base_imp * random.uniform(0.001, 0.02))

                ias_rows.append({
                    "date": row["date"],
                    "publisher": row["publisher"],
                    "campaign": row["campaign"],
                    "campaignId": row["campaignId"],
                    "placement": row["placement"],
                    "ad_format": row["ad_format"],
                    "campaign_concept": row.get("campaign_concept", ""),
                    "creative_concept": row.get("creative_concept", ""),
                    "creative_name": row.get("creative_name", ""),
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


# Example run
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
