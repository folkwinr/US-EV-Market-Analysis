# Project Overview – U.S. Electric Vehicle Market Share

## 1. Background & Business Context

The project analyzes the adoption of electric and alternative fuel vehicles
across the United States at **state level**. The dataset contains vehicle
registration counts for multiple fuel types:

- Electric Vehicles (EV)
- Plug-in Hybrid Electric Vehicles (PHEV)
- Hybrid Electric Vehicles (HEV)
- Gasoline
- Diesel
- Other alternative fuels (Biodiesel, E85, CNG, Propane, Hydrogen, Methanol)

A government transportation board and related industry stakeholders are
interested in:

- How quickly EVs are gaining market share
- Where adoption is geographically concentrated
- How EVs compare to traditional fuels (gasoline & diesel)
- What this means for **infrastructure planning** and **policy decisions**

This repository contains the full SQL pipeline, documentation, and Tableau
dashboards built for that purpose.

---

## 2. Project Goals

The main goals of the project are:

1. **Measure EV market share**  
   Quantify how many vehicles in each U.S. state are EVs, PHEVs, HEVs, and
   gasoline/diesel, both in absolute counts and as percentages of the total fleet.

2. **Identify leaders and laggards**  
   Rank states by EV adoption rate and highlight those leading the transition
   vs. those falling behind.

3. **Assess alternative fuel relevance**  
   Distinguish between alternative fuels with meaningful presence (e.g.,
   biodiesel, E85) and those that are still niche (e.g., hydrogen, methanol).

4. **Support policy & investment decisions**  
   Provide a **data-driven framework** to prioritize EV infrastructure
   investment and to compare state performance against U.S. benchmarks.

---

## 3. Key Questions

The analysis is structured around the following core questions:

1. **Fuel Share by State**  
   - What percentage of vehicles in each state are:
     - EVs  
     - PHEVs  
     - HEVs  
     - Gasoline / Diesel  

2. **EV Adoption Leaders & Laggards**  
   - Which states have the **highest EV adoption rates**?  
   - Which states are **lagging behind**?  
   - How does **California** compare to other large states
     (Texas, Florida, New York, etc.)?

3. **Alternative Fuel Landscape**  
   - Which fuels (biodiesel, E85, CNG, propane, hydrogen) have meaningful
     usage at national and state level?  
   - Which are clearly niche?

4. **Policy & Infrastructure Prioritization**  
   - Where should policymakers **prioritize EV charging infrastructure**?  
   - Which states show **high potential but low current support**?  
   - How do states compare against the **U.S. average EV penetration**?

---

## 4. Tech Stack

The project uses the following tools:

- **SQL Server** – Core data cleaning, transformation, aggregation,
  scoring and policy metrics.
- **Excel / CSV** – Raw data storage and quick sanity checks.
- **Tableau** – Interactive dashboards and visual storytelling.
- *(Optionally)* Markdown + GitHub – Documentation and portfolio presentation.

---

## 5. SQL Pipeline Overview

The SQL pipeline is organized into modular steps:

1. **01_Data_Inspection**  
   Preview data, row counts, and column structure.

2. **02_Data_Cleaning**  
   Rename columns, remove formatting characters (commas), cast numeric fields
   to INT, trim state names, and check for NULLs and duplicates.

3. **03_Data_Enrichment**  
   Add U.S. **regions** (West, Northeast, Midwest, South) via the
   `Vehicle_With_Region` view and prepare analysis-ready structures.

4. **04_State_Level_Analysis**  
   Compute state-level EV/PHEV/HEV/Gasoline percentages, top/bottom EV states,
   and electrification categories.

5. **05_Regional_Analysis**  
   Aggregate results by region and calculate weighted EV shares and regional
   electrification metrics.

6. **06_Alt_Fuel_Analysis**  
   Analyze alternative fuel volumes, shares, diversity, and state contributions.

7. **07_Economic_Indicators**  
   Build economic KPIs such as **EV per million gasoline vehicles**, fuel
   diversity index, and alternative fuel market share.

8. **08_Policy_Scoring**  
   Create composite **readiness scores**, investment priority quadrants, and
   benchmark each state against the U.S. average.

A consolidated script `EV_Analysis_MASTER.sql` runs the entire pipeline end-to-end.

---

## 6. Dashboards & Reporting

Three main Tableau dashboards are produced:

1. **U.S. EV Overview Dashboard**  
   - National KPIs (Total Vehicles, Total EVs, EV Adoption Rate)  
   - State-level EV adoption map  
   - EV performance vs U.S. average  
   - Top 10 EV states & California vs other large states

2. **Regional Electrification Dashboard**  
   - EV/HEV/PHEV share by region  
   - Region vs national EV% comparison  
   - EV share vs total fleet by region  
   - Regional contribution to total U.S. EVs

3. **Alternative Fuel Overview Dashboard**  
   - Fuel type composition across states  
   - Alternative fuel totals by category  
   - Top states by niche fuel (CNG, propane, biodiesel, E85, hydrogen)  
   - Fleet composition (traditional vs electric/hybrid vs other alt fuels)

Static PNG snapshots are stored in `03_Tableau/screenshots/`, while the full
interactive dashboards are available via Tableau Public.

---

## 7. Intended Audience

- Government transportation boards  
- Urban planners and infrastructure teams  
- Automakers and EV strategy teams  
- Energy & sustainability analysts  
- Data analytics reviewers and hiring managers

The project is designed not only as an analytical piece, but also as a
**portfolio-ready case study** demonstrating SQL, visualization, and
policy-oriented storytelling.
