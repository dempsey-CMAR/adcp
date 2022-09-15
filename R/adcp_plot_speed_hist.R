#' Plot histogram of speed observations
#'
#' @param dat_hist Data frame that includes columns \code{bins_plot} (text),
#'   \code{prop}, and \code{freq}.
#'
#' @param bar_cols Vector of colours. Must be the same length as the number of
#'   bins to plot.
#'
#' @param speed_label Title of the current speed legend. Default is "Current
#'   Speed (cm/s)".
#'
#' @return Returns a ggplot object.
#'
#' @importFrom ggplot2 expansion geom_col geom_text scale_fill_manual scale_x_discrete
#'   scale_y_continuous theme_light
#'
#' @export

adcp_plot_speed_hist <- function(dat_hist, bar_cols,
                                 speed_label = "Current Speed (cm/s)"){

  ggplot(dat_hist, aes(ints_label, prop, fill = ints_label)) +
    geom_col(col = 1) +
    geom_text(aes(label = freq), vjust = -0.5, size = 3) +
    scale_fill_manual(values = bar_cols, guide = "none") +
    scale_x_discrete(speed_label) +
    scale_y_continuous("Percent (%)", expand = expansion(mult = c(0, 0.1))) +
    theme_light()
}
