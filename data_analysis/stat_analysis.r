testData <- read.csv("data_analysis/parsed_results.csv", header = TRUE, colClasses = c("factor", "factor", "numeric", "numeric"))

summary(testData)

oneway <- aov(buildConfidence ~ isExperimental + id, data = testData)

summary(oneway)