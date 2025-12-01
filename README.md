# ⚡ U.S. Electric Vehicle (EV) Market Analysis

End-to-end analytics project using SQL Server and Tableau to explore how
electric and alternative fuel vehicles are distributed across the United States.

The project aims to answer:

- How much of each state’s fleet is EV / PHEV / HEV / gasoline / diesel?
- Which states and regions lead or lag in EV adoption?
- Which alternative fuels (biodiesel, E85, CNG, etc.) are relevant vs. niche?
- Where should policymakers prioritize EV charging infrastructure?

---

## 1. Business Context

You are a data analyst in a transportation research group.  
A national transportation board needs a data-driven view of:

- Current EV and alternative-fuel adoption across U.S. states  
- Regional differences in electrification  
- High-priority states for new EV infrastructure investment  

This repository contains:

- A modular SQL pipeline for cleaning, enriching and scoring the data  
- Tableau dashboards for visual storytelling  
- Documentation and a final policy report aimed at decision-makers  

---

## 2. Tech Stack

- SQL Server – data cleaning, transformation, aggregation, scoring  
- Tableau – interactive dashboards and visual analytics  
- Excel / CSV – raw data sanity checks (optional)  
- Git & GitHub – version control and documentation  

---

## 3. Repository Structure (High Level)

EV-Analysis/  
│  
├── 01_Data/  
│   ├── raw_data/              ← original dataset(s)  
│   └── cleaned_data/          ← export used by Tableau  
│  
├── 02_SQL_Pipeline/  
│   ├── 01_Data_Inspection/  
│   ├── 02_Data_Cleaning/  
│   ├── 03_Data_Enrichment/  
│   ├── 04_State_Level_Analysis/  
│   ├── 05_Regional_Analysis/  
│   ├── 06_Alt_Fuel_Analysis/  
│   ├── 07_Economic_Indicators/  
│   ├── 08_Policy_Scoring/  
│   └── 09_EV_Analysis_MASTER/  
│  
├── 03_Tableau/  
│   ├── exports/               ← PNG dashboard exports  
│   ├── workbook/              ← optional TWBX/TWB  
│   └── tableau_notes.md       ← Tableau Public link & notes  
│  
├── 04_Documentation/  
│   ├── project_overview.md  
│   └── methodology.md  
│  
└── 05_Final_Report/  
    ├── final_report.md  
    └── executive_summary.md  

---

## 4. SQL Pipeline Overview

All SQL scripts live under `02_SQL_Pipeline/` and are designed to be modular and
easy to read. The main stages are:

### 4.1 Data Inspection

Folder: `02_SQL_Pipeline/01_Data_Inspection`

- Preview top rows  
- Count rows  
- List columns  
- Check distinct state names and duplicates  

Purpose: verify structure and basic data quality before any transformations.

---

### 4.2 Data Cleaning

Folder: `02_SQL_Pipeline/02_Data_Cleaning`

Key steps:

- Normalize column names  
  - e.g. `Electric (EV)` → `electric`  
  - e.g. `Plug-In Hybrid Electric (PHEV)` → `phev`  
- Remove thousands separators from numeric fields  
  - "1,256,600" → "1256600"  
- Cast numeric columns from text (VARCHAR) to INT  
- Trim whitespace from state names  
- Check for NULLs and duplicates after conversion  

Result: a clean, numeric, analysis-ready `Vehicle_Data` table.

---

### 4.3 Data Enrichment

Folder: `02_SQL_Pipeline/03_Data_Enrichment`

- Add U.S. regions (West, Northeast, Midwest, South) using a view
  `Vehicle_With_Region`  
- Compute derived metrics such as:
  - `total_vehicles` (sum of all fuel counts per state)  
  - base ratios reused by later modules  

This step creates reusable logic for regional and state-level analysis.

---

### 4.4 State-Level Analysis

Folder: `02_SQL_Pipeline/04_State_Level_Analysis`

- Compute EV, PHEV, HEV and gasoline percentages for each state  
- Identify:
  - Top 5 states by EV adoption (EV% of total vehicles)  
  - Bottom 5 states by EV adoption  
- Compare California to other large states:
  - Texas  
  - Florida  
  - New York  

Outputs support both Tableau visuals and the final policy report.

---

### 4.5 Regional Analysis

Folder: `02_SQL_Pipeline/05_Regional_Analysis`

- Aggregate state metrics by region (West, Northeast, Midwest, South)  
- Compute regional EV / HEV / PHEV shares  
- Compare each region’s EV% to the U.S. average  
- Build a `Regional_Electrification` view to simplify downstream queries  

This provides a clear picture of which regions are leading or lagging in EV adoption.

---

### 4.6 Alternative Fuel Analysis

Folder: `02_SQL_Pipeline/06_Alt_Fuel_Analysis`

- Analyze biodiesel, E85, CNG, propane, hydrogen and methanol  
- Distinguish between:
  - fuels with meaningful presence  
  - niche fuels with very low counts  
- Compute:
  - alternative fuel share of total vehicles  
  - top states by alternative fuel types  
  - simple fuel diversity index per state  

Helps understand the broader alternative fuel ecosystem beyond EVs.

---

### 4.7 Economic Indicators

Folder: `02_SQL_Pipeline/07_Economic_Indicators`

Examples of indicators:

- EV per 1,000,000 gasoline vehicles  
- State share of total U.S. alternative-fuel vehicles  
- Fuel diversity index (FDI)

These metrics highlight market maturity and relative EV penetration in traditional-fuel-heavy fleets.

---

### 4.8 Policy Scoring & Benchmarking

Folder: `02_SQL_Pipeline/08_Policy_Scoring`

Includes:

- Composite EV readiness score (0–1) based on:
  - EV adoption (% of fleet)  
  - EV potential (non-EV vehicles)  
  - fuel diversity  
- EV vs U.S. benchmark ratios  
- Quadrant classification:
  - High Adoption, High Volume (mature)  
  - High Volume, Low Adoption (infrastructure priority)  
  - High Adoption, Low Volume (emerging)  
  - Low Adoption, Low Volume (early stage)  

This transforms technical metrics into actionable policy categories.

---

### 4.9 Master Script

Folder: `02_SQL_Pipeline/09_EV_Analysis_MASTER`

- `EV_Analysis_MASTER.sql`  
  - Runs the entire pipeline in sequence  
  - Useful for end-to-end refresh on a fresh database  

---

## 5. Dashboards (Tableau)

Static PNG exports: `03_Tableau/exports/`  
Interactive dashboards: link documented in `03_Tableau/tableau_notes.md`

Main dashboard themes:

1. U.S. EV Overview  
   - National KPIs (total vehicles, EVs, EV adoption rate)  
   - State-level EV adoption map  
   - Top and bottom EV states  
   - California vs Texas, Florida, New York  

2. Regional Electrification  
   - EV / HEV / PHEV mix by region  
   - Region EV% vs national EV%  
   - Regional contribution to total U.S. EVs  

3. Alternative Fuel Overview  
   - Biodiesel, E85, CNG, propane, hydrogen distribution  
   - Top states per alternative fuel type  
   - Fleet composition: traditional vs electric/hybrid vs other alt fuels  

---

## 6. Key Insights (Short)

For full details, see `05_Final_Report/final_report.md`.  
Some highlights:

- National EV adoption is still low (~1.2% of the fleet) but very uneven:
  - A small set of states (e.g. California, D.C., Hawaii, Washington) are far
    ahead of the rest.
- The West region leads on both EV penetration and share of all U.S. EVs.
- The South and Midwest have:
  - large total vehicle fleets,  
  - relatively low EV penetration,  
  - significant potential for future EV growth.  
- Biodiesel and E85 are the most significant alternative fuels; hydrogen and
  methanol remain niche.
- A policy scoring framework suggests that large, under-served states such as
  Texas, Florida and New York are strong candidates for **priority EV
  infrastructure investment**.

---

## 7. How to Run the Project

1. Set up SQL Server:
   - Create database: `EV_Analysis`  
   - Import the raw dataset into table: `Vehicle_Data`

2. Run the SQL modules:
   - Option 1: run each folder’s `.sql` file in order (01 → 08)  
   - Option 2: run `EV_Analysis_MASTER.sql` for a full pipeline run

3. Export cleaned or aggregated data:
   - Save state-level or region-level outputs to `01_Data/cleaned_data/`  
   - Use these files as Tableau data sources

4. Open Tableau:
   - Load the workbook from `03_Tableau/workbook/` (if provided)  
   - Or connect dashboards to the cleaned data extracts  

---

## 8. Documentation & Reports

- `04_Documentation/project_overview.md`  
  - Business context and analytical goals  
- `04_Documentation/methodology.md`  
  - Detailed description of cleaning, enrichment, metrics and scoring logic  
- `05_Final_Report/final_report.md`  
  - Full narrative: findings, regional patterns, policy implications  
- `05_Final_Report/executive_summary.md`  
  - One-page summary for leadership stakeholders  

---

## 9. Future Improvements

- Add time-series data to study EV adoption trends over time  
- Incorporate charging station locations and capacity  
- Join with grid, pricing and emissions data for deeper planning insights  
- Extend the framework to other countries or sub-state geographies  

If you’d like to adapt this pipeline for a new dataset or region, you can fork
the repository and adjust the SQL modules and Tableau data connections to fit
your use case.
