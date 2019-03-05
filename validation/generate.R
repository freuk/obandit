#! /usr/bin/env Rscript

library(plyr)

args=as.list(strsplit(Sys.getenv('R_ARGS')," "))

seed=as.numeric(args[[1]][1])
k=as.numeric(args[[1]][2])
n=as.numeric(args[[1]][3])
output=args[[1]][4]

set.seed(12345)

mus = pmax(0,pmin(1,rnorm(k, mean=0.5, sd=1)))

set.seed(seed)

make_arm <- function(mu) pmax(0,pmin(1,rnorm(n, mean=mu, sd=0.1)))
d=as.data.frame(t(ldply(mus,make_arm)))
names(d) = as.character(1:k)
write.table(d,output,row.names=FALSE,col.names=FALSE)
