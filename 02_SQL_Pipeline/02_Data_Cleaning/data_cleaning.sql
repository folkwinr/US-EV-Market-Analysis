/*
===============================================================================
Module: 02_Data_Cleaning
File: data_cleaning.sql
Purpose:
    Perform all transformation and cleaning operations required to prepare
    the Vehicle_Data table for analysis. This includes:
    - Standardizing column names
    - Removing comma separators from number fields
    - Converting VARCHAR numbers into INT
    - Checking for and identifying NULL values
    - Removing whitespace inconsistencies
    - Detecting duplicate state entries
===============================================================================
*/


/*-----------------------------------------------------------------------------
1) RENAME COLUMNS
   Standardize column names: remove spaces, parentheses and make SQL-friendly.
-----------------------------------------------------------------------------*/

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



/*-----------------------------------------------------------------------------
2) REMOVE COMMAS FROM NUMERIC TEXT FIELDS
   Numbers like '1,256,600' must become '1256600' before INT conversion.
-----------------------------------------------------------------------------*/

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



/*-----------------------------------------------------------------------------
3) CAST CLEANED COLUMNS TO INT
   Convert VARCHAR → INT to enable numerical analysis.
-----------------------------------------------------------------------------*/

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



/*-----------------------------------------------------------------------------
4) CHECK FOR NULL VALUES CAUSED BY BROKEN SOURCE DATA OR BAD CONVERSIONS
-----------------------------------------------------------------------------*/

SELECT *
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



/*-----------------------------------------------------------------------------
5) TRIM WHITESPACE (Especially for state names)
-----------------------------------------------------------------------------*/

UPDATE Vehicle_Data
SET state = LTRIM(RTRIM(state));



/*-----------------------------------------------------------------------------
6) CHECK FOR DUPLICATE STATE ENTRIES
-----------------------------------------------------------------------------*/

SELECT state, COUNT(*) AS duplicate_count
FROM Vehicle_Data
GROUP BY state
HAVING COUNT(*) > 1;


-- END OF MODULE
