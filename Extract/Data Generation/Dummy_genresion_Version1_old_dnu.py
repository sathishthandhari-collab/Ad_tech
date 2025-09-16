import os
import random
import pandas as pd
import datetime

# -----------------------------
# Config
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

# -----------------------------
# Generate Weekly CM360 Reports
# -----------------------------
def generate_weekly_cm360_reports(output_folder="cm360_reports",
                                  start_date=datetime.date(2025, 1, 1),
                                  end_date=datetime.date(2025, 12, 31),
                                  num_campaigns=510,
                                  market="IND",
                                  sites=['DV360', 'TTD', 'WebMD', 'Amazon', 'Youtube', 'PubMatic', 'Magnite']):
    os.makedirs(output_folder, exist_ok=True)

    advertisers = ["THD"]
    concepts = ["DiwaliOffer", "LoanFest", "Dussera", 'Ugadi', 'Christmas', 'Ramadan',
                'Indipendence Day', 'Republic day', "ShoppingFest", "NewYearSale", "SummerDeal", "Winter"]
    creative_types = ["Display", "Instream Video", "Instream Audio", "Tracking"]
    creative_sizes = ["300x250", "728x90", "160x600", "300x600", '320x50']
    creative_durations = ["15s", "30s", "06s", '45s']

    week_start = start_date
    while week_start <= end_date:
        file_date = week_start.strftime("%Y-%m-%d")
        output_file = os.path.join(output_folder, f"CM360_weekly_report_{file_date}.csv")

        rows = []
        for c in range(num_campaigns):
            campaign_id = random.randint(30000000, 39999999)
            advertiser = random.choice(advertisers)

            # --- restrict concepts by date ---
            month = week_start.month
            day = week_start.day
            valid_concepts = []

            for concept in concepts:
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
                continue  # skip if no valid campaigns this week

            concept = random.choice(valid_concepts)
            campaign_name = f"2025_{market}_{advertiser}_{concept}_digital"

            campaign_sites = random.sample(sites, random.randint(2, len(sites)))
            placements_per_campaign = random.randint(350, 1256)

            for p in range(placements_per_campaign):
                site = random.choice(campaign_sites)
                creative_type = random.choice(creative_types)
                size_or_duration = random.choice(creative_durations if "Video" in creative_type else creative_sizes)

                placement_name = f"{advertiser}_{market}_{concept}_{size_or_duration}_{creative_type}_{concept[:3]}_{site}"

                day_val = week_start + datetime.timedelta(days=random.randint(0, 6))
                impressions = random.randint(5000, 150000)
                clicks = random.randint(100, impressions // 30)
                pageviews = random.randint(clicks, clicks * 3)

                rows.append([
                    day_val, campaign_name, campaign_id, site, placement_name,
                    creative_type, impressions, clicks, pageviews
                ])

        df = pd.DataFrame(rows, columns=[
            "day", "campaign_name", "campaign_id", "site_name", "placement_name",
            "creative_type", "impressions", "clicks", "pageviews"
        ])
        df.to_csv(output_file, index=False)
        print(f"✅ CM360 weekly report generated: {output_file}")

        # --- increment week_start for next iteration ---
        week_start += datetime.timedelta(days=7)

# -----------------------------
# Generate Site Reports from CM360
# -----------------------------
def generate_all_site_data_from_cm360(cm360_folder="cm360_reports",
                                      site_folder="site_reports",
                                      sites=['DV360', 'TTD', 'WebMD', 'Amazon', 'Youtube', 'PubMatic', 'Magnite']):
    os.makedirs(site_folder, exist_ok=True)
    cm360_files = sorted([f for f in os.listdir(cm360_folder) if f.endswith(".csv")])
    for cm360_file in cm360_files:
        cm360_path = os.path.join(cm360_folder, cm360_file)
        df = pd.read_csv(cm360_path, parse_dates=['day'])
        for site_name in sites:
            site_df = df[df['site_name'] == site_name].copy()
            if site_df.empty: continue
            column_map = {
                "day": "date", "campaign_name": "campaign", "campaign_id": "campaignId",
                "site_name": "publisher", "placement_name": "placement", "creative_type": "ad_format",
                "impressions": "imp", "clicks": "clk", "pageviews": "views"
            }
            site_df = site_df.rename(columns=column_map)
            site_df["state"] = [random.choice(STATES) if random.random() > 0.1 else None for _ in range(len(site_df))]
            site_df["region"] = [random.choice(TIER1_CITIES[state]) if state and state in TIER1_CITIES else None for state in site_df["state"]]
            site_df["age_group"] = [random.choice(AGE_GROUPS) if random.random() > 0.05 else None for _ in range(len(site_df))]
            site_df["sex"] = [random.choice(SEXES) if random.random() > 0.05 else None for _ in range(len(site_df))]
            site_df["device_type"] = [random.choice(DEVICE_TYPES) if random.random() > 0.1 else None for _ in range(len(site_df))]

            # Add variation to metrics
            for metric in ['imp', 'clk', 'views']:
                variation_pct = [random.uniform(-0.1, 0.1) for _ in range(len(site_df))]
                site_df[metric] = site_df[metric].fillna(0) * (1 + pd.Series(variation_pct))
                site_df[metric] = site_df[metric].apply(lambda x: max(0, int(x)) if pd.notna(x) and x != float("inf") else 0)

            # --- NEW COLUMN: video_completions ---
            site_df["video_completions"] = site_df.apply(
                lambda row: random.randint(int(0.3*row["imp"]), row["imp"]) if "Instream Video" in row["ad_format"] else 0,
                axis=1
            )

            output_file = os.path.join(site_folder, cm360_file.replace("CM360", site_name))
            site_df.to_csv(output_file, index=False)
            print(f"✅ Site report generated: {output_file}")

# -----------------------------
# Generate Monthly Aggregated Reports
# -----------------------------
def generate_monthly_reports_from_sites(site_folder="site_reports", monthly_folder="monthly_reports"):
    os.makedirs(monthly_folder, exist_ok=True)
    site_files = sorted([f for f in os.listdir(site_folder) if f.endswith(".csv")])
    all_data = []
    for f in site_files:
        df = pd.read_csv(os.path.join(site_folder, f), parse_dates=["date"])
        all_data.append(df)
    if not all_data:
        print("⚠️ No site data found for monthly aggregation")
        return
    full_df = pd.concat(all_data, ignore_index=True)
    full_df["month"] = full_df["date"].dt.to_period("M")
    grouped = full_df.groupby(
        ["month", "publisher", "campaign", "state", "region", "age_group", "sex", "device_type"]
    ).agg({
        "imp": "sum", "clk": "sum", "views": "sum", "video_completions": "sum"
    }).reset_index()
    for period, df_month in grouped.groupby("month"):
        output_file = os.path.join(monthly_folder, f"Monthly_Report_{period}.csv")
        df_month.to_csv(output_file, index=False)
        print(f"📊 Monthly report generated: {output_file}")

# -----------------------------
# Run Full Workflow
# -----------------------------
def run_full_adtech_workflow(cm360_folder="cm360_reports",
                             site_folder="site_reports",
                             monthly_folder="monthly_reports",
                             sites=['DV360', 'TTD', 'WebMD', 'Amazon', 'Youtube', 'PubMatic', 'Magnite']):
    generate_weekly_cm360_reports(output_folder=cm360_folder)
    generate_all_site_data_from_cm360(cm360_folder=cm360_folder, site_folder=site_folder, sites=sites)
    generate_monthly_reports_from_sites(site_folder=site_folder, monthly_folder=monthly_folder)

# -----------------------------
# Example Run
# -----------------------------
run_full_adtech_workflow(
    cm360_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\cm360_reports",
    site_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\site_reports",
    monthly_folder=r"C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\monthly_reports",
    sites=['DV360', 'TTD', 'WebMD', 'Amazon', 'Youtube', 'PubMatic', 'Magnite']
)
