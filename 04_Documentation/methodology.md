# Methodology – U.S. EV & Alternative Fuel Market Analysis

This document explains how the analysis was performed — from raw data to SQL
transformations, indicators, scoring methods, and visualization logic.

---

## 1. Data Source & Granularity

- Source table: `Vehicle_Data`
- Granularity: One row per U.S. state (including D.C.)
- Variables: Counts of registered vehicles by fuel type:
  - electric, phev, hev
  - gasoline, diesel
  - biodiesel, e85, cng, propane, hydrogen, methanol
  - unknown_fuel

This dataset represents a current snapshot of the U.S. vehicle fleet.

---

## 2. Tools & Environment

Component  | Usage
---------- | -----
SQL Server | Data cleaning, transformation, aggregation, scoring
Excel / CSV | Raw data checks
Tableau | Dashboards & visual analytics
GitHub | Version control & documentation

---

## 3. Data Cleaning Workflow

All data cleaning steps originate from the `02_Data_Cleaning` module.

### 3.1 Column Normalization

The dataset originally contained non–SQL-friendly column names such as:
`Electric (EV)` and `Plug-In Hybrid Electric (PHEV)`.

These were standardized using `sp_rename`:

- `Electric (EV)` → `electric`
- `Plug-In Hybrid Electric (PHEV)` → `phev`
- `Hybrid Electric (HEV)` → `hev`
- `Unknown Fuel` → `unknown_fuel`

Standardizing names ensures:
- easier SQL usage
- clean joins
- better readability
- Tableau compatibility

---

### 3.2 Cleaning Numeric Formatting

Numeric fields were imported as text values containing commas, for example:

"1,256,600"  
"89,800"

These commas prevent numeric operations in SQL, so they were removed:

UPDATE Vehicle_Data
SET electric = REPLACE(electric, ',', '');

The same update was applied to all fuel columns (`phev`, `hev`, `biodiesel`,
`e85`, `cng`, `propane`, `hydrogen`, `methanol`, `gasoline`, `diesel`,
`unknown_fuel`).

---

### 3.3 Data Type Conversion

After removing commas, all numeric columns were safely cast to integers:

ALTER TABLE Vehicle_Data ALTER COLUMN electric INT;

(Repeated for all fuel-type columns.)

This conversion enables:

- SUM()
- AVG()
- ORDER BY numeric value
- ratio and percentage calculations

---

### 3.4 Whitespace & Duplicate Checks

Duplicate state check:

SELECT state, COUNT(*)
FROM Vehicle_Data
GROUP BY state
HAVING COUNT(*) > 1;

State name cleanup:

UPDATE Vehicle_Data
SET state = LTRIM(RTRIM(state));

No duplicate states were found; one row per state is preserved.

---

### 3.5 NULL Validation

After cleaning and type conversion, all columns were scanned for NULLs.  
No missing values remained, so the dataset is treated as complete.

---

## 4. Data Enrichment

### 4.1 U.S. Region Mapping

A central analysis step is adding U.S. regions:

- West
- Northeast
- Midwest
- South
- Unknown (fallback)

This is implemented in the `Vehicle_With_Region` view:

CREATE VIEW Vehicle_With_Region AS
SELECT *,
       CASE
           WHEN state IN (...) THEN 'West'
           WHEN state IN (...) THEN 'Northeast'
           WHEN state IN (...) THEN 'South'
           WHEN state IN (...) THEN 'Midwest'
           ELSE 'Unknown'
       END AS region
FROM Vehicle_Data;

Region labels enable:

- regional electrification analysis
- weighted EV share calculations
- Tableau visualization layers

---

### 4.2 Derived Metrics

For each state, several derived measures are used throughout the pipeline.

Total vehicles:

total_vehicles =
    electric + phev + hev + biodiesel + e85 + cng +
    propane + hydrogen + methanol + gasoline + diesel + unknown_fuel

EV penetration (share of fleet):

ev_percent = electric * 1.0 / total_vehicles

EV potential (non-EV vehicles that could convert):

ev_potential = total_vehicles - electric

Fuel diversity:

- count of fuel types with meaningful presence (threshold-based),
  used later in policy scoring.

---

## 5. Analytical Modules

### 5.1 State-Level Analysis

Module: `04_State_Level_Analysis`

Objectives:

- compute EV / PHEV / HEV / Gasoline percentages per state
- identify Top 5 and Bottom 5 EV adoption states
- compare California vs large states (TX, FL, NY)

Techniques:

- precise ratio calculations
- ORDER BY for ranking
- aggregations for total vehicles

---

### 5.2 Regional Analysis

Module: `05_Regional_Analysis`

Objectives:

- aggregate all calculations by region
- compute weighted EV, PHEV, HEV shares
- compare regions against national average
- build the `Regional_Electrification` analysis view

Techniques:

- SUM() GROUP BY region
- weighted percentages using regional totals
- region-level comparisons consumed by Tableau

---

### 5.3 Alternative Fuel Analysis

Module: `06_Alt_Fuel_Analysis`

Key metrics:

- national and state-level alternative fuel share
- which fuels are significant vs niche (biodiesel, E85, CNG, propane, hydrogen, methanol)
- state contributions to total U.S. alternative fuel usage
- alternative fuel diversity index per state

Techniques:

- ratios against total fleet
- window functions (SUM() OVER, RANK() OVER)
- ordering and ranking to identify top contributors

---

### 5.4 Economic Indicators

Module: `07_Economic_Indicators`

Core indicators:

- EV per 1,000,000 gasoline vehicles
- alternative fuel market share by state
- fuel diversity index (FDI)
- state-level market contribution metrics

These help interpret EV growth in the context of the existing fossil-fuel fleet.

---

### 5.5 Policy Scoring & Readiness Framework

Module: `08_Policy_Scoring`

This module converts analytics into actionable policy guidance.

EV Readiness Score:

- EV Potential Score
- EV Adoption Score
- Fuel Diversity Score (FDI)

Combined with weights:

Readiness Score =
    0.4 * EV Potential Score
  + 0.4 * EV Adoption Score
  + 0.2 * Fuel Diversity Score

Scores are min–max normalized between 0 and 1.

Investment / Infrastructure Priority Quadrants:

States are assigned to one of four categories based on EV volume (electric count)
and EV penetration (EV% vs national average):

1. High Adoption, High Volume — mature EV markets  
2. High Volume, Low Adoption — infrastructure priority  
3. High Adoption, Low Volume — emerging EV markets  
4. Low Adoption, Low Volume — early-stage markets  

EV vs U.S. Benchmark:

- compare state EV penetration vs national average
- compute share of total U.S. EVs
- compute share of total U.S. vehicles
- derive an EV performance ratio vs U.S. benchmark

---

## 6. Visualization Workflow (Tableau)

The SQL pipeline produces a clean, analysis-ready dataset.

Tableau is used to:

- build state-level EV adoption maps
- design regional electrification dashboards
- visualize Top/Bottom states as bar charts
- display key KPIs (total vehicles, total EVs, EV adoption rate, alt fuel share)
- present alternative fuel distributions and top states

Most heavy calculations are done in SQL; Tableau primarily focuses on:

- layout
- interactivity (filters, highlights)
- visual storytelling

---

## 7. Assumptions & Limitations

- Data is a single snapshot in time (no time-series or trend lines).
- Charging infrastructure counts (fast chargers, stations) are not included;
  infrastructure recommendations are inferred from EV adoption and potential.
- Alternative fuel values are sometimes small; these fuels are treated as niche
  and interpreted cautiously.
- Analysis operates at state level; intra-state variation (urban vs rural)
  is outside the scope.

Despite these limitations, the methodology provides a robust basis for:

- understanding current EV adoption patterns
- comparing regions and states
- supporting high-level infrastructure and policy decisions.
