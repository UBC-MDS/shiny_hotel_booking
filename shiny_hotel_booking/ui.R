library(bslib)
library(leaflet)
library(DT)

ui <- fluidPage(
  theme = bs_theme(bootswatch = 'flatly'),
  # Page title
  titlePanel(
    h2('🏨 🧐 Hotel Industry Competitive Landscape Dashboard',
       align = "center")
  ),
  br(),
  
  # Controller row
  fluidRow(
    dateRangeInput(
      inputId = 'daterange',
      label = '🗓️ Date range:',
      start  = min(data$reservation_status_date),
      end = max(data$reservation_status_date),
      format = "mm/dd/yyyy"
    ),
    selectInput(
      inputId = 'countries',
      label = '🌈 Countries:',
      choices = unique(data$country_full_name),
      selected = NULL,
      multiple = TRUE,
      width = '30%',
      size = NULL
    ),
    selectInput(
      inputId = 'prop_type',
      label = '🏖️ Property types:',
      choices = unique(data$hotel),
      selected = "Resort Hotel",
      multiple = TRUE,
      width = NULL,
      size = NULL
    ),
    selectInput(
      inputId = 'heatmap_metric',
      label = '🧮 Heatmap metric:',
      choices = c("Average per night price", "Number of total bookings"),
      selected = "2",
      width = NULL,
      size = NULL
    ),
  ),
  
  #Charts and heatmap row
  fluidRow(column(
    8,
    leafletOutput("mainHeatMap", width = "100%", height = "640px")
  ),
  # Place holder for charts
  column(
    4,
    plotOutput("graph_avg_price", width = "100%", height = "200px"),
    plotOutput("distPriceCountry", width = "100%", height = "240px"),
    plotOutput("busiest_days", width = "100%", height = "200px")
  )
),
  
  br(),
  fluidRow(
    p(
      "Ⓒ All rights reserved 2023 - 💪 💜 Proudly built by UBC MDS program students: Mengjun Chen, Wilfred Hass, Roan Raina, and Mohammad Reza Nabizadeh"
    )
  ),
  
)