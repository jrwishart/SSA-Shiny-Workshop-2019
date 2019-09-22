library(shiny)
library(ggplot2)

ui <- fluidPage(
  selectInput(inputId = "datachoice",
              label = "Choose dataset to view:",
              choices = c("eruptions", "waiting"),
              selected = 1),
  sliderInput(inputId = "numBins",
              label = "Select number of bins",
              min = 1, 
              max = 50,
              value = 30),
  plotOutput("myShinyOutput")
)

server <- function(input, output) {
  
  output$myShinyOutput <- renderPlot({
    
    # draw the histogram using ggplot2
    ggplot(faithful, aes_string(input$datachoice)) +
      geom_histogram(colour = 'black', fill = 'white',
                     bins = input$numBins)
  })
  
}

shinyApp(ui, server)