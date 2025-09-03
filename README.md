# Analysis code for: "Sex differences in subcortical atrophy and cognition in late-life aging and mild cognitive impairment: Six-year longitudinal findings from the Sydney Memory and Ageing Study "
This page includes the analysis code for the above mentioned manuscript. The analyses in this manuscript can be reproduced using excel file ('MAS_FAIR Review.xlsx') and code included here. The code was run in MatLab and R. 

You will need to download the excel file to your local computer to complete the below. 

## R File  
Use the "after_outliers_removed" sheet from the excel file and run the code in the R script to recreate and check Figures 5 and 6, as well as Table 5. 

1. Download required files to successfully run the R script (download all these files to the same directory):
- Excel file: MAS_FAIR Review.xlsx (sheet: after_outliers_removed)
- RDS files:
  - CUmal_sig_results_alex.rds
  - CUfem_sig_results_alex.rds
  - MCIfem_sig_results_alex.rds
  - MCImal_sig_results_alex.rds

2. Data preparation
   - Reads in the Excel dataset.
   - Converts time in study to years.
   - Re-labels key variables: sex, baseline diagnosis, and study wave.
   - Ensures categorical variables are properly formatted.

3. Figure 5 (Right Caudate): Tests the interaction between sex, diagnosis, and wave on right caudate volume.
   - Produces a line plot with estimated means and error bars, showing sex differences over study waves
   - Compare this to the Figure 5 PNG.

4. Figure 6 (Three-way interactions):Examines significant three-way interactions of sex, diagnosis, and wave on two brain regions:

(a) Right hippocampus and (b) Brainstem
  - Produces plots showing how diagnosis and sex jointly influence trajectories across waves.
  - Compare your outputs here to the Figure 6 PNG. 

5. Table 5 (Brain–Cognition Relationships)
  - Splits the dataset into groups (CU females, CU males, MCI females, MCI males).
  - For each group, calculates individual slopes (rates of change) in brain structure volumes and cognitive scores.
  - Runs correlations between brain slopes and cognitive slopes.
  - Extracts only significant correlations (p < 0.0454).

6. Comparison of your Table 5 results with mine with Reported Results

  - Loads previously reported significant correlations from the RDS files.
  - Compares them against the newly computed results for each group.
  - If the results are the same then R should state:"CU females : The results are the same" for example 
  

## Matlab File  
This script will be used to run and recreate all the PLS analyses and recreate Figures 1 through 4. 

### Running the PLS Analyses and Reproducing Figures

This repository contains the MATLAB script for running three PLS analyses and generating six figures. Follow these steps to reproduce the results:

1. Add paths: PLS files 
  - Add plscmd folder to the .m file https://github.com/McIntosh-Lab/PLS
  - Example: git clone https://github.com/McIntosh-Lab/PLS.git

2. Prepare the Data: Use the data_sorted sheet from the provided excel spreadsheet.
  - Import the data into MATLAB as a numeric matrix and name it data.

3. Run the Analyses - The MATLAB script performs the following steps:
   
    a) Run MC-PLS of Raw Subcortical Volumes: Compares diagnostic groups across time and sex.

    b) Generate Figures 1 and 2 (LV1 and LV2 for raw data).

    c) Convert Raw Volumes to ICV-Adjusted Volumes: Residualizes subcortical brain volumes for intracranial volume (ICV).
  
    d) Run MC-PLS on these ICV-adjusted volumes: Compares diagnostic groups across time and sex (2 visits).

    e) Generate Figures 3a and 3b (LV1 and LV2 for residualized data).

    f) Run MC-PLS of Non-Converters Only: : Compares diagnostic groups across time and sex (N = 85). 
    - Filters out participants who converted to MCI/AD.

    g) Generates Figures 4a and 4b (LV1 and LV2 for non-converters).
