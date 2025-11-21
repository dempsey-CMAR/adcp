# November 20, 2025

# Simulate data for the rolling standard deviation test

# Day 3: Rolling Standard Deviation 3 (high)

library(dplyr)
library(here)
library(lubridate)
library(purrr)
library(tidyr)

# Raw data ----------------------------------------------------------------
path <- here("inst/testdata")

tracking <- adcp_read_tracking() %>%
  filter(depl_id == "YR009")

stats <- adcp_read_txt(path, "2022-09-29_western_shoal.txt")%>%
  adcp_assign_altitude(tracking)%>%
  adcp_correct_timestamp() %>%
  adcp_pivot_bin_height() %>%
  adcp_calculate_bin_depth(tracking) %>%
  filter(bin_height_above_sea_floor_m == 2.61) %>%
  adcp_pivot_vars_longer() %>%
  group_by(variable) %>%
  summarise(mean = round(mean(value), digits = 3))


roll_sd <- current_thresholds %>%
  filter(county == "Yarmouth" | is.na(county), threshold == "rolling_sd_max") %>%
  select(variable, threshold_value)

vars <- unique(roll_sd$variable)

# simulate data
timestamp_utc = seq(
  as_datetime("2023-01-01 12:00:00"), as_datetime("2023-01-07 12:00:00"),
  by = paste0(10, " mins")
)

dat <- expand.grid(
  variable = vars, timestamp_utc = timestamp_utc,
  bin_height_above_sea_floor_m = 2.61
) %>%
  left_join(roll_sd, by = "variable") %>%
  mutate(day_utc = day(timestamp_utc))

attr(dat, "out.attrs") <- NULL

dat_test <- list()

for (i in seq_along(vars)) {

  var_i <- vars[i]
  sd_i <- roll_sd[which(roll_sd$variable == var_i), ]$threshold_value
  mean_i <- stats[which(stats$variable == var_i),]$mean

  dat_i <- dat %>% filter(variable == var_i)

  set.seed(726)
  vals_1 <- abs(rnorm(nrow(dat_i), mean = mean_i, sd = sd_i / 5))
  vals_3 <- abs(
    rnorm(nrow(filter(dat_i, day_utc == 3)), mean = mean_i, sd = 3 * sd_i)
  )

  dat_i <- dat_i %>%
    mutate(value = vals_1)

  dat_i[which(dat_i$day_utc == 3), "value"] <- vals_3

  dat_test[[i]] <- dat_i
}

dat_sd <- map_df(dat_test, .f = bind_rows) %>%
  select(-threshold_value) %>%
  pivot_wider(names_from = "variable", values_from = "value") %>%
  mutate(
    county = "Yarmouth",
    station = "Western Shoal",
    deployment_id = "YR001"
  ) %>%
  select(county, station, deployment_id, everything())

# ggplot(dat_sd, aes(timestamp_utc, sea_water_speed_m_s)) +
#   geom_point() +
#   facet_wrap(~bin_height_above_sea_floor_m)
#

dat_qc <- dat_sd %>%
  adcp_test_rolling_sd(county = "Yarmouth", period_hours = 12) %>%
  adcp_pivot_flags_longer(qc_tests = "rolling_sd")

p <- adcp_plot_flags(dat_qc, qc_tests = "rolling_sd")
ggplotly(p$rolling_sd)





# Export rds file
saveRDS(dat_sd, file = here("inst/testdata/current_test_data_rolling_sd.RDS"))
