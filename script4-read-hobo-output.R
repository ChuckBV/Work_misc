#===========================================================================#
# script4-read-hobo-output.R
# 2023-02-06
#
#
#
#===========================================================================#

library(tidyverse)
library(lubridate)
library(readxl)
library(janitor)

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

# Load data frame to Global Environment and clean

dat_in <- read_csv("q2-2023-02-06.csv")
dat_in <- clean_names(dat_in)
dat_in$date_time_pst <- as.POSIXct(mdy_hm(dat_in$date_time_pst))

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
p1 <- ggplot(dat_in, aes(x = date_time_pst, y = deg_c)) +
  geom_line() +
  labs(title = "Temperature logger readings, 10 s intervals",
       x = "",
       y = "Degree Celcius",
       caption = "Queue2 in H123") +
  theme_csb_fullwidth1()

p1

ggsave(filename = "hobo_plot_2023_02_06.jpg", 
       plot = p1, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")


