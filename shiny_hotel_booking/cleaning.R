library(tidyverse)
library(countrycode)
library(geojsonio)

# Read the data and clean it
data <- read_csv("data/hotel_bookings.csv",
                 show_col_types = FALSE)

data <- data[!is.na(data$country), ]

data <- data |> mutate(
  country_full_name = case_when(
    !country %in% c("CN", "TMP") ~ countrycode(country, "iso3c", "country.name"),
    country == "CN" ~ "China",
    country == "TMP" ~ "East Timor"
  )
)
data <- data[!is.na(data$country_full_name), ]
data$country_full_name[data$country_full_name == 'United States'] <- "United States of America"
data$country_full_name[data$country_full_name == 'Czechia'] <- "Czech Republic"
data$country_full_name[data$country_full_name == 'Bosnia & Herzegovina'] <- "Bosnia and Herzegovina"
data$country_full_name[data$country_full_name == 'Serbia'] <- "Republic of Serbia"
data$country_full_name[data$country_full_name == 'North Macedonia'] <- "Macedonia"

# Read the map polygon data
countries_json <- geojson_read("data/countries.geojson", what = "sp")
country_list = pull(countries_json@data[1])
full_country_df = data_frame(country_full_name = country_list)