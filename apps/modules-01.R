letter_module_UI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("letterchoice"), 
                label = "Choose a letter", 
                choices = LETTERS[1:26]),
    verbatimTextOutput(ns("letter"))
  )
}
letter_module <- function(input, output, session) {
  output$letter = renderText({
    paste0("You have selected ", input$letterchoice)
  })
}

ui <- fluidPage(
  flowLayout(
    letter_module_UI("first"),
    letter_module_UI("second"),
    letter_module_UI("third")
  )
)
server <- function(input, output) {
  callModule(letter_module, "first")
  callModule(letter_module, "second")
  callModule(letter_module, "third")
}
shinyApp(ui, server)

