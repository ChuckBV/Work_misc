#===========================================================================#
# excel-tabs.R
# 
# Intended as a vignette showing how to read in multiple tabs from an
# Excel document, then recombine them into a single data frame.
#==========================================================================#

library(openxlsx)
library(dplyr)

# necessary work-around
path_now <- "./2023-03-17-excel-tabs"

#####################
## Using internal data set iris

## Make iris data set visible in RStudio Environment
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


#####################
## Split Iris into separate data frames, one per species

## Use dplyr::split(). Notice description in documentation of base:split()
## See https://dplyr.tidyverse.org/reference/group_split.html
x <- irises %>% 
  group_split(Species)
    # -- Creates a list of three tibbles with one species each
    # -- Only identifies as x[[1]], x[[2]], and x[[3]]

## Compare with base::split()
y <- split(irises, irises$Species)
y$setosa
y$versicolor
y$virginica
    # -- Creates a list containing three named data frames

## Convert the list to three separate data frames 
## See https://stackoverflow.com/questions/13795526/return-elements-of-list-as-independent-objects-in-global-environment
# list2env(y,globalenv())
# ls()
# # [1] "irises"     "setosa"     "versicolor" "virginica"  "x"          "y"  
    # Potentially useful, but not used in the present example

##########################
## Export 3 data frames to three sheets in a single spreadsheet document.
##
## Working from a list of data frames, this is one short and simple function
## https://www.r-bloggers.com/2022/02/export-data-frames-into-multiple-excel-sheets-in-r/

openxlsx::write.xlsx(y, file = "./2023-03-17-excel-tabs/data.xlsx")
   # -- Creates an Excel file with three sheets, each with the name of the
   # -- corresponding data frame from the list

##########################
## Read 3 data frames from three sheets in a single spreadsheet document
##
## Reading the sheets back required either base::lapply() or purr::map()

## lapply method
## https://stackoverflow.com/questions/12945687/read-all-worksheets-in-an-excel-workbook-into-an-r-list-with-data-frames


read_excel_allsheets <- function(filename, tibble = TRUE) {
  # Get the names of the sheets
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}

## provides simple implementation for lapply and has accompanying YouTube
## https://statisticsglobe.com/read-all-worksheets-of-excel-file-into-list-in-r

## This r-blogger entry addresses how to approach this with lapply or with purr::map()
## https://www.r-bloggers.com/2022/07/read-data-from-multiple-excel-sheets-and-convert-them-to-individual-data-frames/