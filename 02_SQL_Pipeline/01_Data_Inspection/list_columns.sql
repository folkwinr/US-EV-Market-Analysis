/*
===============================================================================
Purpose: Retrieve the column names from the Vehicle_Data table.
         Useful for validating naming consistency and planning transformations.
===============================================================================
*/

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Vehicle_Data';

