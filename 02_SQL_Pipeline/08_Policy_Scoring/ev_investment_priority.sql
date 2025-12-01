
/*
===============================================================================
Metric: EV Investment / Infrastructure Priority Quadrants
File: ev_investment_priority.sql
===============================================================================
*/

USE EV_Analysis;
GO

WITH calc AS (
    SELECT
        state,
        electric,

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
    electric AS total_electric_vehicles,
    ROUND(ev_percent_ratio * 100, 2) AS ev_percent,

    /*-----------------------------------------------------------------------
    4 CATEGORIES
    -----------------------------------------------------------------------*/
    CASE
        WHEN electric > avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'High Adoption, High Volume'
        WHEN electric > avg_electric AND ev_percent_ratio < avg_ev_percent_ratio
            THEN 'High Volume, Low Adoption'
        WHEN electric < avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'High Adoption, Low Volume'
        ELSE 'Low Adoption, Low Volume'
    END AS infrastructure_priority_segment,

    /*-----------------------------------------------------------------------
    DESCRIPTIONS FOR EACH CATEGORY
    -----------------------------------------------------------------------*/
    CASE
        WHEN electric > avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'Mature EV Market – Strong demand & strong volume'
        WHEN electric > avg_electric AND ev_percent_ratio < avg_ev_percent_ratio
            THEN 'Infrastructure Priority – Large fleet but slow EV penetration'
        WHEN electric < avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'Emerging Market – High adoption but small vehicle base'
        ELSE 'Early Stage Market – Low adoption & low volume'
    END AS infrastructure_priority_description

FROM calc
ORDER BY ev_percent_ratio DESC;
