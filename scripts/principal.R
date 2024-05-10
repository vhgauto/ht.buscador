#!/usr/bin/env Rscript

source("scripts/datos.R")

quarto::quarto_render(input = "index.qmd")
