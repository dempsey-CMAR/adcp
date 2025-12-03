#' @importFrom dplyr anti_join bind_rows

path <- system.file("testdata", package = "adcp")

# tidal bin height --------------------------------------------------------

dat_bh <- readRDS(paste0(path, "/current_test_data_tidal_bin_height.RDS"))

dat_bh <- dat_bh %>%
  adcp_test_tidal_bin_height(
    inst_alt_m = 0.6,
    bin_height_m = 1,
    beam_angle = 20
  ) %>%
  adcp_pivot_flags_longer(qc_tests = "tidal_bin_height")

bh_4 <- dat_bh %>%
  filter(bin_height_above_sea_floor_m == 10.61)

bh_3 <- dat_bh %>%
  filter(bin_height_above_sea_floor_m == 9.61)

bh_1 <- dat_bh %>%
  filter(bin_height_above_sea_floor_m == 8.61)


# grossrange test ---------------------------------------------------------

dat_gr <- readRDS(paste0(path, "/current_test_data_grossrange.RDS"))

dat_gr <- dat_gr %>%
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


# rolling_sd --------------------------------------------------------------
dat_rolling_sd <- readRDS(paste0(path, "/current_test_data_rolling_sd.RDS")) %>%
  adcp_test_rolling_sd(county = "Yarmouth") %>%
  adcp_pivot_flags_longer(qc_tests = "rolling_sd")

rolling_sd_3 <- dat_rolling_sd %>%
  filter(
    variable == "sea_water_speed_m_s",
    timestamp_utc >= as_datetime("2023-01-02 21:20:00"),
    timestamp_utc <= as_datetime("2023-01-04 04:10:00")
  ) %>%
  dplyr::bind_rows(
    dat_rolling_sd %>%
      filter(
        variable == "sea_water_to_direction_degree",
        timestamp_utc >= as_datetime("2023-01-02 23:00:00"),
        timestamp_utc <= as_datetime("2023-01-04 03:20:00")
      )
  ) %>%
  dplyr::bind_rows(
    dat_rolling_sd %>%
      filter(
        variable == "sensor_depth_below_surface_m" &
          (timestamp_utc >= as_datetime("2023-01-02 20:50:00") &
             timestamp_utc <= as_datetime("2023-01-04 04:30:00"))
      )
  )


rolling_sd_2 <- dat_rolling_sd %>%
  filter(
    timestamp_utc <= as_datetime("2023-01-01 17:40:00") |
      timestamp_utc >= as_datetime("2023-01-07 06:10:00")
  )

rolling_sd_1 <- dat_rolling_sd %>%
  dplyr::anti_join(
    rolling_sd_3,
    by = dplyr::join_by(
      timestamp_utc, day_utc, variable, value, rolling_sd_flag_value
    )
  ) %>%
  dplyr::anti_join(
    rolling_sd_2,
    by = dplyr::join_by(
      timestamp_utc, day_utc, variable, value, rolling_sd_flag_value
    )
  )


# spike -------------------------------------------------------------------

dat_spike <- readRDS(paste0(path, "/current_test_data_spike.RDS")) %>%
  adcp_test_spike(county = "Yarmouth") %>%
  adcp_pivot_flags_longer(qc_tests = "spike")

spike_2 <- dat_spike %>%
  group_by(variable, bin_height_above_sea_floor_m) %>%
  filter(row_number() == 1 | row_number() == n())

spike_3 <- dat_spike %>%
  filter(
    (day_utc == 3 & hour_utc == 0) |
      (day_utc == 3 & hour_utc == 12) |
      (day_utc == 4 & hour_utc == 23) |
      (day_utc == 5 & hour_utc == 1) |
      (day_utc == 5 & hour_utc == 11) |
      (day_utc == 5 & hour_utc == 13)
  )

spike_4 <- dat_spike %>%
  filter(
    (day_utc == 5 & hour_utc == 0) |
      (day_utc == 5 & hour_utc == 12)
  )

spike_1 <- dat_spike %>%
  dplyr::anti_join(
    spike_2,
    by = dplyr::join_by(
      timestamp_utc, day_utc, variable, value, spike_flag_value
    )
  ) %>%
  dplyr::anti_join(
    spike_3,
    by = dplyr::join_by(
      timestamp_utc, day_utc, variable, value, spike_flag_value
    )
  ) %>%
  dplyr::anti_join(
    spike_4,
    by = dplyr::join_by(
      timestamp_utc, day_utc, variable, value, spike_flag_value
    ))

# adcp_test_all -------------------------------------------------------------

dat_all <- dat_rolling_sd %>%
  select(-c(rolling_sd_flag_value, day_utc)) %>%
  pivot_wider(values_from = "value", names_from = "variable")

dat_all_qc <- dat_all %>%
  adcp_test_all(county = "Yarmouth")


# Assign max flag ---------------------------------------------------------

dat_max_flag <- data.frame(
  timestamp_utc = c("a", "b", "c", "d", "e"),
  variable = "sea_water_speed_m_s",
  value = round(c(runif(5)), digits = 2),
  grossrange_flag_value = c(1, 0, 2, 3, 1),
  rolling_sd_flag_value = c(0, 2, 1, 3, 1),
  tidal_bin_height_flag_value = c(1, 1, 3, 4, 4)
) %>%
  adcp_assign_max_flag()

# trim depth --------------------------------------------------------------

# export dat_qc from wv_test_Data_grossrange
dat_trim <- readRDS(paste0(path, "/current_test_data_grossrange.RDS")) %>%
  adcp_start_end_obs_to_trim(return_depth_diff = TRUE) %>%
  arrange(bin_height_above_sea_floor_m, timestamp_utc)

# p <- ggplot(dat_trim, aes(timestamp_utc, sensor_depth_below_surface_m, col = trim_obs)) +
#   geom_point() +
#   facet_wrap(~bin_height_above_sea_floor_m, ncol = 1)
#
# ggplotly(p)

dat_trim_4 <- dat_trim %>%
  group_by(bin_height_above_sea_floor_m) %>%
  dplyr::filter(row_number() %in% c(1, 2, n() - 1, n() - 2,  n())) %>%
  ungroup()

dat_trim_2 <- dat_trim %>%
  dplyr::anti_join(
    dat_trim_4,
    by = join_by(
      timestamp_utc, bin_depth_below_surface_m,
      bin_height_above_sea_floor_m, county, day_utc,
      sensor_depth_below_surface_m,
      sea_water_speed_m_s, sea_water_to_direction_degree, depth_diff, trim_obs)
  )


# adcp_label_intervals ----------------------------------------------------

# check edge cases
# 0 and 3 are both in the [0, 3] bin
# all other bins are only right inclusive; 9 is in the (6, 9] bin)
df_speed <- data.frame(
  sea_water_speed_cm_s = c(0, 3, 9, 10, 15, 20, 30)
) %>%
  adcp_label_speed(n_ints = 10)


df_direction <- data.frame(
  sea_water_to_direction_degree = c(
    0, 45, 90, 135, 180, 225, 270, 315, 360, # cardinal directions
    22.5, 67.5, 112.5, 247.5, 337.5,         # edge cases - right inclusive
    -10, 775)                                # NA
) %>%
  adcp_label_direction()





