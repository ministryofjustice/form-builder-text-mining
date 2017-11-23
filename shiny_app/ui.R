library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  titlePanel("Visualise those forms!"),

  sidebarLayout(
    sidebarPanel(
      h1('Choose a form'),
      selectizeInput(
        inputId = "form_choice",
        label = "Choose your favourite form:",
        choices = c('ex160', 'pa7')
      )
    ),
    mainPanel(
      h1('References to and from your favourite form'),
      tags$div(HTML(
        '<svg width=800 height=800 style="border:solid 1px"></svg>'
      )),
      tags$div(id='form-network'),
      tags$script(src="https://d3js.org/d3.v4.min.js"),
      singleton(
        tags$head(
          tags$script(src = "d3script.js"),
          tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
        )
      )
    )
  )

)
