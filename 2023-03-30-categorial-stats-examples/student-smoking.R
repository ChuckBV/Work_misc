## student-smoking.R

## Fits a 2 x 2 table:
## '1-2 parents smoke','student smokes',816
## '1-2 parents smoke','student does not smoke',3203
## 'neither parent smokes','student smokes',188
## 'neither parent smokes','student does not smoke',1168

#### define the explanatory variable with two levels:
#### 1=one or more parents smoke, 0=no parents smoke

parentsmoke = as.factor(c(1,0))

#### NOTE: if we do parentsmoke=c(1,0) R will treat this as
#### a numeric and not categorical variable
#### need to create a response vector so that it has counts for both "success" and "failure"

response <- cbind(yes=c(816,188),no=c(3203,1168))
response
#      yes   no
# [1,] 816 3203
# [2,] 188 1168

#### fit the logistic regression model
smoke.logistic <- glm(response ~ parentsmoke, family=binomial(link=logit))

#### OUTPUT
smoke.logistic


summary(smoke.logistic)
anova(smoke.logistic)
