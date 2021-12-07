# https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/
library(tidyverse)
library(ggpubr)
library(rstatix)

data("selfesteem", package = "datarium")
head(selfesteem, 3)

selfesteem <- selfesteem %>%
    gather(key = "time", value = "score", t1, t2, t3) %>%
    convert_as_factor(id, time)
head(selfesteem, 3)

selfesteem %>%
    group_by(time) %>%
    get_summary_stats(score, type = "mean_sd")

bxp <- ggboxplot(selfesteem, x = "time", y = "score", add = "point")
bxp

selfesteem %>%
    group_by(time) %>%
    identify_outliers(score)

selfesteem %>%
    group_by(time) %>%
    shapiro_test(score)

ggqqplot(selfesteem, "score", facet.by = "time")

res.aov <- anova_test(data = selfesteem, dv = score, wid = id, within = time)
get_anova_table(res.aov)


# https://www.scribbr.com/statistics/anova-in-r/
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)

crop.data <- read.csv("data_analysis/test/crop.data.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric"))

summary(crop.data)

oneway <- aov(yield ~ fertilizer, data = crop.data)

summary(oneway)

mockdata <- read.csv("data_analysis/test/mock_data.csv", header = TRUE, colClasses = c("factor", "factor", "numeric"))

summary(mockdata)

oneway <- aov(confidence ~ Experimental, data = mockdata)

summary(oneway)