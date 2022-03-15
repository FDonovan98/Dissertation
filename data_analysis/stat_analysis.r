testData <- read.csv("parsed_student_results.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric"))

oneway <- aov(scopeFrequency ~ isExperimental, data = testData)
summary(oneway)
oneway <- aov(scopeConfidence ~ isExperimental, data = testData)
summary(oneway)
oneway <- aov(stateUnderstanding ~ isExperimental, data = testData)
summary(oneway)
oneway <- aov(contributionUnderstanding ~ isExperimental, data = testData)
summary(oneway)
oneway <- aov(playtestFrequency ~ isExperimental, data = testData)
summary(oneway)



library(AICcmodavg)
testData <- read.csv("data_analysis/parsed_student_results.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric"))

indepVars <- c("scopeFrequency", "scopeConfidence", "stateUnderstanding", "contributionUnderstanding", "playtestFrequency")
lapply(indepVars, function(iv) {
    oneway <- aov(iv ~ isExperimental, data = testData)
    # summary(oneway)

    twowayid <- aov(iv ~ isExperimental + id, data = testData)
    # summary(twowayid)

    interactionid <- aov(iv ~ isExperimental * id, data = testData)
    # summary(interactionid)

    blockingid <- aov(iv ~ isExperimental * id + team, data = testData)
    # summary(blockingid)
    twoplus <- aov(iv ~ isExperimental + id + team, data = testData)
    # summary(twoplus)

    twoway <- aov(iv ~ isExperimental + team, data = testData)
    # summary(twoway)

    interaction <- aov(iv ~ isExperimental * team, data = testData)
    # summary(interaction)

    blocking <- aov(iv ~ isExperimental * team + id, data = testData)
    # summary(blocking)

    model.set <- list(oneway, twowayid, interactionid, blockingid, twoway, interaction, blocking, twoplus)
    model.names <- c("oneway", "twowayid", "interactionid", "blockingid", "twoway", "interaction", "blocking", "twoplus")
    print(iv)
    aictab(model.set, modnames = model.names)
    NULL
})

AnalyseIndependantVariable <- function(iv) {
    oneway <- aov(iv ~ isExperimental, data = testData)
    summary(oneway)
}

library(formula.tools)
AnalyseIndependantVariable(testData$scopeFrequency)
t <- c("scopeFrequency")
lapply(t, AnalyseIndependantVariable)
oneway <- aov(t[[1]] ~ isExperimental, data = testData)
class(t)
print(get.vars(names(testData)[4]))
names(testData)

formula <- as.formula(paste0(paste(names(testData)[4]), " ~ isExperimental"))
print(formula)

test <- aov(formula, data = testData)
summary(test)


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
    print(aictab(model.set, modnames = model.names))
}

formula <- as.formula(paste0(paste(names(testData)[7]), " ~ isExperimental"))
oneway <- aov(formula, data = testData)
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
