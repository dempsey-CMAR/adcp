#' Convert timestamp to UTC from AST or DST
#'
#' @param dat Dataframe with at least one column \code{TIMESTAMP}.
#'
#' @return Returns \code{dat} with \code{TIMESTAMP} in UTC.
#'
#' @importFrom lubridate as_datetime dst force_tz hours
#' @importFrom dplyr everything mutate select
#'
#' @export


adcp_correct_timestamp <- function(dat){

  # dat <- dat %>%
  #   mutate(TIMESTAMP_NS = as_datetime(TIMESTAMP_NS, tz = "America/Halifax"))

  # determine whether instrument was deployed during DST
  DST <- dst(force_tz(min(dat$TIMESTAMP), tzone = "America/Halifax"))

  if(DST) UTC_corr <- hours(3)
  if(!DST) UTC_corr <- hours(4)

  dat %>%
    mutate(TIMESTAMP = TIMESTAMP + UTC_corr,
           TIMESTAMP = force_tz(TIMESTAMP, tzone = "UTC")) %>%
    select(TIMESTAMP, everything())

}
