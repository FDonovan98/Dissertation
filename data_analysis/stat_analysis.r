testData <- read.csv("parsed_student_results.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric"))

oneway <- aov(scopeConfidence ~ isExperimental, data = testData)
summary(oneway)
oneway <- aov(stateUnderstanding ~ isExperimental, data = testData)
summary(oneway)
oneway <- aov(contributionUnderstanding ~ isExperimental, data = testData)
summary(oneway)
oneway <- aov(scopeFrequency ~ isExperimental, data = testData)
summary(oneway)
oneway <- aov(playtestFrequency ~ isExperimental, data = testData)
summary(oneway)



twoway <- aov(scopeConfidence ~ isExperimental + id, data = testData)
summary(twoway)

interaction <- aov(scopeConfidence ~ isExperimental * id, data = testData)
summary(interaction)

blocking <- aov(scopeConfidence ~ isExperimental * id + team, data = testData)
summary(blocking)

twoway <- aov(scopeConfidence ~ isExperimental + team, data = testData)
summary(twoway)

interaction <- aov(scopeConfidence ~ isExperimental * team, data = testData)
summary(interaction)

blocking <- aov(scopeConfidence ~ isExperimental * team + id, data = testData)
summary(blocking)