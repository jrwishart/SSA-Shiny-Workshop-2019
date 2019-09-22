my_selector <- function(id) {
  selectInput(inputId = id,
              label = "Choose dataset to view:",
              choices = c("eruptions", "waiting"),
              selected = "eruptions")
}
ui <- fluidPage(
  fluidRow(
    column(6, my_selector("datachoice1")), column(6, my_selector("datachoice2"))
  ),
  fluidRow(
    column(6, plotOutput("myShinyOutput1")), column(6, plotOutput("myShinyOutput2"))
  )
)
server <- function(input, output) {
  
  output$myShinyOutput1 <- renderPlot({
    ggplot(faithful, aes_string(input$datachoice1)) +
      geom_histogram(colour = 'black', fill = 'white')
  })
  
  output$myShinyOutput2 <- renderPlot({
    ggplot(faithful, aes_string(input$datachoice2)) +
      geom_histogram(colour = 'black', fill = 'white')
  })
}
shinyApp(ui, server)