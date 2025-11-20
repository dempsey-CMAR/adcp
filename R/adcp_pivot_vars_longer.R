#' Pivot current data
#'
#' @param dat_wide Data frame of ADCP current data.
#'
#' @param vars Vector of character strings indicating which columns to pivot.
#'   Default is all variables.
#'
#' @return Returns data in a long format.
#'
#' @importFrom dplyr any_of
#' @importFrom tidyr pivot_longer
#'
#' @export

adcp_pivot_vars_longer <- function(dat_wide, vars = NULL) {

  if(is.null(vars)) {
    vars <- c(
      "sensor_depth_below_surface_m",
      "sea_water_speed_m_s",
      "sea_water_to_direction_degree"
    )
  }

  dat_wide %>%
    pivot_longer(
      cols = any_of(vars),
      names_to = "variable",
      values_to = "value",
      values_drop_na = TRUE
    )
}
