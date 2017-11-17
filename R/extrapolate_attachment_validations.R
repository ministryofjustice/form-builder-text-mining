library(tidyverse)
library(readr)

manual <- read_csv('~/Downloads/manually_validated.csv')
manual <- manual[!is.na(manual$short_text),]
manual$validated <- apply(manual[4:5], MARGIN = 1, FUN = function(row) {
  any(row, na.rm = T)
})

full_list <- read_csv('./validated_attachments.csv')

full_list$validated <- sapply(full_list$short_text, USE.NAMES = F, FUN = function(st){
  req <- manual$validated[manual$short_text == st]
  
  if(length(req) == 0) {
    req <- full_list$automated_validation[full_list$short_text == st]
  }
  
  if(length(req) > 0) {
    req
  } else {
    NA
  }
})

full_list$validated <- as.character(full_list$validated)
full_list$validated <- as.logical(full_list$validated)

# did some stuff in google sheets to combine automated validation
# with manual validations, then ... extrapolate this to fill the register
# match on short text and anything missing is FALSE

unique <- read_csv('~/Downloads/UNIQUE_SHORT_TEXT_VALID.csv')
all_atts <- read_csv('~/Downloads/validated_attachments40v2.csv')

all_atts$required <- sapply(all_atts$short_text, USE.NAMES = F, FUN = function(st){
  req <- unique$required[unique$short_text == st]
  
  if(length(req) > 0 && !is.na(st)) {
    req[2]
  } else {
    NA
  }
})
write_csv(all_atts, './validated_attachments40v2.csv')
