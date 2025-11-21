# November 19, 2025

# Simulate data for the gross range test
# Gross Range Flag 3 (low) - does not exist because user_min = gr_min
# Day 2: Gross Range Flag 3 (high)*
# Day 4: Gross Range Flag 4 (low)
# Day 6: Gross Range Flag 4 (high)

library(dplyr)
library(ggplot2)
library(lubridate)
library(here)
library(stringr)
library(tidyr)

# Raw data ----------------------------------------------------------------
path <- here("inst/testdata")

tracking <- adcp_read_tracking() %>%
  filter(depl_id == "YR009")

dat_raw <- adcp_read_txt(path, "2022-09-29_western_shoal.txt")%>%
  adcp_assign_altitude(tracking)%>%
  adcp_correct_timestamp() %>%
  adcp_pivot_bin_height() %>%
  adcp_calculate_bin_depth(tracking) %>%
  filter(
    row_number() %% 10 == 0,
    bin_height_above_sea_floor_m %in% c(2.61, 3.61),
    timestamp_utc >= as_datetime("2022-10-01"),
    timestamp_utc <= as_datetime("2022-10-07")
  ) %>%
  mutate(county = "Yarmouth")

ggplot(dat_raw, aes(timestamp_utc, sea_water_speed_m_s)) +
  geom_point() +
  facet_wrap(~bin_height_above_sea_floor_m, ncol = 1)

# for the sensor_depth_to_trim test
dat_raw[1, "sensor_depth_below_surface_m"] <- 14.1
dat_raw[2, "sensor_depth_below_surface_m"] <- 13
dat_raw[nrow(dat_raw) - 1, "sensor_depth_below_surface_m"] <- 13.5
dat_raw[nrow(dat_raw), "sensor_depth_below_surface_m"] <- 15

dat_raw <- dat_raw %>%
  adcp_pivot_vars_longer()

dat <- dat_raw %>%
  mutate(
    day_utc = day(timestamp_utc),
    value = case_when(
      day_utc == 2 & variable == "sea_water_speed_m_s" ~ 1,
      #day_utc == 3 & variable ==  "sea_water_to_direction_degree" ~ -1,
      day_utc == 2 & variable ==  "sensor_depth_below_surface_m" ~ 30,

      # these ones should be flagged 4
      day_utc == 4 & variable == "sea_water_speed_m_s" ~ -0.1,
      day_utc == 4 & variable ==  "sea_water_to_direction_degree" ~ -1,
      day_utc == 4 & variable ==  "sensor_depth_below_surface_m" ~ -1,

      # these ones should be flagged 4
      day_utc == 6 & variable == "sea_water_speed_m_s" ~ 5.1,
      day_utc == 6 & variable ==  "sea_water_to_direction_degree" ~ 361,
      day_utc == 6 & variable ==  "sensor_depth_below_surface_m" ~ 65,

      TRUE ~ value
    )
  ) %>%
  pivot_wider(names_from = variable, values_from = value)

dat_qc <- dat %>%
  adcp_test_grossrange(county = "Yarmouth") %>%
  adcp_pivot_flags_longer(qc_tests = "grossrange")

adcp_plot_flags(dat_qc, qc_tests = "grossrange")

# Export rds file
#saveRDS(dat, file = here("inst/testdata/current_test_data_grossrange.RDS"))

