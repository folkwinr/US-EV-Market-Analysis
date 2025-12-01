/*
===============================================================================
Module: 06_Alt_Fuel_Analysis
File: alt_fuel_analysis.sql
Purpose:
    Analyze alternative fuel adoption across U.S. states, including:
    - Alternative fuel percentages
    - State ranking by alt-fuel volume
    - Alt-fuel diversity index
    - State-level alt-fuel market contribution
    - Ordering alternative fuels by volume per state
===============================================================================
*/

USE EV_Analysis;
GO


/*-----------------------------------------------------------------------------
1) NATIONAL-LEVEL ALTERNATIVE FUEL PERCENTAGES
-----------------------------------------------------------------------------*/

SELECT
    ROUND((SUM(biodiesel) * 1.0 /
          SUM(electric + phev + hev + biodiesel + e85 + cng + propane +
              hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
          AS biodiesel_percent,

    ROUND((SUM(e85) * 1.0 /
          SUM(electric + phev + hev + biodiesel + e85 + cng + propane +
              hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
          AS ethanol_percent,

    ROUND((SUM(hydrogen) * 1.0 /
          SUM(electric + phev + hev + biodiesel + e85 + cng + propane +
              hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
          AS hydrogen_percent,

    ROUND((SUM(cng) * 1.0 /
          SUM(electric + phev + hev + biodiesel + e85 + cng + propane +
              hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
          AS cng_percent,

    ROUND((SUM(propane) * 1.0 /
          SUM(electric + phev + hev + biodiesel + e85 + cng + propane +
              hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 4)
          AS propane_percent,

    ROUND((SUM(methanol) * 1.0 /
          SUM(electric + phev + hev + biodiesel + e85 + cng + propane +
              hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 4)
          AS methanol_percent
FROM Vehicle_Data;



/*-----------------------------------------------------------------------------
2) NATIONAL TOTALS OF ALTERNATIVE FUELS
-----------------------------------------------------------------------------*/

SELECT
    SUM(biodiesel) AS total_biodiesel,
    SUM(e85)       AS total_e85,
    SUM(hydrogen)  AS total_hydrogen,
    SUM(cng)       AS total_cng,
    SUM(propane)   AS total_propane,
    SUM(methanol)  AS total_methanol
FROM Vehicle_Data;



/*-----------------------------------------------------------------------------
3) ALTERNATIVE FUEL SHARE PER STATE (%)
-----------------------------------------------------------------------------*/

SELECT 
    state,
    ROUND(
        ((biodiesel + e85 + cng + propane + hydrogen + methanol) * 1.0 /
        (electric + phev + hev + gasoline + biodiesel + e85 + cng +
         propane + hydrogen + methanol + diesel + unknown_fuel)) * 100,
    2) AS alt_fuel_share
FROM Vehicle_Data
ORDER BY alt_fuel_share DESC;



/*-----------------------------------------------------------------------------
4) NICHE FUEL VARIETY INDEX
   Counts how many alt-fuel types exceed a threshold (state-level diversity)
-----------------------------------------------------------------------------*/

SELECT 
    state,
    (CASE WHEN biodiesel > 1000 THEN 1 ELSE 0 END +
     CASE WHEN e85 > 1000 THEN 1 ELSE 0 END +
     CASE WHEN cng > 1000 THEN 1 ELSE 0 END +
     CASE WHEN propane > 1000 THEN 1 ELSE 0 END +
     CASE WHEN hydrogen > 10 THEN 1 ELSE 0 END +
     CASE WHEN methanol > 100 THEN 1 ELSE 0 END
    ) AS alt_fuel_variety
FROM Vehicle_Data
ORDER BY alt_fuel_variety DESC;



/*-----------------------------------------------------------------------------
5) STATE-LEVEL ALT-FUEL MARKET SHARE (US CONTRIBUTION)
-----------------------------------------------------------------------------*/

WITH base AS (
    SELECT
        state,
        (biodiesel + e85 + cng + propane + hydrogen + methanol) AS state_alt_fuel,
        SUM(biodiesel + e85 + cng + propane + hydrogen + methanol)
            OVER () AS us_alt_fuel
    FROM Vehicle_Data
),
calc AS (
    SELECT
        state,
        state_alt_fuel,
        us_alt_fuel,
        state_alt_fuel * 1.0 / us_alt_fuel AS alt_fuel_share,
        RANK() OVER (ORDER BY state_alt_fuel DESC) AS alt_fuel_rank
    FROM base
)

SELECT TOP 10
    state,
    state_alt_fuel,
    us_alt_fuel,
    FORMAT(alt_fuel_share, 'P4') AS alt_fuel_share,
    alt_fuel_rank
FROM calc
ORDER BY alt_fuel_rank;



/*-----------------------------------------------------------------------------
6) ORDER ALTERNATIVE FUELS BY VOLUME PER STATE
-----------------------------------------------------------------------------*/

SELECT
    v.state,
    STRING_AGG(f.fuel_name, ' > ') 
        WITHIN GROUP (ORDER BY f.fuel_value DESC) AS alt_fuel_order
FROM Vehicle_Data v
CROSS APPLY (
    VALUES
        ('Biodiesel', v.biodiesel),
        ('E85',       v.e85),
        ('CNG',       v.cng),
        ('Propane',   v.propane),
        ('Hydrogen',  v.hydrogen),
        ('Methanol',  v.methanol)
) AS f(fuel_name, fuel_value)
GROUP BY v.state
ORDER BY v.state;


-- END OF MODULE
