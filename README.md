# Analysis code for: "Sex differences in subcortical atrophy and cognition in late-life aging and mild cognitive impairment: Six-year longitudinal findings from the Sydney Memory and Ageing Study "
This page includes the analysis code for the above mentioned manuscript. The analyses in this manuscript can be reproduced using excel file ('MAS_FAIR Review.xlsx') and code included here. The code was run in MatLab and R. 

You will need to download the excel file to your local computer to complete the below. 

# R File  

Use the "after_outliers_removed" sheet from the excel file and run the code in the R script to recreate and check Figures 5 and 6, as well as Table 5. 

# Matlab File  

Use the "data_sorted" sheet to run the Matlab Script (.m file). To do this, Import Data on MatLab and call this data "data" in numeric matrix form. This script will be used to run and recreate all the PLS analyses and recreate Figures 1 through 4. 

1. MC-PLS of raw data (Figures 1 and 2) 
2. converted raw subcortical brain volumes to ICV-adjusted volumes
3. MC-PLS of ICV-adjusted volumes (Figure 3a and b)
4. MC-PLS of non-converter participants (Figure 4a and b)
