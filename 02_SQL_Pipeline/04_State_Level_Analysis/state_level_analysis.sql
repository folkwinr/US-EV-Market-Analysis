/*
===============================================================================
Module: 04_State_Level_Analysis
File: state_level_analysis.sql
Purpose:
    Perform all state-level analytical computations, including:
    - Total vehicles per state
    - EV, PHEV, HEV and Gasoline share percentages
    - Ranking of states by EV adoption
    - Identifying top/bottom EV states
    - Comparing California with other major states
    - Building a state electrification index
===============================================================================
*/

USE EV_Analysis;
GO


/*-----------------------------------------------------------------------------
1) TOTAL VEHICLES PER STATE
-----------------------------------------------------------------------------*/

SELECT 
    state,
    (electric + phev + hev + biodiesel + e85 + cng + propane + 
     hydrogen + methanol + gasoline + diesel + unknown_fuel) AS total_vehicles
FROM Vehicle_Data;



/*-----------------------------------------------------------------------------
2) EV, PHEV, HEV, GASOLINE PERCENTAGES PER STATE
-----------------------------------------------------------------------------*/

SELECT 
    state,
    ROUND((electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane + 
         hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
        AS ev_percent,

    ROUND((phev * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane + 
         hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
        AS phev_percent,

    ROUND((hev * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane + 
         hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
        AS hev_percent,

    ROUND((gasoline * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane + 
         hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
        AS gas_percent
FROM Vehicle_Data
ORDER BY ev_percent DESC;



/*-----------------------------------------------------------------------------
3) TOP 5 STATES WITH HIGHEST EV ADOPTION
-----------------------------------------------------------------------------*/

SELECT TOP 5
    state,
    ROUND((electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane + 
         hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
         AS ev_percent
FROM Vehicle_Data
ORDER BY ev_percent DESC;



/*-----------------------------------------------------------------------------
4) BOTTOM 5 STATES WITH LOWEST EV ADOPTION
-----------------------------------------------------------------------------*/

SELECT TOP 5
    state,
    ROUND((electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane + 
         hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
         AS ev_percent
FROM Vehicle_Data
ORDER BY ev_percent ASC;



/*-----------------------------------------------------------------------------
5) CALIFORNIA vs TEXAS, FLORIDA, NEW YORK
-----------------------------------------------------------------------------*/

SELECT 
    state,
    ROUND((electric * 1.0 /
        (electric + phev + hev + gasoline + biodiesel + e85 + cng + propane +
         hydrogen + methanol + diesel + unknown_fuel)) * 100, 2) AS ev_percent
FROM Vehicle_Data
WHERE state IN ('California', 'Texas', 'Florida', 'New York')
ORDER BY ev_percent DESC;



/*-----------------------------------------------------------------------------
6) STATE ELECTRIFICATION INDEX
   Combines EV penetration and EV count to measure adoption maturity.
-----------------------------------------------------------------------------*/

WITH calc AS (
    SELECT
        state,
        electric,
        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel) AS total_vehicles,

        electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel)
        AS ev_percent_ratio,

        AVG(electric) OVER () AS avg_electric,
        AVG(
            electric * 1.0 /
            (electric + phev + hev + biodiesel + e85 + cng + propane +
             hydrogen + methanol + gasoline + diesel + unknown_fuel)
        ) OVER () AS avg_ev_percent_ratio
    FROM Vehicle_Data
)

SELECT
    state,
    electric AS total_evs,
    ROUND(ev_percent_ratio * 100, 2) AS ev_percent,

    CASE
        WHEN electric > avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'High Adoption + High Volume'
        WHEN electric > avg_electric AND ev_percent_ratio < avg_ev_percent_ratio
            THEN 'High Volume + Low Adoption'
        WHEN electric < avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'Low Volume + High Adoption'
        ELSE 'Low Adoption + Low Volume'
    END AS electrification_category

FROM calc
ORDER BY ev_percent_ratio DESC;


-- END OF MODULE
