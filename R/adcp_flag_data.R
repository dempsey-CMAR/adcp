#' Flag ensembles with suspect SENSOR_DEPTH recordings
#'
#' @param dat The usual (formatted)
#'
#' @param depth_flag The change in \code{SENSOR_DEPTH} that will trigger a flag.
#'
#' @return Returns dat with two extra columns for inspection: \code{DIFF} =
#'   lead(SENSOR_DEPTH) - SENSOR_DEPTH and \code{FLAG}.
#'
#' @importFrom glue glue
#' @importFrom dplyr case_when distinct lag lead left_join mutate
#'
#' @export


adcp_flag_data <- function(dat, depth_flag = 1) {

  flag_message <- glue("SENSOR_DEPTH changed by > {depth_flag} m")

  sensor_depth <- dat %>%
    select(TIMESTAMP, SENSOR_DEPTH) %>%
    distinct() %>%
    mutate(
      DIFF = lead(SENSOR_DEPTH) - SENSOR_DEPTH,
      FLAG = case_when(
        DIFF > depth_flag ~ flag_message,
        lag(DIFF) < -depth_flag ~ flag_message,
        TRUE ~ "good"
      )
    )

  dat <- dat %>%
    left_join(sensor_depth, by = c("TIMESTAMP", "SENSOR_DEPTH"))

  dat

}
