# Data Inspection Notes

Basic checks were performed to understand the dataset before cleaning.

## What Was Checked
- Previewed first rows  
- Counted total records  
- Listed column names  
- Checked for formatting issues (commas, text numbers)  
- Looked for NULLs and inconsistent state names  

## Key Findings
- Numeric fields contain commas and must be cleaned  
- Some state names have whitespace  
- Alternative fuel fields include zeros/NULLs  
- Column names need standardization  

## Next Steps
- Clean numeric fields  
- Normalize state names  
- Standardize column names  
- Convert all numeric values to INT  
