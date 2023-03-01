#============================================================================#
# script5-ggplot-scractch.R                                                  #
#
#
#=============================================================================

library(tidyverse)
library(FSA)

Iris <- iris

# Genrate means and SE

sepal_means <- Iris %>% 
  group_by(Species) %>% 
  summarise(nObs = n(),
            mn = mean(Sepal.Length),
            sem = FSA::se(Sepal.Length))
sepal_means
# # A tibble: 3 × 4
#   Species     nObs    mn    sem
#   <fct>      <int> <dbl>  <dbl>
# 1 setosa        50  5.01 0.0498
# 2 versicolor    50  5.94 0.0730
# 3 virginica     50  6.59 0.0899

# Get basic plot

p1 <- ggplot(sepal_means, aes(x = Species, y = mn)) +
  geom_col() +
  geom_errorbar(aes(ymin = mn - sem, 
                    ymax = mn + sem),
                width = 0.5) 

p1

ggsave(filename = "iris-sepal-means-default.jpg", plot = p1, device = "jpg",  
       dpi = 300, width = 2.83, height = 2.1225, units = "in")

# Place theme in a function and use it
#  --- See https://www.r-bloggers.com/2023/01/tips-for-organising-your-r-code/,
#  --- part 3

theme_burks_halfwidth <- function(){
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 9),
    axis.text.y = element_text(color = "black", size = 9),
    axis.title.x = element_text(color = "black", size = 12),
    axis.title.y = element_text(color = "black", size = 12),
    legend.title = element_text(color = "black", size = 9),
    legend.text = element_text(color = "black", size = 8))
}

p2 <- p1 +
  theme_burks_halfwidth() 

p2

ggsave(filename = "iris-sepal-means-w-formatting.jpg", plot = p2, device = "jpg",
       path = "./2023-02-13-ggplot-cheat-sheets",
       dpi = 300, width = 2.83, height = 2.1225, units = "in")
