library(pdftools)
library(stringr)
library(tibble)
library(tidyverse)
library(readr)
library(hunspell)

setwd('~/development/forms')

# load data
sources <- c(
  './hmcts/live_forms_extracted/'
)

# get a list of all text files
text.files <- dir(sources, pattern =".txt")

# get the list of potential form references (it's longer than, hence separate to, the list of files)
form.references <- read_csv('./hmcts/all_form_names.csv')$x
form.references <- str_replace_all(form.references, '\\(', '\\\\(')
form.references <- str_replace_all(form.references, '\\)', '\\\\)')
form.references <- str_replace_all(form.references, '-', ' ')

# create an empty list for references
all.references <- list()

# set wd
setwd('./hmcts/live_forms_extracted/')

# iterate through files to identify which form codes are present in the text
counter = 0

for(filename in text.files) {
  
  #increment counter
  counter = counter + 1
  
  # report progress every 100 files
  if(counter %% 10 == 0) print(counter)
  
  # set self.reference to detect references to the form under analysis, in that same form
  pattern <- '\\-(?=[^\\-]+$)'
  self.reference <- strsplit(filename, pattern, perl = TRUE)
  self.reference <- str_replace_all(self.reference, '-', ' ')
  
  # load text
  txt      <- tolower(read_file(filename))
  # detect references in text
  filter   <- sapply(
    form.references, function(x) {
      
      # do not detect references of 'fee account no'
      if (x == 'fee account') {
        x <- 'fee account(?! no)'
      }
      
      # set the pattern to detect the current reference
      pattern <- paste0('(^|\\W)', x, '($|\\W)')
      
      # grepl pattern && not a self reference && reference is not a single word (e.g. 'costs')
      grepl(pattern, txt, perl = T) &
        x != self.reference &
        hunspell_check(x, dict = dictionary('en_US')) == FALSE
    })
  
  # collect references that were detected above
  file.references <- form.references[filter]
  
  # handle cases where no refs are detected
  if(length(file.references) == 0) {
    file.references <- c('none detected')
  }
  # build list of lists
  all.references <- append(all.references, list(file.references))
}

# make data frame and write to file
references <- data.frame(form = text.files, references = I(all.references))
write_excel_csv(references, '../references.csv')
