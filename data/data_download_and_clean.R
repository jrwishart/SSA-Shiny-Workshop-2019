library(tidyverse)
# This file is 613MB 
# trips = readr::read_csv("https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-06.csv")

place_lookup = readr::read_csv("https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv")

money_vars = c("fare_amount", "total_amount", "tolls_amount", "tip_amount", "extra", "mta_tax")

clean_trips = trips %>%
  filter(trip_distance >= 0 & trip_distance < 200) %>% 
  mutate_at(money_vars, abs) %>% 
  mutate(VendorID = recode(VendorID, `1` = "Creative Mobile Technologies",
                           `2` = "VeriFone Inc.", .default = "Unknown"),
         RatecodeID = recode(RatecodeID, `1` = "Standard rate", `2` = "JFK", `3` = "Newark",
                             `4` = "Nassau or Westchester", `5` = "Negotiated fare",
                             `6` = "Group ride", .default = "Unknown"),
         payment_type = recode(payment_type, `1` = "Credit card", `2` = "Cash", `3` = "No charge",
                               `4` = "Dispute", `5` = "Unknown", `6` = "Voided trip", .default = "Unknown"),
         store_and_fwd_flag = recode(store_and_fwd_flag, `N` = "No", `Y` = "Yes"),
         PULocation = map_chr(PULocationID, ~place_lookup[.x, ]$Borough),
         DOLocation = map_chr(DOLocationID, ~place_lookup[.x, ]$Borough),
         within_Borough = map2_lgl(PULocation, DOLocation, ~.x == .y)) %>% 
  rename(Vendor_ID = VendorID, 
         Rate_Code_ID = RatecodeID,
         pickup_location = PULocation,
         dropoff_location = DOLocation)


save(clean_trips, file = here::here("apps", "trips.RData"))

# Reduce size for speed during workshop
set.seed(23092019)
trips_sample = clean_trips %>% sample_n(1e5)
save(trips_sample, file =  here::here("apps", "june_2019_trips_sample.RData"))

# subset to last week as well for further file size reduction and speed up.
Start = "2019-06-24"
Finish = "2019-06-30"

last_week_june_2019_sample = trips_sample %>% 
  filter(tpep_pickup_datetime <= Finish & tpep_dropoff_datetime >= Start)

save(last_week_june_2019_sample, file = here::here("apps", "last_week_june_2019_sample.Rdata"))
