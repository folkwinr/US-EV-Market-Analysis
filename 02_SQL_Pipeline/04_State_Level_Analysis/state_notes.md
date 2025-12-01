# 🚗 State-Level Analysis Module  
**Folder:** `04_State_Level_Analysis`  
**File:** `state_level_analysis.sql`

This module performs all analysis at the *state* level, enabling comparisons
across U.S. states and identifying EV adoption patterns.

---

## 📌 Key Metrics Calculated

### **1. Total Vehicles per State**
Sum of all fuel categories:
- EV  
- PHEV  
- HEV  
- Gasoline  
- Diesel  
- Alternative fuels  

This provides the vehicle market size for each state.

---

### **2. EV / PHEV / HEV / Gasoline Percentages**
Each fuel type is converted into a percentage of total vehicles.  
This is critical for comparing adoption levels between states of different sizes.

---

### **3. Top 5 EV States**
Identifies the states leading in EV penetration.

### **4. Bottom 5 EV States**
Shows where EV adoption remains lowest.

---

### **5. California vs Major States**
A benchmark comparing:
- California  
- Texas  
- Florida  
- New York  

This highlights early vs late adopters.

---

### **6. State Electrification Index**
A composite indicator combining:
- EV penetration  
- EV volume  

Used to categorize states as:
- **High Adoption + High Volume**  
- **High Volume + Low Adoption**  
- **Low Volume + High Adoption**  
- **Low Adoption + Low Volume**

This index is valuable for:
- Market maturity analysis  
- Infrastructure planning  
- Investment prioritization  

---

## 📁 Output Summary

Running this module provides:

✔ Percentage breakdown of EV adoption by state  
✔ Rankings (highest → lowest EV share)  
✔ State clusters based on EV maturity  
✔ Benchmark comparison between major states  

---

## 📝 Notes
This module feeds directly into regional analysis, economic indicators,  
and policy scoring. It is one of the core analytical layers of the pipeline.

