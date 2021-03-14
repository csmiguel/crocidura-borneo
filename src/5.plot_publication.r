###.............................................................................
# (c) Miguel Camacho Sánchez
# miguelcamachosanchez@gmail.com // miguelcamachosanchez.weebly.com
# https://scholar.google.co.uk/citations?user=1M02-S4AAAAJ&hl=en
# March 2021
###.............................................................................
#GOAL: generate plot for publication
#PROJECT: crocidura-borneo
###.............................................................................
library(dplyr)
library(cowplot)
library(ggplot2)

#read data
tidy_data <- readRDS("intermediate/tidy_data.rds")

#produce individuals plots
p1 <-
  ggplot(dplyr::filter(tidy_data, morph == "tail")) +
  geom_point(aes(x = elevation, y = mm, color = sp_label)) +
  scale_color_manual(values = c("#0A0089", "#8BE0FB7D")) +
  stat_smooth(aes(x = elevation, y = mm), method = "lm", formula = y ~ x) +
  theme_classic()
p2 <-
  ggplot(dplyr::filter(tidy_data, morph == "HF")) +
  geom_point(aes(x = elevation, y = mm, color = sp_label)) +
  scale_color_manual(values = c("#0A0089", "#8BE0FB7D")) +
  stat_smooth(aes(x = elevation, y = mm), method = "lm", formula = y ~ x) +
  theme_classic()
p3 <-
  ggplot(dplyr::filter(tidy_data, morph == "GGLS")) +
  geom_point(aes(x = elevation, y = mm, color = sp_label)) +
  scale_color_manual(values = c("#0A0089", "#8BE0FB7D")) +
  stat_smooth(aes(x = elevation, y = mm), method = "lm", formula = y  ~ x) +
  theme_classic()
phair <-
  ggplot(dplyr::filter(tidy_data,
                       stringr::str_detect(morph, "hair"))) +
  geom_point(aes(x = elevation, y = mm, color = sp_label, shape = morph)) +
  scale_color_manual(values = c("#0A0089", "#8BE0FB7D")) +
  stat_smooth(aes(x = elevation, y = mm,
                  lty = morph), method = "lm", formula = y ~ x) +
  theme_classic()

#combine plots
pall <-
  cowplot::plot_grid(p1 + theme(legend.position = "none"),
                   p2 + theme(legend.position = "none"),
                   p3 + theme(legend.position = "none"),
                   phair + theme(legend.position = "none"),
                   labels = LETTERS[1:4])
legendp <- cowplot::get_legend(phair)

cowplot::plot_grid(pall, legendp, rel_widths = c(1, .2))

#save plot
ggsave("output/final_figure.pdf", height = 5, width = 7)
