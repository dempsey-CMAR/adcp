#' Pivot ADCP data from bin height as column names to bin height as observations
#'
#' @param dat_wide Data frame of ADCP data, as returned from
#'   \code{adcp_read_txt()} or \code{adcp_assign_alt()}.

#' @param rm_NA Logical argument. If \code{rm_NA = TRUE}, rows where
#'   \code{sea_water_speed_m_s} is \code{NA} OR
#'   \code{sea_water_to_direction_degree} is \code{NA} will be removed.
#'
#' @return Returns data in a long format.
#'
#'   If \code{dat_wide} is from \code{adcp_read_txt()} (i.e., bin altitude has
#'   not been assigned), then the following columns are returned: timestamp_utc,
#'   sensor_depth_below_surface_m (SensorDepth), bin_id (the default column
#'   names when imported using read_adcp_txt; starts at V8), sea_water_speed_m_s
#'   (WaterSpeed), and sea_water_to_direction_degree (WaterDirection).
#'
#'   If \code{dat_wide} is from \code{adcp_assign_altitude()}, then the
#'   following columns are returned: timestamp_utc, sensor_depth_below_surface_m
#'   (SensorDepth), bin_depth_below_surface_m, bin_height_above_sea_floor_m,
#'   sea_water_speed_m_s (WaterSpeed), and sea_water_to_direction_degree
#'   (WaterDirection).
#'
#' @importFrom dplyr all_of filter left_join mutate rename select
#' @importFrom tidyr pivot_longer pivot_wider
#'
#' @export


adcp_pivot_longer <- function(dat_wide, rm_NA = TRUE) {

  # index of first data column
  index <- find_index(dat_wide)

  # name of the timestamp column (timestamp_utc or timestamp_ns)
  timestamp_colname <- dat_wide %>%
    select(contains("timestamp")) %>%
    colnames()

  # pull out sensor depth measurements because there are only entries in column all_of(index)
  sensor_depth <- dat_wide %>%
    filter(variable == "SensorDepth") %>%
    select(
      timestamp_foo = contains("timestamp"),
      sensor_depth_below_surface_m = all_of(index)
    )

  dat <- dat_wide %>%
    filter(variable != "SensorDepth") %>%
    rename(timestamp_foo = contains("timestamp")) %>%
    select(-Num) %>%
    # use index - 1 because dropped the Num column
    pivot_longer(
      cols = (all_of(index) - 1):last_col(),
      names_to = "bin_id", values_to = "value"
    ) %>%
    pivot_wider(names_from = "variable", values_from = value) %>%
    left_join(sensor_depth, by = "timestamp_foo") %>%
    select(
      timestamp_foo,
      sensor_depth_below_surface_m,
      bin_id,
      sea_water_speed_m_s = WaterSpeed,
      sea_water_to_direction_degree = WaterDirection
    )

  # in case want to use after adcp_assign_altitude (preferred)
  if (suppressWarnings(!is.na(as.numeric(dat$bin_id[1])))) {
    dat <- dat %>%
      mutate(bin_height_above_sea_floor_m = as.numeric(bin_id)) %>%
      select(
        timestamp_foo,
        sensor_depth_below_surface_m,
        bin_height_above_sea_floor_m,
        sea_water_speed_m_s,
        sea_water_to_direction_degree
      )
  }

  if (isTRUE(rm_NA)) {
    dat <- filter(
      dat, !(is.na(sea_water_speed_m_s) | is.na(sea_water_to_direction_degree))
    )
  }

  colnames(dat)[which(colnames(dat) == "timestamp_foo")] <- timestamp_colname

  dat
}


# # NA check
# x <- data.frame(
#   y = c(1, NA_integer_, 4, NA_integer_),
#   z = c(2, 3, NA_integer_, NA_integer_)
# )
#
# # removes removes rows where BOTH y and z are NA
# filter(x, !is.na(y) | !is.na(z))
#
# filter(x, !(is.na(y) & is.na(z)))
#
# # removes rows where either y OR z is NA
# filter(x, !(is.na(y) | is.na(z)))
#
# filter(x, !is.na(y) & !is.na(z))
