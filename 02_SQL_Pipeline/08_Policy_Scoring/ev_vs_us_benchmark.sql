/*
===============================================================================
Metric: EV vs U.S. Benchmark
File: ev_vs_us_benchmark.sql
Purpose:
    Compare each state to the overall U.S. average EV penetration and
    vehicle market structure. Key metrics:
    - EV penetration (state)
    - Share of total U.S. EVs
    - Share of total U.S. vehicles
    - State EV vs U.S. average penetration ratio
    - EV potential (non-EVs)
    - Ranking by EV count & penetration
===============================================================================
*/

USE EV_Analysis;
GO


/*-----------------------------------------------------------------------------
1) BASE METRICS (STATE + U.S. TOTALS)
-----------------------------------------------------------------------------*/

WITH base AS (
    SELECT
        state,
        electric,

        (electric + phev + hev + biodiesel + e85 + cng +
         propane + hydrogen + methanol + gasoline +
         diesel + unknown_fuel) AS total_vehicles,

        -- State-level EV penetration
        electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng +
         propane + hydrogen + methanol + gasoline +
         diesel + unknown_fuel)
        AS ev_penetration_raw,

        -- U.S.-level totals (window functions)
        SUM(electric) OVER () AS us_electric,
        SUM(
            electric + phev + hev + biodiesel + e85 + cng +
            propane + hydrogen + methanol + gasoline +
            diesel + unknown_fuel
        ) OVER () AS us_total_vehicles
    FROM Vehicle_Data
),

/*-----------------------------------------------------------------------------
2) DERIVED SHARES AND RATIOS
-----------------------------------------------------------------------------*/

calc AS (
    SELECT
        state,
        electric,
        total_vehicles,
        ev_penetration_raw,
        us_electric,
        us_total_vehicles,

        -- State EV share of all U.S. EVs
        electric * 1.0 / us_electric AS ev_share_us_raw,

        -- State EV share of all U.S. vehicles
        electric * 1.0 / us_total_vehicles AS ev_share_us_total_raw,

        -- State vehicle market share (all fuels)
        total_vehicles * 1.0 / us_total_vehicles AS state_vehicle_market_share_raw,

        -- Ratio of state EV penetration vs U.S. average EV penetration
        ev_penetration_raw /
        (us_electric * 1.0 / us_total_vehicles)
        AS ev_vs_us_ratio_raw,

        -- EV potential = non-EVs (vehicles that could transition)
        total_vehicles - electric AS ev_potential
    FROM base
)

SELECT
    state,
    electric,
    total_vehicles,

    FORMAT(ev_penetration_raw, 'P2')       AS ev_penetration,
    FORMAT(ev_share_us_raw, 'P2')          AS ev_share_us,
    FORMAT(ev_share_us_total_raw, 'P4')    AS ev_share_us_total,
    FORMAT(state_vehicle_market_share_raw, 'P2') AS state_vehicle_market_share,
    FORMAT(ev_vs_us_ratio_raw, 'N2')       AS ev_vs_us_ratio,

    ev_potential,

    RANK() OVER (ORDER BY electric DESC)         AS ev_count_rank,
    RANK() OVER (ORDER BY ev_penetration_raw DESC) AS ev_penetration_rank

FROM calc
ORDER BY electric DESC;

-- High ev_vs_us_ratio → state outperforms U.S. average EV penetration.
