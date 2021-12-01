#' Convert ADCP data from raw format to Open Data Portal format
#'
#'
#' @param dat Output from  \code{adcp_read_txt()} or \code{adcp_assign_alt()}.

#' @param rm_NA Logical argument. If \code{rm_NA = TRUE}, rows where \code{SPEED}
#'   is \code{NA} OR \code{DIRECTION} is \code{NA} will be removed.
#'
#' @return Fill this in
#'
#' @importFrom dplyr all_of filter left_join mutate rename select
#' @importFrom tidyr pivot_longer pivot_wider
#'
#' @export


adcp_format_opendata <- function(dat, rm_NA = TRUE){

  index <- find_index(dat)

  sensor_depth <- dat %>%
    filter(VARIABLE == "SensorDepth") %>%
    select(TIMESTAMP, SENSOR_DEPTH = all_of(index))

  dat <- dat %>%
    filter(VARIABLE != "SensorDepth") %>%
    select(-Num) %>%
    pivot_longer(cols = (all_of(index)-1):last_col(),
                 names_to = "BIN_ALTITUDE", values_to = "VALUE") %>%
    pivot_wider(names_from = "VARIABLE", values_from = VALUE) %>%
    left_join(sensor_depth, by = "TIMESTAMP") %>%
    rename(SPEED = WaterSpeed, DIRECTION = WaterDirection)
   # mutate(TIMESTAMP = as.character(TIMESTAMP))

  if(suppressWarnings(!is.na(as.numeric(dat$BIN_ALTITUDE[1])))) {

    dat <- dat %>%
      mutate(BIN_ALTITUDE = as.numeric(BIN_ALTITUDE))

  }

  if(rm_NA) dat <- filter(dat, !is.na(SPEED) & !is.na(DIRECTION))

  dat

}
