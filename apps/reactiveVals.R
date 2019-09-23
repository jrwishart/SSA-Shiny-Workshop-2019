ui <- tagList(
  actionButton("minus", "-1"),
  actionButton("plus", "+1"),
  br(),
  actionButton("reset", "Reset"),
  br(),
  textOutput("value")
)

server <- function(input, output, session) {
  value <- reactiveVal(0)       # rv <- reactiveValues(value = 0)
  
  observeEvent(input$minus, {
    newValue <- value() - 1     # newValue <- rv$value - 1
    value(newValue)             # rv$value <- newValue
  })
  
  observeEvent(input$plus, {
    newValue <- value() + 1
    value(newValue)
  })
  
  observeEvent(input$reset, {
    value(0)
  })
  
  output$value <- renderText({
    value()
  })
}

shinyApp(ui, server)