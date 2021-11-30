
library(adcp)
library(dplyr)
library(lubridate)

path <- system.file("testdata", package = "adcp")

path2 <-  system.file("testdata/2019-01-17_Long_Beach.txt", package = "adcp")


dat1 <- adcp_read_txt(path1, "2019-01-17_Long_Beach.txt")

# use default values for trim_NA and timestamp_utc (TRUE)
dat2 <- adcp_read_txt(path2)


# Tests -------------------------------------------------------------------

test_that("adcp_read_txt() exports TIMESTAMP as a datetime object", {

  expect_equal(class(dat1$TIMESTAMP_NS), c("POSIXct", "POSIXt"))
  expect_equal(class(dat2$TIMESTAMP), c("POSIXct", "POSIXt"))

})

test_that("adcp_read_txt() exports TIMESTAMP in correct timezone", {

  expect_equal(tz(dat1$TIMESTAMP_NS), "America/Halifax")
  expect_equal(tz(dat2$TIMESTAMP), "UTC")

})


DST <- dst(min(dat1$TIMESTAMP_NS))

if(DST) UTC_corr <- hours(3)
if(!DST) UTC_corr <- hours(4)

dat1_trim <- adcp_trim_NA_ensembles(dat1) %>%
  mutate(TIMESTAMP = TIMESTAMP_NS + UTC_corr,
         TIMESTAMP = as.character(TIMESTAMP)) %>%
  select(TIMESTAMP, everything(), -TIMESTAMP_NS)

test_that("adcp_correct_timestamp() returns corrected TIMESTAMP", {

expect_equal(dat1_trim$TIMESTAMP, as.character(dat2$TIMESTAMP))

})

















