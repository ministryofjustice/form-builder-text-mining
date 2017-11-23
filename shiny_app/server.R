library(jsonlite)
library(shiny)
library(DT)
source(file = 'build_links_json.R')

shinyServer(
  function(input, output, session) {

    data = reactive({get_mapping_json(input$form_choice, './links.csv')})

    observeEvent(input$form_choice, {
      session$sendCustomMessage(type = 'jsondata', message = data())
    })

    # session$sendCustomMessage(type = 'jsondata', message = data)
  }
)
