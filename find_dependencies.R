library(pdftools)
library(stringr)
library(tibble)
library(tidyverse)
library(readr)

# set path and working dir
path = "./all-live-forms-extracted/"
setwd('~/development/forms/all-live-forms-extracted/')

# load data
file.names <- dir('.', pattern =".txt")
form.references <- read_csv('../all-form-names.csv')$x

# create an empty list for dependencies
all.dependencies <- list()

# iterate through files to identify which form codes are present in the text
for(i in 1:length(file.names)){
  if(i %% 100 == 0) print(i)
  filename <- file.names[i]
  txt      <- tolower(read_file(filename))
  filter   <- sapply(form.references, function(x) grepl(x, txt))
  file.dependencies <- form.references[filter]
  if(length(file.dependencies) == 0) {
    file.dependencies <- c('none detected')
  }
  all.dependencies <- append(all.dependencies, list(file.dependencies))
}
deps.df <- data.frame(form = file.names, dependencies = I(all.dependencies))
write_excel_csv(deps.df, '../deps-xl.csv')
