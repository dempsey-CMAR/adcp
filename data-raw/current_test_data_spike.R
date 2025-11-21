# November 20, 2025

# Simulate data for the Spike test

# Day 2: Spike Flag 3 (low)
# Day 3: Spike Flag 3 (high)
# Day 15: Spike Flag 4 (low)
# Day 27: Spike Flag 4 (high)

library(dplyr)
library(lubridate)
library(here)
library(tidyr)

# Raw data ----------------------------------------------------------------

# Raw data ----------------------------------------------------------------
path <- here("inst/testdata")

stats <- readRDS(paste0(path, "/current_test_data_grossrange.RDS")) %>%
  adcp_test_grossrange(county = "Yarmouth") %>%
  adcp_pivot_flags_longer(qc_tests = "grossrange") %>%
  filter(grossrange_flag_value != 4) %>%
  group_by(variable) %>%
  summarise(mean = round(mean(value), digits = 3)) %>%
  ungroup()

spike <- current_thresholds %>%
  filter(county == "Yarmouth" | is.na(county), qc_test == "spike") %>%
  select(-c(qc_test, county)) %>%
  pivot_wider(values_from = "threshold_value", names_from = "threshold")

vars <- unique(spike$variable)

# simulate data
timestamp_utc = seq(
  as_datetime("2023-01-01 12:00:00"), as_datetime("2023-01-07 12:00:00"),
  by = paste0(60, " mins")
)

dat <- expand.grid(
  variable = vars,
  timestamp_utc = timestamp_utc,
  bin_height_above_sea_floor_m = c(2.61, 3.61)
  ) %>%
  left_join(spike, by = "variable") %>%
  left_join(stats, by = "variable") %>%
  rename(value = mean) %>%
  group_by(variable, bin_height_above_sea_floor_m) %>%
  dplyr::arrange(timestamp_utc, .by_group = TRUE) %>%
  mutate(
    county = "Yarmouth",
    station = "Cross Island",
    deployment_id = "YR001",
    day_utc = day(timestamp_utc),
    hour_utc = hour(timestamp_utc),

    lag_value = lag(value),
    lead_value = lead(value),
    spike_ref = abs((lag_value + lead_value) / 2),

    value = case_when(
      day_utc == 3 & hour_utc == 0 ~ spike_ref - 1.1 * spike_low,
      day_utc == 3 & hour_utc == 12 ~ spike_ref + 1.1 * spike_low,

      day_utc == 5 & hour_utc == 0 ~ spike_ref - 1.1 * spike_high,
      day_utc == 5 & hour_utc == 12 ~ spike_ref + 1.1 * spike_high,
      TRUE ~ value
    )
  ) %>%
  ungroup() %>%
  select(
    county, station, deployment_id, timestamp_utc, day_utc, hour_utc,
    variable, bin_height_above_sea_floor_m, value
  ) %>%
  pivot_wider(values_from = "value", names_from = "variable")

# ggplot(dat, aes(timestamp_utc, sea_water_speed_m_s)) +
#   geom_point() +
#   facet_wrap(~bin_height_above_sea_floor_m)
#
dat_qc <- dat %>%
  adcp_test_spike(county = "Yarmouth") %>%
  adcp_pivot_flags_longer(qc_test = "spike")

p <- dat_qc %>%
  filter(variable == "sea_water_speed_m_s") %>%
  adcp_plot_flags(qc_tests = "spike")


ggplotly(p$spike)

# Export rds file
saveRDS(dat, file = here("inst/testdata/current_test_data_spike.RDS"))



