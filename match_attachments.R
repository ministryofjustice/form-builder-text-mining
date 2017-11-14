library(readr)
library(magrittr)

setwd('~/development/forms')

register <- read_csv('./forms_register.csv')
attachments <- read_csv('./validated_attachments.csv')
enclosed  <- read_csv('./validated_enclosed.csv')
supporting <- read_csv('./validated_supporting.csv')

attachments40 <- read_csv('~/Downloads/validated_attachments40v2.csv')
enclosed40  <- read_csv('./validated_enclosed40.csv')
supporting40 <- read_csv('./validated_supporting40.csv')

attachments$file <- sapply(attachments$file, function(x) {
  x <- gsub('(?<!_doc).txt', '.pdf', x, perl = T)
  x <- gsub('_', '.', x)
  x <- gsub('.txt', '', x)
})

attachments40$file <- sapply(attachments40$file, function(x) {
  x <- gsub('(?<!_doc).txt', '.pdf', x, perl = T)
  x <- gsub('_', '.', x)
  x <- gsub('.txt', '', x)
})

enclosed$file <- sapply(enclosed$file, function(x) {
  x <- gsub('(?<!_doc).txt', '.pdf', x, perl = T)
  x <- gsub('_', '.', x)
  x <- gsub('.txt', '', x)
})

enclosed40$file <- sapply(enclosed40$file, function(x) {
  x <- gsub('(?<!_doc).txt', '.pdf', x, perl = T)
  x <- gsub('_', '.', x)
  x <- gsub('.txt', '', x)
})

supporting$file <- sapply(supporting$file, function(x) {
  x <- gsub('(?<!_doc).txt', '.pdf', x, perl = T)
  x <- gsub('_', '.', x)
  x <- gsub('.txt', '', x)
})

supporting40$file <- sapply(supporting40$file, function(x) {
  x <- gsub('(?<!_doc).txt', '.pdf', x, perl = T)
  x <- gsub('_', '.', x)
  x <- gsub('.txt', '', x)
})

register$Attachment <- sapply(register$`File Name`, function(x) {
  requires_attached_docs   <- attachments$required[attachments$file == x]
  requires_enclosed_docs   <- enclosed$required[enclosed$file == x]
  requires_supporting_docs <- supporting$required[supporting$file == x]
  
  requires_attached_docs40   <- attachments40$required[attachments$file == x]
  requires_enclosed_docs40   <- enclosed40$required[enclosed$file == x]
  requires_supporting_docs40 <- supporting40$required[supporting$file == x]
  
  forty_chars <- c(
    as.logical(requires_attached_docs40),
    as.logical(requires_enclosed_docs40),
    as.logical(requires_supporting_docs40)
  )
  
  twenty_chars <- c(
    as.logical(requires_attached_docs),
    as.logical(requires_enclosed_docs),
    as.logical(requires_supporting_docs)
  )
  
  if(!all(is.na(forty_chars))) {
    any(forty_chars)
  } else {
    any(twenty_chars)
  }
})

write_csv(register, './register_with_attachments.csv')


