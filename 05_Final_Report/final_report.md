# Final Report – U.S. Electric Vehicle & Alternative Fuel Market

## 1. Introduction & Business Context

The goal of this project is to understand how electric and alternative fuel
vehicles are distributed across the United States and what this implies for
future infrastructure and policy.

A national transportation board is considering where to:

- expand public charging infrastructure,
- support alternative fuel corridors, and
- monitor EV transition risks and opportunities.

To support this decision, a state-level dataset with vehicle registrations by
fuel type (EV, PHEV, HEV, gasoline, diesel, and several alternative fuels) was
analyzed using SQL and visualized with Tableau dashboards.

The analysis focuses on:

- EV adoption levels and trends across states and regions,
- the relative importance of alternative fuels,
- and a policy-oriented readiness and priority framework.

---

## 2. Data & Method Overview (Short)

- Unit of analysis: 1 row = 1 U.S. state (incl. D.C.).
- Metrics: counts of vehicles by fuel type:
  electric, phev, hev, gasoline, diesel, biodiesel, e85, cng, propane,
  hydrogen, methanol, unknown_fuel.
- Tools:
  - SQL Server → data cleaning, enrichment, aggregations, policy scoring
  - Tableau → interactive dashboards and visual storytelling
  - GitHub → documentation and version control

Key preparation steps (details in `methodology.md`):

- Cleaned numeric columns (removed commas, cast to INT).
- Standardized column names (`Electric (EV)` → `electric`, etc.).
- Added U.S. region labels via the `Vehicle_With_Region` view.
- Computed derived metrics such as `total_vehicles`, `ev_percent`,
  `ev_potential`, fuel diversity, and readiness scores.

---

## 3. National Overview

At national level, the dataset shows:

- **Total vehicles:** ≈ 287 million  
- **Total EVs:** ≈ 3.6 million  
- **EV adoption rate:** ≈ 1.2% of the fleet  
- **Alt fuel share (non-gasoline/diesel):** ≈ 4.3% of the fleet

This confirms that the U.S. vehicle fleet is still dominated by gasoline and
diesel, but EVs have begun to reach meaningful scale in specific states and
regions.

---

## 4. State-Level Findings

### 4.1 EV Share by State

For each state, the following percentages were computed:

- EV share = electric / total_vehicles
- PHEV share = phev / total_vehicles
- HEV share = hev / total_vehicles
- Gasoline and diesel share combined

States are then ranked by EV share.

**Top EV adoption states** (EV% of total fleet) include:

- California (~3.4%)
- District of Columbia (~2.6%)
- Hawaii (~2.4%)
- Washington (~2.2%)
- Several additional coastal and Northeastern states around or above 1.5%

These states have both relatively high absolute EV counts and EV penetration
well above the national average (~1.2%).

**Lower-adoption states** are concentrated in parts of the South and Midwest,
with EV percentages significantly below 1%. These states remain dominated by
traditional fuels, although some still have large overall fleets.

### 4.2 California vs Other Large States

A specific comparison between California and other high-population states
(Texas, Florida, New York, etc.) highlights the following:

- California has **more than double** the national EV adoption rate and
  accounts for **a very large share of all U.S. EVs**.
- Texas, Florida and New York have very large vehicle fleets but **moderate
  EV percentages**, often below the levels seen in California and some
  smaller coastal states.
- These large-fleet states combine:
  - strong total EV volume (millions of vehicles that could transition),
  - but still substantial headroom for EV growth.

This pattern is highly relevant for infrastructure planning:  
high population + high total vehicle count + mid-level EV adoption = strong
investment justification.

---

## 5. Regional Electrification

States were grouped into four regions: West, Northeast, Midwest, South.

### 5.1 EV Penetration by Region

Regional aggregation shows:

- **West**  
  - Highest EV penetration (around 2.5%).  
  - Contains some of the earliest and strongest EV markets
    (California, Washington, Oregon, etc.).  
  - Also holds **over half** of total U.S. EVs.

- **Northeast**  
  - Moderate EV penetration (~1.1%).  
  - Several states with strong environmental policies but smaller fleets.

- **South**  
  - EV penetration below 1%, but large total fleet.  
  - Significant potential if policy and infrastructure catch up.

- **Midwest**  
  - Lowest EV penetration (~0.6%).  
  - Fleet still heavily dominated by gasoline and diesel.

### 5.2 Regional Insights

- West is clearly the **mature EV region**, driving most current EV volume.
- South and Midwest are **volume-heavy but adoption-light**:
  - large fleets,
  - slow EV penetration,
  - potentially high need for targeted infrastructure and incentives.
- Northeast sits between the two: decent EV adoption, smaller total volumes.

---

## 6. Alternative Fuel Landscape

Beyond EVs, the dataset tracks several alternative fuels:

- Biodiesel  
- E85 (ethanol flex fuel)  
- CNG (compressed natural gas)  
- Propane  
- Hydrogen  
- Methanol

### 6.1 National Perspective

- Alternative fuels overall represent **around 4–5%** of the vehicle fleet.
- **Biodiesel and E85** account for most of the alternative fuel volume.
- **CNG** is meaningful but more concentrated in a smaller set of states and
  specific use cases (fleets, heavy-duty, public transport).
- **Hydrogen and methanol** are clearly **niche**:
  - very low counts,
  - often concentrated in just a few states,
  - more experimental and infrastructure-dependent.

### 6.2 State-Level Diversity

A “fuel diversity index” was constructed based on how many fuel categories
cross internal volume thresholds per state.

Findings:

- Some Western and Midwestern states show **high fuel diversity** due to E85,
  biodiesel and CNG presence.
- Other states are almost entirely gasoline/diesel with minimal alternative
  fuel penetration.

This suggests that non-EV alternative fuels are often **regional and segment-
specific**, and will likely complement – not replace – the broader EV trend.

---

## 7. Economic & Market Indicators

Several indicators were built to better understand market maturity:

1. **EV per 1,000,000 gasoline vehicles**  
   - How many EVs exist relative to the gasoline fleet?
   - Higher values indicate faster EV transition in traditional-fuel-heavy
     environments.

2. **Alternative Fuel Market Share**  
   - Each state’s contribution to total U.S. alternative fuel vehicles.
   - Highlights key states for biodiesel, E85, CNG, etc.

3. **Fuel Diversity Index (FDI)**  
   - Number of fuel types above volume thresholds.
   - Indicates how broad the energy mix is in a state.

Combined, these metrics help distinguish:

- states that are modernizing their fleets,
- states that remain almost entirely gasoline/diesel,
- and states experimenting with multiple fuel technologies.

---

## 8. Policy Scoring & Priority States

A policy-oriented scoring framework was developed combining:

- EV adoption (EV% of the fleet),
- EV potential (non-EV vehicles that could transition),
- fuel diversity (ability to support multiple cleaner technologies).

A composite **readiness score** ranks states from 0 to 1.  
In parallel, a quadrant model maps each state by:

- EV volume (high vs low),
- EV adoption (above vs below average).

### 8.1 Quadrant Interpretation

- **High Adoption, High Volume**  
  Mature EV markets; focus on network optimization, reliability and grid
  integration rather than only new capacity.

- **High Volume, Low Adoption**  
  Large fleets, slow EV penetration; **priority for infrastructure build-out**,
  incentives and awareness campaigns.

- **High Adoption, Low Volume**  
  Emerging markets; targeted investment can scale these quickly.

- **Low Adoption, Low Volume**  
  Early-stage markets; keep monitoring and use pilot programs before large
  investments.

### 8.2 Suggested Priority States for EV Infrastructure

Based on the combination of:

- large total vehicle fleets,  
- growing but still sub-maximal EV adoption,  
- and strategic importance,

**three states stand out as priority candidates for EV infrastructure
investment:**

1. **Texas**  
   - Very large vehicle fleet, moderate EV adoption.  
   - High highway mileage and long-distance travel corridors.  
   - Significant potential to convert a small percentage of a huge fleet into
     EVs, generating large absolute gains.

2. **Florida**  
   - Large and growing population, strong urban clusters and tourism.  
   - EV adoption increasing but still below the levels of leading states like
     California.  
   - Coastal vulnerability and climate risks make decarbonization particularly
     relevant.

3. **New York**  
   - Large fleet and major urban concentration.  
   - Environmental policies exist, but infrastructure coverage can be uneven
     between metro and upstate areas.  
   - Strong candidate for reinforcing both urban charging and intercity
     corridors.

These states share a common profile:

- big impact on national emissions if EV adoption accelerates,
- enough existing EV presence to justify investment,
- but still far from saturation.

California, by contrast, already sits firmly in the “High Adoption, High
Volume” quadrant and may require **optimization-focused** policies (grid
planning, pricing, reliability) more than pure expansion.

---

## 9. Recommendations

### 9.1 Infrastructure

- Prioritize **Texas, Florida, and New York** for:
  - DC fast charging along major corridors,
  - Level 2 chargers in urban and suburban hubs,
  - coverage in multi-unit dwellings and workplace parking.

- Continue strengthening the Western region’s network, but with a focus on:
  - reliability,
  - congestion management,
  - integration with renewable generation and storage.

- In Southern and Midwestern states with very low EV adoption but large
  fleets, pilot:
  - corridor-based fast-charging projects,
  - fleet electrification (delivery, municipal, transit),
  - targeted incentives.

### 9.2 Policy & Incentives

- Align state-level incentives with readiness metrics:
  - higher support where readiness scores are good but adoption still lags.
- Combine financial incentives with non-monetary levers:
  - parking benefits,
  - HOV lane access,
  - municipal procurement commitments.

### 9.3 Monitoring & Data

- Refresh the dataset periodically to turn this into a **time-series** view of
  EV transition.
- Integrate charging station, energy pricing and grid capacity data for more
  detailed infrastructure planning.
- Track alternative fuels as complements to EVs in specific sectors
  (heavy-duty, long-haul, specialty fleets).

---

## 10. Limitations & Future Work

- Data is cross-sectional; trends over time are inferred, not directly
  observed.
- No explicit information on charging station density or utilization.
- Within-state variation (city vs rural) is not visible.
- Some alternative fuels have very small counts and are sensitive to
  measurement noise.

Future extensions:

- Incorporate time-series registration data to model EV diffusion curves.
- Join with charging network and grid data to assess local capacity.
- Build scenario analysis for EV adoption under different policy and
  infrastructure assumptions.

---

## 11. Conclusion

The analysis confirms that:

- EV adoption in the U.S. is still in early stages nationally but highly
  concentrated in a small set of states and regions.
- The West leads in both adoption and volume, while the South and Midwest
  remain heavily gasoline/diesel with significant but under-realized EV
  potential.
- Alternative fuels play a supporting, often niche role, with biodiesel and
  E85 being the most relevant categories.
- From a policy perspective, **Texas, Florida and New York** emerge as
  high-impact, high-priority targets for accelerated EV infrastructure
  deployment, while mature markets like California require optimization and
  long-term integration planning.

This project demonstrates how state-level registration data, combined with
careful SQL modeling, visualization and scoring, can directly support
real-world decisions on EV infrastructure and climate policy.
