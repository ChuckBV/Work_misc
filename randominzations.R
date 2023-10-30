# randomizations.R

# OBJECTIVE: Randomize treatments for a randomized complete block design,
# and output as data frame with columns for Rep, Position, and Treatment

# Create columns for Replication and Position within Replicate
Rep <- rep(1:5, each = 5) # length = 25
Position <- rep(1:5, 5)   # length = 25

# Create Treatment labels
Trts <- LETTERS[1:5]

# Randomize order of treatments 5 times
rep1 <- sample(LETTERS[1:5]) 
rep2 <- sample(LETTERS[1:5]) 
rep3 <- sample(LETTERS[1:5]) 
rep4 <- sample(LETTERS[1:5])
rep5 <- sample(LETTERS[1:5])

# Append the five treatments
Trt <- c(rep1,rep2,rep3,rep5,rep5)

# Combine replicate, position, and treatment vectors to form a data frame
rcbd <- data.frame(Rep,Position,Trt)

# head(rcbd)
#   Rep Position Trt
# 1   1        1   B
# 2   1        2   A
# 3   1        3   E
# 4   1        4   D
# 5   1        5   C
# 6   2        1   A

str(rcbd) # integer, integer, character

# Output design to desktop
setwd("C:/Users/Charles.Burks/Desktop")
list.dirs()

write.csv(rcbd,"rcbd.csv", row.names = F)
