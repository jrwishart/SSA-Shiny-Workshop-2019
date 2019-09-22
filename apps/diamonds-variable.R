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
            sum_dat = summary(abs(diff(diamond_dat[, input$variable])))
            mn = sum_dat[1]
            md = sum_dat[3]
            mx = sum_dat[5]
            sliderInput("bin_width", "Choose the histogram bin width:",
                        min = mn, max = mx,
                        step = (mx - mn)/50, value = md)
        } else {
            br()
        }
    })
    
    output$outputPlot <- renderPlot({
        p <- ggplot(diamonds, aes_string(x = input$variable)) 
        if(input$variable %in% numeric_vars) {
            bins = ifelse(is.null(input$bin_width), 30, input$bin_width)
            p <- p + geom_histogram(binwidth = bins)
        } else {
            p <- p + geom_bar()
        }
        return(p)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
