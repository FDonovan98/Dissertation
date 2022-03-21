testData <- read.csv("data_analysis/parsed_student_results.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric"))

library(AICcmodavg)

for (i in 4:8) {
    formula <- as.formula(paste0(paste(names(testData)[i]), " ~ isExperimental"))
    oneway <- aov(formula, data = testData)

    formula <- as.formula(paste0(paste(names(testData)[i]), " ~ isExperimental + team"))
    twoway <- aov(formula, data = testData)

    formula <- as.formula(paste0(paste(names(testData)[i]), " ~ isExperimental * team + id"))
    blocking <- aov(formula, data = testData)

    model.set <- list(oneway, twoway, blocking)
    model.names <- c("oneway", "twoway", "blocking")

    print(names(testData)[i])
    print(summary(oneway))
    print(effectsize::omega_squared(oneway))
    print(aictab(model.set, modnames = model.names))
}

formula <- as.formula(paste0(paste(names(testData)[7]), " ~ isExperimental"))
oneway <- aov(formula, data = testData)
print(names(testData)[7])
print(summary(oneway))
print(effectsize::cohens_f(oneway))
effectsize::eta_squared(oneway)
effectsize::omega_squared(oneway)
par(mfrow = c(2, 2))
plot(oneway)
par(mfrow = c(1, 1))

tukey <- TukeyHSD(oneway)
tukey

library(sjstats)
effectsize::cohens_f(oneway)

library(ggplot2)
onewayplot <- ggplot(testData, aes(x = isExperimental, y = scopeFrequency)) +
    geom_point(cex = 1.5, pch = 1.0, position = position_jitter(w = 0.1, h = 0))

onewayplot <- onewayplot +
    stat_summary(fun.data = "mean_se", geom = "errorbar", width = 0.2) +
    stat_summary(fun.data = "mean_se", geom = "pointrange") +
    geom_point(data = testData, aes(x = isExperimental, y = scopeFrequency))

onewayplot