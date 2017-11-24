library(tidyverse)
library(readr)
library(jsonlite)
library(optparse)

get_links_to_map <- function(linksdf, forms_of_interest, ref_direction) {
  if(ref_direction == 'to_and_from') {
    target_filter <- linksdf$target %in% forms_of_interest
    source_filter <- linksdf$source %in% forms_of_interest
    filter <- target_filter | source_filter
  } else if(ref_direction == 'to') {
    filter <- linksdf$target %in% forms_of_interest
  } else if(ref_direction == 'from') {
    filter <- linksdf$source %in% forms_of_interest
  } else {
    stop('Invalid `ref_direction` parameter')
  }
    linksdf[filter,]
}

get_new_focus <- function(new_links, prev_foci) {
  focus_from_new_links <- c(new_links$target, new_links$source)
  already_done <- focus_from_new_links %in% c(prev_foci)
  focus_from_new_links[!already_done]
}

get_mapping_json <- function(focus_opt, links_path, ref_direction, iterations) {
  
  # setting up
  focus_list <- strsplit(focus_opt, ':')[[1]]
  focus = tolower(focus_list)
  initial_focus = focus
  # output_file_name <- paste0(focus_opt, '-vis.json')
  links = read_csv(links_path)
  links <- links[links$target != 'none detected',]
  links$source <- gsub('\\-eng|\\-cym|\\-bil', '', links$source)
  links$source <- gsub('_doc', '', links$source)
  
  links_to_map = tibble()
  prev_foci = c()
  
  remaining_iterations = iterations
  # doing the work
  while(length(focus) > 0 && remaining_iterations > 0) {
    new_links_to_map <- get_links_to_map(links, focus, ref_direction)
    links_to_map     <- unique(rbind(links_to_map, new_links_to_map))
    prev_foci        <- c(focus, prev_foci)
    focus            <- get_new_focus(new_links_to_map, prev_foci)
    remaining_iterations <- remaining_iterations - 1
  }
  
  # abstracting nodes
  nodes_to_map <- tibble(id = unique(c(links_to_map$source, links_to_map$target, initial_focus)))
  nodes_to_map$group <- sapply(
    nodes_to_map$id,
    FUN = function(node) { 
      nrow(links_to_map[links_to_map$target == node,] ) + 10
    }
  )
  
  # generating nodes and links json
  jsonlite::toJSON(list(form_choice = initial_focus, links_and_nodes = list(nodes = nodes_to_map, links = links_to_map)))
}
