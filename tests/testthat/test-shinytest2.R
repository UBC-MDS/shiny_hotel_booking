library(shinytest2)
library(shinycssloaders)

test_that("{shinytest2} recording: test_filtering", {
  app <- AppDriver$new(name = "test_filtering", height = 990, width = 1409)
  app$set_inputs(countries = "United States of America")
  app$set_inputs(countries = c("United States of America", "Spain"))
  app$set_inputs(countries = c("United States of America", "Spain", "France", "Norway"))
  app$set_inputs(countries = c("United States of America", "Spain", "France", "Norway", 
      "Russia"))
  app$set_inputs(prop_type = c("Resort Hotel", "City Hotel"))
  app$set_inputs(prop_type = "City Hotel")
  app$expect_values()
})



test_that("{shinytest2} recording: test_total_bookings", {
  app <- AppDriver$new(name = "test_total_bookings", height = 990, width = 1409)
  app$set_inputs(heatmap_metric = "Number of total bookings")
  app$set_inputs(prop_type = character(0))
  app$set_inputs(prop_type = "City Hotel")
  app$set_inputs(daterange = c("2013-06-04", "2017-09-14"))
  app$expect_values()
})



test_that("{shinytest2} recording: test_daterng_month", {
  app <- AppDriver$new(name = "test_daterng_month", height = 990, width = 1409)
  app$set_inputs(daterange = c("2016-06-01", "2016-06-30"))
  app$set_inputs(countries = c("France", "Ireland", "Brazil", "Australia"))
  app$expect_values()
})

