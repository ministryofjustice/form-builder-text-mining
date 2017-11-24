library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(

  sidebarLayout(
    fluidRow(
      column(2,
        offset = 1,
        uiOutput("ref_direction")
      ),
      column(3,
        uiOutput("form_choice")
      ),
      column(2,
        uiOutput("iterations")
      )
    ),
    fluidRow(
      column(12,
      offset = 1,
      tags$div(HTML(
        '<svg width=1200 height=650 style="border:solid 1px"></svg>'
      )),
      tags$div(id='form-network'),
      tags$script(src="https://d3js.org/d3.v4.min.js"),
      singleton(
        tags$head(
          tags$script(src = "d3script.js"),
          tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
        )
      )
    ))
  )

)
