library(shiny)
library(ggplot2)
library(leaflet)
library(tidyverse)
library(bslib)
library(plotly)
library(thematic)
library(countrycode)
library(DT)
library(geojsonio)
library(htmltools)

options(shiny.autoreload = TRUE)

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

ui <- fluidPage(
  theme = bs_theme(bootswatch = 'flatly'),
  # Page title 
  titlePanel(h2('🏨 🧐 Hotel Industry Competitive Landscape Dashboard',
                align = "center")),
  br(),
  
  # Controller row
  fluidRow(
    dateRangeInput(inputId = 'daterange',
                   label = '🗓️ Date range:',
                   start  = min(data$reservation_status_date),
                   end = max(data$reservation_status_date),
                   format = "mm/dd/yyyy"
                   ),
    selectInput(inputId = 'countries',
                label = '🌈 Countries:',
                choices = unique(data$country_full_name),
                selected = NULL,
                multiple = TRUE,
                width = '30%',
                size = NULL
                ),
    selectInput(inputId = 'prop_type',
                label = '🏖️ Property types:',
                choices = unique(data$hotel),
                selected = "Resort Hotel",
                multiple = TRUE,
                width = NULL,
                size = NULL
                ),
    selectInput(inputId = 'heatmap_metric',
                label = '🧮 Heatmap metric:',
                choices = c("Average per night price", "Number of total bookings"),
                selected = "2",
                width = NULL,
                size = NULL
                ),
    ),
  
  #Charts and heatmap row
  fluidRow(
    column(9,
           leafletOutput("mainHeatMap", width = "100%", height = "600px")
           ),
    column(3,
           h6("Charts Placeholder")
           )
    ),
  br(),
  
  fluidRow(
    column(12,
           h3("Main Data Tester"),
           DTOutput(outputId = 'table_main')
           )
    ),
  br(),
  fluidRow(
    p("Ⓒ All rights reserved 2023 - 💪 💜 Proudly built by UBC MDS program students: Mengjun Chen, Wilfred Hass, Roan Raina, and Mohammad Reza Nabizadeh")
  ),
  
)

server <- function(input, output, session) {
  thematic::thematic_shiny()
  
  #Apply the data filtering to creatively filter the main data
  reactive_data <-
    reactive(
      {
    # Default data selection
      filtered_data <- data
      
    # Apply the date range, type, and country filtering
      if (!is.null(input$daterange)) {
        filtered_data <- filtered_data |>
          filter(reservation_status_date > input$daterange[1] &
                   reservation_status_date < input$daterange[2])
        }
      
      if (!is.null(input$countries)) {
        filtered_data <- filtered_data |> 
          filter(country_full_name %in% input$countries)
        }
      
      if (!is.null(input$prop_type)) {
        filtered_data <- filtered_data |> 
          filter(hotel %in% input$prop_type)
        }
      
      filtered_data
      }
    )
  
  #Apply the data filtering to creatively filter the summarized data
  reactive_sum_data <-
    reactive(
      {
        # Default data selection
        filtered_data <- data
        
        # Apply the date range, type, and country filtering
        if (!is.null(input$daterange)) {
          filtered_data <- filtered_data |>
            filter(reservation_status_date > input$daterange[1] &
                     reservation_status_date < input$daterange[2])
          }
        
        if (!is.null(input$countries)) {
          filtered_data <- filtered_data |> 
            filter(country_full_name %in% input$countries)
          }
        
        if (!is.null(input$prop_type)) {
          filtered_data <- filtered_data |> 
            filter(hotel %in% input$prop_type)
          }
        
        if (input$heatmap_metric == "Average per night price"){
          df <- filtered_data |> group_by(country_full_name) |>
            summarise(agg_sum = mean(adr, na.rm = TRUE))
          
          filtered_data <- left_join(
            full_country_df,
            df,
            by = 'country_full_name')
          }
        
        if (input$heatmap_metric == "Number of total bookings"){
          df <- filtered_data |> group_by(country_full_name) |>
            summarise(agg_sum = n())
          
          filtered_data <- left_join(
            full_country_df,
            df,
            by = 'country_full_name')
          }
        
        filtered_data
      }
    )
  
  reactive_color_pal <- reactive({
    bins <- c(0, 92.5, 95, 97.5, 100, 120.5, 105, 200, 300)
    col_pallete <- colorBin("YlOrRd",
                            domain = reactive_sum_data()$agg_sum,
                            bins = bins
                            )
    
    if (input$heatmap_metric == "Number of total bookings"){
      bins <- c(0, 100, 500, 1000, 2000, 5000, 10000, 50000)
      col_pallete <- colorBin("Greens",
                              domain = reactive_sum_data()$agg_sum,
                              bins = bins
                              )
    }
    col_pallete
  }
  )
  
  reactive_label <- reactive({
    labels <- sprintf(
      "<strong>%s</strong><br/>%g USD/Night",
      reactive_sum_data()$country_full_name,
      reactive_sum_data()$agg_sum) |> lapply(HTML)
    
    if (input$heatmap_metric == "Number of total bookings"){
      labels <- sprintf(
        "<strong>%s</strong><br/>Total %g Bookings",
        reactive_sum_data()$country_full_name,
        reactive_sum_data()$agg_sum) |> lapply(HTML)
      }
    labels
    }
    )
  
  output$table_main <-  renderDT({
    # read the documentation for the arguments  
    datatable(reactive_data(),
              caption = 'Table: Observations by location.',
              extensions = 'Scroller',
              options=list(deferRender = TRUE,
                           scrollY = 200,
                           scroller = TRUE))
    
  })
  
  output$mainHeatMap <- renderLeaflet({
  
    pal <- reactive_color_pal()
    labels <- reactive_label()
    
    leaflet(countries_json) |>
      addTiles() |>
      setView(lng = 0, lat = 30, zoom = 2) |>
      addProviderTiles("MapBox",
                       options = providerTileOptions(
                         id = "mapbox.light",
                         accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) |>
      addPolygons(
        fillColor = pal(reactive_sum_data()$agg_sum),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "2",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 2,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) |>
      addLegend(pal = pal,
                values = ~reactive_sum_data()$agg_sum,
                opacity = 0.7,
                title = NULL,
                position = "bottomright")
    
    
  })

}

shinyApp(ui, server)