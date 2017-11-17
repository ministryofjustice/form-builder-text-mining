library(tidyverse)

setwd('~/development/forms')

live <- read.csv('./live_forms_file_list.csv', stringsAsFactors = F)
live.names <- live$name

master <- read.csv('./form_analysis_master.csv', stringsAsFactors = F)
master.names <- tolower(master$Form.name.1)

# remove troublesome characters from master.names which have no meaning
master.names <- gsub("\\*", "", master.names)

# get items present in both lists
common.names <- intersect(live.names, master.names)

# there are approximately 1500 forms live that are not found
length(common.names)
length(live.names)
length(master.names)

# present in live absent from master
live.only <- setdiff(live.names, master.names)

# combine unique entries
all.names <- union(live.names, master.names)
# remove form codes that may generate false positives
longer_than_two_chars <- sapply(all.names, function(x) nchar(x) > 2)
all.names <- all.names[longer_than_two_chars]
# save the list
write.csv(all.names, file = './all_form_names.csv')
