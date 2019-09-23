NYC_taxi_module_UI <- function(id) {
  ns <- NS(id)
  fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = ns("y"), 
                  label = "Response Variable (y-axis):",
                  choices = c("Passenger count" = "passenger_count",
                              "Trip distance" = "trip_distance",
                              "Fare amount" = "fare_amount",
                              "Tip amount" = "tip_amount",
                              "Total amount" = "total_amount"), 
                  selected = "fare_amount"),
      selectInput(inputId = ns("x"),
                  label = "Predictor Variable (x-axis):",
                  choices = c("Passenger count" = "passenger_count",
                              "Trip distance" = "trip_distance",
                              "Fare amount" = "fare_amount",
                              "Tip amount" = "tip_amount",
                              "Total amount" = "total_amount"), 
                  selected = "trip_distance"),
      selectInput(inputId = ns("colour"),
                  label = "Colour points with:",
                  choices = c("Vendor ID" = "Vendor_ID",
                              "Rate Code ID" = "Rate_Code_ID",
                              "Store and FWD Flag" = "store_and_fwd_flag",
                              "Payment Type" = "payment_type"), 
                  selected = "trip_distance"),
      sliderInput(inputId = ns("alpha"),
                  label = "Set the transparency level:",
                  min = 0.01, max = 1, step = 0.1, value = 0.8),
      dateRangeInput(inputId = ns("dates"), label = "Select the Date Range",
                     min = "2019-06-01", max = "2019-06-30",
                     start = "2019-06-01", end = "2019-06-30"),
      sliderInput(inputId = ns("n"), label = "Choose size of random sample",
                  min = 2, max = 3000, value = 512),
      # uiOutput(outputId = ns("reactive_slider")),
      actionButton(inputId = ns("sampButton"), label = "Sample")
    ),
    mainPanel(
      plotOutput(outputId = ns("myScatterplot")),
      dataTableOutput(outputId = ns("myDataTable"))
    )
  )
  )
}
NYC_taxi_module <- function(input, output, session, trip_data) {
  nams <- names(trip_data)
  
  dat <- reactive({
    days = input$dates
    # Subset the data
    subset(trip_data, as.Date(tpep_pickup_datetime) >= days[1] &
             as.Date(tpep_pickup_datetime) <= days[2])
  })
  
  subDat <- eventReactive(input$sampButton, {
    dat_size = min(3000, nrow(dat()))
    updateSliderInput(session, inputId = "n",
                      max = dat_size,
                      value = dat_size/2)
    dat() %>% sample_n(input$n)
  }, ignoreNULL = FALSE)
  
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
    cols = which(nams %in% c("Vendor_ID", "passenger_count", "trip_distance",
                             "payment_type", "fare_amount", "tip_amount", "total_amount"))
    datatable(data = subDat()[, cols], rownames = FALSE)
  })
}
