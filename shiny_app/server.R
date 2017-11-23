library(jsonlite)
library(shiny)
library(DT)
source(file = 'build_links_json.R')

shinyServer(
  function(input, output, session) {

    data = reactive({get_mapping_json(input$form_choice, './links.csv')})
    links = read_csv('./links.csv')
    forms = unique(links$target, links$source)

    output$form_choice <- renderUI({
      selectInput(inputId = "form_choice",
                  label = "Choose a form",
                  choices = sort(forms)
      )
    })

    observeEvent(input$form_choice, {
      session$sendCustomMessage(type = 'jsondata', message = data())
    })
  }
)
