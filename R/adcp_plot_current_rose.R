#' Generate current rose
#'
#' @details Generates a current rose using the \code{windRose()} function from
#'   the \code{openair} package. See help files for \code{openair::windRose} for
#'   more detail.
#'
#' @param dat Dataframe that includes columns \code{SPEED} and \code{DIRECTION}.
#'
#' @param breaks Number of break points for current speed OR a vector of breaks.
#'   Lower-inclusive.
#'
#' @param speed_cols Vector of colours. Must be the same length as
#'   \code{breaks}.
#'
#' @param speed_label Title of the current speed legend. Default is "Current
#'   Speed (cm/s)".
#'
#' @return Returns an "openair" object, a rose plot of current speed and
#'   direction.
#'
#' @importFrom openair windRose
#'
#' @export


adcp_plot_current_rose <- function(dat, breaks, speed_cols,
                                   speed_label = "Current Speed (cm/s)"){

  openair::windRose(
    dat,
    ws = "SPEED", wd = "DIRECTION",
    breaks = breaks,
    cols = speed_cols,
    paddle = FALSE,
    auto.text = FALSE,
    annotate = FALSE,
    key.header = speed_label,
    key.footer = "",
    key.position = "right"
  )

}
