library(tidyverse)
library(readr)
library(jsonlite)

# set initial focus to one or more forms and then run everything
# output file is called links-and-nodes.json (re-runs will overwrite )
focus = c('pa1')

links = read_csv('./links.csv')
links$source <- gsub('\\-eng|\\-cym|\\-bil', '', links$source)
links$source <- gsub('_doc', '', links$source)
links_to_map = tibble()

get_links_to_map <- function(linksdf, forms_of_interest) {
  filter <- linksdf$target %in% forms_of_interest
  linksdf[filter,]
}

while(length(focus) > 0) {
  new_links_to_map <- get_links_to_map(links, focus)
  links_to_map <- unique(rbind(links_to_map, new_links_to_map))
  focus <- unique(new_links_to_map$source)
  already_done <- focus %in% links_to_map$target
  focus <- focus[!already_done]
}

nodes_to_map <- tibble(id = unique(c(links_to_map$source, links_to_map$target)))

nodes_to_map.json <- toJSON(nodes_to_map, pretty = T)
links_to_map.json <- toJSON(links_to_map, pretty = T)

jsonfile <- sprintf("{'nodes': %s, 'links': %s}", nodes_to_map.json, links_to_map.json)
write(jsonfile, './links-and-nodes.json')


