#' Convert timestamp to UTC from AST or DST
#'
#' @details For the raw ADCP data: the \code{TIMESTAMP} column is in the
#'   timezone of the deployment date (e.g., "AST" if deployed in November to
#'   March and "DST" if deployed in March to November). The \code{TIMESTAMP}
#'   does NOT account for changes in daylight savings time.
#'
#'   \code{adcp_read_text()} assigns the \code{TIMESTAMP} a timezone of "UTC" to
#'   avoid \code{NA} values during the beginning of daylight savings time (e.g.,
#'   2019-03-10 02:30:00 is NOT a valid time for the "America/Halifax"
#'   timezone).
#'
#'   \code{adcp_correct_timestamp()} converts each \code{TIMESTAMP} to true UTC
#'   by adding 3 hours if the deployment date was during daylight savings, or 4
#'   hours if the deployment date was during Atlantic Standard Time.
#'
#'   This \code{TIMESTAMP} can be converted to true UTC using
#'   \code{adcp_correct_timestamp()}.

#' @param dat Dataframe with at least one column \code{TIMESTAMP} (long or wide
#'   format).
#'
#' @return Returns \code{dat} with \code{TIMESTAMP} in true UTC.
#'
#' @importFrom lubridate as_datetime dst force_tz hours
#' @importFrom dplyr everything mutate select
#'
#' @export


adcp_correct_timestamp <- function(dat){

  # determine whether instrument was deployed during DST
  DST <- dst(force_tz(min(dat$TIMESTAMP), tzone = "America/Halifax"))

  if(DST) UTC_corr <- hours(3)
  if(!DST) UTC_corr <- hours(4)

  dat %>%
    mutate(TIMESTAMP = TIMESTAMP + UTC_corr,
           TIMESTAMP = force_tz(TIMESTAMP, tzone = "UTC")) %>%
    select(TIMESTAMP, everything())

}
