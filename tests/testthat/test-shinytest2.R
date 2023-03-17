library(shinytest2)

test_that("{shinytest2} recording: test_filtering", {
  app <- AppDriver$new(variant = platform_variant(), name = "test_filtering", height = 990, 
      width = 1409)
  app$set_inputs(countries = "United States of America")
  app$set_inputs(countries = c("United States of America", "Spain"))
  app$set_inputs(countries = c("United States of America", "Spain", "New Zealand"))
  app$set_inputs(countries = c("United States of America", "Spain", "New Zealand", 
      "Mexico"))
  app$set_inputs(prop_type = c("Resort Hotel", "City Hotel"))
  app$expect_values()
  app$expect_screenshot()
})

