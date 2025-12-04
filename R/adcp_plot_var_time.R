#' Plot histogram of speed observations
#'
#' @param dat Data frame that includes columns \code{timestamp_utc} (POSIXct),
#'   and \code{plot_col} (numeric).
#'
#' @param plot_col Column to plot (UNQUOTED).
#'
#' @param y_axis_label Character string for the y-axis title. Could hard code
#'   some options.
#'
#' @param pal Single colour value (hex code or number).
#'
#' @param geom Character value indicating which geom to use. Options are "point"
#'   or "line."
#'
#' @param date_format Character string indicating the format for the date
#'   labels.
#'
#' @return Returns a ggplot object.
#'
#' @importFrom ggplot2 aes element_blank element_rect facet_wrap geom_line
#'   geom_point labs scale_x_datetime scale_y_continuous theme_light waiver
#'
#' @export


adcp_plot_var_time <- function(
    dat,
    plot_col,
    y_axis_label = NULL,
    geom = "line",
    date_format = "%Y-%b-%d",
    pal = "#000000"
    ) {

  if (!(geom %in% c("point", "line"))) {
    stop("geom must be 'point' or 'line ")
  }

  if (is.null(y_axis_label)) y_axis_label <- waiver()

  p <- ggplot(dat, aes(timestamp_utc, {{ plot_col }})) +
    scale_y_continuous(y_axis_label, minor_breaks = NULL) +
    scale_x_datetime("Date", date_labels = date_format) +
    adcp_theme()

  if (geom == "point") p <- p + geom_point(alpha = 0.7, size = 1, colour = pal)
  if (geom == "line") p <- p + geom_line(linewidth = 0.25, colour = pal)
  if ("bin_height_above_sea_floor_m" %in% colnames(dat)) {
    p <- p +
      facet_wrap(~bin_height_above_sea_floor_m, ncol = 2)
  }

  p

}
