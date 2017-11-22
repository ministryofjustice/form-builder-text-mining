library(jsonlite)
library(shiny)
library(DT)

shinyServer(
  function(input, output, session) {
    data <- toJSON(read_json('../ex160-vis.json'))
    session$sendCustomMessage(type = 'testmessage', message = data)
  }
)
