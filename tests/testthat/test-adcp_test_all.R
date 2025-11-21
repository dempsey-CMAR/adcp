test_that("adcp_test_all() returns expected dimensions", {
  expect_equal(nrow(dat_all), nrow(dat_all_qc))

  # will need to adjust number of columns as tests and metadata are added
  expect_equal(ncol(dat_all_qc), 17)

})
