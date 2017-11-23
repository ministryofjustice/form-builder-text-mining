library(jsonlite)
library(shiny)
library(DT)
source(file = 'build_links_json.R')

shinyServer(
  function(input, output, session) {
    data = get_mapping_json(c('ex160'), './links.csv')
    session$sendCustomMessage(type = 'jsondata', message = data)
  }
)
