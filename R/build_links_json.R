library(tidyverse)
library(readr)
library(jsonlite)
library(optparse)

#GRAB COMMAND LINE ARGS

option_list = list(
  make_option(c("-f", "--focus"),
              type    = "character",
              default = NULL, 
              help    = "colon separated list of forms to focus on",
              metavar = "character"
  ),
  make_option(c("-s", "--save"),
              type    = "character",
              default = 'TRUE', 
              help    = "Save json to file?",
              metavar = "character"
  ),
  make_option(c("-l", "--links_path"),
              type    = "character",
              default = './links.csv', 
              help    = "Save json to file?",
              metavar = "character"
  )
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

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

get_mapping_json <- function(focus_opt, links_path) {
  
  # setting up
  focus_list <- strsplit(opt$focus, ':')[[1]]
  focus = tolower(focus_list)
  output_file_name <- paste0(opt$focus, '-vis.json')
  links = read_csv(links_path)
  links <- links[links$target != 'none detected',]
  links$source <- gsub('\\-eng|\\-cym|\\-bil', '', links$source)
  links$source <- gsub('_doc', '', links$source)
  
  links_to_map = tibble()
  prev_foci = c()
  
  # doing the work
  while(length(focus) > 0) {
    new_links_to_map <- get_links_to_map(links, focus)
    links_to_map     <- unique(rbind(links_to_map, new_links_to_map))
    prev_foci        <- c(focus, prev_foci)
    focus            <- get_new_focus(new_links_to_map, prev_foci)
  }
  
  # abstracting nodes
  nodes_to_map <- tibble(id = unique(c(links_to_map$source, links_to_map$target)))
  
  # generating nodes and links json
  nodes_to_map.json <- toJSON(nodes_to_map, pretty = T)
  links_to_map.json <- toJSON(links_to_map, pretty = T)
  
  # assembling and saving full json object
  jsonfile <- sprintf('{"nodes": %s, "links": %s}', nodes_to_map.json, links_to_map.json)
  
  if(opt$save == 'TRUE') {
    write(jsonfile, output_file_name)
  } else {
    jsonfile
  }
}

get_mapping_json(opt$focus, opt$links_path)

