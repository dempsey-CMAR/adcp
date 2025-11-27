test_that("adcp_test_tidal_bin_height() assigns correct flags", {
  expect_equal(as.numeric(unique(bh_1$tidal_bin_height_flag_value)), 1)

  expect_equal(as.numeric(unique(bh_3$tidal_bin_height_flag_value)), 3)

  expect_equal(as.numeric(unique(bh_4$tidal_bin_height_flag_value)), 4)

})

test_that("adcp_test_tidal_bin_height() returns error", {
  expect_error(adcp_test_tidal_bin_height(dat_bh))
})
