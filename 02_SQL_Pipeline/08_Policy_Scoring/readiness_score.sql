/*
===============================================================================
Module: 08_Policy_Scoring
Metric: EV Readiness Score
File: readiness_score.sql
Purpose:
    Build a composite "EV readiness" score per state, combining:
    - EV potential (non-EV vehicles that could transition)
    - EV adoption (current EV penetration)
    - Fuel diversity (multi-fuel ecosystem maturity)

    Score = 0.4 * EV Potential Score
          + 0.4 * EV Adoption Score
          + 0.2 * Fuel Diversity Index (FDI)
===============================================================================
*/

USE EV_Analysis;
GO


/*-----------------------------------------------------------------------------
1) BASE METRICS PER STATE
   - total_vehicles
   - electric (EV count)
   - ev_percent_ratio
   - ev_potential (non-EV vehicles)
   - fuel_diversity (count of significant fuel types)
-----------------------------------------------------------------------------*/

WITH base AS (
    SELECT
        state,

        -- Total vehicles (all fuel types)
        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel) AS total_vehicles,

        electric,

        -- EV penetration ratio (0–1)
        electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel) AS ev_percent_ratio,

        -- EV potential = non-EVs
        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel) - electric AS ev_potential,

        -- Fuel diversity count based on volume thresholds
        (
            (CASE WHEN phev > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN hev > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN biodiesel > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN e85 > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN cng > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN propane > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN hydrogen > 100 THEN 1 ELSE 0 END) +
            (CASE WHEN methanol > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN gasoline > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN diesel > 5000 THEN 1 ELSE 0 END) +
            (CASE WHEN unknown_fuel > 5000 THEN 1 ELSE 0 END)
        ) AS fuel_diversity
    FROM Vehicle_Data
),

/*-----------------------------------------------------------------------------
2) NORMALIZATION
   - Log-scale + min–max normalization for EV potential
   - Min–max normalization for EV adoption
   - Relative scaling for fuel diversity (0–1)
-----------------------------------------------------------------------------*/

norm AS (
    SELECT
        state,
        electric,
        ev_percent_ratio,
        ev_potential,
        fuel_diversity,

        -- Log-transform EV potential to reduce skew
        LOG(ev_potential + 1) AS ev_potential_log,

        MIN(LOG(ev_potential + 1)) OVER() AS min_log,
        MAX(LOG(ev_potential + 1)) OVER() AS max_log,

        -- 0–1 normalized potential score
        (LOG(ev_potential + 1) - MIN(LOG(ev_potential + 1)) OVER()) /
        NULLIF(MAX(LOG(ev_potential + 1)) OVER() - MIN(LOG(ev_potential + 1)) OVER(), 0)
        AS ev_potential_score,

        -- 0–1 normalized adoption score
        (ev_percent_ratio - MIN(ev_percent_ratio) OVER()) /
        NULLIF(MAX(ev_percent_ratio) OVER() - MIN(ev_percent_ratio) OVER(), 0)
        AS ev_adoption_score,

        -- Fuel diversity scaled to [0,1]
        fuel_diversity * 1.0 / MAX(fuel_diversity) OVER() AS fdi_score
    FROM base
)

SELECT
    state,
    electric,
    ROUND(ev_percent_ratio * 100, 2) AS ev_percent,
    ev_potential,
    fuel_diversity,

    ROUND(ev_potential_score, 3) AS ev_potential_score,
    ROUND(ev_adoption_score, 3) AS ev_adoption_score,
    ROUND(fdi_score, 3)         AS fdi_score,

    -- Final composite readiness score
    ROUND(
        (0.4 * ev_potential_score) +
        (0.4 * ev_adoption_score) +
        (0.2 * fdi_score),
    3) AS readiness_score

FROM norm
ORDER BY readiness_score DESC;

-- High readiness_score → strong candidate for EV acceleration policies.
