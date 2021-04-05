# script2-p-auraria-md.R

library(tidyverse)
library(readxl)
library(car)
library(Rmisc)
library(FSA)  # for se
library(multcomp)
library(multcompView)
library(emmeans)

## shamelessly cribbed from parts of
## https://www.rcompanion.org/rcompanion/index.html

#-- 1. Get data set into the Repo ---------------------------------------------
#lure_aging <- read_excel("C:/Users/Charles.Burks/Desktop/p_auraria_pheromone.xlsx",
#                         range = "A1:D11")
lure_aging
# A tibble: 10 x 4
#   Weeks  TrtA  TrtB  TrtC
#    <dbl> <dbl> <dbl> <dbl>
#  1     1    14    25    26
#  2     2    26    21    27
#  3     3    22    24    11
#  4     4    23    28    24
#  5     5     8    27    23
#  6     6    18    20    30
#  7     7    16    28    24
#  8     8    13    21    23
#  9     9    17    27    17
# 10    10    15    26    21

#write.csv(lure_aging,"p_auraria_lure_age.csv", row.names = FALSE)
lure_aging <- read_csv("p_auraria_lure_age.csv")

#-- 2. Examine capture vs age for three treatments ---------------------------
m_reg_a <- lm(TrtA ~ Weeks, data = lure_aging)
summary(m_reg_a)
# Residual standard error: 5.207 on 8 degrees of freedom
# Multiple R-squared:  0.1446,	Adjusted R-squared:  0.03766 
# F-statistic: 1.352 on 1 and 8 DF,  p-value: 0.2784

m_reg_b <- lm(TrtB ~ Weeks, data = lure_aging)
summary(m_reg_b)
# Residual standard error: 3.193 on 8 degrees of freedom
# Multiple R-squared:  0.0303,	Adjusted R-squared:  -0.09091 
# F-statistic:  0.25 on 1 and 8 DF,  p-value: 0.6305

m_reg_c <- lm(TrtC ~ Weeks, data = lure_aging)
summary(m_reg_c)
# Residual standard error: 5.606 on 8 degrees of freedom
# Multiple R-squared:  0.02702,	Adjusted R-squared:  -0.0946 
# F-statistic: 0.2222 on 1 and 8 DF,  p-value: 0.65

#-- 3. Examine lure means w 2-way ANOVA --------------------------------------

## Recode wide to long
tidylure <- lure_aging %>% 
  tidyr::pivot_longer(cols = (2:4),
               names_to = "lure",
               values_to = "count")

## summary stats
fctr_stats <- summarySE(tidylure,
                        measurevar = "count",
                        groupvars = c("lure","Weeks"))
fctr_stats
#    lure Weeks N count sd se  ci
# 1  TrtA     1 1    14 NA NA NaN
# 2  TrtA     2 1    26 NA NA NaN
# 3  TrtA     3 1    22 NA NA NaN
  # n = 1 in all cells, so meaningless

anov <- lm(count ~ lure + Weeks,
           data = tidylure)

car::Anova(anov, type = "II")

tidylure %>% 
  group_by(lure) %>% 
  dplyr::summarise(nObs = n(),
            mn = mean(count, na.rm = TRUE),
            sem = FSA::se(count))


tidylure %>% 
  group_by(lure) %>% 
  summarise(nObs = sum(!is.na(count)),
            mn = mean(count, na.rm = TRUE),
            sem = FSA::se(count))
# A tibble: 3 x 4
# lure   nObs    mn   sem
#   <chr> <int> <dbl> <dbl>
# 1 TrtA     10  17.2 1.68 
# 2 TrtB     10  24.7 0.967
# 3 TrtC     10  22.6 1.69 

em <- emmeans::emmeans(anov,
                 ~ lure,
                 adjust = "tukey")

multcomp::cld(em,
    alpha = 0.05,
    Letter = letters)
