# 🌎 Regional Analysis Module  
**Folder:** `05_Regional_Analysis`  
**Files:**  
- `regional_analysis.sql`  
- `regional_electrification_view.sql`  

This module performs all region-based calculations and aggregations, using the
`Vehicle_With_Region` view created in the enrichment phase.

---

## 📌 Key Outputs

### **1. Regional Totals**
Aggregates all fuel types per region:
- EV  
- PHEV  
- HEV  
- Gasoline  
- Diesel  
- Alternative fuels  

### **2. Weighted EV / PHEV / HEV Percentages**
Accounts for different population sizes across regions.

### **3. Full Fuel Distribution**
Breakdown of:
- Electrified vehicles  
- Fossil fuels  
- Alternative fuels  

### **4. Regional Electrification Summary**
Creates KPI-style regional adoption metrics.

---

## 📌 The VIEW: `Regional_Electrification`

A separate VIEW is created to support:

- BI dashboards  
- Tableau / Power BI maps  
- Policy modeling  
- Cross-regional comparative analysis  

It contains:
- EV %  
- PHEV %  
- HEV %  
- Total EVs per region  

---

## 📝 Notes
Regional segmentation is a core analytical layer. It allows high-level EV 
adoption insights and supports economic and policy analysis done in later 
modules.

