test_that("`adcp_label_intervals()` assigns correct number of levels", {

  expect_equal(length(levels(df_speed$sea_water_speed_cm_s_labels)), 10)

  expect_equal(
    length(levels(df_direction$sea_water_to_direction_degree_labels)), 8
  )
})


test_that("`adcp_label_intervals()` assigns correct labels", {

  expect_equal(
    as.character(df_speed$sea_water_speed_cm_s_labels),
    c("0 to 3", "0 to 3", "6 to 9", "9 to 12",
      "12 to 15", "18 to 21", "27 to 30")
  )

  expect_equal(
    as.character(df_direction$sea_water_to_direction_degree_labels),
    c("N", "NE", "E", "SE", "S", "SW", "W", "NW", "N",
      "N", "NE", "E", "SW", "NW",
      NA, NA )
  )
})
