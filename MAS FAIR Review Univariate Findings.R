#FAIR Review of Tables 4 and 5 as well as Figures 5 and 6(a and b)
#Created September 2nd, 2025 by Alex(andria) Samson
#for the McLab and MAS Study collab 

#Libraries to load 
library(readxl)
library(dplyr)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(lmerTest)
library(effectsize)
library(emmeans)
library(car)
options(scipen = 999) #this ensure that things are not in scientific notation 

#Set directory (customize to wherever the excel file is saved on your computer)
setwd('C:/Users/asamson/Desktop/OneDrive - University of Toronto/Desktop/PhD/Sydney MAS')

#Read in the correct sheet
data <- read_excel("MAS_FAIR Review.xlsx",sheet="after_outliers_removed")

#Setting up the dataframe 
#convert time in study (TIS) to years
data$TIS_years <- data$TIS / 365.25

data <- data %>%
  mutate(
    Sex = ifelse(Sex == 1, "Male", "Female"),
    diagnosis_at_baseline = ifelse(diagnosis_at_baseline == 0, "CU", "MCI")
  )

data <- data %>%
  mutate(Wave = case_when(
    Wave == 1 ~ "Wave 1",
    Wave == 2 ~ "Wave 2",
    Wave == 4 ~ "Wave 4"
  ))

data$Sex = as.factor(data$Sex)
data$diagnosis_at_baseline = as.factor(data$diagnosis_at_baseline)
data$Wave = as.factor(data$Wave)
data$ID = as.factor(data$ID)

## FIGURE 5 ----

#Visualization of the significant interaction between sex and time on right caudate
R_caud <- lmer(R_Caudate ~ Sex * diagnosis_at_baseline * Wave + (1  + TIS_years|ID), 
               data = data,  control = lmerControl(optimizer = "bobyqa"))

R_caud_2_way = summary(emmeans(R_caud, ~ Sex*Wave)) %>%
  mutate(across(c(emmean, SE), ~ round(.x, 2)))

R_caud_2_way <- emmip(R_caud, Sex ~ Wave, plotit = FALSE)
R_caud_2_way$ymin <- R_caud_2_way$yvar - R_caud_2_way$SE
R_caud_2_way$ymax <- R_caud_2_way$yvar + R_caud_2_way$SE

ggplot(R_caud_2_way, aes(x = Wave, y = yvar, color = Sex, group = Sex)) +
  geom_point(size = 3) +              
  geom_line(linewidth = 2) + 
  geom_errorbar(aes(ymin = ymin, ymax = ymax), width = 0.1, linewidth = 1) +         
  theme_minimal() +                    
  labs(
    title = "",                        
    x = "",                      
    y = expression("Right Caudate in  " * mm^3 * ""), 
    color = "Sex"                      
  ) +
  scale_color_manual(values = c("Female" = "#1A5A84", "Male" = "#E08F00")) +
  theme(
    legend.position = "right",  
    legend.title = element_blank(),
    legend.text = element_text(size = 16, color = "black"),
    axis.text.x = element_text(hjust = 0.5, size = 16, color = "black"), 
    axis.text.y = element_text(angle = 0, hjust = 0.5, size = 14, color = "black"),
    axis.title.y = element_text(size = 18),     
    axis.line = element_line(color = "black"),  
    plot.background = element_rect(fill = "white"),  
    panel.background = element_rect(fill = "white"), 
    panel.grid.major = element_blank(),       
    panel.grid.minor = element_blank(),         
    panel.border = element_blank(),            
    text = element_text(family = "serif"))

## FIGURE 6 ----

#Visualization of the significant three-way interactions on 

#a) right hippocampus 
#b) brainstem 

#### Fig 6 a) Right Hippocampus ----
R_hippo <- lmer(R_Hippocampus ~ Sex * diagnosis_at_baseline * Wave + (1  + TIS_years|ID), 
                data = data,  control = lmerControl(optimizer = "bobyqa"))

R_hippo_3_way = summary(emmeans(R_hippo, ~ diagnosis_at_baseline*Sex*Wave)) %>%
  mutate(across(c(emmean, SE), ~ round(.x, 2)))

R_hippo_3_way <- emmip(R_hippo, Sex ~ diagnosis_at_baseline | Wave, plotit = FALSE)
R_hippo_3_way$ymin <- R_hippo_3_way$yvar - R_hippo_3_way$SE
R_hippo_3_way$ymax <- R_hippo_3_way$yvar + R_hippo_3_way$SE

ggplot(R_hippo_3_way, aes(x = Wave, y = yvar, color = interaction(diagnosis_at_baseline, Sex), 
                          group = interaction(diagnosis_at_baseline, Sex))) +
  geom_point(size = 4) +              
  geom_line(linewidth = 2) + 
  geom_errorbar(aes(ymin = ymin, ymax = ymax), width = 0.1, linewidth = 1) +    
  scale_color_manual(
    values = c(
      "CU.Female" = "#56B4E9", "CU.Male" = "#E69F00",   
      "MCI.Female" = "#0072B2","MCI.Male" = "#D55E00"))+
  labs(title = "", x = "", y = expression("Right Hippocampus  in   " * mm^3 * ""), 
       color = "Diagnosis-Sex Group") +
  guides(
    color = guide_legend(override.aes = list(shape = NA, linetype = 1, size = 4))) +
  theme(
    legend.position = "right",  
    legend.title = element_blank(),
    legend.text = element_text(size = 16, color = "black"),
    axis.text.x = element_text(hjust = 0.5, size = 16, color = "black"), 
    axis.text.y = element_text(angle = 0, hjust = 0.5, size = 14, color = "black"),
    axis.title.y = element_text(size = 18),    
    axis.line = element_line(color = "black"),  
    plot.background = element_rect(fill = "white"),  
    panel.background = element_rect(fill = "white"), 
    panel.grid.major = element_blank(),       
    panel.grid.minor = element_blank(),         
    panel.border = element_blank(),            
    text = element_text(family = "serif"))

#### Fig 6 b) Brainstem ----
Brnstem <- lmer(BrainStem~ Sex * diagnosis_at_baseline * Wave + (1  + TIS_years|ID), 
                data = data,  control = lmerControl(optimizer = "bobyqa"))

brnstem_3_way = summary(emmeans(Brnstem, ~ diagnosis_at_baseline*Sex*Wave)) %>%
  mutate(across(c(emmean, SE), ~ round(.x, 2)))

brnstem_3_way <- emmip(Brnstem, Sex ~ diagnosis_at_baseline | Wave, plotit = FALSE)
brnstem_3_way$ymin <- brnstem_3_way$yvar - brnstem_3_way$SE
brnstem_3_way$ymax <- brnstem_3_way$yvar + brnstem_3_way$SE

ggplot(brnstem_3_way, aes(x = Wave, y = yvar, color = interaction(diagnosis_at_baseline, Sex), 
                          group = interaction(diagnosis_at_baseline, Sex))) +
  geom_point(size = 4) +              
  geom_line(linewidth = 2) + 
  geom_errorbar(aes(ymin = ymin, ymax = ymax), width = 0.1, linewidth = 1) +    
  scale_color_manual(
    values = c(
      "CU.Female" = "#56B4E9", "CU.Male" = "#E69F00",   
      "MCI.Female" = "#0072B2","MCI.Male" = "#D55E00"))+
  labs(title = "", x = "", y = expression("Brainstem  in   " * mm^3 * ""), 
       color = "Diagnosis-Sex Group") +
  guides(
    color = guide_legend(override.aes = list(shape = NA, linetype = 1, size = 4))) +
  theme(
    legend.position = "right",  
    legend.title = element_blank(),
    legend.text = element_text(size = 16, color = "black"),
    axis.text.x = element_text(hjust = 0.5, size = 16, color = "black"), 
    axis.text.y = element_text(angle = 0, hjust = 0.5, size = 14, color = "black"),
    axis.title.y = element_text(size = 18),    
    axis.line = element_line(color = "black"),  
    plot.background = element_rect(fill = "white"),  
    panel.background = element_rect(fill = "white"), 
    panel.grid.major = element_blank(),       
    panel.grid.minor = element_blank(),         
    panel.border = element_blank(),            
    text = element_text(family = "serif"))

## TABLE 5 ----
# Relationship between subcortical structure and cognitive scores

# Split data by sex and diagnosis
female <- data.frame(filter(data, Sex == "Female"))
male   <- data.frame(filter(data, Sex == "Male"))

CUfem <- data.frame(filter(female, diagnosis_at_baseline == "CU"))
MCIfem <- data.frame(filter(female, diagnosis_at_baseline == "MCI"))
CUmal <- data.frame(filter(male, diagnosis_at_baseline == "CU"))
MCImal <- data.frame(filter(male, diagnosis_at_baseline == "MCI"))

# Function to calculate slopes for each variable
get_slopes <- function(df, time_var = "TIS_years", id_var = "ID") {
  vars <- c(11:34, 36)
  df %>%
    dplyr::select(all_of(c(id_var, time_var, names(df)[vars]))) %>%
    tidyr::pivot_longer(-all_of(c(id_var, time_var)), names_to = "variable", values_to = "value") %>%
    dplyr::group_by(across(all_of(c(id_var, "variable")))) %>%
    dplyr::summarize(slope = coef(lm(value ~ .data[[time_var]]))[2], .groups = "drop") %>%
    tidyr::pivot_wider(names_from = variable, values_from = slope)
}

# Compute slopes
CUfem_slopes   <- get_slopes(CUfem)
CUmal_slopes   <- get_slopes(CUmal)
MCIfem_slopes  <- get_slopes(MCIfem)
MCImal_slopes  <- get_slopes(MCImal)

# Get variable names
brain_vars <- grep("^(L_|R_|BrainStem)", names(CUfem_slopes), value = TRUE)
other_vars <- setdiff(names(CUfem_slopes), c("ID", brain_vars))

# Function to get correlation + p-value
get_corr_pval <- function(x, y) {
  result <- cor.test(x, y)
  list(cor = result$estimate, p = result$p.value)
}

# Function to run correlations
run_corrs <- function(df_slopes, brain_vars, other_vars) {
  results <- list()
  for (bv in brain_vars) {
    for (ov in other_vars) {
      x <- df_slopes[[bv]]
      y <- df_slopes[[ov]]
      if (is.numeric(x) && is.numeric(y)) {
        res <- get_corr_pval(x, y)
        results[[paste(bv, ov, sep = "_vs_")]] <- data.frame(
          BrainVar = bv,
          OtherVar = ov,
          Correlation = res$cor,
          P_value = res$p
        )
      }
    }
  }
  results_df <- do.call(rbind, results)
  results_df[results_df$P_value < 0.0454, ]
}

# Run correlations for each group
CUfem_sig_results  <- run_corrs(CUfem_slopes, brain_vars, other_vars)
CUmal_sig_results  <- run_corrs(CUmal_slopes, brain_vars, other_vars)
MCIfem_sig_results <- run_corrs(MCIfem_slopes, brain_vars, other_vars)
MCImal_sig_results <- run_corrs(MCImal_slopes, brain_vars, other_vars)

# Load reported results (replace with your file paths)
MCImal_sig_results_alex <- readRDS("MCImal_sig_results_alex.rds")
MCIfem_sig_results_alex <- readRDS("MCIfem_sig_results_alex.rds")
CUfem_sig_results_alex  <- readRDS("CUfem_sig_results_alex.rds")
CUmal_sig_results_alex  <- readRDS("CUmal_sig_results_alex.rds")

# Compare results
compare_results <- function(new_results, reported_results, group_name) {
  # Sort to ensure consistent order
  new_sorted <- new_results[order(new_results$BrainVar, new_results$OtherVar), ]
  reported_sorted <- reported_results[order(reported_results$BrainVar, reported_results$OtherVar), ]
  
  if (isTRUE(all.equal(new_sorted, reported_sorted, tolerance = 1e-8))) {
    message(paste(group_name, ": The results are the same"))
  } else {
    message(paste(group_name, ": The results are different"))
    
    # Show differences if any
    diff_new <- setdiff(new_sorted, reported_sorted)
    diff_reported <- setdiff(reported_sorted, new_sorted)
    
    if (nrow(diff_new) > 0) {
      print("Rows in NEW results but not in REPORTED:")
      print(diff_new)
    }
    
    if (nrow(diff_reported) > 0) {
      print("Rows in REPORTED results but not in NEW:")
      print(diff_reported)
    }
  }
}

# Run comparisons
compare_results(MCImal_sig_results, MCImal_sig_results_alex, "MCI males")
compare_results(MCIfem_sig_results, MCIfem_sig_results_alex, "MCI females")
compare_results(CUmal_sig_results, CUmal_sig_results_alex, "CU males")
compare_results(CUfem_sig_results, CUfem_sig_results_alex, "CU females")

