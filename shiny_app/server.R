library(jsonlite)
library(shiny)
library(DT)
library(snakecase)
source(file = 'build_links_json.R')

shinyServer(
  function(input, output, session) {

    data = reactive({
      get_mapping_json(c(input$form_choice), './links.csv', to_snake_case(input$ref_direction), as.integer(input$iterations))
    })

    links = read_csv('./links.csv')
    forms = unique(links$target, links$source)

    output$form_choice <- renderUI({
      selectInput(inputId = "form_choice",
                  label = 'each form, working outwards from',
                  choices = sort(forms),
      )
    })

    output$ref_direction <- renderUI({
      selectInput(inputId = "ref_direction",
                  label = 'Show references',
                  choices = c('to and from', 'to', 'from')
      )
    })

    output$iterations <- renderUI({
      selectInput(inputId = "iterations",
                  label = 'for this many iterations',
                  choices = c('1','2','3','4','5')
      )
    })

    observeEvent(input$form_choice, {
      session$sendCustomMessage(type = 'jsondata', message = data())
    })

    observeEvent(input$ref_direction, {
      session$sendCustomMessage(type = 'jsondata', message = data())
    })

    observeEvent(input$iterations, {
      session$sendCustomMessage(type = 'jsondata', message = data())
    })
  }
)
