#' Plot sensor_depth_below_surface_m coloured by depth_flag
#'
#' @param dat Data frame of ACDP data in long format, including
#'   \code{depth_flag} column, as exported from \code{adcp_flag_data()}.
#'
#' @param plotly_friendly Logical argument. If \code{TRUE}, the legend will be
#'   plotted when \code{plotly::ggplotly} is called on \code{p}. Default is
#'   \code{FALSE}, which makes the legend look better in a static figure.
#'
#' @return ggplot object. Figure shows sensor_depth_below_surface_m over time,
#'   coloured by the \code{depth_flag} column.
#'
#' @importFrom ggplot2 aes geom_point ggplot labs scale_colour_manual
#'   scale_x_datetime theme theme_light
#' @importFrom dplyr distinct mutate select
#'
#' @export

adcp_plot_depth_flags <- function(dat, plotly_friendly = FALSE) {

  flag_colours <- c("chartreuse4", "grey24", "#EDA247", "#DB4325")

  p <- dat %>%
    select(
      timestamp_utc,
      sensor_depth_below_surface_m,
      trim_obs
    ) %>%
    distinct() %>%
    qaqcmar::qc_assign_flag_labels() %>%
    ggplot(
      aes(timestamp_utc, sensor_depth_below_surface_m, colour = trim_obs)) +
    geom_point(show.legend = TRUE, size = 0.5) +
    scale_x_datetime("Date", date_labels = "%Y-%m-%d") +
    scale_colour_manual("Flag Value", values = flag_colours, drop = FALSE) +
    theme_light() +
    theme(
      strip.text = element_text(colour = "black", size = 10),
      strip.background = element_rect(fill = "white", colour = "darkgrey")
    )

  if(isFALSE(plotly_friendly)) {
    p <- p + guides(color = guide_legend(override.aes = list(size = 4)))
  }

  p

}


#' Plot sensor_depth_below_surface_m
#'
#' @param dat Data frame of ACDP data in long format, as returned by
#'   \code{adcp_format_opendata()}.
#'
#' @param title Optional title for the figure.
#'
#' @param date_format Format for the date labels. Default is
#'   \code{"\%Y-\%b-\%d"}.
#'
#' @param geom Geom to plot. Options are \code{"point"} or \code{"line"}.
#'
#' @return ggplot object. Figure shows sensor_depth_below_surface_m over time.
#'
#' @importFrom dplyr distinct mutate select
#' @importFrom ggplot2 aes geom_line geom_point ggplot labs scale_colour_manual
#'   scale_x_datetime theme_light
#' @importFrom lubridate as_date
#'
#' @export

adcp_plot_depth <- function(dat, title = NULL, date_format = "%Y-%b-%d", geom = "point") {
  if (!(geom %in% c("point", "line"))) {
    stop("geom must be 'point' or 'line ")
  }

  # "#66C2A5" "#FC8D62" "#8DA0CB"
  p <- dat %>%
    dplyr::select(timestamp_utc, sensor_depth_below_surface_m) %>%
    dplyr::mutate(timestamp_utc = as_datetime(timestamp_utc)) %>%
    dplyr::distinct() %>%
    ggplot(aes(timestamp_utc, sensor_depth_below_surface_m), col = "#66C2A5") +
    scale_x_datetime("Date", date_labels = "%Y-%m-%d") +
    scale_y_continuous("Sensor Depth Below Surface (m)") +
    labs(title = title) +
    theme_light()

  if (geom == "point") p <- p + geom_point(alpha = 0.7, size = 1)

  if (geom == "line") p <- p + geom_line(size = 0.25)

  p
}
