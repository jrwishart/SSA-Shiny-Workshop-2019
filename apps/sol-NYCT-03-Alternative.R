library(shiny)
library(ggplot2)
library(dplyr)
library(tools)
library(DT)
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
                  min = 0.01, max = 1, step = 0.1, value = 0.8),
      dateRangeInput(inputId = "dates", label = "Select the Date Range",
                     min = "2019-06-01", max = "2019-06-30",
                     start = "2019-06-28", end = "2019-06-30"),
      sliderInput(inputId = "n", label = "Choose size of random sample",
                  min = 2, max = 3000, value = 512),
      actionButton(inputId = "sampButton", label = "Sample")
    ),
    mainPanel(
      plotOutput(outputId = "myScatterplot"),
      dataTableOutput(outputId = "myDataTable")
    )
  )
)

# Define server instructions
server <- function(input, output, session) {
  
  dat <- reactive({
    days = input$dates
    # Subset the data
    subset(trips_sample, as.Date(tpep_pickup_datetime) >= days[1] &
             as.Date(tpep_pickup_datetime) <= days[2])
  })
  
  subDat <- reactive({ 
    input$sampButton
    max_slider = min(3000, nrow(dat()))
    updateSliderInput(session, inputId = "n",
                      max = max_slider, value = min(max_slider, isolate(input$n)))
    dat() %>% sample_n(isolate(input$n))
  })
  
  # Create the scatterplot output
  output$myScatterplot <- renderPlot({
    ggplot(data = subDat(), aes_string(x = input$x, y = input$y, colour = input$colour)) +
      geom_point(alpha = input$alpha) +
      # Code to clean up the axis and colour labels
      labs(x = toTitleCase(sub("_", " ", input$x)),
           y = toTitleCase(sub("_", " ", input$y)),
           colour = toTitleCase(sub("_", " ", input$colour)))
  })
  
  # Create data table output
  output$myDataTable <- renderDataTable({
    cols = c(1, 4:5, 12:13, 16, 18)
    datatable(data = subDat()[, cols], rownames = FALSE)
  })
}

# Run the app
shinyApp(ui = ui, server = server)