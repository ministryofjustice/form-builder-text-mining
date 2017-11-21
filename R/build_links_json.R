library(tidyverse)
library(readr)
library(jsonlite)

# set initial focus to one or more forms and then run everything
# output file is called links-and-nodes.json (re-runs will overwrite )
focus = c(
  'pa7'
)

# output file is named according to the initial focus
output_file_name <- paste0(focus, '-vis.json')

focus <- tolower(focus)

links = read_csv('./links.csv')
links$source <- gsub('\\-eng|\\-cym|\\-bil', '', links$source)
links$source <- gsub('_doc', '', links$source)
links <- links[links$target != 'none detected',]
links_to_map = tibble()

get_links_to_map <- function(linksdf, forms_of_interest) {
  target_filter <- linksdf$target %in% forms_of_interest
  source_filter <- linksdf$source %in% forms_of_interest
  rbind(linksdf[target_filter,], linksdf[source_filter,])
}

get_new_focus <- function(new_links, prev_foci) {
  focus_from_new_links <- c(new_links$target, new_links$source)
  already_done <- focus_from_new_links %in% c(prev_foci)
  focus_from_new_links[!already_done]
}

prev_foci = c()
while(length(focus) > 0) {
  new_links_to_map <- get_links_to_map(links, focus)
  links_to_map     <- unique(rbind(links_to_map, new_links_to_map))
  prev_foci        <- c(focus, prev_foci)
  focus            <- get_new_focus(new_links_to_map, prev_foci)
}

nodes_to_map <- tibble(id = unique(c(links_to_map$source, links_to_map$target)))

nodes_to_map.json <- toJSON(nodes_to_map, pretty = T)
links_to_map.json <- toJSON(links_to_map, pretty = T)

jsonfile <- sprintf('{"nodes": %s, "links": %s}', nodes_to_map.json, links_to_map.json)
write(jsonfile, output_file_name)


