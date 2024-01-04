#===========================================================================#
# script5-read-hobo-output.R
# 2024-01-02
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
#-- READ CSV AND PLOT TEMPERATURE ONLY -----------------------------------

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
       caption = "Queue2 in H123") +
  theme_csb_halfwidth1()

p4

ggsave(filename = "hobo_plot_2024_01_02.jpg", 
       plot = p4, device = "jpg", 
       dpi = 300, width = 5.83, height = 5.83, units = "in")