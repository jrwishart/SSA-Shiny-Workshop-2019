letter_module_UI <- function(id, my_label = "Choose a letter") {
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("letterchoice"), 
                label = my_label, 
                choices = LETTERS[1:26]),
    verbatimTextOutput(ns("letter"))
  )
}
letter_module <- function(input, output, session, show_output) {
  output$letter = renderText({
    if(show_output()) {
      paste0("You have selected ", input$letterchoice)  
    } else {
      return(NULL)
    }
  })
}

ui <- fluidPage(
  flowLayout(
    letter_module_UI("first", ),
    letter_module_UI("second", "Choose a special letter"),
    letter_module_UI("third", ),
    checkboxInput(inputId = "show",
                  label = "Show first and third module outputs",
                  value = TRUE),
    
    checkboxInput(inputId = "show2",
                  label = "Show second module output",
                  value = TRUE)
  )
)
server <- function(input, output) {
  show_output <- reactive({
    input$show
  })
  show_output_2 <- reactive({
    input$show2
  })
  callModule(letter_module, "first", show_output)
  callModule(letter_module, "second", show_output_2)
  callModule(letter_module, "third", show_output)
  
}
shinyApp(ui, server)