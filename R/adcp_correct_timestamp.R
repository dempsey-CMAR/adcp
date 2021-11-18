#' Convert timestamp to UTC from AST or DST
#'
#' @param dat Dataframe with at least one column \code{TIMESTAMP_NS}.
#'
#' @return Returns \code{dat} with \code{TIMESTAMP} in UTC.
#'
#' @importFrom lubridate as_datetime dst force_tz hours
#' @importFrom dplyr everything mutate select
#'
#' @export


adcp_correct_timestamp <- function(dat){

  dat <- dat %>%
    mutate(TIMESTAMP_NS = as_datetime(TIMESTAMP_NS),
           TIMESTAMP_NS = force_tz(TIMESTAMP_NS, tzone = "America/Halifax"))

  # determine whether instrument was deployed during DST
  DST <- dst(min(dat$TIMESTAMP_NS))

  if(DST) UTC_corr <-  hours(3)
  if(!DST) UTC_corr <-  hours(4)

  dat %>%
    mutate(TIMESTAMP = TIMESTAMP_NS + UTC_corr) %>%
    select(-TIMESTAMP_NS) %>%
    select(TIMESTAMP, everything())

}
