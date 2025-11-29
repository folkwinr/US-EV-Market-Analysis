/*
===============================================================================
Module: 03_Data_Enrichment
File: data_enrichment.sql
Purpose:
    Enhance the Vehicle_Data table with additional derived variables and 
    standardized classifications. This includes:
    - Creating a region mapping (West, Northeast, South, Midwest)
    - Normalizing state names (if needed)
    - Adding combined fuel metrics (optional)
    - Creating the Vehicle_With_Region VIEW for downstream analytics
===============================================================================
*/

USE EV_Analysis;
GO


/*-----------------------------------------------------------------------------
1) NORMALIZE STATE NAMES (Optional)
   Ensures consistent formatting (e.g., remove trailing/leading whitespace,
   fix casing if necessary).
-----------------------------------------------------------------------------*/

UPDATE Vehicle_Data
SET state = LTRIM(RTRIM(state));
-- Additional normalization can be added (upper(), proper case, etc.)



/*-----------------------------------------------------------------------------
2) CREATE REGION VIEW
   Adds a region field using standard U.S. Census region definitions.
-----------------------------------------------------------------------------*/

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



/*-----------------------------------------------------------------------------
3) OPTIONAL DATA ENRICHMENT (FUEL COMBINATIONS)
   Adds total alternative fuel usage or combined EV metrics.
-----------------------------------------------------------------------------*/

-- Alternative fuel total per state
SELECT
    state,
    (biodiesel + e85 + cng + propane + hydrogen + methanol) AS alt_fuel_total
FROM Vehicle_Data;

-- Combined EV (Electric + PHEV + HEV)
SELECT
    state,
    electric + phev + hev AS total_electrified
FROM Vehicle_Data;


-- END OF MODULE
