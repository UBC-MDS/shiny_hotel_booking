library(shiny)
library(shinytest2)

options(shiny.autoreload = TRUE)

source('shiny_hotel_booking/cleaning.R')
source('shiny_hotel_booking/ui.R')
source('shiny_hotel_booking/server.R')

shinyApp(ui, server)