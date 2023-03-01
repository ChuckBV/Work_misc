# y23-phx-now-hatch.R

## Determine hatch rate of eggs on USDA-Parlier PST egg papers

library(tidyverse)
library(readxl)
library(janitor)

# Read data

eggs <- read_excel("./2023-02-28-now-egg-hatch/Y23_Egg_Paper_First_Instar_Eval_Phoenix.xlsx")

# Clean data

eggs <- clean_names(eggs)
eggs$obs_day <- as.Date(eggs$obs_day)
eggs$start_date <- as.Date(eggs$start_date)
eggs$end_date <- as.Date(eggs$end_date)
eggs
# # A tibble: 114 × 12
#   obs_day    start_date end_date   day_check id_number total red_hatch red_unhatched white_hatch white_un_hatched larvae comments
#   <date>     <date>     <date>         <dbl>     <dbl> <dbl>     <dbl>         <dbl>       <dbl>            <dbl>  <dbl> <chr>   
# 1 2023-02-13 2023-02-07 2023-02-10         1         1    50         0            32           0               18      2 NA      
# 2 2023-02-13 2023-02-07 2023-02-10         1         2    50         0            24           0               26      4 NA      
# 3 2023-02-13 2023-02-07 2023-02-10         1         3    50         0            38           0               12      2 NA      

# Number of unique egg papers

eggs %>% 
  group_by(start_date,id_number) %>% 
  summarise(nObs = n())
# # A tibble: 30 × 3
# # Groups:   start_date [5]
#   start_date id_number  nObs
#   <date>         <dbl> <int>
# 1 2023-02-07         1     5
# 2 2023-02-07         2     5
# 3 2023-02-07         3     5

# one paper as an example

eggs %>% 
  filter(start_date == as.Date("2023-02-07") & id_number == 1)
# # A tibble: 5 × 12
#   obs_day    start_date end_date   day_check id_number total red_hatch red_unhatched white_hatch white_un_hatched larvae comments
#   <date>     <date>     <date>         <dbl>     <dbl> <dbl>     <dbl>         <dbl>       <dbl>            <dbl>  <dbl> <chr>   
# 1 2023-02-13 2023-02-07 2023-02-10         1         1    50         0            32           0               18      2 NA      
# 2 2023-02-14 2023-02-07 2023-02-10         2         1    50         0            26           0               17      1 NA      
# 3 2023-02-15 2023-02-07 2023-02-10         3         1    33         0            12           0               11      0 NA      
# 4 2023-02-16 2023-02-07 2023-02-10         4         1    30        14             0          16                0      0 NA      
# 5 2023-02-17 2023-02-07 2023-02-10         5         1    50        32             0          18                0      0 NA 

eggs <- eggs %>% 
  arrange(start_date,id_number,day_check)
