library(shiny)
library(tools)
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
                  choices = c("Passenger count" = "passenger_count",
                              "Trip distance" = "trip_distance",
                              "Fare amount" = "fare_amount",
                              "Tip amount" = "tip_amount",
                              "Total amount" = "total_amount"), 
                  selected = "fare_amount"),
      selectInput(inputId = "x",
                  label = "Predictor Variable (x-axis):",
                  choices = c("Passenger count" = "passenger_count",
                              "Trip distance" = "trip_distance",
                              "Fare amount" = "fare_amount",
                              "Tip amount" = "tip_amount",
                              "Total amount" = "total_amount"), 
                  selected = "trip_distance"),
      selectInput(inputId = "colour",
                  label = "Colour points with:",
                  choices = c("Vendor ID" = "Vendor_ID",
                              "Rate Code ID" = "Rate_Code_ID",
                              "Store and FWD Flag" = "store_and_fwd_flag",
                              "Payment Type" = "payment_type"), 
                  selected = "trip_distance"),
      sliderInput(inputId = "alpha",
                  label = "Set the transparency level:",
                  min = 0.01, max = 1, step = 0.1, value = 0.8)
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
    ggplot(data = trips_sample, aes_string(x = input$x, y = input$y, colour = input$colour)) +
       geom_point(alpha = input$alpha) +
      # Code to clean up the axis and colour labels
      labs(x = toTitleCase(sub("_", " ", input$x)),
           y = toTitleCase(sub("_", " ", input$y)),
           colour = toTitleCase(sub("_", " ", input$colour)))
  })
}

# Run the app
shinyApp(ui = ui, server = server)