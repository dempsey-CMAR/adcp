
library(adcp)
library(dplyr)
library(lubridate)

path <- system.file("testdata", package = "adcp")

dat <- adcp_read_txt(path, "2019-01-17_Long_Beach.txt")

# timestamp -------------------------------------------------------------------

test_that("adcp_read_txt() exports timestamp as a datetime object in UTC", {

  expect_equal(class(dat$timestamp_ns), c("POSIXct", "POSIXt"))

  expect_equal(tz(dat$timestamp_ns), "UTC")

})


ts1 <- data.frame(timestamp_ns = seq(as_datetime("2021-03-13 19:00:00"),
          as_datetime("2021-03-14 12:00:00"),
          by = "15 mins"))

ts2 <- data.frame(timestamp_ns = seq(as_datetime("2021-11-06 19:00:00"),
                                  as_datetime("2021-11-07 12:00:00"),
                                  by = "15 mins"))

ts1_corrected <- adcp_correct_timestamp(ts1)
ts2_corrected <- adcp_correct_timestamp(ts2)


test_that("adcp_correct_timestamp() works for daylight savings transitions", {

  expect_equal(tz(ts1_corrected$timestamp_utc), "UTC")

  expect_equal(
    unique(as.numeric(difftime(ts1_corrected$timestamp_utc, ts1$timestamp))), 4
  )

  # check that March 14 at 02:00 was not converted to NA for "spring forward"
  expect_equal(
    sum(is.na(ts1_corrected$timestamp_utc)), 0
  )

  expect_equal(tz(ts2_corrected$timestamp_utc), "UTC")

  expect_equal(
    unique(as.numeric(difftime(ts2_corrected$timestamp_utc, ts2$timestamp))), 3
  )

  # check that no times are repeated for "fall back"
  expect_equal(
    sum(duplicated(ts2_corrected$timestamp_utc)), 0
  )

})


# Altitude (Bin height above sea floor) ----------------------------------------------------------------

metadata <- tibble(Inst_Altitude = 0.5,
                   Bin_Size = 1,
                   First_Bin_Range = 1)

dat_alt <- adcp_assign_altitude(dat, metadata)

test_that("adcp_assign_altitude() returns expected results" ,{

  expect_equal(dim(dat), dim(dat_alt))
  expect_equal(colnames(dat_alt)[4:35], as.character(seq(1.5, 32.5, 1)))

})


# Format ------------------------------------------------------------------

dat_long <- dat_alt %>%
  adcp_correct_timestamp() %>%
  adcp_pivot_longer()

test_that("adcp_pivot_longer() returns correct columns and classes", {

  expect_equal(class(dat_long$timestamp_utc), c("POSIXct", "POSIXt"))
  expect_equal(class(dat_long$bin_height_above_sea_floor_m), "numeric")
  expect_equal(class(dat_long$sea_water_speed_m_s), "numeric")
  expect_equal(class(dat_long$sea_water_to_direction_degree), "numeric")
  expect_equal(class(dat_long$sensor_depth_below_surface_m), "numeric")

})


# bin depth calculation ---------------------------------------------------

dat_od <- dat_long %>%
  adcp_calculate_bin_depth(metadata = metadata)

test_that("adcp_calculate_bin_depth() calculates expected bin depth", {

  expect_equal(class(dat_od$bin_depth_below_surface_m), "numeric")
  expect_equal(
    dat_od$sensor_depth_below_surface_m,
    dat_od$bin_depth_below_surface_m +
      dat_od$bin_height_above_sea_floor_m -
      metadata$Inst_Altitude
  )

})


# sensor depth ------------------------------------------------------------

dat_od_depth <- distinct(dat_od, timestamp_utc, sensor_depth_below_surface_m)

dat_depth <- dat %>%
  adcp_correct_timestamp() %>%
  filter(variable == "SensorDepth") %>%
  select(timestamp_utc, sensor_depth_below_surface_m = V8) %>%
  # trim to start of deployment
  filter(sensor_depth_below_surface_m > 10)

test_that("adcp_pivot_longer() returns expected sensor_depth_below_surface_m",{

  expect_equal(dat_od_depth, tibble(dat_depth))

})


# Flags -------------------------------------------------------------------

dat_flag <- adcp_flag_data(dat_od)
n_row <- nrow(dat_flag)

flag <- unique(
  dat_flag[
    which(dat_flag$timestamp_utc == min(dat_flag$timestamp_utc)), "depth_flag"
  ]
)

good <- unique(
  dat_flag[
    -which(dat_flag$timestamp_utc == min(dat_flag$timestamp_utc)), "depth_flag"
  ]
)

test_that("adcp_flag_data() flags correct observations", {

  expect_equal(as.character(flag$depth_flag), "sensor_depth_below_surface_m changed by > 1 m")
  expect_equal(as.character(good$depth_flag), "good")

})

