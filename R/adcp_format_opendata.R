#' Convert ADCP data from raw format to Open Data Portal format
#'
#' @details Both the bin height above the bottom and bin depth below the surface
#'   are reported, where:
#'
#'   BIN_DEPTH_BELOW_SURFACE = SENSOR_DEPTH_BELOW_SURFACE -
#'   BIN_HEIGHT_ABOVE_SEAFLOOR
#'
#'   A warning is printed if any BIN_DEPTH_BELOW_SURFACE are negative.
#'
#' @param dat_wide Dataframe of ADCP data, as returned from
#'   \code{adcp_read_txt()} or \code{adcp_assign_alt()}.

#' @param rm_NA Logical argument. If \code{rm_NA = TRUE}, rows where
#'   \code{SPEED} is \code{NA} OR \code{DIRECTION} is \code{NA} will be removed.
#'
#' @return Returns data in a long format.
#'
#'   If \code{dat_wide} is from \code{adcp_read_txt()} (i.e., bin altitude has
#'   not been assigned), then the following columns are returned: TIMESTAMP,
#'   SENSOR_DEPTH_BELOW_SURFACE (SensorDepth), BIN_ID (the default column names
#'   when imported using read_adcp_txt; starts at V8), SPEED (WaterSpeed), and
#'   DIRECTION (WaterDirection).
#'
#'   If \code{dat_wide} is from \code{adcp_assign_altitude()}, then the
#'   following columns are returned: TIMESTAMP, SENSOR_DEPTH_BELOW_SURFACE
#'   (SensorDepth), BIN_DEPTH_BELOW_SURFACE, BIN_HEIGHT_ABOVE_SEAFLOOR, SPEED
#'   (WaterSpeed), and DIRECTION (WaterDirection).
#'
#' @importFrom dplyr all_of filter left_join mutate rename select
#' @importFrom tidyr pivot_longer pivot_wider
#'
#' @export


adcp_format_opendata <- function(dat_wide, rm_NA = TRUE){

  index <- find_index(dat_wide)

  sensor_depth <- dat_wide %>%
    filter(VARIABLE == "SensorDepth") %>%
    select(TIMESTAMP, SENSOR_DEPTH_BELOW_SURFACE = all_of(index))

  dat <- dat_wide %>%
    filter(VARIABLE != "SensorDepth") %>%
    select(-Num) %>%
    # use index - 1 because dropped the Num column
    pivot_longer(
      cols = (all_of(index)-1):last_col(),
      names_to = "BIN_ID", values_to = "VALUE"
    ) %>%
    pivot_wider(names_from = "VARIABLE", values_from = VALUE) %>%
    left_join(sensor_depth, by = "TIMESTAMP") %>%
    # in case want to use directly after adcp_read_txt()
    select(
      TIMESTAMP,
      SENSOR_DEPTH_BELOW_SURFACE,
      BIN_ID,
      SPEED = WaterSpeed,
      DIRECTION = WaterDirection
    )

  # in case want to use after adcp_assign_bin_height (preferred)
  if(suppressWarnings(!is.na(as.numeric(dat$BIN_ID[1])))) {

    dat <- dat %>%
      mutate(
        BIN_HEIGHT_ABOVE_SEAFLOOR = as.numeric(BIN_ID),
        BIN_DEPTH_BELOW_SURFACE = SENSOR_DEPTH_BELOW_SURFACE - BIN_HEIGHT_ABOVE_SEAFLOOR,
        BIN_DEPTH_CHECK = BIN_DEPTH_BELOW_SURFACE > 0
      ) %>%
      select(
        TIMESTAMP,
        SENSOR_DEPTH_BELOW_SURFACE,
        BIN_DEPTH_BELOW_SURFACE,
        BIN_HEIGHT_ABOVE_SEAFLOOR,
        SPEED,
        DIRECTION,
        BIN_DEPTH_CHECK
      )

    if(any(isFALSE(dat$BIN_DEPTH_CHECK))) {
      warning("Negative BIN_DEPTH_BELOW_SURFACE value(s) detected.")
    }

    dat <- dat %>% select(-BIN_DEPTH_CHECK)

  }

  if(rm_NA) dat <- filter(dat, !is.na(SPEED) | !is.na(DIRECTION))

  dat

}
