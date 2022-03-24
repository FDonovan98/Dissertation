# Reads in data from parsed .csv
# Data analysis on test data
data <- read.csv("data_analysis/parsed_test_results.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Data analysis on student data
# data <- read.csv("data_analysis/parsed_student_results.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric"))

library(AICcmodavg)

# Goes through each independent variable and runs data analysis
for (i in 4:8) {
    # as.formula is used so that this code can be generalised enough to work in a loop
    formula <- as.formula(paste0(paste(names(data)[i]), " ~ isExperimental"))
    oneway <- aov(formula, data = data)

    formula <- as.formula(paste0(paste(names(data)[i]), " ~ isExperimental + team"))
    twoway <- aov(formula, data = data)

    formula <- as.formula(paste0(paste(names(data)[i]), " ~ isExperimental * team + id"))
    blocking <- aov(formula, data = data)

    model.set <- list(oneway, twoway, blocking)
    model.names <- c("oneway", "twoway", "blocking")

    # Prints results from data analysis
    print(names(data)[i])
    print(summary(oneway))
    # Calculates effect size
    print(effectsize::omega_squared(oneway))
    # Check which model fits the data the best
    print(aictab(model.set, modnames = model.names))
}