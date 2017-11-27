library(jsonlite)
library(shiny)
library(stringr)
library(DT)
library(snakecase)
library(readr)
source(file = 'build_links_json.R')

shinyServer(
  function(input, output, session) {

    data <- reactive({
      get_mapping_json(c(input$form_choice), './links.csv', to_snake_case(input$ref_direction), input$iterations)
    })

    register = read_csv('./register.csv')
    colnames(register)[5] <- 'Type'
    register$Payment <- sapply(register$Payment, FUN = function(x) if(x == 0){ 'Yes' } else {'No'})
    register$'File Name' <- sapply(register$'File Name', FUN = function(f) {
      str_interp("<a href=\"https://formfinder.hmctsformfinder.justice.gov.uk/${f}\">${f}</a>")
    })
    links = read_csv('./links.csv')
    forms = unique(links$target, links$source)

    output$form_choice <- renderUI({
      selectInput(inputId = "form_choice",
                  label = 'each form, working outwards from',
                  choices = sort(forms),
      )
    })

    table_cols <- c(
      'Attachment',
      'Payment',
      'Type',
      'File Name'
    )

    table <- reactive({
      register[tolower(register$'Form Reference') == input$form_choice,][table_cols]
    })

    output$table <- renderTable({table()}, sanitize.text.function = function(x) x)

    output$ref_direction <- renderUI({
      selectInput(inputId = "ref_direction",
                  label = 'Show references',
                  choices = c('to and from', 'to', 'from')
      )
    })

    output$iterations <- renderUI({
      selectInput(inputId = "iterations",
                  label = 'for this many iterations',
                  choices = c(1,2,3,4,5,'To completion')
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
