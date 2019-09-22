library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  # Optional but recommended application title
  titlePanel("Histograms of Faithful Geyser Data"),
  
  # SidebarLayout call
  sidebarLayout(position = "left",
    # Sidebar panel with input controls
    sidebarPanel(
      selectInput(inputId = "datachoice",
                  label = "Choose dataset to view:",
                  choices = c("eruptions", "waiting"),
                  selected = 1),
      sliderInput(inputId = "numBins",
                  label = "Select number of bins",
                  min = 1, 
                  max = 50,
                  value = 30),
      checkboxInput("datSummary", "Show Five Number Summary")
    ),
    # main Panel with the outputs
    mainPanel(
      plotOutput("myShinyOutput"),
      verbatimTextOutput("numberSummary")
    )
  )
)

server <- function(input, output) {
  
  output$myShinyOutput <- renderPlot({
    
    # draw the histogram using ggplot2
    ggplot(faithful, aes_string(input$datachoice)) +
      geom_histogram(colour = 'black', fill = 'white',
                     bins = input$bins)
  })
  
  output$numberSummary <- renderPrint({
    if(input$datSummary) {
      summary(faithful[, which(names(faithful) == input$datachoice)])
    }
  })
}

shinyApp(ui, server)