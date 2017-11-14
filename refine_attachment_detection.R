library(tidyverse)
library(readr)

atts <- read_csv('~/Downloads/validated_attachments40v2.csv')

atts$automated_validation <- sapply(atts$short_text, FUN = function(x) {
  positive <- c(
    must    <- grepl('you must attach', x),
    must_2  <- grepl('must be attached', x),
    copy    <- grepl('attach a copy', x),
    should  <- grepl('you should attach', x),
    draft   <- grepl('attach a draft', x),
    draft_2 <- grepl('attach the draft', x),
    if_you <- grepl('if you are attaching', x),
    two <- grepl('attach two', x),
    any_relevant <- grepl('attached copies of any relevant documents', x),
    copies <- grepl('attached copies of', x),
    copies_2 <- grepl('attach copies', x),
    evidence <- grepl('attach any evidence', x)
  )
  
  negative <- c(
    earnings_1 <- grepl('attachable earnings', x),
    earnings_2 <- grepl('attachment of earnings', x),
    order      <- grepl('attachment order', x),
    additional <- grepl('additional sheet', x),
    separate   <- grepl('separate sheet', x),
    divorce    <- grepl('attachment on divorce', x)
  )
  
  if(any(positive)) {
    TRUE
  } else if(any(negative)) {
    FALSE
  } else {
    NA
  }
})

sum(is.na(atts$automated_validation))

write_csv(atts, './validated_attachments.csv')
