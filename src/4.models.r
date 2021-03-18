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

#load wide data
load("intermediate/wide_data.rdata")

#linear models for external morphology
# HF
m1_HF <- lm(HF ~ sex + elevation + GGLS, data = wide_adults)
# tail
m1_tail <- lm(tail ~ sex + elevation + GGLS, data = wide_adults)
# HB
m1_HB <- lm(HB ~ sex + elevation + GGLS, data = wide_adults)
# GGLS
m1_G <- lm(GGLS ~ sex + elevation, data = wide_adults)

morph_table <-
  memisc ::mtable(
    "HF" = m1_HF,
    "tail" = m1_tail,
    "HB" = m1_HB,
    "GGLS" = m1_G,
    digits = 5)
sink("output/models_morph")
morph_table
sink()

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
