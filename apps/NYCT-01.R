library(shiny)
library(ggplot2)
load("june_2019_trips_sample.RData")

# Define UI 
ui <- fluidPage(
  title = "NYC Taxi and Limo Data Explorer:",
  titlePanel("NYC Taxi and Limo Data Explorer:"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "y", 
                  label = "Response Variable (y-axis):",
                  choices = c("passenger_count",
                              "trip_distance",
                              "fare_amount",
                              "tip_amount",
                              "total_amount"), 
                  selected = "fare_amount"),
      selectInput(inputId = "x",
                  label = "Predictor Variable (x-axis):",
                  choices = c("passenger_count",
                              "trip_distance",
                              "fare_amount",
                              "tip_amount",
                              "total_amount"), 
                  selected = "trip_distance")
    ),
    mainPanel(
      plotOutput(outputId = "myScatterplot")
    )
  )
)

# Define server instructions
server <- function(input, output) {
  # Create the scatterplot output
  output$myScatterplot <- renderPlot({
    ggplot(data = trips_sample, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
}

# Run the app
shinyApp(ui = ui, server = server)