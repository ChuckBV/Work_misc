# script3-hacu-2021.R

library(tidyverse)

candidates <- list.files("C:/Users/Charles.Burks/OneDrive - USDA/_Personnel/_hacu2021/")
candidates <- as.data.frame(candidates)
colnames(candidates) <- "name"

candidates <- candidates %>% 
  filter(str_detect(name,"HACU", negate = TRUE)) %>% 
  filter(str_detect(name,"hacu", negate = TRUE))
candidates
# 1      Alexander Lopez.pdf
# 2          Alexia Beck.pdf
# 3     Amelia Teicheira.pdf
# 4     Angham M. Ahmed.docx
# 5       Hailie Warnock.pdf
# 6  Jesus Romero Castro.pdf
# 7           Sandy Vue.docx
# 8      Valerie Fulton.docx
# 9  Yevgeniy Mordvinov.docx

write.csv(candidates,
          "C:/Users/Charles.Burks/OneDrive - USDA/_Personnel/_hacu2021/hacu_cand_db.csv",
          row.names = FALSE)
