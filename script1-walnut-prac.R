# script1-walnut-prac.R

library(tidyverse)
library(stringi)

### Import and work with roster

mlist <- read_csv("prac_list_2020.csv",
         col_names = c("name","email","x1","fname","lname","x2"))

nrow(mlist) #61 obs
unique(mlist$email) #61 obs
unique(mlist$lname) #57 obs

mlist %>% 
  group_by(lname) %>% 
  summarise(nObs = n()) %>% 
  filter(nObs > 1)
# A tibble: 3 x 2
#   lname   nObs
#   <chr>  <int>
# 1 Audley     2
# 2 Norene     3
# 3 Ramos      2


### Spit out emails as a single string

mlist <- mlist %>% 
  select(-c("x1","x2"))

mailstring <- mlist$email

x <- paste(mailstring, sep = '', collapse = ';')


noquote(x)
# kamaram@ucdavis.edu;klarnold@ucdavis.edu;jackson.audley@gmail.com;jpaudley@ucdavis.edu;brent@bartonranch.com;rmbostock@ucdavis.edu;eaboyd@csuchico.edu;gurreetbrar@csufresno.edu;rpbuchner@ucanr.edu;Charles.Burks@ARS.USDA.GOV;jlcaprile@ucanr.edu;chaseag1@gmail.com;matconant@sbcglobal.net;MConnelly@Walnuts.org;halcrain@crainranch.com;bcrane@craneranches.com;NormanCrow53@gmail.com;cmculumber@ucanr.edu;HDonoho@Walnuts.org;bobdriver@aol.com;rbelkins@ucanr.edu;ejfichtner@ucanr.edu;jfisher@ucdavis.edu;goodhue@primal.ucdavis.edu;pegordon@ucanr.edu;jagrant@ucanr.edu;jkhasey@ucanr.edu;dhaviland@ucdavis.edu;gary@hesterorchards.com;DHull@Walnuts.org;kjarvisshean@ucanr.edu;Keyawaorchards@sbcglobal.net;dakluepfel@ucdavis.edu;ckron@ucanr.edu;bdlampinen@ucdavis.edu;palarbi@ucanr.edu;caleslie@ucdavis.edu;da13light@att.net;rflong@ucanr.edu;growerschoicesuz@aol.com;tjmichailides@ucanr.edu;lkmilliron@ucanr.edu;nmills@berkeley.edu;jkmoore944@gmail.com;fjniederholzer@ucanr.edu;bigtime@bigtimefarming.com;rdnorene@gmail.com;dnorene@syix.com;mnouri@ucanr.edu;deramos@ucdavis.edu;todd.ramosfarms@gmail.com;jrijal@ucanr.edu;sibbett@lightspeed.net;dpaulstanfield@gmail.com;ejsymmes@ucanr.edu;ketollerup@ucanr.edu;bill@tosfarms.com;bobvanst@berkeley.edu;hwilson@ucanr.edu;mayaghmour@ucanr.edu;fgzalom@ucdavis.edu

myselfi <- ("c_s_burks@yahoo.com;r.dominica@gmail.com")
noquote(myselfi) #c_s_burks@yahoo.com;r.dominica@gmail.com
#-- Putting the string above in Outlook sends to both emails



