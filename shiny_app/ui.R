library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  titlePanel("Visualise those forms!"),

  sidebarLayout(
    sidebarPanel(
      h1('Choose a form')
    ),
    mainPanel(
      h1('References to and from your favourite form'),
      tags$div(HTML(
        '<svg width=8000 height=8000 style="border:solid 1px"></svg>'
      )),
      tags$div(id='form-network'),
      tags$script(src="https://d3js.org/d3.v4.min.js"),
      singleton(
        tags$head(tags$script(src = "d3script.js"))
      )
    )
  )

)
