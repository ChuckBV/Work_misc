## dataformats.R

## Source: https://online.stat.psu.edu/onlinecourses/sites/stat504/files/lesson06/dataformats.R

##create two binary vectors of length 100 
x=sample(c(0,1),100, replace=T)
y=sample(c(0,1),100, replace=T)

##set up a basic dataset with two 100 rows and two columns
xydata=cbind(x,y)
xydata
head(xydata)
# [1,] 1 0
# [2,] 1 0
# [3,] 1 0
# [4,] 1 1
# [5,] 1 0
# [6,] 1 1

##create a 2x2 table with counts
xytab=table(x,y)
xytab
#   y
# x    0  1
#   0 27 20
#   1 27 26

count=cbind(xytab[,2],xytab[,1])
count
#   [,1] [,2]
# 0   20   27
# 1   26   27

xfactor=factor(c("0","1"))
xfactor

##create a dataframe with 4 rows and counts in the Freq column
xydf=as.data.frame(xytab)
xydf
#   x y Freq
# 1 0 0   27
# 2 1 0   27
# 3 0 1   20
# 4 1 1   26

##logistic regression models
## tmp1, tmp2 and tmp3 all fit the same simple logistic regression model
tmp1=glm(y~x, family=binomial("logit"))
summary(tmp1)

tmp2=glm(as.factor(y)~as.factor(x), family=binomial("logit"))
summary(tmp2)

tmp3=glm(count~xfactor, family=binomial("logit"))
summary(tmp3)

tmp4=glm(count~1, family=binomial("logit")) ## intercept only model

##loglinear modelss
tmp5=glm(xydf$Freq~xydf$x+xydf$y, family=poisson("log")) ## loglinear model
tmp6=loglin(xytab, list(c(1,2)), fit=TRUE, param=TRUE)
tmp7=loglin(xytab, list(1,2), fit=TRUE, param=TRUE)

##chi-square test of independence
tmp8=chisq.test(xytab, correct=FALSE)