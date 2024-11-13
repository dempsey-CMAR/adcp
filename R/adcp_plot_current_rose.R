#' Generate current rose
#'
#' @details Generates a current rose using the \code{windRose()} function from
#'   the \code{openair} package. See help files for \code{openair::windRose} for
#'   more detail.
#'
#'   For wave roses, replace "current speed" with "wave height".
#'
#' @param dat Data frame with column names that include the strings
#'   \code{"speed"} and \code{"direction"}.
#'
#' @param breaks Number of break points for current speed OR a vector of breaks.
#'   Lower-inclusive.
#'
#' @param speed_column Column name of the current speed (or wave height) column
#'   (i.e., the length of the petals).
#'
#' @param direction_column Column name of the current (or wave ) direction
#'   column (i.e., the direction of the petals).
#'
#' @param speed_colors Vector of colours. Must be the same length as
#'   \code{breaks}.
#'
#' @param speed_label Title of the current speed legend. Default is "Current
#'   Speed (cm/s)".
#'
#' @return Returns an "openair" object, a rose plot of current speed and
#'   direction.
#'
#' @importFrom lattice ltext
#' @importFrom latticeExtra layer
#' @importFrom openair windRose
#' @importFrom viridis viridis
#'
#' @export


adcp_plot_current_rose <- function(
    dat,
    breaks,
    speed_column, direction_column,
    speed_colors = NULL,
    speed_label = "Current Speed (cm/s)"
  #  add_direction_labs = TRUE,
) {
  if (is.null(speed_colors)) {
    speed_colors <- viridis(breaks, option = "F", direction = -1)
  }

  dat <- dat %>%
    select(SPEED = {{ speed_column }}, DIRECTION = {{ direction_column }})

 p <- openair::windRose(
    dat,
    ws = "SPEED", wd = "DIRECTION",
    breaks = breaks,
    cols = speed_colors,
    paddle = FALSE,
    auto.text = FALSE,
    annotate = FALSE,
    key.header = speed_label,
    key.footer = "",
    key.position = "right",
    plot = FALSE
  )

#   if(isTRUE(add_direction_labs)) {
#
# #    browser()
#
#     direction_label_placement <- direction_label_placement
#
#     #ints <- adcp::adcp_count_obs(dat, SPEED, n_ints = length(breaks))
#     #dir_cor <- round(max(ints$prop)) # non-standard evaluation so this doesn't work
#
#     p <- p$plot +
#       latticeExtra::layer(
#         lattice::ltext(0, direction_label_placement, "N", cex = 0.75, col = "darkgrey")
#       ) +
#     latticeExtra::layer(
#       lattice::ltext(round(max(ints$prop)), 0, "E", cex = 0.75, col = "darkgrey")
#     ) +
#     latticeExtra::layer(
#       lattice::ltext(-round(max(ints$prop)), 0, "W", cex = 0.75, col = "darkgrey")
#     ) +
#     latticeExtra::layer(
#       lattice::ltext(0, -round(max(ints$prop)), "S", cex = 0.75, col = "darkgrey")
#     )
#   }

  p

}







