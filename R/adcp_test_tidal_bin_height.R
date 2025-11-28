#' Apply tidal bin height test to adcp data
#'
#' ADCP data from bins near the surface can be contaminated by "side-lobe
#' interference." These observations were automatically removed from the data
#' output by the ADCP software.
#'
#' The tide can substantially impact the depth of the ADCP. At high tide, there
#' may be more "good" bins further from the sensor than at low tide. The sea
#' water speed and direction recorded in these high-altitude bins will be
#' accurate, but not representative of the long-term average because they are
#' only recorded at high-water times.
#'
#' The maximum range from the ADCP for acceptable data depends on the sensor
#' depth and the beam angle of the ADCP:
#'
#' \eqn{h = D*cos(theta)}.
#'
#' Accounting for the sensor height above the sea floor and averaging across
#' bins, the maximum acceptable range is:
#'
#' \eqn{h_max = D*cos(theta) + sensor height above sea floor - bin height}.
#'
#' This test assigns the same flag to all data in a given bin based on this
#' equation and the number of observations in the bin. D is the minimum depth
#' recorded over the deployment, and theta is the beam angle based on the sensor
#' model specifications. Any bin heights greater than h +
#' sensor_height_above_sea_floor_m are flagged as "Suspect/Of Interest". Any
#' bins that also have fewer than 25 % of the number of observations in the bin
#' with the most observations will be flagged "Fail."
#'
#' Assumes negligible wave height.
#'
#' @param dat Data frame of current variables in wide format.
#'
#' @param sensor_model ADCP model used to collect data. Used to determine the
#'   beam angle. Must be one of "Sentinel_V20", "Sentinel_V50", "Sentinel_V100",
#'   or "Workhorse Sentinel 600 kHz". Not required if \code{beam_angle} argument
#'   is supplied.
#'
#' @param inst_alt_m Height of the ADCP transducer above
#'   the sea floor, in metres.
#'
#' @param bin_height_m Height of each measurement bin in metres.
#'
#' @param beam_angle ADCP beam angle. Only required if \code{sensor_model} is
#'   not provided.
#'
#' @param min_prop_obs The proportion of observations in the bin relative to the
#'   maximum number of observations in a bin. Bins with prop_obs > min_prop_obs
#'   and h < hmax will be flagged 3. Bins with prop_obs < min_prop_obs and h <
#'   hmax will be flagged 4. Default is 0.25.
#'
#' @returns Returns \code{dat} with additional column
#'   \code{bin_heigh_flag_value}.
#'
#' @importFrom dplyr filter group_by join_by left_join mutate pull summarise
#'   ungroup
#'
#' @export

adcp_test_tidal_bin_height <- function(
    dat,
    sensor_model = NULL,
    inst_alt_m = NULL,
    bin_height_m = NULL,
    beam_angle = NULL,
    min_prop_obs = 0.25
) {

  message("applying tidal bin height test")

  if(is.null(beam_angle)) {

    models <- c("Sentinel_V20",
                "Sentinel_V50",
                "Sentinel_V100",
                "Workhorse Sentinel 600 kHz")
    if(!(sensor_model %in% models)) {
      stop("sensor_model not recognized. beam_angle must be provided.")
    }

    beam_angle <- data.frame(
      sensor_model = c(
      "Sentinel_V20",
      "Sentinel_V50",
      "Sentinel_V100",
      "Workhorse Sentinel 600 kHz"),
      beam_angle = c(25, 25, 25, 20)
    ) %>%
      filter(sensor_model == !!sensor_model) %>%
      pull(beam_angle)
  }

  n_obs <- dat %>%
    group_by(bin_height_above_sea_floor_m) %>%
    summarise(n_obs = n()) %>%
    mutate(prop_obs = round(n_obs / max(n_obs), digits = 3)) %>%
    ungroup()

  # min depth recorded (shallowest water)
  min_sensor_depth <- min(dat$sensor_depth_below_surface_m)

  # maximum bin height that will have obs for full tidal cycle
  max_bin_height <- round(
    min_sensor_depth * cos(beam_angle * pi / 180), digits = 2
  ) +
    inst_alt_m - bin_height_m

  dat %>%
    left_join(n_obs, by = join_by(bin_height_above_sea_floor_m)) %>%
    mutate(

      tidal_bin_height_flag = case_when(
        bin_height_above_sea_floor_m <= max_bin_height ~ 1,

        bin_height_above_sea_floor_m > max_bin_height &
          prop_obs >= min_prop_obs ~ 3,

        bin_height_above_sea_floor_m > max_bin_height &
          prop_obs < min_prop_obs ~ 4,

        TRUE ~ 2
      ),

      tidal_bin_height_flag = ordered(tidal_bin_height_flag, levels = 1:4)
    ) %>%
    select(-c(n_obs, prop_obs))
}
