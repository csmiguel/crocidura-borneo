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
library(ggplot2)
library(ggrepel)

#read tidy data
tidy_d <-
  readRDS("intermediate/tidy_data.rds")
tidy_d_adults <-
  readRDS("intermediate/tidy_data_adults.rds")

#exploratory plots external morphology
pmorph <-
  tidy_d_adults %>%
  dplyr::filter(morph %in% c("tail", "HF", "GGLS")) %>%
  ggplot() +
  geom_point(aes(x = elevation, y = mm, color = sp_label,
                 shape = ifelse(is.na(sex), "NA", sex))) +
  ggrepel::geom_text_repel(
    aes(x = elevation, y = mm, label = museum_code),
    size = 2,
    segment.size = 0.1) +
  scale_color_manual(values = c("#0A0089", "#8BE0FB")) +
  scale_shape_manual(name = "",
                     values = c("NA" = 15,
                                female = 16,
                                male = 17)) +
  theme_classic() +
  ggplot2::xlab("elevation (m)") +
  facet_wrap(~morph, scales = "free_y")

# save plot
ggsave("output/exploratory-morphology.pdf", plot = pmorph, width = 8, height = 3.5)

#exploratory plots hair
phair <-
  tidy_d %>%
  dplyr::filter(stringr::str_detect(morph, "hair")) %>%
  ggplot() +
  geom_point(aes(x = elevation, y = mm,
                 shape = sp_label, color = morph)) +
  stat_smooth(aes(x = elevation, y = mm,
                 color = morph), method = 'lm', formula = y ~ x) +
  theme_classic() +
  ggplot2::xlab("elevation (m)")
# save plot
ggsave("output/exploratory-hair.pdf", phair, width = 6, height = 4)
