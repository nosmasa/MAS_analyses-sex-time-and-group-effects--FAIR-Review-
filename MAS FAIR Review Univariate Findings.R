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

#Set directory (wherever the excel file is saved)
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
# Relationship between subcortical strucutre and cognitive scores 
female = data.frame(filter(data, Sex == "Female"))
male = data.frame(filter(data, Sex == "Male"))

CUfem = data.frame(filter(female, diagnosis_at_baseline == "CU"))
MCIfem = data.frame(filter(female, diagnosis_at_baseline == "MCI"))

CUmal = data.frame(filter(male, diagnosis_at_baseline == "CU"))
MCImal = data.frame(filter(male, diagnosis_at_baseline == "MCI"))

#Using TIS_years
get_slopes <- function(df, time_var = "TIS_years", id_var = "ID") {
  vars <- c(11:34, 36)
  df %>%
    dplyr::select(all_of(c(id_var, time_var, names(df)[vars]))) %>%
    tidyr::pivot_longer(-all_of(c(id_var, time_var)), names_to = "variable", values_to = "value") %>%
    dplyr::group_by(across(all_of(c(id_var, "variable")))) %>%
    dplyr::summarize(slope = coef(lm(value ~ .data[[time_var]]))[2], .groups = "drop") %>%
    tidyr::pivot_wider(names_from = variable, values_from = slope)
}

CUfem_slopes   <- get_slopes(CUfem)
CUmal_slopes   <- get_slopes(CUmal)
MCIfem_slopes  <- get_slopes(MCIfem)
MCImal_slopes  <- get_slopes(MCImal)

# Get variable names - can use the same variables for the other groups 
brain_vars <- grep("^(L_|R_|BrainStem)", names(CUfem_slopes), value = TRUE)
other_vars <- setdiff(names(CUfem_slopes), c("ID", brain_vars))

# Function to get correlation and p-value
get_corr_pval <- function(x, y) {
  result <- cor.test(x, y)
  list(cor = result$estimate, p = result$p.value)
}

# Initialize empty list to store results for each group 
CUfem_results <- list()
CUmal_results <- list()
MCIfem_results <- list()
MCImal_results <- list()

# Loop over combinations of brain_vars and other_vars
#CU females
for (bv in brain_vars) {
  for (ov in other_vars) {
    x <- CUfem_slopes[[bv]]
    y <- CUfem_slopes[[ov]]
    if (is.numeric(x) && is.numeric(y)) {
      res <- get_corr_pval(x, y)
      CUfem_results[[paste(bv, ov, sep = "_vs_")]] <- data.frame(
        BrainVar = bv,
        OtherVar = ov,
        Correlation = res$cor,
        P_value = res$p
      )
    }
  }
}

CUfem_cor_results <- do.call(rbind, CUfem_results)
CUfem_sig_results <- CUfem_cor_results[CUfem_cor_results$P_value < 0.0454, ]

# Compare these below results to the CU Female results in Table 5
View(CUfem_sig_results)

#CU males
for (bv in brain_vars) {
  for (ov in other_vars) {
    x <- CUmal_slopes[[bv]]
    y <- CUmal_slopes[[ov]]
    if (is.numeric(x) && is.numeric(y)) {
      res <- get_corr_pval(x, y)
      CUmal_results[[paste(bv, ov, sep = "_vs_")]] <- data.frame(
        BrainVar = bv,
        OtherVar = ov,
        Correlation = res$cor,
        P_value = res$p
      )
    }
  }
}

CUmal_cor_results <- do.call(rbind, CUmal_results)
CUmal_sig_results <- CUmal_cor_results[CUmal_cor_results$P_value < 0.0454, ]

#incase the correlations are in scientific notation then run below 
#CNmal_cor_results$Correlation <- formatC(CNmal_cor_results$Correlation, format = "f", digits = 10)

# Compare these below results to the CU Male results in Table 5
View(CUmal_sig_results)

#MCI females
for (bv in brain_vars) {
  for (ov in other_vars) {
    x <- MCIfem_slopes[[bv]]
    y <- MCIfem_slopes[[ov]]
    if (is.numeric(x) && is.numeric(y)) {
      res <- get_corr_pval(x, y)
      MCIfem_results[[paste(bv, ov, sep = "_vs_")]] <- data.frame(
        BrainVar = bv,
        OtherVar = ov,
        Correlation = res$cor,
        P_value = res$p
      )
    }
  }
}

MCIfem_cor_results <- do.call(rbind, MCIfem_results)
MCIfem_sig_results <- MCIfem_cor_results[MCIfem_cor_results$P_value < 0.0454, ]

# Compare these below results to the MCI Female results in Table 5
View(MCIfem_sig_results)

#MCI males
for (bv in brain_vars) {
  for (ov in other_vars) {
    x <- MCImal_slopes[[bv]]
    y <- MCImal_slopes[[ov]]
    if (is.numeric(x) && is.numeric(y)) {
      res <- get_corr_pval(x, y)
      MCImal_results[[paste(bv, ov, sep = "_vs_")]] <- data.frame(
        BrainVar = bv,
        OtherVar = ov,
        Correlation = res$cor,
        P_value = res$p
      )
    }
  }
}

MCImal_cor_results <- do.call(rbind, MCImal_results)
MCImal_sig_results <- MCImal_cor_results[MCImal_cor_results$P_value < 0.0454, ]

# Compare these below results to the MCI Male results in Table 5
View(MCImal_sig_results)
