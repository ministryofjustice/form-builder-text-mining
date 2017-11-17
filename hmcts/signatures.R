library(tidyverse)
library(readr)
library(stringr)

setwd('~/development/forms/live_forms_extracted/')

# load data
file.names <- dir('.', pattern =".txt")

# can be a regex
# negate match using 'match this (?!do not match this)'
# then execute as `grepl(pattern, x, perl = TRUE)`
pattern <- 'signed'

# to populate with positive hits
key_word_positive <- tibble()

for(file.name in file.names) {
  txt <- read_file(file.name)
  txt <- str_replace_all(txt, '\\|', ' ')
  txt <- str_replace_all(txt, '\\s+', ' ')
  sentences <- tibble(file = file.name, text = tolower(str_extract_all(txt, boundary('sentence'))[[1]]))
  key_word_positive <- rbind(key_word_positive, filter(sentences, grepl(pattern, sentences$text)))
}

key_word_positive$short_text <- sapply(key_word_positive$text, function(x) str_extract(x, '(.{40})signed(.{40})')[[1]])

setwd('../')
write_csv(key_word_positive, './signatures.csv')
