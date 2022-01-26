#' Flag ensembles with suspect SENSOR_DEPTH_BELOW_SURFACE recordings
#'
#' @param dat Dataframe of ACDP data in long format, as returned by
#'   \code{adcp_format_opendata()}.
#'
#' @param depth_flag The change in \code{SENSOR_DEPTH_BELOW_SURFACE} that will trigger a flag
#'   (in metres).
#'
#' @return Returns dat with two extra columns for inspection: \code{DIFF} =
#'   lead(SENSOR_DEPTH_BELOW_SURFACE) - SENSOR_DEPTH_BELOW_SURFACE and \code{FLAG}.
#'
#' @importFrom glue glue
#' @importFrom dplyr case_when distinct lag lead left_join mutate
#'
#' @export


adcp_flag_data <- function(dat, depth_flag = 1) {

  flag_message <- glue("SENSOR_DEPTH_BELOW_SURFACE changed by > {depth_flag} m")

  sensor_depth <- dat %>%
    select(TIMESTAMP, SENSOR_DEPTH_BELOW_SURFACE) %>%
    distinct() %>%
    mutate(
      DIFF = lead(SENSOR_DEPTH_BELOW_SURFACE) - SENSOR_DEPTH_BELOW_SURFACE,
      FLAG = case_when(
        DIFF > depth_flag ~ flag_message,        # when sensor is being lowered
        lag(DIFF) < -depth_flag ~ flag_message,  # when sensor is being retrieved
        TRUE ~ "good"
      )
    )

  dat <- dat %>%
    left_join(sensor_depth, by = c("TIMESTAMP", "SENSOR_DEPTH_BELOW_SURFACE"))

  dat

}
