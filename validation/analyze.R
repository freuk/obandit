#!/usr/bin/env Rscript

args=as.list(strsplit(Sys.getenv('R_ARGS')," "))

input_f=args[[1]][1]
report=args[[1]][2]

library(ggplot2)
library(tidyr)
library(ggthemes)
library(plyr)
library(lubridate)
library(dplyr)
library(cowplot)
library(xtable)
library(knitr)
library(data.table)

source("lib.R")
data=load_manypolicies(input_f)
#data$class="powercap"
#data_reduced=reducer_stats(data)
#data_augmented=augmenter_stats(data)

knit("./report.rmd",output=report)
