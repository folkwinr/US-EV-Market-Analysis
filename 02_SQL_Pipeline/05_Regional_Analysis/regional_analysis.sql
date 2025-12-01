/*
===============================================================================
Module: 05_Regional_Analysis
File: regional_analysis.sql
Purpose:
    Perform all regional-level aggregation and electrification calculations,
    including:
    - Regional EV/PHEV/HEV percentages
    - Weighted fuel distribution
    - Total EV counts by region
    - Regional electrification ranking
===============================================================================
*/

USE EV_Analysis;
GO


/*-----------------------------------------------------------------------------
1) REGIONAL TOTALS
   Aggregate all numeric fuel-type columns by region.
-----------------------------------------------------------------------------*/

WITH totals AS (
    SELECT
        region,
        SUM(electric) AS electric,
        SUM(phev) AS phev,
        SUM(hev) AS hev,
        SUM(biodiesel) AS biodiesel,
        SUM(e85) AS e85,
        SUM(cng) AS cng,
        SUM(propane) AS propane,
        SUM(hydrogen) AS hydrogen,
        SUM(methanol) AS methanol,
        SUM(gasoline) AS gasoline,
        SUM(diesel) AS diesel,
        SUM(unknown_fuel) AS unknown_fuel,
        SUM(
            electric + phev + hev +
            biodiesel + e85 + cng + propane +
            hydrogen + methanol + gasoline + diesel + unknown_fuel
        ) AS total_vehicles
    FROM Vehicle_With_Region
    GROUP BY region
)

SELECT *
FROM totals
ORDER BY total_vehicles DESC;



/*-----------------------------------------------------------------------------
2) WEIGHTED REGIONAL FUEL PERCENTAGES
-----------------------------------------------------------------------------*/

WITH totals AS (
    SELECT
        region,
        SUM(electric) AS electric,
        SUM(phev) AS phev,
        SUM(hev) AS hev,
        SUM(gasoline) AS gasoline,
        SUM(
            electric + phev + hev +
            biodiesel + e85 + cng + propane +
            hydrogen + methanol + gasoline + diesel + unknown_fuel
        ) AS total_vehicles
    FROM Vehicle_With_Region
    GROUP BY region
)

SELECT
    region,
    ROUND(electric * 1.0 / total_vehicles * 100, 2) AS weighted_ev_percent,
    ROUND(phev * 1.0 / total_vehicles * 100, 2) AS weighted_phev_percent,
    ROUND(hev * 1.0 / total_vehicles * 100, 2) AS weighted_hev_percent,
    ROUND(gasoline * 1.0 / total_vehicles * 100, 2) AS weighted_gas_percent
FROM totals
ORDER BY weighted_ev_percent DESC;



/*-----------------------------------------------------------------------------
3) FULL FUEL DISTRIBUTION BY REGION
-----------------------------------------------------------------------------*/

WITH totals AS (
    SELECT
        region,
        SUM(electric) AS electric,
        SUM(phev) AS phev,
        SUM(hev) AS hev,
        SUM(biodiesel) AS biodiesel,
        SUM(e85) AS e85,
        SUM(cng) AS cng,
        SUM(propane) AS propane,
        SUM(hydrogen) AS hydrogen,
        SUM(methanol) AS methanol,
        SUM(gasoline) AS gasoline,
        SUM(diesel) AS diesel,
        SUM(unknown_fuel) AS unknown_fuel,
        SUM(
            electric + phev + hev +
            biodiesel + e85 + cng + propane +
            hydrogen + methanol + gasoline + diesel + unknown_fuel
        ) AS total_vehicles
    FROM Vehicle_With_Region
    GROUP BY region
)

SELECT
    region,
    ROUND(electric * 1.0 / total_vehicles * 100, 2) AS ev_percent,
    ROUND(phev * 1.0 / total_vehicles * 100, 2) AS phev_percent,
    ROUND(hev * 1.0 / total_vehicles * 100, 2) AS hev_percent,
    ROUND(gasoline * 1.0 / total_vehicles * 100, 2) AS gas_percent,
    ROUND(diesel * 1.0 / total_vehicles * 100, 2) AS diesel_percent,
    ROUND(
        (biodiesel + e85 + cng + propane + hydrogen + methanol + unknown_fuel)
        * 1.0 / total_vehicles * 100, 2
    ) AS alternative_fuel_percent,
    ROUND((gasoline + diesel) * 1.0 / total_vehicles * 100, 2) AS fossil_percent
FROM totals
ORDER BY ev_percent DESC;



/*-----------------------------------------------------------------------------
4) REGIONAL ELECTRIFICATION SUMMARY
   Useful for BI dashboards and policy reports.
-----------------------------------------------------------------------------*/

WITH totals AS (
    SELECT
        region,
        SUM(electric) AS electric,
        SUM(phev) AS phev,
        SUM(hev) AS hev,
        SUM(
            electric + phev + hev +
            biodiesel + e85 + cng + propane +
            hydrogen + methanol + gasoline + diesel + unknown_fuel
        ) AS total_vehicles
    FROM Vehicle_With_Region
    GROUP BY region
)

SELECT
    region,
    electric AS total_electric_vehicles,
    ROUND(electric * 1.0 / total_vehicles * 100, 2) AS ev_percent,
    ROUND(phev * 1.0 / total_vehicles * 100, 2) AS phev_percent,
    ROUND(hev * 1.0 / total_vehicles * 100, 2) AS hev_percent
FROM totals
ORDER BY ev_percent DESC;


-- END OF MODULE
