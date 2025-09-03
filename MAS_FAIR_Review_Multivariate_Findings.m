%FAIR Review for Figures 1 - 4
%Created September 2nd 2025 by Alex(andria) Samson
%for the McLab and MAS Collab

%Import Data(go to HOME tab and cick on Import Data): 'MAS_FAIR Reveiw.xlsx'; sheet "data_sorted"
%import as a NUMERIC MATRIX and name it data 

%Legend for this numeric matrix 
%Column 1 = subject ID 
%Column 2 = wave (1, 2, 4) 
%Column 3 = converters 
%Column 4 = sex (1 = male, 2 = female)
%Column 5 = Age
%Column 6 - 20 = raw subcourtical regions (mm^3)
%Column 21 = GM_Total_Vol (cm^3)	
%Column 22 = WM_Total_Vol (cm^3)	
%Column 23 = CSF_Total_Vol (cm^3)
%Column 24 = softtissue_Total_Vol (cm^3)	
%Column 25 = ICV_Total_Vol (cm^3)
%Column 26 = diagnosis_at_baseline (0 = CU, 1 = MCI) 
%Column 27 = diagnostic_sex_time_groups (1 to 12)
%Column 28 = diagnostic_sex groups (1 - 4) - 1 = CUfem, 2 = MCIfem, 3 = CU
%mal, 4 = MCImal

%Brain Region Names 
brain_regions = { ...
    'L Hippocampus', 'R Hippocampus', ...
    'L Thalamus', 'R Thalamus', ...
    'L Caudate', 'R Caudate', ...
    'L Putamen', 'R Putamen', ...
    'L Pallidum', 'R Pallidum', ...
    'L Amygdala', 'R Amygdala', ...
    'L Accumbens', 'BrainStem'};

%Diagnostic-Sex-Time Group Names 
group_names = { ...
    'CU Fem W1', 'CU Fem W2', ...
    'CU Fem W4', 'MCI Fem W1', ...
    'MCI Fem W2', 'MCI Fem W4', ...
    'CU Mal W1', 'CU Mal W2', ...
    'CU Mal E4', 'MCI Mal W1', ...
    'MCI Mal W2', 'MCI Mal W4'};

%add PLS paths, example: 
addpath 'PLS Files'\
addpath 'plscmd'\

%% RUN MC-PLS of brain values across diagnostic groups, time, and sex
clear option 
option.method = 1;
option.num_perm = 1000;
option.num_boot = 1000;
option.meancentering_type = 2; 
num_cond = 3; 
num_subj = [sum(data(:, 27) == 1), sum(data(:, 27) == 4),...
    sum(data(:, 27) == 7), sum(data(:, 27) == 10)];
subcort_vols_range = [6:18,20]; %no right accumbens because participants had 0 values for this brain region
datamat_lst = arrayfun(@(i) data(data(:, 28) == i, subcort_vols_range), ...
    1:4, 'UniformOutput', false);

result_mcpls_sex_time_diagnosis_raw = pls_analysis(datamat_lst,num_subj,num_cond,option);

%FIGURE 1 (LV1) 
figure;
subplot(2,1,1);
b = bar(result_mcpls_sex_time_diagnosis_raw.boot_result.compare_u(:,1));
hold on;
xticks([1:14]);
xtickangle(45);
xticklabels(brain_regions);
xlabel('Brain Regions');
ylabel('Bootstrap Ratio');

% Add title with LV1, percent variance, and p-value
percent_var = result_mcpls_sex_time_diagnosis_raw.s(1)^2 / sum(result_mcpls_sex_time_diagnosis_raw.s.^2) * 100;
p_val = result_mcpls_sex_time_diagnosis_raw.perm_result.sprob(1);

title(sprintf('LV1, %.2f%% variance explained, p = %.3f', percent_var, p_val));

subplot(2,1,2);
b=bar(result_mcpls_sex_time_diagnosis_raw.boot_result.orig_usc(:,1),'w');
hold on;
errorbar([1:12],result_mcpls_sex_time_diagnosis_raw.boot_result.orig_usc(:,1), ...
    result_mcpls_sex_time_diagnosis_raw.boot_result.orig_usc(:,1)-result_mcpls_sex_time_diagnosis_raw.boot_result.llusc(:,1), ...
    result_mcpls_sex_time_diagnosis_raw.boot_result.ulusc(:,1)-result_mcpls_sex_time_diagnosis_raw.boot_result.orig_usc(:,1),'k','linestyle','none');
xticks([1:12]);
xtickangle(45);
xticklabels(group_names);
ylabel('Design Saliences');

%FIGURE 2 (LV2) 
figure;
subplot(2,1,1);
b = bar(result_mcpls_sex_time_diagnosis_raw.boot_result.compare_u(:,2));
hold on;
xticks([1:14]);
xtickangle(45);
xticklabels(brain_regions);
xlabel('Brain Regions');
ylabel('Bootstrap Ratio');

percent_var = result_mcpls_sex_time_diagnosis_raw.s(2)^2 / sum(result_mcpls_sex_time_diagnosis_raw.s.^2) * 100;
p_val = result_mcpls_sex_time_diagnosis_raw.perm_result.sprob(2);
title(sprintf('LV2, %.2f%% variance explained, p = %.3f', percent_var, p_val));

subplot(2,1,2);
b=bar(result_mcpls_sex_time_diagnosis_raw.boot_result.orig_usc(:,2),'w');
hold on;
errorbar([1:12],result_mcpls_sex_time_diagnosis_raw.boot_result.orig_usc(:,2), ...
    result_mcpls_sex_time_diagnosis_raw.boot_result.orig_usc(:,2)-result_mcpls_sex_time_diagnosis_raw.boot_result.llusc(:,2), ...
    result_mcpls_sex_time_diagnosis_raw.boot_result.ulusc(:,2)-result_mcpls_sex_time_diagnosis_raw.boot_result.orig_usc(:,2),'k','linestyle','none');
xticks([1:12]);
xtickangle(45);
xticklabels(group_names);
ylabel('Design Saliences');

%% Convert raw brain volumes to residualized brain volumes
% there is only ICV data for 2 visits so we need to make a new dataframe
% that removes Wave 4
data_2visits = data(data(:,2)~=4,:);

% need to seperate participants by diagnostic group
% Cognitively Unimpaired participants: 
CU = data_2visits(data_2visits(:,26)==0,:);
% Mild Cognitive Impairment 
MCI = data_2visits(data_2visits(:,26)==1,:);

% Residualizing CU brain regions 
CU_brain_vols_datamat_2visits = CU(:,[6:18,20]); %volumes (with no R accumbens)
CU_ICV_vols = CU(:,25); %ICV value 
CU_ICV_vols_mm3 = CU_ICV_vols * 1000;  % convert to mm^3

[r c]=size(CU_brain_vols_datamat_2visits);
intercept=ones(r,1);
beta = [double(intercept) double(CU_ICV_vols_mm3)] \ double(CU_brain_vols_datamat_2visits);
CU_pred = [double(intercept) double(CU_ICV_vols_mm3)] * beta;
CU_brain_vols_datamat_2visits_resid = CU_brain_vols_datamat_2visits - CU_pred;

%MILD COGNITIVE IMPAIRMENT (MCI)
MCI_brain_vols_datamat_2visits = MCI(:,[6:18,20]); %volumes 
MCI_ICV_vols = MCI(:,25); %ICV value 
MCI_ICV_vols_mm3 = MCI_ICV_vols * 1000;  % convert to mm^3

intercept = ones(80,1); %80 = number of MCI participants 
MCI_pred=[double(intercept) double(MCI_ICV_vols_mm3)]*beta;
MCI_brain_vols_datamat_2visits_resid=MCI_brain_vols_datamat_2visits-MCI_pred;

%vertically concatenate diagnosis data 
CU_residdata = [CU,CU_brain_vols_datamat_2visits_resid];
MCI_residdata = [MCI,MCI_brain_vols_datamat_2visits_resid];

% Columns 29 - 42 are residualized brain volumes in both dataframes

data_residdata = [CU_residdata; MCI_residdata];
data_residdata_sorted = sortrows(data_residdata,27);

%% RUN MC-PLS of brain values (residualize) across diagnostic groups, time, and sex 
num_cond = 2; 
num_subj = [sum(data_residdata_sorted(:, 27) == 1), sum(data_residdata_sorted(:, 27) == 4),...
    sum(data_residdata_sorted(:, 27) == 7), sum(data_residdata_sorted(:, 27) == 10)];
subcort_vols_range_resid = 29:42;
datamat_lst = arrayfun(@(i) data_residdata_sorted(data_residdata_sorted(:,28) == i, subcort_vols_range_resid), ...
    1:4, 'UniformOutput', false);

result_mcpls_sex_time_diagnosis_resid_2visits = pls_analysis(datamat_lst,num_subj,num_cond,option);

%FIGURE 3a (LV1)
figure;
subplot(2,1,1);
b = bar(result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.compare_u(:,1));
hold on;
xticks([1:14]);
xtickangle(45);
xticklabels(brain_regions);
xlabel('Brain Regions');
ylabel('Bootstrap Ratio');

percent_var = result_mcpls_sex_time_diagnosis_resid_2visits.s(1)^2 / sum(result_mcpls_sex_time_diagnosis_resid_2visits.s.^2) * 100;
p_val = result_mcpls_sex_time_diagnosis_resid_2visits.perm_result.sprob(1);
title(sprintf('LV1, %.2f%% variance explained, p = %.3f', percent_var, p_val));

subplot(2,1,2);
b=bar(result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.orig_usc(:,1),'w');
hold on;
errorbar([1:8],result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.orig_usc(:,1), ...
    result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.orig_usc(:,1)-result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.llusc(:,1), ...
    result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.ulusc(:,1)-result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.orig_usc(:,1),'k','linestyle','none');
xticks([1:8]);
xtickangle(45);
xticklabels(group_names(:,[1:2,4:5,7:8,10:11]));
ylabel('Design Saliences');

%FIGURE 3b (LV2) 
figure;
subplot(2,1,1);
b = bar(result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.compare_u(:,2));
hold on;
xticks([1:14]);
xtickangle(45);
xticklabels(brain_regions);
xlabel('Brain Regions');
ylabel('Bootstrap Ratio');

percent_var = result_mcpls_sex_time_diagnosis_resid_2visits.s(2)^2 / sum(result_mcpls_sex_time_diagnosis_resid_2visits.s.^2) * 100;
p_val = result_mcpls_sex_time_diagnosis_resid_2visits.perm_result.sprob(2);
title(sprintf('LV2, %.2f%% variance explained, p = %.3f', percent_var, p_val));

subplot(2,1,2);
b=bar(result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.orig_usc(:,2),'w');
hold on;
errorbar([1:8],result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.orig_usc(:,2), ...
    result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.orig_usc(:,2)-result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.llusc(:,2), ...
    result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.ulusc(:,2)-result_mcpls_sex_time_diagnosis_resid_2visits.boot_result.orig_usc(:,2),'k','linestyle','none');
xticks([1:8]);
xtickangle(45);
xticklabels(group_names(:,[1:2,4:5,7:8,10:11]));
ylabel('Design Saliences');

%% RUN MC-PLS of brain values across diagnostic groups, time, and sex in non-converters
data_non_converters = data(ismember(data(:,3), [0, -1, -2]), :); %non-converters 

num_cond = 3; 
num_subj = [sum(data_non_converters(:, 27) == 1), sum(data_non_converters(:, 27) == 4),...
    sum(data_non_converters(:, 27) == 7), sum(data_non_converters(:, 27) == 10)];
datamat_lst = arrayfun(@(i) data_non_converters(data_non_converters(:, 28) == i, subcort_vols_range), ...
    1:4, 'UniformOutput', false);

result_mcpls_sex_time_diagnosis_raw_nonConverters = pls_analysis(datamat_lst,num_subj,num_cond,option);

%FIGURE 4a (LV1) 
figure;
subplot(2,1,1);
b = bar(result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.compare_u(:,1));
hold on;
xticks([1:14]);
xtickangle(45);
xticklabels(brain_regions);
xlabel('Brain Regions');
ylabel('Bootstrap Ratio');

percent_var = result_mcpls_sex_time_diagnosis_raw_nonConverters.s(1)^2 / sum(result_mcpls_sex_time_diagnosis_raw_nonConverters.s.^2) * 100;
p_val = result_mcpls_sex_time_diagnosis_raw_nonConverters.perm_result.sprob(1);
title(sprintf('LV1, %.2f%% variance explained, p = %.3f', percent_var, p_val));

subplot(2,1,2);
b=bar(result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.orig_usc(:,1),'w');
hold on;
errorbar([1:12],result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.orig_usc(:,1), ...
    result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.orig_usc(:,1)-result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.llusc(:,1), ...
    result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.ulusc(:,1)-result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.orig_usc(:,1),'k','linestyle','none');
xticks([1:12]);
xtickangle(45);
xticklabels(group_names);
ylabel('Design Saliences');

%FIGURE 4b (LV2) 
figure;
subplot(2,1,1);
b = bar(result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.compare_u(:,2));
hold on;
xticks([1:14]);
xtickangle(45);
xticklabels(brain_regions);
xlabel('Brain Regions');
ylabel('Bootstrap Ratio');

percent_var = result_mcpls_sex_time_diagnosis_raw_nonConverters.s(2)^2 / sum(result_mcpls_sex_time_diagnosis_raw_nonConverters.s.^2) * 100;
p_val = result_mcpls_sex_time_diagnosis_raw_nonConverters.perm_result.sprob(2);
title(sprintf('LV2, %.2f%% variance explained, p = %.3f', percent_var, p_val));

subplot(2,1,2);
b=bar(result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.orig_usc(:,2),'w');
hold on;
errorbar([1:12],result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.orig_usc(:,2), ...
    result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.orig_usc(:,2)-result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.llusc(:,2), ...
    result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.ulusc(:,2)-result_mcpls_sex_time_diagnosis_raw_nonConverters.boot_result.orig_usc(:,2),'k','linestyle','none');
xticks([1:12]);
xtickangle(45);
xticklabels(group_names);

ylabel('Design Saliences');

