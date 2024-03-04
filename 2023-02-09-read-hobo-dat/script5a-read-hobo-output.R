#===========================================================================#
# script5a-read-hobo-output.R
# 2024-03
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
#-- 1. Q1 H123 2024-03-04 update -----------------------------------------

# 2024-03-04

dat <- read_xlsx("./Queue 1 2024-03-04 12_36_26 PST (Data PST).xlsx")

dat <- clean_names(dat)

glimpse(dat)
# Rows: 8,809
# Columns: 5
# $ number             <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,…
# $ date_time_pst      <dttm> 2024-01-03 08:34:53, 2024-01-03 08:44:53, 2024-01-03 08:54:53…
# $ ch_1_temperature_c <dbl> 30.24, 28.49, 28.02, 26.70, 26.38, 26.38, 26.45, 26.57, 26.72,…
# $ ch_2_rh_percent    <dbl> 44.79980, 46.16699, 47.85156, 45.31250, 51.87988, 50.85449, 50…
# $ dew_point_c        <dbl> 16.93575, 15.82251, 15.95607, 13.90778, 15.71745, 15.40554, 15…

# variable types look good

dat <- dat %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh_percent)

glimpse(dat)
# Rows: 8,809
# Columns: 5
# $ number        <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, …
# $ date_time_pst <dttm> 2024-01-03 08:34:53, 2024-01-03 08:44:53, 2024-01-03 08:54:53, 202…
# $ deg_c         <dbl> 30.24, 28.49, 28.02, 26.70, 26.38, 26.38, 26.45, 26.57, 26.72, 26.8…
# $ rh            <dbl> 44.79980, 46.16699, 47.85156, 45.31250, 51.87988, 50.85449, 50.9277…
# $ dew_point_c   <dbl> 16.93575, 15.82251, 15.95607, 13.90778, 15.71745, 15.40554, 15.4924…

# Filter everything after the last repository update (1/30/24)

dat <- dat %>% 
  filter(number >= 3982)

# Plot Temperature
p9 <- ggplot(dat, aes(x = date_time_pst, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue1 in H123") +
  theme_csb_halfwidth1()

p9

ggsave(filename = "hobo_plot_2024_03_04__q1.jpg", 
       plot = p9, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

# Plot Humidity
p10 <- ggplot(dat, aes(x = date_time_pst, y = rh)) +
  geom_line() +
  labs(title = "Relative humidity logger readings, 10 s intervals",
       x = "",
       y = "Relative Humidity",
       caption = "Queue1 in H123") +
  theme_csb_halfwidth1()

p10

ggsave(filename = "hobo_plot_2024_03_04_q1.jpg", 
       plot = p10, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")


#------------------------------------------------------------------------#
#-- 2. Q2 H123 2024-03-04 update -----------------------------------------


dat1 <- read_xlsx("./Queue 2 2024-03-04 12_37_34 PST (Data PST).xlsx")

dat1 <- clean_names(dat1)

glimpse(dat1)
# Rows: 33,021
# Columns: 5
# $ number             <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,…
# $ date_time_pst_pdt  <dttm> 2023-07-19 06:14:47, 2023-07-19 06:24:47, 2023-07-19 06:34:47…
# $ ch_1_temperature_c <dbl> 26.99, 27.19, 27.41, 26.08, 26.43, 26.65, 26.89, 27.11, 27.33,…
# $ ch_2_rh_percent    <dbl> 59.17969, 58.95996, 58.61816, 62.42676, 60.20508, 57.81250, 57…
# $ dew_point_c        <dbl> 18.36550, 18.49343, 18.60641, 18.36298, 18.11424, 17.67501, 17…

# variable types look good

dat1 <- dat1 %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh_percent)

glimpse(dat1)
#looks good

# Plot Temperature
p11 <- ggplot(dat1, aes(x = date_time_pst_pdt, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue2 in H123") +
  theme_csb_halfwidth1()

p11

ggsave(filename = "hobo_plot_2024_03_04_q2.jpg", 
       plot = p11, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

# Plot Humidity
p12 <- ggplot(dat1, aes(x = date_time_pst_pdt, y = rh)) +
  geom_line() +
  labs(title = "Relative humidity logger readings, 10 s intervals",
       x = "",
       y = "Relative Humidity",
       caption = "Queue2 in H123") +
  theme_csb_halfwidth1()

p12

ggsave(filename = "hobo_plot_2024_03_04__q2.jpg", 
       plot = p12, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

