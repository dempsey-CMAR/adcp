#' Plot sensor_depth_below_surface_m colour-coded by depth_flag
#'
#' @param dat Dataframe of ACDP data in long format, including \code{depth_flag}
#'   column, \code{adcp_flag_data()}.
#'
#' @param title Optional title for the figure.
#'
#' @param date_format Format for the date labels. Default is "\%Y-\%b-\%d"
#'
#' @return ggplot object. Figure shows sensor_depth_below_surface_m over time, coloured by the
#'   \code{depth_flag} column.
#'
#' @importFrom ggplot2 aes geom_point ggplot labs scale_colour_manual scale_x_datetime theme
#' @importFrom dplyr distinct mutate select
#' @importFrom lubridate as_date
#'
#' @export


adcp_plot_depth_flags <- function(dat, title = NULL, date_format = "%Y-%b-%d"){

  dat %>%
    select(timestamp_utc, sensor_depth_below_surface_m, depth_flag) %>%
    mutate(timestamp_utc = as_datetime(timestamp_utc)) %>%
    distinct() %>%
    ggplot(aes(timestamp_utc, sensor_depth_below_surface_m, col = depth_flag)) +
    geom_point(alpha = 0.7, size = 1) +
    scale_x_datetime(date_labels = date_format) +
    scale_colour_manual(
      "Depth Flag", values = c("#66C2A5", "#FC8D62", "#B3B3B3"), drop = TRUE
    ) +
    labs(title = title) +
    theme(legend.position = "bottom")

}


#' Plot sensor_depth_below_surface_m
#'
#' @param dat Dataframe of ACDP data in long format, as returned by
#'   \code{adcp_format_opendata()}.
#'
#' @param title Optional title for the figure.
#'
#' @param date_format Format for the date labels. Default is "\%Y-\%b-\%d"
#'
#' @param geom Geom to plot. Options are \code{"point"} or \code{"line"}.
#'
#' @return ggplot object. Figure shows sensor_depth_below_surface_m over time.
#'
#' @importFrom ggplot2 aes geom_point ggplot labs scale_colour_manual
#'   scale_x_datetime
#'
#' @importFrom dplyr distinct mutate select
#' @importFrom lubridate as_date
#' @importFrom ggplot2 geom_line geom_point ggplot labs scale_x_datetime
#'   theme_light
#'
#' @export

adcp_plot_depth <- function(dat, title = NULL, date_format = "%Y-%b-%d", geom = "point"){

  if(!(geom %in% c("point", "line"))) {

    stop("geom must be 'point' or 'line ")
  }

  #"#66C2A5" "#FC8D62" "#8DA0CB"
  p <- dat %>%
    select(timestamp_utc, sensor_depth_below_surface_m) %>%
    mutate(timestamp_utc = as_datetime(timestamp_utc)) %>%
    distinct() %>%
    ggplot(aes(timestamp_utc, sensor_depth_below_surface_m), col = "#66C2A5") +
    scale_x_datetime("Date", date_labels = "%Y-%b-%d") +
    scale_y_continuous("Sensor Depth Below Surface (m)") +
    labs(title = title) +
    theme_light()

  if(geom == "point") p <- p + geom_point(alpha = 0.7, size = 1)

  if(geom == "line") p <- p + geom_line(size = 0.25)

  p

}
