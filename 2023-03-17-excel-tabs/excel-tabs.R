#===========================================================================#
# excel-tabs.R
# 
# Intended as a vignette showing how to read in multiple tabs from an
# Excel document, then recombine them into a single data frame. 
#  1. Load and characterize internal iris data set 
#  2. Divide Iris into separate data frames, one per species
#  3. Export the data frames to sheets in a single spreadsheet doc
#  4. Read back 3 data frames from 3 sheets in a single spreadsheet
#  5. Join the data frames end-to-end
#  6. Convert the list of 3 data frames to 3 separate data frames
#
# demonstrates storing multiple data frames to multiple sheets in a
# spreadsheet in order to provide something to work with. 
# 
#==========================================================================#

library(openxlsx)
library(dplyr)
library(readxl)
library(purrr)

# Remove data file, if present, so it can be re-created from scratch
file.remove("./2023-03-17-excel-tabs/data.xlsx")

#---------------------------------------------------------------------------#
#--  1. Load and characterize internal iris data set ------------------------
irises <- iris
head(irises)
#   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 1          5.1         3.5          1.4         0.2  setosa
# 2          4.9         3.0          1.4         0.2  setosa
# 3          4.7         3.2          1.3         0.2  setosa
# 4          4.6         3.1          1.5         0.2  setosa
# 5          5.0         3.6          1.4         0.2  setosa
# 6          5.4         3.9          1.7         0.4  setosa

## Remind ourselves of the species
unique(irises$Species)
# [1] setosa     versicolor virginica 
# Levels: setosa versicolor virginica


#---------------------------------------------------------------------------#
#--  2. Divide Iris into separate data frames, one per species ------------- 

## See https://dplyr.tidyverse.org/reference/group_split.html
## Using base::split()
y <- split(irises, irises$Species)
y$setosa
y$versicolor
y$virginica
    # -- Creates a list containing three named data frames

## dplyr::group_split() is another option, split() seems to serve the present 
## purpose better
x <- irises %>% 
  group_split(Species)
# -- Creates a list of three tibbles with one species each
# -- Only identifies as x[[1]], x[[2]], and x[[3]]

#---------------------------------------------------------------------------#
#-- 3. Export the data frames to sheets in a single spreadsheet doc ---------

## Working from a list of data frames, this is one short and simple function
## https://www.r-bloggers.com/2022/02/export-data-frames-into-multiple-excel-sheets-in-r/

openxlsx::write.xlsx(y, file = "./2023-03-17-excel-tabs/data.xlsx")
   # -- Creates an Excel file with three sheets, each with the name of the
   # -- corresponding data frame from the list


#---------------------------------------------------------------------------#
#-- 4. Read back 3 data frames from 3 sheets in a single spreadsheet --------

## This r-blogger entry addresses how to approach this with lapply or with purr::map()
## https://www.r-bloggers.com/2022/07/read-data-from-multiple-excel-sheets-and-convert-them-to-individual-data-frames/

# Read Excel sheets into a list of three data frames using lapply
df_list1 <- lapply(readxl::excel_sheets("./2023-03-17-excel-tabs/data.xlsx"), function(x)
  read_excel("./2023-03-17-excel-tabs/data.xlsx", sheet = x)
)

df_list1$setosa
# NULL (data frames not named)

# Read Excel sheets into a list of three data frames using purrr::map()
df_list2 <- map(set_names(excel_sheets("./2023-03-17-excel-tabs/data.xlsx")),
               read_excel, path = "./2023-03-17-excel-tabs/data.xlsx"
)
df_list2$setosa
# # A tibble: 50 × 5
#    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#          <dbl>       <dbl>        <dbl>       <dbl> <chr>  
# 1          5.1         3.5          1.4         0.2 setosa 
# 2          4.9         3            1.4         0.2 setosa 
# 3          4.7         3.2          1.3         0.2 setosa 
    # data frames in the list are named

#---------------------------------------------------------------------------#
#-- 5. Join the data frames end-to-end --------------------------------------

## For greater depth, see also
## https://www.r-bloggers.com/2021/08/r-a-combined-usage-of-split-lapply-and-do-call/

# Join end-to-end using base::do.call
irises2 <- do.call(rbind, df_list2)
irises2
# # A tibble: 150 × 5
# Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# *        <dbl>       <dbl>        <dbl>       <dbl> <chr>  
# 1          5.1         3.5          1.4         0.2 setosa 
# 2          4.9         3            1.4         0.2 setosa 
# 3          4.7         3.2          1.3         0.2 setosa 

  # went from a list of 3 50-row data frams to a 150-row data frame

# Join end-to-end using dplyr::bind_rows
irises3 <- bind_rows(df_list2)
  # accomplishes the same thing, but bind_rows can have advantages
  # See https://dplyr.tidyverse.org/reference/bind.html


#---------------------------------------------------------------------------#
#-- 6. Convert the list of 3 data frames to 3 separate data frames  --------

## Convert the list to three separate data frames 
## See https://stackoverflow.com/questions/13795526/return-elements-of-list-as-independent-objects-in-global-environment

# The list generated with lapply() does not work with this method
list2env(df_list1,globalenv())
# Error in list2env(df_list1, globalenv()) : 
#   names(x) must be a character vector of the same length as x

# The list generated with purrr::map does work
list2env(df_list2,globalenv())
# This works



