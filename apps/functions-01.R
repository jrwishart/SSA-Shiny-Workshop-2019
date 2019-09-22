my_selector <- function() {
  selectInput(inputId = "datachoice",
              label = "Choose dataset to view:",
              choices = c("eruptions", "waiting"),
              selected = "eruptions")
}
ui <- fluidPage(
  my_selector(),
  plotOutput("myShinyOutput")
)
server <- function(input, output) {
  
  output$myShinyOutput <- renderPlot({
    # draw the histogram using ggplot2
    ggplot(faithful, aes_string(input$datachoice)) +
      geom_histogram(colour = 'black', fill = 'white')
  })
  
}
shinyApp(ui, server)