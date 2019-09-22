ui <- fluidPage(
  actionButton("minus", "-1"),
  actionButton("plus", "+1"),
  br(),
  actionButton("reset", "Reset"),
  br(),
  textOutput("value")
)

# The comments below show the equivalent logic using reactiveValues()
server <- function(input, output, session) {
  # Initialise the value to zero.
  value <- reactiveVal(0)
  
  observeEvent(input$minus, {
    newValue <- value() - 1
    value(newValue)
  })
  
  observeEvent(input$plus, {
    newValue <- value() + 1     # newValue <- rv$value + 1
    value(newValue)             # rv$value <- newValue
  })
  observeEvent(input$reset, {
    value(0)
  })
  output$value <- renderText({
    paste0("The button counter is " + value())                     # rv$value
  })
}

shinyApp(ui, server)