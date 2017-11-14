library(stringr)
library(tibble)
library(tidyverse)
library(readr)

path = "./live_forms_extracted/"
setwd('~/development/forms/live_forms_extracted/')

# load data
file.names <- dir('.', pattern =".txt")

attachment_pattern <- 'attach'
enclose_pattern <- 'enclose'
supporting_pattern <- 'supporting document'

supporting <- tibble()
enclosed <- tibble()
attachment <- tibble()

for(file.name in file.names) {
  txt <- read_file(file.name)
  txt <- str_replace_all(txt, '\\|', ' ')
  txt <- str_replace_all(txt, '\\s+', ' ')
  sen_df <- tibble(file = file.name, text = tolower(str_extract_all(txt, boundary('sentence'))[[1]]))
  enclosed <- rbind(enclosed, filter(sen_df, grepl(enclose_pattern, sen_df$text)))
  supporting <- rbind(supporting, filter(sen_df, grepl(supporting_pattern, sen_df$text)))
  attachment <- rbind(attachment, filter(sen_df, grepl(attachment_pattern, sen_df$text)))
}

enclosed$short_text   <- sapply(enclosed$text,   function(x) str_extract(x, '(.{40})enclose(.{40})')[[1]])
attachment$short_text <- sapply(attachment$text, function(x) str_extract(x, '(.{40})attach(.{40})')[[1]])
supporting$short_text <- sapply(supporting$text, function(x) str_extract(x, '(.{40})supporting(.{40})')[[1]])

enclosed$text   <- NULL
supporting$text <- NULL
attachment$text <- NULL

write_csv(enclosed, '../eclosed.csv')
write_csv(supporting, '../supporting.csv')
write_csv(attachment, '../attachment.csv')

# OR:
# 1. Analyse sentences in Google sheets.
# 2. Manually identify all forms which require supporting docs.
# 3. Mark True / False in the sheet and export to csv.
# 4. Import csv back into R
# 5. Match new values against form_register.csv and add data to register.
