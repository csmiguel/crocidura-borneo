###.............................................................................
# (c) Miguel Camacho Sánchez
# miguelcamachosanchez@gmail.com // miguelcamachosanchez.weebly.com
# https://scholar.google.co.uk/citations?user=1M02-S4AAAAJ&hl=en
# March 2021
###.............................................................................
#GOAL: write tidy tables
#PROJECT: crocidura-borneo
###.............................................................................
library(dplyr)

#read tidy data
tidy_d <-
  readRDS("intermediate/tidy_data.rds")
tidy_d_adults <-
  readRDS("intermediate/tidy_data_adults.rds")


#no of data point per measurement
sink("output/no_data_points")
cat("number of data points per measurement:\n")
table(tidy_d$morph[!is.na(tidy_d$mm)])
sink()

# create wide formatted tables
wide_adults <-
  tidy_d_adults %>%
  reshape2::dcast(...~morph, value.var = "mm")
#dataset including juveniles (for hair)
wide_allAges <-
  tidy_d %>%
  reshape2::dcast(...~morph, value.var = "mm")

#write tidy data
write.table(wide_allAges, "output/wide_allAges")
write.table(wide_adults, "output/wide_adults")

#save wide objects
save(wide_adults, wide_allAges, file = "intermediate/wide_data.rdata")
