# 🔧 Data Enrichment Module  
**Folder:** `03_Data_Enrichment`  
**File:** `data_enrichment.sql`  

This module creates enriched and derived fields that make the dataset more
usable for downstream analytics, state/regional comparisons, and visualization.

---

## 📌 Key Enhancements

### **1. State Name Normalization**
- Removes leading/trailing whitespace
- Ensures consistency for joins and grouping

### **2. Region Classification**
A new field `region` is added using U.S. Census Bureau definitions:

- **West**
- **Northeast**
- **South**
- **Midwest**

This is implemented inside a SQL VIEW called:

This view is essential for regional EV adoption, alternative fuel analysis, 
and regional electrification scoring.

### **3. Optional Derived Metrics**
The module contains examples of calculated fields:

- `alt_fuel_total`  
- `total_electrified` (EV + PHEV + HEV)

These are often needed for dashboards or multi-fuel comparison studies.

---

## 📁 Output Summary
After running this module, you get:

### ✔ `Vehicle_With_Region` View  
A structured view with `region` added to all state rows.

### ✔ Clean and normalized state names  
Avoids grouping and aggregation errors.

### ✔ Optional enriched metrics  
Useful for data visualization tools such as Power BI, Tableau, or Python.

---

## 📝 Notes
This enrichment layer serves as a **semantic layer**, meaning it organizes and 
standardizes the data for interpretation—critical for analytics pipelines and BI.


