
path <- system.file("testdata", package = "adcp")


# grossrange test ---------------------------------------------------------

dat <- readRDS(paste0(path, "/current_test_data_grossrange.RDS"))

dat_gr <- dat %>%
  adcp_test_grossrange(county = "Yarmouth") %>%
  adcp_pivot_flags_longer(qc_tests = "grossrange")

p <- adcp_plot_flags(dat_gr, qc_tests = "grossrange",  n_col = 2)

gr_4 <- dat_gr %>%
  filter(day_utc %in% c(4, 6))

# the direction variables cannot have flag of 3, since gr_max = user_max
# and gr_min = user_min
gr_3 <- dat_gr %>%
  filter(day_utc == 2 & !str_detect(variable, "direction"))

gr_1 <- dat_gr %>%
  dplyr::anti_join(
    gr_4,
    by = dplyr::join_by(
      timestamp_utc, day_utc, variable, value, grossrange_flag_value
    )
  ) %>%
  dplyr::anti_join(
    gr_3,
    by = dplyr::join_by(
      timestamp_utc, day_utc, variable, value, grossrange_flag_value
    ))
