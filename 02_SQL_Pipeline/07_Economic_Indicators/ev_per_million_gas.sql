/*
===============================================================================
Metric: EV per 1 Million Gasoline Vehicles
File: ev_per_million_gas.sql
Purpose:
    Measures EV maturity relative to traditional vehicle population.
    Formula: (EV / Gasoline) * 1,000,000
===============================================================================
*/

USE EV_Analysis;
GO

SELECT 
    state,
    ROUND((electric * 1.0 / gasoline) * 1000000, 2) AS ev_per_million_gas
FROM Vehicle_Data
ORDER BY ev_per_million_gas DESC;

-- High value → advanced EV market maturity
