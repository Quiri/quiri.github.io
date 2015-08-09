library(knitr)
library(optparse)

option_list <- list(
  make_option(c("-o", "--output"), type = "character", 
             help = "Name of output file", default = ""),
  make_option(c("-b", "--basedir"), type = "character", 
             help = "Path of blog root dir", default = dirname(getwd())),
  make_option(c("-f", "--figdir"), type = "character", 
             help = "Name of output file", default = "")
)

options <- OptionParser(usage = "%prog [options] inputfile",
                          option_list=option_list)
arguments <- parse_args(options, positional_arguments = 1)


opts <- arguments$options
input <- arguments$args
title <- gsub("\\.Rmd", "", input)
if(opts$output == "") {
  output <- paste0(title, ".md")
} else {
  output <- opts$output
}


if(opts$figdir == "") {
  fig.dir <- paste0(opts$basedir, "/images")
} else {
  fig.dir <- opts$figdir
}

fig.dir <- paste0(fig.dir, "/", basename(title), "/")

cat(fig.dir, "\n END \n")

cache.dir <- paste0(opts$basedir, "/cache.dir")

render_jekyll(highlight = "pygments")

opts_chunk$set(
  fig.path   = fig.dir,
  fig.width  = 8.5,
  fig.height = 5.25,
  dev        = 'svg',
  cache      = FALSE,
  warning    = FALSE,
  message    = FALSE,
  cache.dir = cache.dir,
  tidy       = FALSE
)


knit(input = input, output = output)


