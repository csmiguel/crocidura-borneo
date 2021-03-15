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
library(memisc)
library(MuMIn)
library(sjPlot)

#load wide data
load("intermediate/wide_data.rdata")

#Linear models for the hair:
mhair_dor <- lm(hair_middorsum ~ elevation, data = wide_allAges)
mhair_guar <- lm(guard.hairs..mm. ~ elevation, data = wide_allAges)
mhair_long <- lm(longest.guard.hair..mm. ~ elevation, data = wide_allAges)

hair_table <-
  memisc ::mtable(
    "mid-dorsum" = mhair_dor,
    "guard-hair" = mhair_guar,
    "longest guard hair" = mhair_long,
    digits = 5)
sink("output/models_hair")
hair_table
sink()

#Size of skull and relative tail length increase with elevation.
# I have not controlled for sex, but I can add it as random factor:

# HF
m1_HF <- lme4::lmer(HF ~ (1 | sex) + elevation + GGLS, data = wide_adults)
m0_HF <- lme4::lmer(HF ~ (1 | sex) + GGLS, data = wide_adults)
an_h <- anova(m0_HF, m1_HF)
MuMIn::r.squaredGLMM(m1_HF)

# tail
m1_tail <- lme4::lmer(tail ~ (1 | sex) + elevation + GGLS, data = wide_adults)
m0_tail <- lme4::lmer(tail ~ (1 | sex) + GGLS, data = wide_adults)
an_t <- anova(m0_tail, m1_tail)
MuMIn::r.squaredGLMM(m1_tail)

# HB
m1_HB <- lme4::lmer(HB ~ (1|sex) + elevation + GGLS, data = wide_adults)
m0_HB <- lme4::lmer(HB ~ (1|sex) + GGLS, data = wide_adults)
an_hb <- anova(m0_HB, m1_HB)
MuMIn::r.squaredGLMM(m1_HB)

# GGLS
m1_G <- lme4::lmer(GGLS ~ (1|sex) + elevation, data = wide_adults)
m0_G <- lme4::lmer(GGLS ~ (1|sex), data = wide_adults)
an_g <- anova(m1_G, m0_G)
MuMIn::r.squaredGLMM(m1_G)

#write model ouput to html format
sjPlot::tab_model(m1_tail, file = "output/model_tail.html")
sjPlot::tab_model(m1_G, file = "output/model_GGLS.html")
sjPlot::tab_model(m1_HF, file = "output/model_HF.html")
sjPlot::tab_model(m1_HB, file = "output/model_HB.html")

#write p values from model comparissons
sink("output/models_morph_pvalues")
cat("There is an effect of elevation on the relative tail length (p = ",
  round(an_t[, 8][2], 3),
  "), relative length of hindfoot (p = ",
  round(an_h[, 8][2], 3),
  "), GGLS (p =",
  round(an_g[, 8][2], 3),
  "), but not on relative head body (p =",
  round(an_hb[, 8][2], 3), ")")
sink()
