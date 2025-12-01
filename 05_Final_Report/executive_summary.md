# Executive Summary – U.S. EV & Alternative Fuel Market

## Context

A national transportation board is evaluating where to expand electric vehicle
(EV) charging infrastructure across the United States. To support this
decision, state-level vehicle registration data by fuel type (EV, PHEV, HEV,
gasoline, diesel and alternative fuels) was analyzed using SQL and visualized
in Tableau dashboards.

The objective is to answer:

- Where is EV adoption strongest or weakest?
- Which alternative fuels matter today?
- Which states should be prioritized for new EV infrastructure investment?

---

## National Snapshot

- Total vehicles: ≈ **287 million**
- Total EVs: ≈ **3.6 million**
- EV adoption rate: ≈ **1.2%** of the fleet
- Alternative fuel share (non-gasoline/diesel): ≈ **4.3%**

The U.S. fleet remains overwhelmingly gasoline/diesel. EVs are growing quickly
but are **highly concentrated in a small number of states**.

---

## Key Findings

### 1. State-Level EV Adoption

- **California** is the clear leader with EV adoption above **3%** of its
  fleet, more than double the national average.
- Other leaders include **D.C., Hawaii, Washington, Nevada, New Jersey and
  Oregon**, all above or near ~1.5–2% EV share.
- Many Southern and Midwestern states have **EV shares well below 1%**, with
  fleets still dominated by gasoline and diesel.

### 2. Regional Electrification

- The **West** region has the highest EV penetration (~2.5%) and accounts for
  **over half of all U.S. EVs**.
- The **Northeast** shows moderate EV penetration (~1.1%), with several
  policy-active states but smaller fleets.
- The **South** and **Midwest** have the lowest EV penetration (≈0.6–0.9%),
  but very large total fleets – a key signal of unrealized potential.

### 3. Alternative Fuel Insights

- **Biodiesel and E85 (ethanol)** make up most of the alternative fuel volume.
- **CNG** is meaningful but concentrated in specific states and fleet
  applications.
- **Hydrogen and methanol** are niche, with very low counts and limited
  geographic spread.
- Overall alternative fuels account for about **4–5%** of the fleet and often
  complement, rather than compete with, EV adoption.

### 4. Economic & Readiness Indicators

- A combined **readiness score** was constructed from:
  - EV adoption (EV%),
  - EV potential (non-EV vehicles),
  - fuel diversity.
- A quadrant model positions states by:
  - EV volume (high vs low),
  - EV adoption (above vs below average).

This framework distinguishes:

- **Mature EV markets** – high adoption, high volume (e.g., California).
- **Infrastructure priority markets** – high volume, low adoption.
- **Emerging markets** – high adoption, low volume.
- **Early-stage markets** – low adoption, low volume.

---

## Priority States for Infrastructure Investment

Based on fleet size, EV penetration, regional position and readiness metrics,
**three states are recommended as first-tier priorities**:

1. **Texas**
   - Very large vehicle fleet and extensive highway network.
   - Moderate but rising EV adoption.
   - High potential impact from even small percentage increases in EV share.

2. **Florida**
   - Large, growing population with strong tourism and coastal risk exposure.
   - EV adoption below leading states but trending upward.
   - Strong business case for corridor charging and dense urban networks.

3. **New York**
   - High-density urban areas plus large upstate regions.
   - Environmental policies in place, but charging coverage can be uneven.
   - Strategic for both public transit integration and private EV growth.

California is not ignored, but treated as a **mature market** where the focus
shifts from simply adding chargers to optimizing the network, improving
reliability and integrating with the power grid.

---

## Recommendations

1. **Short-Term (0–3 years)**
   - Prioritize deployment of DC fast chargers and Level 2 networks in:
     - Texas, Florida, New York (high impact, high readiness).
   - Launch pilot programs in selected Southern and Midwestern states with
     very low EV shares but large fleets.

2. **Medium-Term (3–7 years)**
   - Strengthen corridor coverage between major metro areas and across regions.
   - Integrate EV planning with grid capacity and renewable energy projects.
   - Expand support for fleet electrification (delivery, municipal, transit).

3. **Monitoring & Data**
   - Convert this snapshot into a recurring, time-series analysis.
   - Add charging station data, utilization, and pricing to future iterations.
   - Track alternative fuel usage as a complementary pathway for specific
     vehicle segments.

---

## Conclusion

The analysis shows that:

- EV adoption is **uneven and regionally concentrated**.
- The West leads, but the South and Midwest contain large, under-served
  markets.
- Alternative fuels play a niche but non-trivial role, particularly in certain
  states and fleet types.
- Targeted infrastructure investments in **Texas, Florida and New York** offer
  some of the highest near-term leverage for accelerating U.S. EV adoption.

This project demonstrates how state-level data, structured SQL analysis and
clear visualization can directly inform EV policy and infrastructure planning.
