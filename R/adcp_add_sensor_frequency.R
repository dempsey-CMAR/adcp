#' Add column of ADCP frequency
#'
#' @param dat Data frame including column \code{sensor_model} with entries
#'   "Sentinel_V20", "Sentinel_V50", "Sentinel_V100", and "Workhorse Sentinel
#'   600kHz".
#'
#' @return Returns dat with additional column adcp_frequency_khz.
#'
#' @importFrom dplyr case_when mutate
#' @export

adcp_add_sensor_frequency <- function(dat) {

  dat %>%
    mutate(
      adcp_frequency_khz = case_when(
        sensor_model == "Sentinel_V20" ~ 1000,
        sensor_model == "Sentinel_V50" ~ 500,
        sensor_model == "Sentinel_V100" ~ 300,
        sensor_model == "Workhorse Sentinel 600kHz" ~ 600,
        TRUE ~ NA
      )
    )
}
