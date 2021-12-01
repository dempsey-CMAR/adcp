
library(adcp)
library(dplyr)
library(lubridate)

path <- system.file("testdata", package = "adcp")

dat <- adcp_read_txt(path, "2019-01-17_Long_Beach.txt")

# TIMESTAMP -------------------------------------------------------------------

test_that("adcp_read_txt() exports TIMESTAMP as a datetime object in UTC", {

  expect_equal(class(dat$TIMESTAMP), c("POSIXct", "POSIXt"))

  expect_equal(tz(dat$TIMESTAMP), "UTC")

})


ts1 <- data.frame(TIMESTAMP = seq(as_datetime("2021-03-13 19:00:00"),
          as_datetime("2021-03-14 12:00:00"),
          by = "15 mins"))

ts2 <- data.frame(TIMESTAMP = seq(as_datetime("2021-11-06 19:00:00"),
                                  as_datetime("2021-11-07 12:00:00"),
                                  by = "15 mins"))

ts1_corrected <- adcp_correct_timestamp(ts1)
ts2_corrected <- adcp_correct_timestamp(ts2)


test_that("adcp_correct_timestamp() works for daylight savings transitions", {

  expect_equal(tz(ts1_corrected$TIMESTAMP), "UTC")

  expect_equal(
    unique(as.numeric(difftime(ts1_corrected$TIMESTAMP, ts1$TIMESTAMP))), 4
  )

  # check that March 14 at 02:00 was not converted to NA for "spring forward"
  expect_equal(
    sum(is.na(ts1_corrected$TIMESTAMP)), 0
  )

  expect_equal(tz(ts2_corrected$TIMESTAMP), "UTC")

  expect_equal(
    unique(as.numeric(difftime(ts2_corrected$TIMESTAMP, ts2$TIMESTAMP))), 3
  )

  # check that no times are repeated for "fall back"
  expect_equal(
    sum(duplicated(ts2_corrected$TIMESTAMP)), 0
  )

})


# Altitude ----------------------------------------------------------------

metadata <- tibble(Inst_Altitude = 0.5,
                   Bin_Size = 1,
                   First_Bin_Range = 1)

dat_alt <- adcp_assign_altitude( dat, metadata)

test_that("adcp_assign_altitude() returns expected results" ,{

  expect_equal(dim(dat), dim(dat_alt))
  expect_equal(colnames(dat_alt)[4:35], as.character(seq(1.5, 32.5, 1)))

})


# Format ------------------------------------------------------------------

dat_od <- adcp_format_opendata(dat_alt)

test_that("adcp_format", {

  expect_equal(class(dat_od$TIMESTAMP), c("POSIXct", "POSIXt"))
  expect_equal(class(dat_od$BIN_ALTITUDE), "numeric")
  expect_equal(class(dat_od$SPEED), "numeric")
  expect_equal(class(dat_od$DIRECTION), "numeric")
  expect_equal(class(dat_od$SENSOR_DEPTH), "numeric")

})


dat_od_depth <- distinct(dat_od, TIMESTAMP, SENSOR_DEPTH)

dat_depth <- dat %>%
  filter(VARIABLE == "SensorDepth") %>%
  select(TIMESTAMP, SENSOR_DEPTH = V8) %>%
  filter(SENSOR_DEPTH > 10)

test_that("adcp_format_opendata() returns expected SENSOR_DEPTH",{

  expect_equal(dat_od_depth, tibble(dat_depth))

})


# Flags -------------------------------------------------------------------

dat_flag <- adcp_flag_data(dat_od)
n_row <- nrow(dat_flag)

flag <- unique(dat_flag[which(dat_flag$TIMESTAMP == min(dat_flag$TIMESTAMP)), "FLAG"])
good <- unique(dat_flag[-which(dat_flag$TIMESTAMP == min(dat_flag$TIMESTAMP)), "FLAG"])

test_that("adcp_flag_data() flags correct observations", {

  expect_equal(as.character(flag$FLAG), "SENSOR_DEPTH changed by > 1 m")
  expect_equal(as.character(good$FLAG), "good")

})

