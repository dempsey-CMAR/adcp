#' Calculate the bin depth below the surface
#'
#' @details Bin depth below the surface is calculated as:
#'
#'   bin_depth_below_surface_m = sensor_depth_below_surface_m + inst_alt -
#'   bin_height_above_sea_floor_m
#'
#'   A warning is printed if any bin_depth_below_surface_m are negative.
#'
#' @param dat Data frame of ACDP data in long format, as returned by
#'   \code{adcp_pivot_longer()}.
#'
#' @param metadata Data frame with metadata information for the deployment in
#'   \code{dat} (e.g., a row from the NSDFA tracking sheet). Must include column
#'   \code{Inst_Altitude}. Option to use default value \code{metadata = NULL}
#'   and provide the required value in the \code{inst_alt} argument.
#'
#' @param inst_alt Height of the instrument above the sea floor (in metres). Not
#'   used if \code{metadata} argument is specified.
#'
#' @importFrom dplyr %>% contains mutate select
#'
#' @export

adcp_calculate_bin_depth <- function(
  dat,
  metadata = NULL,
  inst_alt = NULL
){

  if(!is.null(metadata)) inst_alt <- metadata$Inst_Altitude


  dat <- dat %>%
    mutate(
      bin_depth_below_surface_m =
        sensor_depth_below_surface_m + inst_alt - bin_height_above_sea_floor_m,
      BIN_DEPTH_CHECK = bin_depth_below_surface_m > 0
    ) %>%
    select(
      contains("timestamp"),
      sensor_depth_below_surface_m,
      bin_depth_below_surface_m,
      bin_height_above_sea_floor_m,
      sea_water_speed_m_s,
      sea_water_to_direction_degree,
      BIN_DEPTH_CHECK
    )

  if(any(isFALSE(dat$BIN_DEPTH_CHECK))) {
    warning("Negative bin_depth_below_surface_m value(s) detected.")
  }

  dat %>% select(-BIN_DEPTH_CHECK)

}
