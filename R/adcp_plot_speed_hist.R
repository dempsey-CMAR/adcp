#' Plot histogram of speed observations
#'
#' @param dat_hist Dataframe that includes columns \code{bins_plot} (text),
#'   \code{prop}, and \code{freq}.
#'
#' @param bar_cols Vector of colours. Must be the same length as the number of
#'   bins to plot.
#'
#' @return Returns a dataframe of upper and lower bin limits (lower inclusive),
#'   and frequency and proportion of observations in each bin.
#'
#' @importFrom ggplot2 geom_col geom_text scale_fill_manual scale_x_discrete
#'   scale_y_continuous theme_light
#'
#' @export

adcp_plot_speed_hist <- function(dat_hist, bar_cols){

  ggplot(dat_hist, aes(ints_label, prop, fill = ints_label)) +
    geom_col(col = 1) +
    geom_text(aes(label = freq), vjust = -0.5, size = 3) +
    scale_fill_manual(values = bar_cols, guide = "none") +
    scale_x_discrete("Current Speed (cm/s)") +
    scale_y_continuous("Percent (%)") +
    theme_light()

}
