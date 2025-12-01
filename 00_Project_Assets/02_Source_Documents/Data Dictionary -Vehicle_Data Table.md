# 📘 Data Dictionary – Vehicle_Data Table
This document describes all variables used in the EV Analysis project.
The dataset contains state-level counts of vehicle types across the United States.

---

## 🗂 Table Overview
| Item | Description |
|------|-------------|
| **Table Name** | `Vehicle_Data` |
| **Grain** | 1 row = 1 U.S. state |
| **Rows** | 51 (50 states + District of Columbia) |
| **Purpose** | Analyze EV adoption, fuel mix, regional differences, and infrastructure readiness |

---

# 🔢 Column Definitions

## 1. `state`
| Field | Description |
|-------|-------------|
| **Column Name** | `state` |
| **Description** | Name of the U.S. state (e.g., California, Texas). |
| **Data Type** | VARCHAR → cleaned to trimmed text |
| **Allowed Values** | 51 unique state names |
| **Cleaning Notes** | Trimmed whitespace, duplicates checked |

---

## 2. `electric`
| Field | Description |
|-------|-------------|
| **Column Name** | `electric` |
| **Description** | Number of fully electric vehicles (EVs) registered in the state. |
| **Data Type** | INT |
| **Unit** | Count (vehicles) |
| **Cleaning Notes** | Originally VARCHAR with commas → cleaned & cast to INT |

---

## 3. `phev`
| Field | Description |
|-------|-------------|
| **Column Name** | `phev` |
| **Description** | Plug-in Hybrid Electric Vehicles. |
| **Data Type** | INT |
| **Unit** | Count |
| **Cleaning Notes** | Commas removed → cast to INT |

---

## 4. `hev`
| Field | Description |
|-------|-------------|
| **Column Name** | `hev` |
| **Description** | Hybrid Electric Vehicles (non-plug-in). |
| **Data Type** | INT |
| **Unit** | Count |

---

## 5. `biodiesel`
| Field | Description |
|-------|-------------|
| **Column Name** | `biodiesel` |
| **Description** | Biodiesel engine vehicles registered in the state. |
| **Data Type** | INT |
| **Unit** | Count |

---

## 6. `e85`
| Field | Description |
|-------|-------------|
| **Column Name** | `e85` |
| **Description** | Flex-fuel (ethanol E85) vehicles. |
| **Data Type** | INT |
| **Unit** | Count |

---

## 7. `cng`
| Field | Description |
|-------|-------------|
| **Column Name** | `cng` |
| **Description** | Compressed Natural Gas vehicles. |
| **Data Type** | INT |
| **Unit** | Count |

---

## 8. `propane`
| Field | Description |
|-------|-------------|
| **Column Name** | `propane` |
| **Description** | Propane (LPG) vehicles. |
| **Data Type** | INT |
| **Unit** | Count |

---

## 9. `hydrogen`
| Field | Description |
|-------|-------------|
| **Column Name** | `hydrogen` |
| **Description** | Hydrogen fuel-cell vehicles. |
| **Data Type** | INT |
| **Unit** | Count |
| **Notes** | Very small values (<500) in most states |

---

## 10. `methanol`
| Field | Description |
|-------|-------------|
| **Column Name** | `methanol` |
| **Description** | Methanol fuel vehicles. Rare fuel type. |
| **Data Type** | INT |
| **Unit** | Count |

---

## 11. `gasoline`
| Field | Description |
|-------|-------------|
| **Column Name** | `gasoline` |
| **Description** | Gasoline vehicles registered in the state. |
| **Data Type** | INT |
| **Unit** | Count |
| **Notes** | Largest share in every state |

---

## 12. `diesel`
| Field | Description |
|-------|-------------|
| **Column Name** | `diesel` |
| **Description** | Diesel vehicles. |
| **Data Type** | INT |
| **Unit** | Count |

---

## 13. `unknown_fuel`
| Field | Description |
|-------|-------------|
| **Column Name** | `unknown_fuel` |
| **Description** | Vehicles with unspecified or unclassified fuel type. |
| **Data Type** | INT |
| **Unit** | Count |
| **Cleaning Notes** | Commas removed; cast to INT |

---

# 🧮 Derived Fields (Not in raw data but created during analysis)

These are **calculated in SQL** and appear in analysis outputs:

### `total_vehicles`
Sum of all fuel type counts.

### `ev_percent`
EV share of total vehicles.

### `ev_potential`
Non-EV vehicles (used in readiness score).

### `fuel_diversity`
Count of fuel types with significant presence.

### `readiness_score`  
Composite index of:
- EV adoption  
- EV potential  
- Fuel diversity  

---

# ✔ Summary
This data dictionary ensures that anyone reviewing the EV Analysis project clearly understands:

- What each column represents  
- How values are cleaned  
- How downstream metrics are derived  

