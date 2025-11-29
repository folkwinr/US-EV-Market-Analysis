/*
===============================================================================
Purpose: Count the total number of records in the Vehicle_Data table.
         This helps verify dataset size and detect missing or duplicate loads.
===============================================================================
*/

SELECT COUNT(*) AS row_count
FROM Vehicle_Data;
