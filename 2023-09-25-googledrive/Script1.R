#============================================================================#
# script1.R
#
#
#
#============================================================================#

library(tidyverse)
library(googledrive)
library(googlesheets4)

### References
# YouTube -- Googledrive and Googlesheet4 in R | A RStudio Tutorial
#   Video and accompanying script from "Liquid Brain", a project by Brandon Yeo 
#   and Lindsey Foong
#   
# https://youtu.be/Bdvqtb7fsH0?feature=shared
#
# Script in Google Doc -- Googledrive and Googlesheet4 in R
# y: https://docs.google.com/document/d/1SXGvoayjSfP7Jm5zPKG1rFJIk_4X4FerJIa_HSFMlSU/edit

### Follow the tutorial in the script
googledrive::drive_auth()
# From the help file:
# Authorize googledrive to view and manage your Drive files. This function is a 
# wrapper around gargle::token_fetch().
# 
# By default, you are directed to a web browser, asked to sign in to your Google 
# account, and to grant googledrive permission to operate on your behalf with 
# Google Drive. By default, with your permission, these user credentials are 
# cached in a folder below your home directory, from where they can be 
# automatically refreshed, as necessary. Storage at the user level means the 
# same token can be used across multiple projects and tokens are less likely to 
# be synced to the cloud by accident.

### googledrive::drive_get()
# Retrieves metadata for files specified via path or via file id. This function 
# is quite straightforward if you specify files by id. But there are some 
# important considerations when you specify your target files by path. See below 
# for more. If the target files are specified via path, the returned dribble 
# will include a path column.

td <- drive_get("https://drive.google.com/drive/folders/1OyDLhCspnS98ZQRy8Pht1iavrC60gIJl")
# Using a new empty folder in the r.dominica@gmail.com account
# Path is "My Drive/_1bWork/work-burks-group/tidyverse_googledrive_test"

td
# A dribble: 0 × 3
# ℹ 3 variables: name <chr>, id <drv_id>, drive_resource <list>


#googledrive::drive_ls()
# List the contents of a folder or shared drive, recursively or not. This is a 
# thin wrapper around drive_find(), that simply adds one constraint: the search 
# is limited to direct or indirect children of path.

googledrive::drive_ls(td)
# A dribble: 0 × 3
# ℹ 3 variables: name <chr>, id <drv_id>, drive_resource <list>
#    < Empty, as we might hope >

### Make a csv dataframe to upload
test_df <- head(iris)
write.csv(test_df,"./data/sample.csv")

### Upload
drive_upload("./data/sample.csv",name = "Sample1", type = "spreadsheet", path = as_id(td))
# Local file:
#   • ./data/sample.csv
# Uploaded into Drive file:
#   • Sample1 <id: 15A7P0FoL2kvt1zDCxe7ztGZ1up7HRbo8GKjAYM4QaqA>
#   With MIME type:
#   • application/vnd.google-apps.spreadsheet

googledrive::drive_ls(td)
# # A dribble: 1 × 3
#   name    id                                           drive_resource   
#   <chr>   <drv_id>                                     <list>           
# 1 Sample1 15A7P0FoL2kvt1zDCxe7ztGZ1up7HRbo8GKjAYM4QaqA <named list [37]>
#   < Now lists a single file >

