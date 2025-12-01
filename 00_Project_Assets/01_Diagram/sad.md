# EV Analysis – Full Project Structure & Pipeline (FINAL)

EV-Analysis/
│
├── .gitattributes
├── README.md              # (to be filled later)
│
├── 00_Project_Assets/
│   ├── 01_Diagrams/
│   │   └── pipeline_diagram.png        # project flow / pipeline diagram
│   ├── 02_Source_Documents/
│   │   └── data_dictionary.md          # column-level documentation
│   ├── 03_Images/
│   │   └── ...                         # charts / figures used in README & report
│   └── 04_Presentation/
│       └── ...                         # slides / executive material (optional)
│
├── 01_Data/
│   ├── raw_data/                       # original datasets (as received)
│   └── cleaned_data/                   # export after SQL pipeline (for Tableau)
│
├── 02_SQL_Pipeline/
│   │
│   ├── 01_Data_Inspection/
│   │   ├── preview_top_rows.sql
│   │   ├── count_rows.sql
│   │   ├── list_columns.sql
│   │   └── inspection_notes.md
│   │
│   ├── 02_Data_Cleaning/
│   │   ├── data_cleaning.sql           # renames, comma strip, CAST to INT, trims
│   │   └── cleaning_notes.md
│   │
│   ├── 03_Data_Enrichment/
│   │   ├── data_enrichment.sql         # region view, derived totals, helper views
│   │   └── enrichment_notes.md
│   │
│   ├── 04_State_Level_Analysis/
│   │   ├── state_level_analysis.sql    # state EV %, top/bottom states, CA vs majors
│   │   └── state_notes.md
│   │
│   ├── 05_Regional_Analysis/
│   │   ├── regional_analysis.sql       # West / South / Midwest / Northeast metrics
│   │   └── region_notes.md
│   │
│   ├── 06_Alt_Fuel_Analysis/
│   │   ├── alt_fuel_analysis.sql       # alt fuel shares, diversity, rankings
│   │   └── altfuel_notes.md
│   │
│   ├── 07_Economic_Indicators/
│   │   ├── ev_per_million_gas.sql      # EV per 1M gasoline vehicles
│   │   ├── alt_fuel_market_share.sql   # state share of US alt fuels
│   │   ├── fuel_diversity_index.sql    # FDI metric
│   │   └── economic_notes.md
│   │
│   ├── 08_Policy_Scoring/
│   │   ├── readiness_score.sql         # composite readiness score (0–1)
│   │   ├── ev_vs_us_benchmark.sql      # benchmark vs US avg penetration
│   │   ├── ev_investment_priority.sql  # quadrant: High/Low adoption & volume
│   │   └── policy_notes.md
│   │
│   └── 09_EV_Analysis_MASTER/
│       └── EV_Analysis_MASTER.sql      # 🔥 runs full SQL pipeline end-to-end
│
├── 03_Tableau/
│   ├── exports/                        # PNG screenshots of dashboards
│   │   └── ...                         # overview / regional / alt fuel dashboards
│   ├── workbook/                       # (optional) TWBX/TWB if shared
│   └── tableau_notes.md                # Tableau Public link + dashboard docs
│
├── 04_Documentation/
│   ├── methodology.md                  # how the analysis was done (SQL + logic)
│   └── project_overview.md             # business context & goals
│
└── 05_Final_Report/
    ├── final_report.md                 # full narrative: findings + recommendations
    └── executive_summary.md            # 1-page leadership summary

# Flow Summary

RAW DATA  →  02_SQL_Pipeline (01–03)  →  CLEAN & ENRICHED STATE DATA  
          →  02_SQL_Pipeline (04–08)  →  METRICS, INDICATORS & SCORES  
          →  01_Data/cleaned_data + 03_Tableau  →  DASHBOARDS  
          →  04_Documentation + 05_Final_Report →  STORY & POLICY INSIGHTS
