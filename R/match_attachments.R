library(tidyverse)
library(readr)

setwd('~/development/forms')

register <- read_csv('forms_register.csv')

validation_files <- c(
  './hmcts/hmcts_attachment.csv',
  './hmcts/hmcts_supporting_docs.csv',
  './hmcts/hmcts_enclosed.csv',
  './laa/laa_attachment.csv',
  './laa/laa_supporting_docs.csv',
  './laa/laa_enclosed.csv',
  './opg/opg_attachment.csv',
  './opg/opg_supporting_docs.csv',
  './opg/opg_enclosed.csv',
  './hmpps/hmpps_attachment.csv',
  './hmpps/hmpps_supporting_docs.csv',
  './hmpps/hmpps_enclosed.csv'
)

reference_table <- tibble()

for(f in validation_files) {
  reference_table <- rbind(reference_table, read_csv(f))
}

reference_table$file <- sapply(reference_table$file, function(x) {
  x <- gsub('(?<!_doc).txt', '.pdf', x, perl = T)
  x <- gsub('_', '.', x)
  x <- gsub('.txt', '', x)
})

register$Attachment <- sapply(register$`File Name`, function(x) {
  requires_attachment <- reference_table$required[reference_table$file == x]
  any(requires_attachment, na.rm = T)
})

write_csv(register, './register_with_attachments.csv')
