#' Plot histogram of speed observations
#'
#' @param dat Data frame that includes columns \code{station},
#'   \code{bin_height_above_sea_floor_m}, \code{sea_water_speed_cm_s} and
#'   \code{timestamp_utc}.
#'
#' @return Returns a ggplot object.
#'
#' @importFrom ggplot2 aes geom_line labs scale_x_datetime scale_y_continuous
#'   theme_light
#'
#' @export


adcp_plot_current_speed_time <- function(dat) {

  # check if more than one bin depth
  col_names <- colnames(dat)

  if("bin_height_above_sea_floor_m" %in% col_names) {

    bins <- unique(dat$bin_height_above_sea_floor_m)

    if(length(bins) > 1) {

      warning("More than one bin depth found in dat")
    }

  }

  ggplot(dat, aes(timestamp_utc, sea_water_speed_cm_s)) +
    geom_line() +
    scale_y_continuous("Current Speed (cm / s)") +
    scale_x_datetime("Date") +
    labs(
      title = unique(dat$station),
      caption = paste0(
        unique(dat$bin_height_above_sea_floor_m), " m above sea floor",
        "\n",
        "(approx ", round(mean(unique(dat$sensor_depth_below_surface_m)), digits = 1),
        " m below the surface)"
      )
    ) +
    theme_light()


}
