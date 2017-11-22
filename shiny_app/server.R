library(jsonlite)
library(shiny)
library(DT)

shinyServer(
  function(input, output, session) {
    data <- toJSON(read_json('../pa1-vis.json'))
    session$sendCustomMessage(type = 'testmessage', message = data)
  }
)
