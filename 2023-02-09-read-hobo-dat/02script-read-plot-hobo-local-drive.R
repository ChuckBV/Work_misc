#===========================================================================#
# script-read-plot-hobo-local-drive.R
# 2023-03-02
#
# Please in local hard drive directory (e.g., Desktop) with the data files 
# of interest. Read from and saves to local directory
#
#===========================================================================#

library(tidyverse)    # dplyr, tidyr, and ggplot2
library(lubridate)    # mdy_hms()  and mday()
library(janitor)      # clean_names()

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

#------------------------------------------------------------------------#
#-- READ CSV AND PLOT TEMPERATURE ONLY -----------------------------------
#   Read Feb 2023 csv file for new environmental controller 
#   Load data frame to Global Environment and clean

##  Confirm dir w script (Desktop) is working dir, find csv files, and 
## rename them for convenience

getwd()                      
file_list <- list.files(pattern = ".csv")

# read Q1
q1 <- read_csv("Queue 1 2023-03-01 08_24_24 PST (Data PST).csv")

q1 <- clean_names(q1)
q1$date_time_pst <- as.POSIXct(mdy_hms(q1$date_time_pst))

q1 <- q1 %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh_percent)

q1
# # A tibble: 490 × 7
#   number date_time_pst       deg_c    rh dew_point_c host_connected end_of_file
#   <dbl> <dttm>              <dbl> <dbl>       <dbl> <chr>          <chr>      
# 1      1 2023-03-02 06:40:00  13.1  87.6       11.1  NA             NA         
# 2      2 2023-03-02 06:50:00  23.4  69.4       17.5  NA             NA         
# 3      3 2023-03-02 07:00:00  24.4  64.5       17.3  NA             NA     

# read Q2
q2 <- read_csv("Queue 2 2023-03-01 08_24_44 PST (Data PST).csv")

q2 <- clean_names(q2)
q2$date_time_pst <- as.POSIXct(mdy_hms(q2$date_time_pst))

q2 <- q2 %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh_percent)

#------------------------------------------------------------------------#
#-- READ CSV AND PLOT TEMPERATURE AND RH AT DEFAULT SCALE ---------------#

## Make the files tidy (temperature and rh in the same column with an index row)

q1 <- q1 %>% 
  select(1:4) %>% # dropped 2 qc cols w mostly NA and a dewpoint col
  pivot_longer(cols = 3:4, names_to = "response_var", values_to = "response")
q1
# # A tibble: 418 × 4
#   number date_time_pst       response_var response
#    <dbl> <dttm>              <chr>           <dbl>
# 1      1 2023-02-07 15:17:00 deg_c            27.1
# 2      1 2023-02-07 15:17:00 rh               45.1
# 3      2 2023-02-07 15:22:00 deg_c            26.4
# 4      2 2023-02-07 15:22:00 rh               41.7

q2 <- q2 %>% 
  select(1:4) %>% # dropped 2 qc cols w mostly NA and a dewpoint col
  pivot_longer(cols = 3:4, names_to = "response_var", values_to = "response")
q2

## Create and save multi-day plot, Queue 1

p1 <- ggplot(q1, aes(x = date_time_pst, y = response)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 m intervals",
       x = "",
       y = " ",
       caption = "Queue1 in H123") +
  facet_grid(response_var ~ ., scales = "free_y") +
  theme_csb_fullwidth1()

p1

ggsave(filename = "hobo_plot_h123q1_2023_03_01.jpg", 
       plot = p1, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")


## Create and save multi-day plot, Queue 2

p2 <- ggplot(q2, aes(x = date_time_pst, y = response)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 m intervals",
       x = "",
       y = " ",
       caption = "Queue2 in H123") +
  facet_grid(response_var ~ ., scales = "free_y") +
  theme_csb_fullwidth1()

p2

ggsave(filename = "hobo_plot_h123q2_2023_03_01.jpg", 
       plot = p2, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")


#------------------------------------------------------------------------#
#-- CHOOSE 1 DAY AND REPLOT ---------------------------------------------#

## Examine Feb 27, 2023. Both files start in February

q1_mar27 <- q1 %>% 
  filter(mday(date_time_pst) == 27)

q2_mar27 <- q2 %>% 
  filter(mday(date_time_pst) == 27)

## Create and save one-day plot, Queue 1

p3 <- ggplot(q1_mar27, aes(x = date_time_pst, y = response)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 m intervals",
       x = "",
       y = " ",
       caption = "Queue1 in H123") +
  facet_grid(response_var ~ ., scales = "free_y") +
  theme_csb_fullwidth1()

p3

ggsave(filename = "hobo_plot_h123q1_2023_02_27_24hr.jpg", 
       plot = p3, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

## Create and save one-day plot, Queue 2

p4 <- ggplot(q2_mar27, aes(x = date_time_pst, y = response)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 m intervals",
       x = "",
       y = " ",
       caption = "Queue2 in H123") +
  facet_grid(response_var ~ ., scales = "free_y") +
  theme_csb_fullwidth1()

p4

ggsave(filename = "hobo_plot_h123q2_2023_02_27_24hr.jpg", 
       plot = p4, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

