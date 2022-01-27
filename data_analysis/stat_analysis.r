testData <- read.csv("data_analysis/parsed_supervisor_results.csv", header = TRUE, colClasses = c("factor", "factor", "numeric", "numeric"))

oneway <- aov(buildConfidence ~ isExperimental, data = testData)
summary(oneway)

twoway <- aov(buildConfidence ~ isExperimental + id, data = testData)
summary(twoway)

interaction <- aov(buildConfidence ~ isExperimental * id, data = testData)
summary(interaction)

blocking <- aov(buildConfidence ~ isExperimental * id + team, data = testData)
summary(blocking)