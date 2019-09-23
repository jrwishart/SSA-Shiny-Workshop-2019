library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(tools)
source("NYCT-module-data.R")
source("sol-NYCT-module.R")

ui <- navbarPage(
  title = "June 2019 NYC Yellow Taxi Data",
  tabPanel("All", NYC_taxi_module_UI("all")),
  tabPanel("Manhattan", NYC_taxi_module_UI("manhattan")),
  tabPanel("Queens", NYC_taxi_module_UI("queens")),
  tabPanel("Brooklyn", NYC_taxi_module_UI("brooklyn")),
  tabPanel("Bronx", NYC_taxi_module_UI("bronx"))
)

server <- function(input, output, session) {
  callModule(NYC_taxi_module, "all", all_data)
  callModule(NYC_taxi_module, "manhattan", manhattan_data)
  callModule(NYC_taxi_module, "queens", queens_data)
  callModule(NYC_taxi_module, "brooklyn", brooklyn_data)
  callModule(NYC_taxi_module, "bronx", bronx_data)
}
shinyApp(ui = ui, server = server)