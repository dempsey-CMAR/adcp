test_that("adcp_assign_max_flag() assigns correct flag value", {
  expect_equal(
    dat_max_flag$qc_flag_sea_water_speed_m_s,
    ordered( c(1, 2, 3, 4, 4), levels = 1:4)
    )
})
