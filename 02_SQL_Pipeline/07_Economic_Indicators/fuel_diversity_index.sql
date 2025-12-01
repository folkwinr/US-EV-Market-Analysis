/*
===============================================================================
Metric: Fuel Diversity Index (FDI)
File: fuel_diversity_index.sql
Purpose:
    Measures how many alternative fuels exceed meaningful thresholds.
    Represents complexity & diversification of the state's energy portfolio.
===============================================================================
*/

USE EV_Analysis;
GO

SELECT 
    state,
    (CASE WHEN phev > 5000 THEN 1 ELSE 0 END +
     CASE WHEN hev > 5000 THEN 1 ELSE 0 END +
     CASE WHEN biodiesel > 5000 THEN 1 ELSE 0 END +
     CASE WHEN e85 > 5000 THEN 1 ELSE 0 END +
     CASE WHEN cng > 5000 THEN 1 ELSE 0 END +
     CASE WHEN propane > 5000 THEN 1 ELSE 0 END +
     CASE WHEN hydrogen > 100 THEN 1 ELSE 0 END +
     CASE WHEN methanol > 5000 THEN 1 ELSE 0 END +
     CASE WHEN gasoline > 5000 THEN 1 ELSE 0 END +
     CASE WHEN diesel > 5000 THEN 1 ELSE 0 END +
     CASE WHEN unknown_fuel > 5000 THEN 1 ELSE 0 END
    ) AS fuel_diversity
FROM Vehicle_Data
ORDER BY fuel_diversity DESC;

-- High value → more complex, diverse energy system
