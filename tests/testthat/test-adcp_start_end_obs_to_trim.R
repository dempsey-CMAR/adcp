test_that("adcp_start_end_obs_to_trim() assigns correct flags", {
  expect_equal(as.numeric(unique(dat_trim_2$trim_obs)), 2)
  expect_equal(as.numeric(unique(dat_trim_4$trim_obs)), 4)
})
