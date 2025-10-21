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
SEXES = ["Male", "Female", "Other"]
DEVICE_TYPES = ["Mobile", "Desktop", "Tablet"]

DEFAULT_SITES = [
    'DV360','TTD','WebMD','Amazon','Youtube','PubMatic','Magnite',
    'InMobi','Criteo','Sharethrough','BingAds','MIQ','Hindhu','TOI','remezcla','AVZU'
]

ADVERTISERS = ["THD"]
MARKET = "IND"

SEASONAL_CONCEPTS = [
    "DiwaliOffer", "LoanFest", "Dussera", "Ugadi", "Christmas", "Ramadan",
    "Independence Day", "Republic day", "ShoppingFest", "NewYearSale", "SummerDeal", "Winter"
]
QUARTERLY_CONCEPTS = [
    "QuarterlySale", "FiscalCampaign", "SeasonalBlast"
]
YEARLY_CONCEPTS = [
    "YearlyReview", "AnnualPromo"
]

ALL_CONCEPTS = SEASONAL_CONCEPTS + QUARTERLY_CONCEPTS + YEARLY_CONCEPTS

CREATIVE_TYPES = ["Display", "Instream Video", "Instream Audio", "Tracking"]
CREATIVE_SIZES = ["300x250", "728x90", "160x600", "300x300", "320x50"]
CREATIVE_DURATIONS = ["06s", "15s", "30s", "45s"]

PLACEMENTS_PER_CAMPAIGN_MIN = 4
PLACEMENTS_PER_CAMPAIGN_MAX = 80

IMP_MIN = 0
IMP_MAX = 85421

# -----------------------------
# Helpers
# -----------------------------
def rand_id(length=8):
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))

_used_campaign_ids = set()
_campaign_name_to_id = {}

def get_unique_random_campaign_id():
    while True:
        candidate = random.randint(30000000, 39999999)
        if candidate not in _used_campaign_ids:
            _used_campaign_ids.add(candidate)
            return candidate

def get_campaign_id_for_name(campaign_name: str):
    if campaign_name in _campaign_name_to_id:
        return _campaign_name_to_id[campaign_name]
    else:
        new_id = get_unique_random_campaign_id()
        _campaign_name_to_id[campaign_name] = new_id
        return new_id

def generate_realistic_metrics(impressions: int):
    impressions = max(0, int(impressions))
    ctr = random.uniform(0.001, 0.015)
    clicks = int(impressions * ctr)
    clicks = max(0, clicks)
    pv_rate = random.uniform(0.5, 1.5)
    pageviews = int(clicks * pv_rate)
    return clicks, pageviews

def sample_creatives_for_concept(concept, creative_type):
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

CREATIVES = {}
for concept in ALL_CONCEPTS:
    CREATIVES[concept] = {}
    for ctype in CREATIVE_TYPES:
        CREATIVES[concept][ctype] = sample_creatives_for_concept(concept, ctype)

def valid_concepts_for_week(week_start: datetime.date):
    month = week_start.month
    day = week_start.day
    valid = []

    for concept in SEASONAL_CONCEPTS:
        if concept == "DiwaliOffer" and month == 10:
            valid.append(concept)
        elif concept == "Dussera" and month in [9, 10]:
            valid.append(concept)
        elif concept == "Independence Day" and month == 8 and 10 <= day <= 20:
            valid.append(concept)
        elif concept == "SummerDeal" and month in [3, 4, 5, 6]:
            valid.append(concept)
        elif concept == "Winter" and month in [11, 12]:
            valid.append(concept)
        elif concept == "Ugadi" and month == 4:
            valid.append(concept)
        elif concept == "Christmas" and month == 12:
            valid.append(concept)
        elif concept == "Ramadan" and month == 3:
            valid.append(concept)
        elif concept == "Republic day" and month == 1 and 20 <= day <= 31:
            valid.append(concept)
        elif concept == "NewYearSale" and month == 1 and 1 <= day <= 15:
            valid.append(concept)
        elif concept in ["ShoppingFest", "LoanFest"]:
            valid.append(concept)

    valid.extend(QUARTERLY_CONCEPTS)
    valid.extend(YEARLY_CONCEPTS)

    return valid

def generate_weekly_cm360_reports(output_folder="cm360_reports",
                                  start_date=datetime.date(2025, 1, 1),
                                  end_date=datetime.date(2025, 12, 31),
                                  num_campaigns=150,
                                  market=MARKET,
                                  sites=DEFAULT_SITES):
    os.makedirs(output_folder, exist_ok=True)
    week_start = start_date

    while week_start <= end_date:
        file_date = week_start.strftime("%Y-%m-%d")
        output_file = os.path.join(output_folder, f"CM360_weekly_report_{file_date}.csv")

        rows = []
        placement_day_tracker = set()

        for _ in range(num_campaigns):
            advertiser = random.choice(ADVERTISERS)
            valid_concepts = valid_concepts_for_week(week_start)
            if not valid_concepts:
                continue
            concept = random.choice(valid_concepts)
            campaign_name = f"2025_{market}_{advertiser}_{concept}_digital"
            campaign_id = get_campaign_id_for_name(campaign_name)

            campaign_sites = random.sample(sites, random.randint(2, len(sites)))
            placements_per_campaign = random.randint(PLACEMENTS_PER_CAMPAIGN_MIN, PLACEMENTS_PER_CAMPAIGN_MAX)

            packages_map = {}
            for s in campaign_sites:
                pkg_count = random.randint(0, 10)
                packages_map[s] = [rand_id(8) for _ in range(pkg_count)] if pkg_count > 0 else []

            pkg_assign_counters = {s: {"pkg_idx": 0, "used_in_current_pkg": 0,
                                       "cap": random.randint(1, 10)} for s in campaign_sites}

            placement_names_used = set()
            campaign_placements = []
            for _p in range(placements_per_campaign):
                attempts = 0
                while attempts < 100:
                    site = random.choice(campaign_sites)
                    creative_type = random.choice(CREATIVE_TYPES)
                    creative_name = random.choice(CREATIVES[concept][creative_type])

                    pkg_list = packages_map.get(site, [])
                    if not pkg_list:
                        package_random_id = "NOP" + rand_id(5)
                    else:
                        info = pkg_assign_counters[site]
                        package_random_id = pkg_list[info["pkg_idx"]]
                        info["used_in_current_pkg"] += 1
                        if info["used_in_current_pkg"] >= info["cap"]:
                            info["pkg_idx"] = (info["pkg_idx"] + 1) % len(pkg_list)
                            info["used_in_current_pkg"] = 0
                            info["cap"] = random.randint(1, 10)

                    placement_randid = rand_id(8)
                    name = (
                        f"Placement_{advertiser}_{market}_{concept}_{site}_{package_random_id}_"
                        f"{creative_type}_{concept[:3]}_{placement_randid}_{creative_name}"
                    )
                    if len(name) > 180:
                        name = name[:180]

                    if name not in placement_names_used:
                        placement_names_used.add(name)
                        campaign_placements.append({
                            'placement_name': name,
                            'site': site,
                            'creative_type': creative_type
                        })
                        break
                    attempts += 1

                if attempts >= 100:
                    site = random.choice(campaign_sites)
                    creative_type = random.choice(CREATIVE_TYPES)
                    creative_name = random.choice(CREATIVES[concept][creative_type])
                    name = (
                        f"Placement_{advertiser}_{market}_{concept}_{site}_{rand_id(12)}_"
                        f"{creative_type}_{concept[:3]}_{rand_id(8)}_{creative_name}"
                    )
                    if len(name) > 180:
                        name = name[:180]
                    placement_names_used.add(name)
                    campaign_placements.append({
                        'placement_name': name,
                        'site': site,
                        'creative_type': creative_type
                    })

            week_days = [week_start + datetime.timedelta(days=d) for d in range(7)]
            for pl in campaign_placements:
                assigned = False
                for _try in range(20):
                    day_val = random.choice(week_days)
                    key = (pl['placement_name'], day_val)
                    if key not in placement_day_tracker:
                        placement_day_tracker.add(key)
                        assigned = True
                        break
                if not assigned:
                    for day_val in week_days:
                        key = (pl['placement_name'], day_val)
                        if key not in placement_day_tracker:
                            placement_day_tracker.add(key)
                            break

                impressions = random.randint(IMP_MIN, IMP_MAX)
                clicks, pageviews = generate_realistic_metrics(impressions)

                rows.append([
                    day_val, campaign_name, campaign_id, pl['site'], pl['placement_name'],
                    pl['creative_type'], impressions, clicks, pageviews
                ])

        df = pd.DataFrame(rows, columns=[
            "day", "campaign_name", "campaign_id", "site_name", "placement_name",
            "creative_type", "impressions", "clicks", "pageviews"
        ])

        dup_count = df.groupby(['placement_name', 'day']).size().gt(1).sum()

        campaign_id_check = df.groupby('campaign_name')['campaign_id'].nunique()
        bad_campaigns = campaign_id_check[campaign_id_check > 1]

        df.to_csv(output_file, index=False)
        print(f"✅ CM360 weekly report generated: {output_file}")
        print(f"   Total rows: {len(df)}, Duplicate placement-day combinations: {dup_count}")
        print(f"   Campaign name-ID violations: {len(bad_campaigns)}")
        if len(bad_campaigns) > 0:
            print(f"   ❌ BAD CAMPAIGNS: {bad_campaigns.to_dict()}")

        week_start += datetime.timedelta(days=7)


def generate_all_site_and_ias_reports_from_cm360(cm360_folder="cm360_reports",
                                                site_folder="site_reports",
                                                ias_folder="ias_reports",
                                                sites=DEFAULT_SITES):
    os.makedirs(site_folder, exist_ok=True)
    os.makedirs(ias_folder, exist_ok=True)

    cm360_files = sorted([f for f in os.listdir(cm360_folder) if f.endswith('.csv')])
    for cm360_file in cm360_files:
        cm360_path = os.path.join(cm360_folder, cm360_file)
        df = pd.read_csv(cm360_path, parse_dates=['day'])

        for site_name in sites:
            site_df = df[df['site_name'] == site_name].copy()
            if site_df.empty:
                continue

            column_map = {
                'day': 'date', 'campaign_name': 'campaign', 'campaign_id': 'campaignId',
                'site_name': 'publisher', 'placement_name': 'placement', 'creative_type': 'ad_format',
                'impressions': 'imp', 'clicks': 'clk', 'pageviews': 'views'
            }
            site_df = site_df.rename(columns=column_map)

            # site_df['imp_cm360'] = site_df['imp'].astype(int)

            unique_placements = site_df['placement'].unique().tolist()
            demo_map = {}
            for pl in unique_placements:
                st = random.choice(STATES) if random.random() > 0.1 else None
                region = random.choice(TIER1_CITIES[st]) if st and st in TIER1_CITIES else None
                demo_map[pl] = {
                    'state': st,
                    'region': region,
                    'age_group': random.choice(AGE_GROUPS) if random.random() > 0.05 else None,
                    'sex': random.choice(SEXES) if random.random() > 0.05 else None,
                    'device_type': random.choice(DEVICE_TYPES) if random.random() > 0.1 else None,
                }
            site_df['state'] = site_df['placement'].map(lambda x: demo_map[x]['state'])
            site_df['region'] = site_df['placement'].map(lambda x: demo_map[x]['region'])
            site_df['age_group'] = site_df['placement'].map(lambda x: demo_map[x]['age_group'])
            site_df['sex'] = site_df['placement'].map(lambda x: demo_map[x]['sex'])
            site_df['device_type'] = site_df['placement'].map(lambda x: demo_map[x]['device_type'])

            n = len(site_df)
            imp_arr = site_df['imp'].fillna(0).astype(int).to_numpy()
            var_pct = np.random.uniform(-0.1, 0.1, size=n)
            imp_var = (imp_arr * (1.0 + var_pct)).astype(np.int64)
            imp_var = np.maximum(0, imp_var)

            clk_arr = site_df['clk'].fillna(0).astype(int).to_numpy()
            views_arr = site_df['views'].fillna(0).astype(int).to_numpy()
            ctr = np.divide(clk_arr, np.maximum(imp_arr, 1))
            ctr = np.clip(ctr, 0.001, 0.05)
            vpr = np.divide(views_arr, np.maximum(clk_arr, 1))
            vpr = np.clip(vpr, 0.3, 1.5)

            new_clk = (imp_var * ctr).astype(np.int64)
            new_views = (new_clk * vpr).astype(np.int64)

            site_df['imp'] = imp_var
            site_df['clk'] = np.maximum(0, new_clk)
            site_df['views'] = np.maximum(0, new_views)

            def compute_completions(imp, ad_fmt):
                imp = int(imp) if pd.notna(imp) else 0
                ad_fmt = str(ad_fmt)
                if 'Instream Video' in ad_fmt:
                    low = int(0.2 * imp)
                    high = int(0.9 * imp)
                    if high < low:
                        high = low
                    return random.randint(low, high) if imp > 0 else 0
                if 'Instream Audio' in ad_fmt:
                    low = int(0.3 * imp)
                    high = int(0.95 * imp)
                    if high < low:
                        high = low
                    return random.randint(low, high) if imp > 0 else 0
                return 0

            site_df['video_completions'] = site_df.apply(lambda r: compute_completions(r['imp'], r['ad_format']), axis=1)

            output_file = os.path.join(site_folder, cm360_file.replace('CM360', site_name))
            site_df.to_csv(output_file, index=False)
            print(f"✅ Site report generated: {output_file}")

            ias_rows = []
            for _, row in site_df.iterrows():
                base_imp_cm360 = int(row.get('imp_cm360', 0))
                monitored_pct = random.uniform(0.98, 1.05)
                monitored_ads = max(0, int(base_imp_cm360 * monitored_pct))
                viewable_pct = random.uniform(0.40, 0.90)
                viewable_ads = int(monitored_ads * viewable_pct)
                brand_safety_ads = int(monitored_ads * random.uniform(0.002, 0.03))
                out_of_geo_ads = int(monitored_ads * random.uniform(0.001, 0.02))

                ias_rows.append({
                    'date': row['date'],
                    'publisher': row['publisher'],
                    'campaign': row['campaign'],
                    'campaignId': row['campaignId'],
                    'placement': row['placement'],
                    'ad_format': row['ad_format'],
                    'imp_cm360': base_imp_cm360,
                    'monitored_ads': monitored_ads,
                    'viewable_ads': viewable_ads,
                    'brand_safety_ads': brand_safety_ads,
                    'out_of_geo_ads': out_of_geo_ads,
                    'clk': int(row.get('clk', 0)),
                    'views': int(row.get('views', 0)),
                    'video_completions': int(row.get('video_completions', 0))
                })

            ias_df = pd.DataFrame(ias_rows)
            ias_output_file = os.path.join(ias_folder, cm360_file.replace('CM360', f'IAS_{site_name}'))
            ias_df.to_csv(ias_output_file, index=False)
            print(f"🛡️ IAS report generated: {ias_output_file}")


def run_full_adtech_workflow(cm360_folder="cm360_reports",
                             site_folder="site_reports",
                             ias_folder="ias_reports",
                             start_date=datetime.date(2025,1,1),
                             end_date=datetime.date(2025,12,31),
                             num_campaigns=150,
                             sites=DEFAULT_SITES):
    print("Starting CM360 generation (extended campaign portfolio)...")
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


if __name__ == "__main__":
    run_full_adtech_workflow(
        cm360_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\cm360_reports",
        site_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\site_reports",
        ias_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\ias_reports",
        start_date=datetime.date(2025,1,1),
        end_date=datetime.date(2025,12,31),
        num_campaigns=150,
        sites=DEFAULT_SITES
    )
