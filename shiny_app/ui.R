library(shiny)
library(shinyBS)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  div(
    titlePanel("Map all the references to and / or from your favourite HMCTS form")
  ),

  sidebarLayout(
    sidebarPanel(
      fluidRow(
        h4('What does this thing do?'),
        p(
          "Text from each live HMCTS form was mined for references to every other live HMCTS form.
          Use the controls below to generate a map of these references, starting from one form of interest."
        ),
        p(
          "Node size relates to the number of references to that form."
        )
      ),
      fluidRow(uiOutput("ref_direction")),
      fluidRow(uiOutput("form_choice")),
      fluidRow(uiOutput("iterations")),
      fluidRow(tableOutput("table"))       
    ),
    mainPanel(
      tags$div(HTML(
        '<svg width=900 height=550 style="border:solid 1px"></svg>'
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
