# Model selection strategies
# Prostate Cancer 


# use the "prostate.data.txt" dataset
p.data <- read.table("prostate.data.txt", header=TRUE)

#The model selection software is in a package called "leaps".  Install as follows
install.packages("leaps")

#Make sure to load the package after it's been installed
library(leaps)

#First we'll run the function "regsubsets" that checks all possible models
# nvmax specifies the maximum number of predictor variables to include
# method="exhaustive" specifies that every possible model should be considered
result <- regsubsets(lpsa~.,data=p.data,nvmax=8,method="exhaustive")

summary(result)


#Get best possible model based on BIC
plot(result,scale="bic")

which.min(summary(result)$bic)
summary(result)$which[3,]

#Again based on adjusted R^2
plot(result,scale="adjr2")

which.max(summary(result)$adjr2)

summary(result)$which[7,]

#Forward selection
#Have to specify the "null" model.  i.e. a model with only an intercept
model.null <- lm(lpsa~1,data=p.data)
#Next, we specify the "full" model.  This includes all possible predictors
model.full <- lm(lpsa~.,data=p.data)

#Finally, the "step" function (defaults to AIC)
forward <- step(model.null, scope=list(lower=model.null, upper=model.full), direction="forward")
#Summary gives the best model from forward selection
summary(forward)

#Backward selection (can set trace=0 so no output appears from "step" function)
backward=step(model.full, direction="backward",trace=0)
summary(backward)

#The way we specify forward selection using BIC is a little bit weird...
# Have to specify a new parameter k=log(NROW(p.data)) (the log of the sample size)
forward.bic <- step(model.null, scope=list(lower=model.null, upper=model.full), 
                    direction="forward", k=log(NROW(p.data)))
summary(forward.bic)






