# load both files
setwd('~/development/forms')
live <- read.csv('./all-live-forms-file-list.csv', stringsAsFactors = F)
master <- read.csv('./form-analysis-master.csv', stringsAsFactors = F)

# file names from G drive (live) need formatting
live.names <- tolower(live$name)

# split on last hyphen DOESN'T QUITE WORK
pattern <- '\\-(?=[^\\-]+$)'
live.names <- sapply(strsplit(live.names, pattern, perl = TRUE), `[`, 1)
# those from the list prepped by MC are fine
master.names <- tolower(master$Form.name.1)
# remove troublesome characters from master.names which have no meaning
master.names <- gsub("\\*", "", master.names)

# get items present in both lists
common.names <- intersect(live.names, master.names)

# there are approximately 1500 forms live that are not found
# in the master list - comparison could be IMPROVED
length(common.names)
length(live.names)
length(master.names)

# present in live absent from master
live.only <- setdiff(live.names, master.names)

# combine unique entries
all.names <- union(live.names, master.names)
write.csv(all.names, file = './all-form-names.csv')
