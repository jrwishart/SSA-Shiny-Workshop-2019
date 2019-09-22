letter_module_UI <- function(id, my_label = "Choose a letter") {
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("letterchoice"), 
                label = my_label, 
                choices = LETTERS[1:26]),
    verbatimTextOutput(ns("letter"))
  )
}
letter_module <- function(input, output, session, extra_param = 42) {
  output$letter = renderText({
    paste0("You have selected ", input$letterchoice)
  })
  extra_param
}

ui <- fluidPage(
  flowLayout(
    letter_module_UI("first"),
    letter_module_UI("second", "Choose a special letter"),
    letter_module_UI("third"),
    textOutput("mod1"),
    textOutput("mod2"),
    textOutput("mod3")
    
  )
)
server <- function(input, output) {
  mod1out <- callModule(letter_module, "first")
  mod2out <- callModule(letter_module, "second", extra_param = 10)
  mod3out <- callModule(letter_module, "third")
  
  output$mod1 <- renderText({
    paste0("Module 1 returns", mod1out)
  })
  output$mod2 <- renderText({
    paste0("Module 2 returns", mod2out)
  })
  output$mod3 <- renderText({
    paste0("Module 3 returns", mod3out)
  })
}
shinyApp(ui, server)

