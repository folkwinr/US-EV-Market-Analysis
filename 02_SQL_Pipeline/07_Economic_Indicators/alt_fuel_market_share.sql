/*
===============================================================================
Metric: Alternative Fuel Market Share (State Contribution)
File: alt_fuel_market_share.sql
Purpose:
    Measures each state's contribution to total U.S. alternative fuel usage.
    Useful for federal energy policy and infrastructure planning.
===============================================================================
*/

USE EV_Analysis;
GO

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

-- High share → strategic states for alternative fuel expansion
