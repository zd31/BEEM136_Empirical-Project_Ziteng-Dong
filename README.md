# BEEM136 Empirical Project

## Overview
This project aims to replicate and extend the research conducted by Bakó et al. (2026). Their
study examines the association between present bias and lower memory accuracy in intertemporal
decision-making.

## Author
- Ziteng Dong, MRes Finance, University of Exeter

## Project Structure
```
-README.md                   # Project documentation
-Project_Paper.pdf           # Project paper
-Codes/                      # All codes
    --1_Data_Clean.do             # Data cleaning and preparation
    --2_Figures.do                # Figure generation
    --3_Tables.do                 # Regression tables and statistics
-Data/                       # All data files
    --Data_Raw/                   # Original raw data
        ---data_raw.csv
    --Data_Cleaned/               # Processed and cleaned data
        ---Cleaned_Working_Data.dta
-Output/                     # Generated outputs
    --Output_Figures/             # Figures
        ---Figure_1_switching_point_diff.png
        ---Figure_2_fractional_polynomial.png
        ---Figure_3_cdf_1visit.png
        ---Figure_4_cdf_2visit.png
    --Output_Tables/              # Tables and regression outputs
        ---regr_c5.tex
        ---regr_c6.tex
        ---regression_tables1.tex
        ---regression_tables2.tex  
-Reference/                  # Bibliographic sources
    --bibliography.bib
```

## Data Description
- **Source**: https://github.com/ToniErtl/Remembering_Past_Present_Biased
- **Sample Size**: 146 

## Software
- StataNow/SE 19.5 for Windows (64-bit x86-64)

## Running Codes

### 1. Data Preparation
Run the data cleaning do file first:
```stata
do "Codes/1_Data_Clean.do"
```
This will process `data_raw.csv` and output `Cleaned_Working_Data.dta`

### 2. Generate Figures
```stata
do "Codes/2_Figures.do"
```
Output saved to `Output/Output_Figures/`

### 3. Generate Tables & Regression Results
```stata
do "Codes/3_Tables.do"
```
Output saved to `Output/Output_Tables/`

## References
See `Reference/bibliography.bib` for full citations.

## Contact
- Email: zd290@exeter.ac.uk
- Institution: University of Exeter
- Module: BEEM136 - Research Methods

