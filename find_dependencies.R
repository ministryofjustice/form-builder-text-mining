library(pdftools)
library(stringr)
library(tibble)
library(tidyverse)

# set path and working dir
path = "./all-live-forms-extracted/"
setwd('~/development/forms/all-live-forms-extracted/')

# load data
file.names <- dir('.', pattern =".txt")
form.codes <- read_csv('../all-form-names.csv')
# remove troublesome characters from form.codes which have no meaning
formatted.form.codes <- gsub("\\*", "", form.codes$x)
# remove 'codes' that are incomplete
complete <- grepl("\\d", formatted.form.codes)
complete_codes <- formatted.form.codes[complete]

# create an empty list for dependencies
all.dependencies <- list()

# iterate through files to identify which forms codes are present in the text
for(i in 1:length(file.names)){
  if(i %% 100 == 0) print(i)
  filename <- file.names[i]
  txt     <- tolower(read_file(filename))
  filter   <- sapply(complete_codes, function(x) grepl(x, txt))
  file.dependencies <- complete_codes[filter]
  if(length(file.dependencies) == 0) {
    file.dependencies <- c('none detected')
  }
  all.dependencies <- append(all.dependencies, list(file.dependencies))
}
deps.df <- data.frame(form = file.names, dependencies = I(all.dependencies))
write_excel_csv(deps.df, '../deps-xl.csv')
