/*
===============================================================================
Purpose: Preview the first 10 rows of the Vehicle_Data table to understand
         the structure and identify any immediate data quality issues.
===============================================================================
*/

USE EV_Analysis;
GO

SELECT TOP 10 *
FROM Vehicle_Data;

