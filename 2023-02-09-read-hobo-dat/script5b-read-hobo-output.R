#===========================================================================#
# script5b-read-hobo-output.R
# 2024-03-28
#
#===========================================================================#

library(tidyverse)
library(readxl)
library(janitor)
library(lubridate)

### Function to make plots look descent in printed form when printed at
### ESA full page width
theme_csb_fullwidth1 <- function(){
  theme_bw() +
    theme(axis.text.x = element_text(color = "black", size = 12),
          axis.text.y = element_text(color = "black", size = 12),
          axis.title.x = element_text(color = "black", size = 12),
          axis.title.y = element_text(color = "black", size = 12),
          legend.title = element_text(color = "black", size = 12),
          legend.text = element_text(color = "black", size = 10)
    )
}

theme_csb_halfwidth1 <- function(){
  theme_bw() +
    theme(axis.text.x = element_text(color = "black", size = 10),
          axis.text.y = element_text(color = "black", size = 10),
          axis.title.x = element_text(color = "black", size = 10),
          axis.title.y = element_text(color = "black", size = 10),
          legend.title = element_text(color = "black", size = 10),
          legend.text = element_text(color = "black", size = 9)
    )
}


#------------------------------------------------------------------------#
#-- 1. Q1 H123 2024-03-28 update -----------------------------------------

# 2024-03-28

dat <- read.csv("./Queue 1 2024-03-28 07_13_19 PDT (Data PDT).csv")

dat <- clean_names(dat)

glimpse(dat)
#
# $ x                  <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 1…
# $ date_time_pst_pdt  <chr> "01/03/2024 08:34:53", "01/03/2024 08:44:53", "01/03/2024 08…
# $ ch_1_temperature_c <dbl> 30.24, 28.49, 28.02, 26.70, 26.38, 26.38, 26.45, 26.57, 26.7…
# $ ch_2_rh            <dbl> 44.800, 46.167, 47.852, 45.313, 51.880, 50.854, 50.928, 50.8…
# $ dew_point_c        <dbl> 16.94, 15.82, 15.96, 13.91, 15.72, 15.41, 15.49, 15.57, 15.6…
# $ host_connected     <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", …
# $ end_of_file        <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", …

# variable types look good

dat <- dat %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh)

glimpse(dat)
# Rows: 12,229
# Columns: 7
# $ x                 <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18…
# $ date_time_pst_pdt <chr> "01/03/2024 08:34:53", "01/03/2024 08:44:53", "01/03/2024 08:…
# $ deg_c             <dbl> 30.24, 28.49, 28.02, 26.70, 26.38, 26.38, 26.45, 26.57, 26.72…
# $ rh                <dbl> 44.800, 46.167, 47.852, 45.313, 51.880, 50.854, 50.928, 50.83…
# $ dew_point_c       <dbl> 16.94, 15.82, 15.96, 13.91, 15.72, 15.41, 15.49, 15.57, 15.67…
# $ host_connected    <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "…
# $ end_of_file       <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "…

# Filter everything after the last repository update (3/4)

dat <- dat %>% 
  filter(x >= 8880) %>% 
  slice(-3350) %>% 
  select(1:5)

# Plot Temperature
p13 <- ggplot(dat, aes(x = date_time_pst_pdt, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue1 in H123") +
  theme_csb_halfwidth1()

p13

ggsave(filename = "hobo_plot_2024_03_04__q1.jpg", 
       plot = p9, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

# Plot Humidity
p14 <- ggplot(dat, aes(x = date_time_pst_pdt, y = rh)) +
  geom_line() +
  labs(title = "Relative humidity logger readings, 10 s intervals",
       x = "",
       y = "Relative Humidity",
       caption = "Queue1 in H123") +
  theme_csb_halfwidth1()

p14

ggsave(filename = "hobo_plot_2024_03_04_q1.jpg", 
       plot = p10, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")


#------------------------------------------------------------------------#
#-- 2. Q2 H123 2024-03-04 update -----------------------------------------


dat1 <- read.csv("./Queue 2 2024-03-28 07_14_36 PDT (Data PDT).csv")

dat1 <- clean_names(dat1)

glimpse(dat1)
# Rows: 36,448
# Columns: 7
# $ x                  <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, …
# $ date_time_pst_pdt  <chr> "07/19/2023 06:14:47", "07/19/2023 06:24:47", "07/19/2023 0…
# $ ch_1_temperature_c <dbl> 26.99, 27.19, 27.41, 26.08, 26.43, 26.65, 26.89, 27.11, 27.…
# $ ch_2_rh            <dbl> 59.180, 58.960, 58.618, 62.427, 60.205, 57.813, 57.324, 56.…
# $ dew_point_c        <dbl> 18.37, 18.49, 18.61, 18.36, 18.11, 17.68, 17.76, 17.81, 17.…
# $ host_connected     <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",…
# $ end_of_file        <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",…
 
# variable types look good

dat1 <- dat1 %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh)

glimpse(dat1)
#looks good

# Filter everything after the last repository update (3/4)

dat1 <- dat1 %>% 
  filter(x >= 33096) %>% 
  filter(x <= 36446) %>% 
  select(1:5)

# Plot Temperature
p15 <- ggplot(dat1, aes(x = date_time_pst_pdt, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue2 in H123") +
  theme_csb_halfwidth1()

p15

ggsave(filename = "hobo_plot_2024_03_04_q2.jpg", 
       plot = p11, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

# Plot Humidity
p16 <- ggplot(dat1, aes(x = date_time_pst_pdt, y = rh)) +
  geom_line() +
  labs(title = "Relative humidity logger readings, 10 s intervals",
       x = "",
       y = "Relative Humidity",
       caption = "Queue2 in H123") +
  theme_csb_halfwidth1()

p16

ggsave(filename = "hobo_plot_2024_03_04__q2.jpg", 
       plot = p12, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

