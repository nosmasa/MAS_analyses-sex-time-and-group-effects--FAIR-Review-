# Analysis code for: "Sex differences in subcortical atrophy and cognition in late-life aging and mild cognitive impairment: Six-year longitudinal findings from the Sydney Memory and Ageing Study "
This page includes the analysis code for the above mentioned manuscript. The analyses in this manuscript can be reproduced using excel file (`MAS_FAIR Review.xlsx`) and code included here. The code was run in R and MatLab. 

All the files can be found on Compute Canada. To access the data/excel file and to run the scripts do the following... 
1. Open a terminal on your computer.
2. Navigate to the folder where you want to run the code, for example, your Documents folder: `cd ~/Documents`
3. Clone the repository: `git clone https://github.com/nosmasa/MAS_analyses-sex-time-and-group-effects--FAIR-Review-.git`
4. Change into the repository directory: `cd MAS_analyses-sex-time-and-group-effects--FAIR-Review-`
5. Copy a file from Compute Canada to download the files directly into your local repository folder (replace "username" with your username): `scp -r username@fir.computecanada.ca:/project/def-rmcintos/data-sets/MAS_analyses .`

## R File  
R script file name: `MAS FAIR Review Univariate Findings.R`
R version used: 4.5.0 (2025-04-11 ucrt)
Use the `after_outliers_removed` sheet from the excel file and run the code in the R script to recreate and check Figures 5 and 6, as well as Table 5. 

1. Data preparation
   - Reads in the Excel dataset - make sure to customize line 18 to where the excel file is located on your computer. 
   - Converts time in study to years.
   - Re-labels key variables: sex, baseline diagnosis, and study wave.
   - Ensures categorical variables are properly formatted.

2. Figure 5 (Right Caudate): Tests the interaction between sex, diagnosis, and wave on right caudate volume.
   - Produces a line plot with estimated means and error bars, showing sex differences over study waves
   - Compare this to the `Figure 5.PNG`

3. Figure 6 (Three-way interactions): Examines significant three-way interactions of sex, diagnosis, and wave on two brain regions:

   (a) Right hippocampus and (b) Brainstem
  - Produces plots showing how diagnosis and sex jointly influence trajectories across waves.
  - Compare your outputs here to the `Figure 6.PNG` 

4. Table 5 (Brain–Cognition Relationships)
  - Splits the dataset into groups (CU females, CU males, MCI females, MCI males).
  - For each group, calculates individual slopes (rates of change) in brain structure volumes and cognitive scores.
  - Runs correlations between brain slopes and cognitive slopes.
  - Extracts only significant correlations (p < 0.0454).

5. Comparison of your Table 5 results with mine with Reported Results
  - Loads previously reported significant correlations from the RDS files (`CUfem_sig_results_alex.rds`, `CUmal_sig_results_alex.rds`, `MCIfem_sig_results_alex.rds`, `MCImal_sig_results_alex.rds`)
  - Compares them against the newly computed results for each group.
  - If the results are the same then R should state: `CU females : The results are the same` for example 
  

## Matlab File  
Matlab script file name: `MAS_FAIR_Review_Multivariate_Findings.m`
MatLab version: R2021b
This script will be used to run and recreate three PLS analyses and generating six figures. Follow these steps to reproduce the results:

1. Add paths: PLS files 
  - Add plscmd folder to the .m file https://github.com/McIntosh-Lab/PLS
  - Example: `git clone https://github.com/McIntosh-Lab/PLS.git`
     - then:
     - `addpath 'PLS/plscmd'` #for mac and linux
     - `addpath 'PLS\plscmd'` #for windows

2. Prepare the Data: Use the `data_sorted` sheet from the provided excel spreadsheet.
  - See the top of the MATLAB script `MAS_FAIR_Review_Multivariate_Findings.m` for instructions on importing the data.

3. Run the Analyses - The MATLAB script performs the following steps:
   - a)  Run MC-PLS of Raw Subcortical Volumes: Compares diagnostic groups across time and sex.
   - b) Generate Figures 1 and 2 (LV1 and LV2 for raw data).
      - Compare these to the `Figure 1.JPG` and `Figure 2.JPG`
   - c) Convert Raw Volumes to ICV-Adjusted Volumes: Residualizes subcortical brain volumes for intracranial volume (ICV).
   - d) Run MC-PLS on these ICV-adjusted volumes: Compares diagnostic groups across time and sex (2 visits).
   - e) Generate Figures 3a and 3b (LV1 and LV2 for residualized data).
      - Compare this to the `Figure 3a.JPG` and `Figure 3b.JPG`
   - f) Run MC-PLS of Non-Converters Only: : Compares diagnostic groups across time and sex (N = 85). 
       - Filters out participants who converted to MCI/AD.
    - g) Generate Figures 4a and 4b (LV1 and LV2 for non-converters).
      - Compare this to the `Figure 4a.JPG` and `Figure 4b.JPG`
