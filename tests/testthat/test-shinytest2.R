library(shinytest2)

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

