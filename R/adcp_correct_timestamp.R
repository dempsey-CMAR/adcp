#' Convert timestamp to UTC from AST or DST
#'
#' @details For the raw ADCP data, the timestamp column is in the timezone of
#'   the deployment date (e.g., "AST" if deployed in November to March and "DST"
#'   if deployed in March to November). The timestamp does NOT account for
#'   changes in daylight savings time.
#'
#'   \code{adcp_read_text()} assigns the timestamp a timezone of "UTC" to avoid
#'   \code{NA} values during the beginning of daylight savings time (e.g.,
#'   2019-03-10 02:30:00 is NOT a valid time for the "America/Halifax"
#'   timezone).
#'
#'   \code{adcp_correct_timestamp()} converts each timestamp to true UTC by
#'   adding 3 hours if the deployment date was during daylight savings, or 4
#'   hours if the deployment date was during Atlantic Standard Time.
#'
#'   The earliest timestamp is used to define the original timezone (AST/DST).
#'
#' @param dat Data frame with at least one column \code{timestamp_ns} (long or
#'   wide format).
#'
#' @param rm Logical argument. If \code{TRUE} the original \code{timestamp_ns}
#'   column will be removed.
#'
#' @return Returns \code{dat} with \code{timestamp_utc} in true UTC.
#'
#' @importFrom lubridate as_datetime dst force_tz hours
#' @importFrom dplyr everything mutate select
#'
#' @export


adcp_correct_timestamp <- function(dat, rm = TRUE) {

  # determine whether instrument was deployed during DST
  DST <- dst(force_tz(min(dat$timestamp_ns), tzone = "America/Halifax"))

  if (isTRUE(DST)) UTC_corr <- hours(3)
  if (isFALSE(DST)) UTC_corr <- hours(4)

  dat <- dat %>%
    mutate(
      timestamp_utc = timestamp_ns + UTC_corr,
      timestamp_utc = force_tz(timestamp_utc, tzone = "UTC")
    ) %>%
    select(timestamp_utc, everything())

  if (isTRUE(rm)) dat <- dat %>% select(-timestamp_ns)

  dat
}
