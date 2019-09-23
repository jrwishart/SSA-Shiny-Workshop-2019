library(ggplot2)
library(shiny)
data(diamonds)

diamond_dat = as.data.frame(diamonds)

ui <- fluidPage(
    titlePanel("Single Variable summary of Diamonds Data"),
    sidebarLayout(
        sidebarPanel(
            selectInput("variable",
                        "Choose a variable from the diamonds dataset:",
                        choices = names(diamonds)),
            uiOutput("bin_chooser")
        ),
        mainPanel(
           plotOutput("outputPlot")
        )
    )
)

numeric_vars = c("carat", "depth", "table", "x", "y", "z")

server <- function(input, output) {
    
    output$bin_chooser <- renderUI({
        if(input$variable %in% numeric_vars) {
            sliderInput("bin_num", "Choose the number of bins:",
                        min = 1, max = 100,
                        step = 1, value = 10)
        } else {
            br()
        }
    })
    
    output$outputPlot <- renderPlot({
        p <- ggplot(diamonds, aes_string(x = input$variable)) 
        if(input$variable %in% numeric_vars) {
            req(input$bin_num)
            bins = input$bin_num
            p <- p + geom_histogram(bins = bins)
        } else {
            p <- p + geom_bar()
        }
        return(p)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
