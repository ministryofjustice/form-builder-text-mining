# load both files
live <- read.csv('./all-live-forms-file-list.csv', stringsAsFactors = F)
master <- read.csv('./form-analysis-master.csv', stringsAsFactors = F)

# file names from G drive (live) need formatting
live.names <- live$name
live.names <- sapply(strsplit(live.names,"\\-"), `[`, 1)
# those from the list prepped by MC are fine
master.names <- master$Form.name.1

# convert all letters to lower case because case varies
# but is assumed to have no meaning
live.names <- sapply(live.names, tolower)
master.names <- sapply(master.names, tolower)

# get items present in both lis
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

