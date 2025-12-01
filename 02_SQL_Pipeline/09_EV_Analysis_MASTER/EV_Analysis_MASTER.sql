/*
===============================================================================
Project: EV Analysis – Master SQL Pipeline
File   : EV_Analysis_MASTER.sql
Purpose:
    End-to-end SQL pipeline for the EV Analysis project.
    This script runs all major steps in order:

        01 – Data Inspection
        02 – Data Cleaning
        03 – Data Enrichment (Region mapping)
        04 – State Level Analysis
        05 – Regional Analysis
        06 – Alternative Fuel Analysis
        07 – Economic Indicators
        08 – Policy Scoring

    Note:
        - Run this script in the EV_Analysis database.
        - Parts 01–03 modify or define objects (UPDATE, ALTER, VIEW).
        - Parts 04–08 are analytical SELECTs (no data changes).
===============================================================================
*/

USE EV_Analysis;
GO


/*=============================================================================
01) DATA INSPECTION
   Quick sanity checks on the raw Vehicle_Data table.
=============================================================================*/

PRINT '01) DATA INSPECTION – preview, row count, columns';
-- Preview first 10 rows
SELECT TOP 10 * FROM Vehicle_Data;

-- Row count
SELECT COUNT(*) AS row_count
FROM Vehicle_Data;

-- Column list
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Vehicle_Data';
GO



/*=============================================================================
02) DATA CLEANING
   - Standardize column names
   - Remove commas from numeric text fields
   - Cast VARCHAR → INT
   - Trim whitespace
   - Check NULLs & duplicates
=============================================================================*/

PRINT '02) DATA CLEANING – renaming columns';
-- 2.1 Rename columns (make them SQL-friendly)
EXEC sp_rename 'Vehicle_Data.[State]', 'state', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Electric (EV)]', 'electric', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Plug-In Hybrid Electric (PHEV)]', 'phev', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Hybrid Electric (HEV)]', 'hev', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Biodiesel]', 'biodiesel', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Ethanol Flex (E85)]', 'e85', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Compressed Natural Gas (CNG)]', 'cng', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Propane]', 'propane', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Hydrogen]', 'hydrogen', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Methanol]', 'methanol', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Gasoline]', 'gasoline', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Diesel]', 'diesel', 'COLUMN';
EXEC sp_rename 'Vehicle_Data.[Unknown Fuel]', 'unknown_fuel', 'COLUMN';
GO

PRINT '02) DATA CLEANING – removing comma separators';
-- 2.2 Strip commas from numeric text fields
UPDATE Vehicle_Data
SET 
    electric      = REPLACE(electric, ',', ''),
    phev          = REPLACE(phev, ',', ''),
    hev           = REPLACE(hev, ',', ''),
    biodiesel     = REPLACE(biodiesel, ',', ''),
    e85           = REPLACE(e85, ',', ''),
    cng           = REPLACE(cng, ',', ''),
    propane       = REPLACE(propane, ',', ''),
    hydrogen      = REPLACE(hydrogen, ',', ''),
    methanol      = REPLACE(methanol, ',', ''),
    gasoline      = REPLACE(gasoline, ',', ''),
    diesel        = REPLACE(diesel, ',', ''),
    unknown_fuel  = REPLACE(unknown_fuel, ',', '');
GO

PRINT '02) DATA CLEANING – casting VARCHAR columns to INT';
-- 2.3 Cast columns to INT
ALTER TABLE Vehicle_Data ALTER COLUMN electric INT;
ALTER TABLE Vehicle_Data ALTER COLUMN phev INT;
ALTER TABLE Vehicle_Data ALTER COLUMN hev INT;
ALTER TABLE Vehicle_Data ALTER COLUMN biodiesel INT;
ALTER TABLE Vehicle_Data ALTER COLUMN e85 INT;
ALTER TABLE Vehicle_Data ALTER COLUMN cng INT;
ALTER TABLE Vehicle_Data ALTER COLUMN propane INT;
ALTER TABLE Vehicle_Data ALTER COLUMN hydrogen INT;
ALTER TABLE Vehicle_Data ALTER COLUMN methanol INT;
ALTER TABLE Vehicle_Data ALTER COLUMN gasoline INT;
ALTER TABLE Vehicle_Data ALTER COLUMN diesel INT;
ALTER TABLE Vehicle_Data ALTER COLUMN unknown_fuel INT;
GO

PRINT '02) DATA CLEANING – trimming state names';
-- 2.4 Trim whitespace on state field
UPDATE Vehicle_Data
SET state = LTRIM(RTRIM(state));
GO

PRINT '02) DATA CLEANING – NULL + duplicate checks';
-- 2.5 NULL check
SELECT COUNT(*) AS null_count
FROM Vehicle_Data
WHERE
    electric IS NULL
 OR phev IS NULL
 OR hev IS NULL
 OR biodiesel IS NULL
 OR e85 IS NULL
 OR cng IS NULL
 OR propane IS NULL
 OR hydrogen IS NULL
 OR methanol IS NULL
 OR gasoline IS NULL
 OR diesel IS NULL
 OR unknown_fuel IS NULL;

-- 2.6 Duplicate state check
SELECT state, COUNT(*) AS duplicate_count
FROM Vehicle_Data
GROUP BY state
HAVING COUNT(*) > 1;
GO



/*=============================================================================
03) DATA ENRICHMENT
   - Normalize state names (already trimmed above)
   - Add region classification via view Vehicle_With_Region
=============================================================================*/

PRINT '03) DATA ENRICHMENT – creating Vehicle_With_Region view';

IF OBJECT_ID('Vehicle_With_Region', 'V') IS NOT NULL
    DROP VIEW Vehicle_With_Region;
GO

CREATE VIEW Vehicle_With_Region AS
SELECT
    *,
    CASE
        WHEN state IN (
            'California','Oregon','Washington','Alaska','Hawaii',
            'Nevada','Idaho','Montana','Wyoming','Utah','Colorado',
            'Arizona','New Mexico'
        ) THEN 'West'

        WHEN state IN (
            'Maine','New Hampshire','Vermont','Massachusetts','Rhode Island',
            'Connecticut','New York','New Jersey','Pennsylvania'
        ) THEN 'Northeast'

        WHEN state IN (
            'Delaware','District of Columbia','Maryland','Virginia','West Virginia',
            'Kentucky','Tennessee','North Carolina','South Carolina','Georgia','Florida',
            'Alabama','Mississippi','Arkansas','Louisiana','Oklahoma','Texas'
        ) THEN 'South'

        WHEN state IN (
            'Ohio','Indiana','Illinois','Michigan','Wisconsin','Minnesota','Iowa',
            'Missouri','North Dakota','South Dakota','Nebraska','Kansas'
        ) THEN 'Midwest'

        ELSE 'Unknown'
    END AS region
FROM Vehicle_Data;
GO



/*=============================================================================
04) STATE LEVEL ANALYSIS
   - Total vehicles per state
   - EV / PHEV / HEV / Gas percentages
   - Top/Bottom EV states
   - State electrification categories
=============================================================================*/

PRINT '04) STATE LEVEL ANALYSIS – total vehicles per state';
-- 4.1 Total vehicles per state
SELECT 
    state,
    (electric + phev + hev + biodiesel + e85 + cng + propane + 
     hydrogen + methanol + gasoline + diesel + unknown_fuel) AS total_vehicles
FROM Vehicle_Data
ORDER BY total_vehicles DESC;


PRINT '04) STATE LEVEL ANALYSIS – EV/PHEV/HEV/Gas percentages';
-- 4.2 Fuel share per state
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


PRINT '04) STATE LEVEL ANALYSIS – top 5 EV states';
-- 4.3 Top 5 EV states
SELECT TOP 5
    state,
    ROUND((electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane + 
         hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
         AS ev_percent
FROM Vehicle_Data
ORDER BY ev_percent DESC;


PRINT '04) STATE LEVEL ANALYSIS – bottom 5 EV states';
-- 4.4 Bottom 5 EV states
SELECT TOP 5
    state,
    ROUND((electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane + 
         hydrogen + methanol + gasoline + diesel + unknown_fuel)) * 100, 2)
         AS ev_percent
FROM Vehicle_Data
ORDER BY ev_percent ASC;


PRINT '04) STATE LEVEL ANALYSIS – state electrification index';
-- 4.5 Electrification category per state
WITH state_calc AS (
    SELECT
        state,
        electric,
        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel)
         AS total_vehicles,

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

    CASE
        WHEN electric > avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'High Adoption + High Volume'
        WHEN electric > avg_electric AND ev_percent_ratio < avg_ev_percent_ratio
            THEN 'High Volume + Low Adoption'
        WHEN electric < avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'High Adoption + Low Volume'
        ELSE 'Low Adoption + Low Volume'
    END AS electrification_category
FROM state_calc
ORDER BY ev_percent_ratio DESC;
GO



/*=============================================================================
05) REGIONAL ANALYSIS
   - Regional totals & EV share
   - Weighted fuel distributions
   - Regional electrification view
=============================================================================*/

PRINT '05) REGIONAL ANALYSIS – totals by region';
WITH reg_totals AS (
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
FROM reg_totals
ORDER BY total_vehicles DESC;


PRINT '05) REGIONAL ANALYSIS – weighted EV / PHEV / HEV / Gas %';
WITH reg_weighted AS (
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
    ROUND(phev * 1.0 / total_vehicles * 100, 2)    AS weighted_phev_percent,
    ROUND(hev * 1.0 / total_vehicles * 100, 2)     AS weighted_hev_percent,
    ROUND(gasoline * 1.0 / total_vehicles * 100, 2)AS weighted_gas_percent
FROM reg_weighted
ORDER BY weighted_ev_percent DESC;
GO


PRINT '05) REGIONAL ANALYSIS – creating Regional_Electrification view';
IF OBJECT_ID('Regional_Electrification', 'V') IS NOT NULL
    DROP VIEW Regional_Electrification;
GO

WITH reg_view_src AS (
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
CREATE VIEW Regional_Electrification AS
SELECT
    region,
    electric AS total_electric_vehicles,
    ROUND(electric * 1.0 / total_vehicles * 100, 2) AS ev_percent,
    ROUND(phev * 1.0 / total_vehicles * 100, 2)     AS phev_percent,
    ROUND(hev * 1.0 / total_vehicles * 100, 2)      AS hev_percent
FROM reg_view_src;
GO



/*=============================================================================
06) ALTERNATIVE FUEL ANALYSIS
   - National alt fuel percentages
   - Alt fuel share per state
   - Diversity index & market share
=============================================================================*/

PRINT '06) ALT FUEL ANALYSIS – national alt-fuel percentages';
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


PRINT '06) ALT FUEL ANALYSIS – alt-fuel share per state';
SELECT 
    state,
    ROUND(
        ((biodiesel + e85 + cng + propane + hydrogen + methanol) * 1.0 /
        (electric + phev + hev + gasoline + biodiesel + e85 + cng +
         propane + hydrogen + methanol + diesel + unknown_fuel)) * 100,
    2) AS alt_fuel_share
FROM Vehicle_Data
ORDER BY alt_fuel_share DESC;


PRINT '06) ALT FUEL ANALYSIS – alt-fuel diversity + state contribution';
-- Diversity index
SELECT 
    state,
    (CASE WHEN biodiesel > 1000 THEN 1 ELSE 0 END +
     CASE WHEN e85 > 1000 THEN 1 ELSE 0 END +
     CASE WHEN cng > 1000 THEN 1 ELSE 0 END +
     CASE WHEN propane > 1000 THEN 1 ELSE 0 END +
     CASE WHEN hydrogen > 10  THEN 1 ELSE 0 END +
     CASE WHEN methanol > 100 THEN 1 ELSE 0 END
    ) AS alt_fuel_variety
FROM Vehicle_Data
ORDER BY alt_fuel_variety DESC;

-- State contribution to U.S. alt-fuel
WITH alt_base AS (
    SELECT
        state,
        (biodiesel + e85 + cng + propane + hydrogen + methanol) AS state_alt_fuel,
        SUM(biodiesel + e85 + cng + propane + hydrogen + methanol)
            OVER () AS us_alt_fuel
    FROM Vehicle_Data
),
alt_calc AS (
    SELECT
        state,
        state_alt_fuel,
        us_alt_fuel,
        state_alt_fuel * 1.0 / us_alt_fuel AS alt_fuel_share,
        RANK() OVER (ORDER BY state_alt_fuel DESC) AS alt_fuel_rank
    FROM alt_base
)
SELECT TOP 10
    state,
    state_alt_fuel,
    us_alt_fuel,
    FORMAT(alt_fuel_share, 'P4') AS alt_fuel_share,
    alt_fuel_rank
FROM alt_calc
ORDER BY alt_fuel_rank;
GO



/*=============================================================================
07) ECONOMIC INDICATORS
   - EV per 1M gasoline vehicles
   - Fuel diversity index
   - Alt fuel market share
=============================================================================*/

PRINT '07) ECONOMIC INDICATORS – EV per 1M gasoline vehicles';
SELECT 
    state,
    ROUND((electric * 1.0 / gasoline) * 1000000, 2) AS ev_per_million_gas
FROM Vehicle_Data
ORDER BY ev_per_million_gas DESC;


PRINT '07) ECONOMIC INDICATORS – fuel diversity index';
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


PRINT '07) ECONOMIC INDICATORS – alt-fuel market share (top 10 states)';
WITH econ_base AS (
    SELECT
        state,
        (biodiesel + e85 + cng + propane + hydrogen + methanol) AS state_alt_fuel,
        SUM(biodiesel + e85 + cng + propane + hydrogen + methanol)
            OVER () AS us_alt_fuel
    FROM Vehicle_Data
),
econ_calc AS (
    SELECT
        state,
        state_alt_fuel,
        us_alt_fuel,
        state_alt_fuel * 1.0 / us_alt_fuel AS alt_fuel_share,
        RANK() OVER (ORDER BY state_alt_fuel DESC) AS alt_fuel_rank
    FROM econ_base
)
SELECT TOP 10
    state,
    state_alt_fuel,
    us_alt_fuel,
    FORMAT(alt_fuel_share, 'P4') AS alt_fuel_share,
    alt_fuel_rank
FROM econ_calc
ORDER BY alt_fuel_rank;
GO



/*=============================================================================
08) POLICY SCORING
   - EV readiness score
   - Investment / infrastructure priority segments
   - EV vs U.S. benchmark (quadrants + ratios)
=============================================================================*/

PRINT '08) POLICY SCORING – EV readiness score';
WITH base_ready AS (
    SELECT
        state,

        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel) AS total_vehicles,

        electric,

        electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel) AS ev_percent_ratio,

        (electric + phev + hev + biodiesel + e85 + cng + propane +
         hydrogen + methanol + gasoline + diesel + unknown_fuel) - electric AS ev_potential,

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
norm_ready AS (
    SELECT
        state,
        electric,
        ev_percent_ratio,
        ev_potential,
        fuel_diversity,

        LOG(ev_potential + 1) AS ev_potential_log,

        MIN(LOG(ev_potential + 1)) OVER() AS min_log,
        MAX(LOG(ev_potential + 1)) OVER() AS max_log,

        (LOG(ev_potential + 1) - MIN(LOG(ev_potential + 1)) OVER()) /
        NULLIF(MAX(LOG(ev_potential + 1)) OVER() - MIN(LOG(ev_potential + 1)) OVER(), 0)
        AS ev_potential_score,

        (ev_percent_ratio - MIN(ev_percent_ratio) OVER()) /
        NULLIF(MAX(ev_percent_ratio) OVER() - MIN(ev_percent_ratio) OVER(), 0)
        AS ev_adoption_score,

        fuel_diversity * 1.0 / MAX(fuel_diversity) OVER() AS fdi_score
    FROM base_ready
)
SELECT
    state,
    electric,
    ROUND(ev_percent_ratio * 100, 2) AS ev_percent,
    ev_potential,
    fuel_diversity,
    ROUND(ev_potential_score, 3) AS ev_potential_score,
    ROUND(ev_adoption_score, 3)  AS ev_adoption_score,
    ROUND(fdi_score, 3)          AS fdi_score,
    ROUND(
        (0.4 * ev_potential_score) +
        (0.4 * ev_adoption_score) +
        (0.2 * fdi_score),
    3) AS readiness_score
FROM norm_ready
ORDER BY readiness_score DESC;


PRINT '08) POLICY SCORING – investment / infrastructure priority quadrants';
WITH calc_priority AS (
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

    CASE
        WHEN electric > avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'High Adoption, High Volume'
        WHEN electric > avg_electric AND ev_percent_ratio < avg_ev_percent_ratio
            THEN 'High Volume, Low Adoption'
        WHEN electric < avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'High Adoption, Low Volume'
        ELSE 'Low Adoption, Low Volume'
    END AS infrastructure_priority_segment,

    CASE
        WHEN electric > avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'Mature EV Market – Strong demand & strong volume'
        WHEN electric > avg_electric AND ev_percent_ratio < avg_ev_percent_ratio
            THEN 'Infrastructure Priority – Large fleet but slow EV penetration'
        WHEN electric < avg_electric AND ev_percent_ratio > avg_ev_percent_ratio
            THEN 'Emerging Market – High adoption but small vehicle base'
        ELSE 'Early Stage Market – Low adoption & low volume'
    END AS infrastructure_priority_description
FROM calc_priority
ORDER BY ev_percent_ratio DESC;


PRINT '08) POLICY SCORING – EV vs US benchmark (quadrant classification)';
WITH base_bench AS (
    SELECT
        state,
        electric,
        phev,
        hev,
        biodiesel,
        e85,
        cng,
        propane,
        hydrogen,
        methanol,
        gasoline,
        diesel,
        unknown_fuel,

        (electric + phev + hev + biodiesel + e85 + cng +
         propane + hydrogen + methanol + gasoline +
         diesel + unknown_fuel) AS total_vehicles,

        electric * 1.0 /
        (electric + phev + hev + biodiesel + e85 + cng +
         propane + hydrogen + methanol + gasoline +
         diesel + unknown_fuel) AS ev_penetration_raw,

        SUM(electric) OVER () AS us_electric,
        SUM(
            electric + phev + hev + biodiesel + e85 + cng +
            propane + hydrogen + methanol + gasoline +
            diesel + unknown_fuel
        ) OVER () AS us_total_vehicles
    FROM Vehicle_Data
),
calc_bench AS (
    SELECT
        state,
        electric,
        total_vehicles,
        ev_penetration_raw,
        us_electric,
        us_total_vehicles,

        electric * 1.0 / us_electric        AS ev_share_us_raw,
        electric * 1.0 / us_total_vehicles  AS ev_share_us_total_raw,
        total_vehicles * 1.0 / us_total_vehicles AS state_vehicle_market_share_raw,

        ev_penetration_raw /
        (us_electric * 1.0 / us_total_vehicles) AS ev_vs_us_ratio_raw,

        total_vehicles - electric AS ev_potential,

        AVG(electric) OVER ()        AS avg_electric,
        AVG(ev_penetration_raw) OVER() AS avg_ev_penetration
    FROM base_bench
)
SELECT
    state,
    electric,
    total_vehicles,

    FORMAT(ev_penetration_raw, 'P2')            AS ev_penetration,
    FORMAT(ev_share_us_raw, 'P2')               AS ev_share_us,
    FORMAT(ev_share_us_total_raw, 'P4')         AS ev_share_us_total,
    FORMAT(state_vehicle_market_share_raw, 'P2')AS state_vehicle_market_share,
    FORMAT(ev_vs_us_ratio_raw, 'N2')            AS ev_vs_us_ratio,

    ev_potential,

    RANK() OVER (ORDER BY electric DESC)           AS ev_count_rank,
    RANK() OVER (ORDER BY ev_penetration_raw DESC) AS ev_penetration_rank,

    CASE
        WHEN electric > avg_electric
         AND ev_penetration_raw > avg_ev_penetration
            THEN 'High Adoption + High Volume'
        WHEN electric > avg_electric
         AND ev_penetration_raw < avg_ev_penetration
            THEN 'High Volume + Low Adoption'
        WHEN electric < avg_electric
         AND ev_penetration_raw > avg_ev_penetration
            THEN 'High Adoption + Low Volume'
        ELSE 'Low Adoption + Low Volume'
    END AS quadrant_category
FROM calc_bench
ORDER BY electric DESC;
GO


PRINT 'EV_Analysis_MASTER.sql – pipeline completed successfully.';
