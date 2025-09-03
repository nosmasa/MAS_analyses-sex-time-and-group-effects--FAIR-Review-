# Analysis code for: "Sex differences in subcortical atrophy and cognition in late-life aging and mild cognitive impairment: Six-year longitudinal findings from the Sydney Memory and Ageing Study "
This page includes the analysis code for the above mentioned manuscript. The analyses in this manuscript can be reproduced using excel file ('MAS_FAIR Review.xlsx') and code included here. The code was run in MatLab and R. 

You will need to download the excel file to your local computer to complete the below. 

## R File  

Use the "after_outliers_removed" sheet from the excel file and run the code in the R script to recreate and check Figures 5 and 6, as well as Table 5. 

## Matlab File  
This script will be used to run and recreate all the PLS analyses and recreate Figures 1 through 4. 

### Running the PLS Analyses and Reproducing Figures

This repository contains the MATLAB script for running three PLS analyses and generating six figures. Follow these steps to reproduce the results:

1. Prepare the Data: Use the data_sorted sheet from the provided excel spreadsheet.

- Import the data into MATLAB as a numeric matrix and name it data.

2. Run the Analyses

The MATLAB script performs the following steps:

a) MC-PLS of Raw Subcortical Volumes: Compares diagnostic groups across time and sex.

b) Generate Figures 1 and 2 (LV1 and LV2 for raw data).

c) Convert Raw Volumes to ICV-Adjusted Volumes: Residualizes subcortical brain volumes for intracranial volume (ICV).

d) Run MC-PLS on these ICV-adjusted volumes: Compares diagnostic groups across time and sex (2 visits).

e) Generate Figures 3a and 3b (LV1 and LV2 for residualized data).

f) Run MC-PLS of Non-Converters Only: : Compares diagnostic groups across time and sex (N = 85). 

- Filters out participants who converted to MCI/AD.

g) Generates Figures 4a and 4b (LV1 and LV2 for non-converters).
