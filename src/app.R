library(shiny)
library(ggplot2)

# Simple Shiny app to render a scatter plot of unemployment data from 1967-2015.

dataset <- data("economics")

# Server component of Shiny application
server <- function(input, output) {
  output$rangeText <- renderText({
    paste("You have selected dates from", min(input$dateRange), "to", max(input$dateRange))
  })
  output$displayHistogram <- renderPlot({
    display <- subset(economics, economics$date >= input$dateRange[1] & economics$date <= input$dateRange[2])
    display <- subset(mutate(display, percent_unemployed = (unemploy / pop)*100), select = c(date, percent_unemployed))
    plot(display)
  })
}

# UI component of Shiny application
ui <- shinyUI(fluidPage(
  
  titlePanel("U.S. Unemployment Data from 1967-2015"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("dateRange", label = "Select a date range:",
                  value = c(min(economics$date), max(economics$date)),
                  min = min(economics$date),
                  max = max(economics$date))
    ),
    
    mainPanel(
      textOutput("rangeText"),
      plotOutput("displayHistogram")
    )
  )
))

shinyApp(ui = ui, server = server)