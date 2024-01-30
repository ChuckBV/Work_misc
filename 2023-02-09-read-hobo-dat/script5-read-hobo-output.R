#===========================================================================#
# script5-read-hobo-output.R
# 2024-01
#
#===========================================================================#

library(tidyverse)
#library(readxl)
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
#-- 1. Q1 H123 2024-01-02 update -----------------------------------------

# 2024-01-02

dat <- read.csv("./2023-02-09-read-hobo-dat/Queue 1 2024-01-02 14_19_50 PST (Data PST)(2).xlsx - Data.csv")

dat <- clean_names(dat)

glimpse(dat)

# Rows: 24,103
# Columns: 5
# $ x                  <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1…
# $ date_time_pst_pdt  <chr> "07/19/2023 06:14:02", "07/19/2023 06:24:02", "07/19/2023 06:34:…
# $ ch_1_temperature_c <dbl> 27.06, 27.14, 27.16, 27.26, 27.33, 27.31, 25.99, 25.74, 26.11, 2…
# $ ch_2_rh            <dbl> 60.645, 57.275, 60.547, 62.061, 61.157, 61.157, 49.243, 70.459, …
# $ dew_point_c        <dbl> 18.82, 17.98, 18.89, 19.38, 19.21, 19.19, 14.55, 19.99, 20.27, 2…

# change date_time_pst_pdt to date

dat$date_time_pst_pdt <- mdy_hms(dat$date_time_pst_pdt)

dat <- dat %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh)

glimpse(dat)

# Rows: 24,103
# Columns: 5
# $ x                 <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19…
# $ date_time_pst_pdt <dttm> 2023-07-19 06:14:02, 2023-07-19 06:24:02, 2023-07-19 06:34:02, 2…
# $ deg_c             <dbl> 27.06, 27.14, 27.16, 27.26, 27.33, 27.31, 25.99, 25.74, 26.11, 26…
# $ rh                <dbl> 60.645, 57.275, 60.547, 62.061, 61.157, 61.157, 49.243, 70.459, 7…
# $ dew_point_c       <dbl> 18.82, 17.98, 18.89, 19.38, 19.21, 19.19, 14.55, 19.99, 20.27, 20…

# Filter last two months

dat <- dat %>% 
  filter(x >= 19554)

# Plot
p4 <- ggplot(dat, aes(x = date_time_pst_pdt, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue1 in H123") +
  theme_csb_halfwidth1()

p4

ggsave(filename = "hobo_plot_2024_01_02.jpg", 
       plot = p4, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

#------------------------------------------------------------------------#
#-- 2. Q1 H123 2024-01-30 update -----------------------------------------

# 2024-01-30

dat1 <- read.csv("./Queue 1 2024-01-29 07_56_34 PST (Data PST).xlsx - Data.csv")

dat1 <- clean_names(dat1)

glimpse(dat1)
# Rows: 3,741
# Columns: 5
# $ x                  <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,…
# $ date_time_pst      <chr> "01/03/2024 08:34:53", "01/03/2024 08:44:53", "01/03/2024 08:5…
# $ ch_1_temperature_c <dbl> 30.24, 28.49, 28.02, 26.70, 26.38, 26.38, 26.45, 26.57, 26.72,…
# $ ch_2_rh            <dbl> 44.800, 46.167, 47.852, 45.313, 51.880, 50.854, 50.928, 50.830…
# $ dew_point_c        <dbl> 16.94, 15.82, 15.96, 13.91, 15.72, 15.41, 15.49, 15.57, 15.67,…

# change date_time_pst_pdt to date

dat1$date_time_pst <- mdy_hms(dat1$date_time_pst)

dat1 <- dat1 %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh)

glimpse(dat1)
#looks good

# Plot Temperature
p5 <- ggplot(dat1, aes(x = date_time_pst, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue1 in H123") +
  theme_csb_halfwidth1()

p5

ggsave(filename = "hobo_plot_2024_01_30.jpg", 
       plot = p5, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

# Plot Humidity
p6 <- ggplot(dat1, aes(x = date_time_pst, y = rh)) +
  geom_line() +
  labs(title = "Relative humidity logger readings, 10 s intervals",
       x = "",
       y = "Relative Humidity",
       caption = "Queue1 in H123") +
  theme_csb_halfwidth1()

p6

ggsave(filename = "hobo_plot_2024_01_30_.jpg", 
       plot = p6, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

#------------------------------------------------------------------------#
#-- 3. Q2 H123 2024-01-02 update -----------------------------------------

dat2 <- read.csv("./Queue 2 2024-01-30 12_57_47 PST (Data PST).xlsx - Data.csv")

dat2 <- clean_names(dat2)

glimpse(dat2)
# Rows: 28,127
# Columns: 5
# $ x                  <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,…
# $ date_time_pst_pdt  <chr> "07/19/2023 06:14:47", "07/19/2023 06:24:47", "07/19/2023 06:3…
# $ ch_1_temperature_c <dbl> 26.99, 27.19, 27.41, 26.08, 26.43, 26.65, 26.89, 27.11, 27.33,…
# $ ch_2_rh            <dbl> 59.180, 58.960, 58.618, 62.427, 60.205, 57.813, 57.324, 56.763…
# $ dew_point_c        <dbl> 18.37, 18.49, 18.61, 18.36, 18.11, 17.68, 17.76, 17.81, 17.82,…

# change date_time_pst_pdt to date

dat2$date_time_pst_pdt <- mdy_hms(dat2$date_time_pst_pdt)

dat2 <- dat2 %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh)

glimpse(dat2)
#looks good

# Filter last month

dat2 <- dat2 %>% 
  filter(x >= 23874)

# Plot
p7 <- ggplot(dat2, aes(x = date_time_pst_pdt, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue2 in H123") +
  theme_csb_halfwidth1()

p7

ggsave(filename = "hobo_plot_2024_01_30_q2.jpg", 
       plot = p7, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

# Plot Humidity
p8 <- ggplot(dat2, aes(x = date_time_pst_pdt, y = rh)) +
  geom_line() +
  labs(title = "Relative humidity logger readings, 10 s intervals",
       x = "",
       y = "Relative Humidity",
       caption = "Queue2 in H123") +
  theme_csb_halfwidth1()

p8

ggsave(filename = "hobo_plot_2024_01_30_q2_.jpg", 
       plot = p8, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")
