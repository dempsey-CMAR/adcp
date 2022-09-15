#' Flag ensembles with suspect sensor_depth_below_surface_m recordings
#'
#' @param dat Dataframe of ACDP data in long format, as returned by
#'   \code{adcp_pivot_longer()}.
#'
#' @param depth_flag_threshold The change in \code{sensor_depth_below_surface_m}
#'   that will trigger a flag (in metres).
#'
#' @return Returns \code{dat} with two extra columns for inspection:
#'   \code{depth_diff} = lead(sensor_depth_below_surface_m) -
#'   sensor_depth_below_surface_m and \code{depth_flag}.
#'
#' @importFrom glue glue
#' @importFrom dplyr case_when distinct lag lead left_join mutate
#'
#' @export


adcp_flag_data <- function(dat, depth_flag_threshold = 1) {

  flag_message <- glue("sensor_depth_below_surface_m changed by > {depth_flag_threshold} m")

  sensor_depth <- dat %>%
    select(timestamp_utc, sensor_depth_below_surface_m) %>%
    distinct() %>%
    mutate(
      depth_diff = lead(sensor_depth_below_surface_m) - sensor_depth_below_surface_m,
      depth_flag = case_when(
        depth_diff > depth_flag_threshold ~ flag_message,        # when sensor is being lowered
        lag(depth_diff) < -depth_flag_threshold ~ flag_message,  # when sensor is being retrieved
        TRUE ~ "good"
      )
    )

  dat <- dat %>%
    left_join(sensor_depth, by = c("timestamp_utc", "sensor_depth_below_surface_m"))

  dat
}
