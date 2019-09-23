load("june_2019_trips_sample.RData")

all_data <- trips_sample
manhattan_data <- filter(trips_sample, pickup_location == "Manhattan" & within_Borough == TRUE)
queens_data <- filter(trips_sample, pickup_location == "Queens" & within_Borough == TRUE)
brooklyn_data <- filter(trips_sample, pickup_location == "Brooklyn" & within_Borough == TRUE)
bronx_data <- filter(trips_sample, pickup_location == "Bronx" & within_Borough == TRUE)
