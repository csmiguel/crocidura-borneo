###.............................................................................
# (c) Miguel Camacho Sánchez
# miguelcamachosanchez@gmail.com // miguelcamachosanchez.weebly.com
# https://scholar.google.co.uk/citations?user=1M02-S4AAAAJ&hl=en
# March 2021
###.............................................................................
#GOAL: read and tidy data
#PROJECT: crocidura-borneo
###.............................................................................
library(dplyr)
library(xlsx)

source("src/auxiliary-functions.r")

#read data
d <-
  xlsx::read.xlsx("raw/crocidura_morphological_data.xlsx", 1) %>%
  dplyr::select(-date_collected, -source_elev, -source_morpho, -collector, -measurements) %>%
  dplyr::as_tibble() %>%
  dplyr::mutate_all(replacena) %>%
  dplyr::mutate_at(vars(contains("hair")), as.numeric)

#tidy data
tidy_d <-
  d %>%
  #force conversion of variables to numeric
  dplyr::mutate_at(names(d)[grep("weight",
    names(d)):ncol(d)], as.numeric) %>%
  #convert feet to meters
  dplyr::mutate(elevation = ft_2_mt(elevation) %>% as.numeric()) %>%
  #complete HB when total_length and tail are available
  dplyr::mutate(HB = {
    hb2 <- total_length - tail
    hb <-
      1:length(hb2) %>%
      sapply(function(y) {
        if(!is.na(HB[y])) HB[y] else if (is.na(HB[y])) hb2[y]
      }) %>% unlist()
    hb
  }) %>%
  #remove extra variables
  dplyr::select(-species, -age, -locality, -ear, -comments,
                -weight, -hair_tail_base) %>%
  #reshape. Tidy format
  reshape2::melt(id.vars = c("museum_code", "sp_label", "sex", "age_expanded",
                             "elevation", "total_length"),
                 variable.name = "morph",
                 value.name = "mm") %>%
  dplyr::select(-total_length) %>%
  #rename sex
  dplyr::mutate(sex = plyr::mapvalues(
    x = sex,
    from = c(NA, 1, 2),
    to = c(NA, "male", "female"))) %>%
  dplyr::as_tibble() %>%
  #remove rows with no data for elevation, keep Sabahan individuals
  dplyr::filter(!is.na(elevation) & sp_label != "C_foetida_sarawak" &
  museum_code != "MCZ36571" & !is.na(mm)) %>%
  dplyr::mutate(morph = droplevels(morph))

# keep only adults
tidy_d_adults <-
  tidy_d %>%
    dplyr::filter(age_expanded == 1)

#save tidy data
saveRDS(tidy_d, "intermediate/tidy_data.rds")
saveRDS(tidy_d_adults, "intermediate/tidy_data_adults.rds")
