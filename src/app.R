library(shiny)
library(plyr)
library(data.table)

# Simple Shiny app to render a scatter plot of unemployment data from 1967-2015.

data("economics")
dataset <- economics

# server component of shiny application
server <- function(input, output) {
  output$text1 <- renderText({
    paste("You have selected dates from", min(input$dateRange), "to", max(input$dateRange))
  })
  output$displayHistogram <- renderPlot({
    display <- subset(economics, economics$date >= input$dateRange[1] & economics$date <= input$dateRange[2])
    display <- subset(mutate(display, percent_unemployed = (unemploy / pop)*100), select = c(date, percent_unemployed))
    plot(display)
  })
}

# ui component of shiny application
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
      textOutput("text1"),
      plotOutput("displayHistogram")
    )
  )
))

shinyApp(ui = ui, server = server)