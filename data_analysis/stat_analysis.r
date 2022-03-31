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

# names(data)[7] relates to scope frequency
# Generate bar plot with error bars as this is the only hypothesis to reach statistical significance
formula <- as.formula(paste0(paste(names(data)[7]), " ~ isExperimental"))
oneway <- aov(formula, data = data)

# Test for homoscedasticity as aov analysis relies on that assumption being true
par(mfrow = c(2, 2))
plot(oneway)

library(ggplot2)

# Plot data
onewayplot <- ggplot(data, aes(x = isExperimental, y = scopeFrequency)) +
    geom_point(cex = 1.5, pch = 1.0, position = position_jitter(w = 0.1, h = 0))

# Generate and plot box and whisker diagram for the data
onewayplot <- onewayplot + stat_summary(fun.data = "mean_se", geom = "errorbar", width = 0.2) + stat_summary(fun.data = "mean_se", geom = "pointrange") + geom_point(data = data, aes(x = isExperimental, y = scopeFrequency))

# Add titles and better axis labels to the graph
onewayplot <- onewayplot +
    labs(title = "Rescope frequency with relatation to a teams use of a CD pipeline", x = "Does the team use a CD pipeline? (True = Yes, False = No)", y = "Frequency of rescoping \n (1 = Only at events, 2 = Every other sprint, 3 = Once per sprint, 4 = Multiple times per sprint)")

# Generate graph
onewayplot