library(shiny)

ui <- navbarPage(
  # title (appears in browser tab)
  title = "Simple Linear regression simulator",
  tabPanel("Settings",
      # Title to appear in App
      withMathJax(),
      h4("Simulation settings : \\(Y_i = \\beta_0 + \\beta_1 X_i + \\varepsilon_i\\)"),
      sidebarLayout(
        sidebarPanel(
          # Inputs
          numericInput('beta0', withMathJax(), label = "Intercept coef: \\(\\beta_0\\)",
                       min = -50, max = 50, value = 10),
          numericInput('beta1', withMathJax(), label = "Slope coef: \\(\\beta_1\\)",
                       min = -50, max = 50, value = 10),
          sliderInput('SNR', label = "Signal to Noise Ratio",
                      min = 5, 
                      max = 40,
                      value = 40, step = 1),
          numericInput("n", label = "Sample size",
                       min = 10, max = 1024, value = 128),
          checkboxInput("showTrueLine", label = "Show True regression line"),
          checkboxInput("showConfBands", label = "Show 95% confidence bands"),
          actionButton("simulate", label = "Simulate")
        ),
        mainPanel(
          plotOutput("scatterplot")
        )
      )
  ),
  tabPanel("Summary Output",
           verbatimTextOutput("summaryOutput")
  ),
  tabPanel("Data Table",
           dataTableOutput("tableOfData"))
)

server <- function(input, output) {
  
  dat <- eventReactive(input$simulate, {
    
    validate(
      need(input$n %in% 2:1000, "Please select n between 2 and 1000")
    )
    
    x = sort(runif(n = input$n))
    mu = input$beta0 + input$beta1 * x
    sigma = mean(mu^2) * 10^(-input$SNR/20)
    y = mu + sigma * rnorm(input$n)
    data.frame(x = x, y = y, mu = mu)
  }, ignoreNULL = FALSE)
  
  output$scatterplot <- renderPlot({
    p <- ggplot(dat(), aes(x = x, y = y)) + geom_point()
    if(input$showTrueLine) {
      p <- p + geom_line(aes(x = x, y = mu))
    }
    
    if(input$showConfBands) {
      p <- p + geom_smooth(method = 'lm', formula = y ~ x, se = TRUE)
    } else {
      p <- p + geom_smooth(method = 'lm', formula = y ~ x, se = FALSE)
    }
    p
  })
  
  output$summaryOutput <- renderPrint({
    summary(lm(y ~ x, data = dat()))
  })
  
  output$tableOfData <- renderDataTable({
    datatable(round(dat(), 3), options = list(pageLength = 10), rownames = FALSE)
    
  })
}

shinyApp(ui, server)