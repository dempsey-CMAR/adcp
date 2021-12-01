#' Convert ADCP data from raw format to Open Data Portal format
#'
#'
#' @param dat_wide Dataframe of ADCP data, as returned from
#'   \code{adcp_read_txt()} or \code{adcp_assign_alt()}.

#' @param rm_NA Logical argument. If \code{rm_NA = TRUE}, rows where \code{SPEED}
#'   is \code{NA} OR \code{DIRECTION} is \code{NA} will be removed.
#'
#' @return Returns data in a long format, with columns:
#'
#' @importFrom dplyr all_of filter left_join mutate rename select
#' @importFrom tidyr pivot_longer pivot_wider
#'
#' @export


adcp_format_opendata <- function(dat_wide, rm_NA = TRUE){

  index <- find_index(dat_wide)

  sensor_depth <- dat_wide %>%
    filter(VARIABLE == "SensorDepth") %>%
    select(TIMESTAMP, SENSOR_DEPTH = all_of(index))

  dat <- dat_wide %>%
    filter(VARIABLE != "SensorDepth") %>%
    select(-Num) %>%
    # use index - 1 because dropped the Num column
    pivot_longer(cols = (all_of(index)-1):last_col(),
                 names_to = "BIN_ALTITUDE", values_to = "VALUE") %>%
    pivot_wider(names_from = "VARIABLE", values_from = VALUE) %>%
    left_join(sensor_depth, by = "TIMESTAMP") %>%
    rename(SPEED = WaterSpeed, DIRECTION = WaterDirection)

  if(suppressWarnings(!is.na(as.numeric(dat$BIN_ALTITUDE[1])))) {

    dat <- dat %>%
      mutate(BIN_ALTITUDE = as.numeric(BIN_ALTITUDE))

  }

  if(rm_NA) dat <- filter(dat, !is.na(SPEED) | !is.na(DIRECTION))

  dat

}
