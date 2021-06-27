#!bin/bash

rm intermediate/*
rm output/*

Rscript src/1.read_data.r
Rscript src/2.exploratory_plots.r
Rscript src/3.wide_data.r
Rscript src/4.models.r
Rscript src/5.plot_publication.r
