#===========================================================================#
# script4-read-hobo-output.R
# 2023-02-06
#
#===========================================================================#

library(tidyverse)
#library(readxl)
library(janitor)

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
#-- READ CSV AND PLOT TEMPERATURE ONLY -----------------------------------
#   Read Feb 2023 csv file for new environmental controller 
#   Load data frame to Global Environment and clean

dat_in <- read_csv("./2023-02-09-read-hobo-dat/Queue 2 2023-05-02 06_34_22 PDT (Data PDT).csv")
dat_in <- clean_names(dat_in)
dat_in


dat_in$date_time_pst_pdt <- as.POSIXct(mdy_hm(dat_in$date_time_pst_pdt))

dat_in <- dat_in %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh_percent)

dat_in
# # A tibble: 490 × 7
#   number date_time_pst       deg_c    rh dew_point_c host_connected end_of_file
#   <dbl> <dttm>              <dbl> <dbl>       <dbl> <chr>          <chr>      
# 1      1 2023-03-02 06:40:00  13.1  87.6       11.1  NA             NA         
# 2      2 2023-03-02 06:50:00  23.4  69.4       17.5  NA             NA         
# 3      3 2023-03-02 07:00:00  24.4  64.5       17.3  NA             NA     

# Plot
p1 <- ggplot(dat_in, aes(x = date_time_pst_pdt, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue2 in H123") +
  theme_csb_halfwidth1()

p1

ggsave(filename = "hobo_plot_2023_02_06.jpg", 
       plot = p1, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

#-------------------------------------------------------------------#
#-- READ EXCEL AND PLOT TEMPERATURE ONLY ---------------------------


#   Read a 2022 file for old environmental controller

old <- read_excel("h123-q2-2022-02-11-07-18-05-0800.xlsx",
           sheet = "DATA",
           skip = 1)

old <- clean_names(old)


old <- old %>% 
  rename(date_time = date_time_gmt_0700,
         deg_c = temp_c,
         rh = rh_percent)

# Select 3 days

old <- dat_in %>% 
  mutate(Date = as.Date(date_time_pst_pdt),
         Julian = yday(as.Date(date_time_pst_pdt))) %>%
  group_by(Julian) %>% 
  summarise(nObs = n())
tail(old) 

old <- dat_in %>%  # narrow to October
  filter(yday(as.Date(date_time_pst_pdt)) > 120)# & month(date_time) < 11)

# old <- old %>% # narrow to first three days of October
#   filter(mday(date_time) < 4)

#  Make and save the plot

p2 <- ggplot(old, aes(x = date_time_pst_pdt, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 5 min intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue2 in H123") +
  ylim(25,28) +
  theme_csb_halfwidth1()

p2

ggsave(filename = "hobo_plot_2022_10_03.jpg", 
       plot = p2, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")

#------------------------------------------------------------------------#
#-- READ CSV AND PLOT TEMPERATURE AND RH ---------------------------------
#   Read Feb 2023 csv file for new environmental controller 


#   Load data frame to Global Environment and clean
dat_in <- read_csv("Queue 2 2023-02-08 08_24_03 PST (Data PST).csv")
dat_in <- clean_names(dat_in)
dat_in$date_time_pst <- as.POSIXct(mdy_hm(dat_in$date_time_pst))

dat_in <- dat_in %>% 
  rename(deg_c = ch_1_temperature_c,
         rh = ch_2_rh_percent)

dat_in
# # A tibble: 209 × 7
#   number date_time_pst       deg_c    rh dew_point_c host_connected end_of_file
#    <dbl> <dttm>              <dbl> <dbl>       <dbl> <chr>          <chr>      
# 1      1 2023-02-07 15:17:00  27.1  45.1        14.2 NA             NA         
# 2      2 2023-02-07 15:22:00  26.4  41.7        12.4 NA             NA        

# Make tidy (all number response data in same column)

dat_in <- dat_in %>% 
  select(1:4) %>% # dropped 2 qc cols w mostly NA and a dewpoint col
  pivot_longer(cols = 3:4, names_to = "response_var", values_to = "response")
dat_in
# # A tibble: 418 × 4
#   number date_time_pst       response_var response
#    <dbl> <dttm>              <chr>           <dbl>
# 1      1 2023-02-07 15:17:00 deg_c            27.1
# 2      1 2023-02-07 15:17:00 rh               45.1
# 3      2 2023-02-07 15:22:00 deg_c            26.4
# 4      2 2023-02-07 15:22:00 rh               41.7

# Plot
p3 <- ggplot(dat_in, aes(x = date_time_pst, y = response)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = " ",
       caption = "Queue2 in H123") +
  facet_grid(response_var ~ ., scales = "free_y") +
  theme_csb_fullwidth1()

p3

ggsave(filename = "hobo_plot_2023_02_08.jpg", 
       plot = p3, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")
