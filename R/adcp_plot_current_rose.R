#' Generate current rose
#'
#' The direction of the petal indicates the direction the current is flowing to.
#' The colour indicates the current speed. The length of the petal shows the
#' number of observations for each current speed and direction bin.
#'
#' @param dat Data frame with at least 2 columns: an ordered factor of direction
#'   groups, and a factor of speed groups. The proportion of observations in
#'   each group is counted in the function and automatically converted to
#'   percent for the figure.
#'
#' @param direction_col The column in \code{dat} that holds the direction groups
#'   (NOT QUOTED).
#'
#' @param speed_col The column in \code{dat} that holds the speed groups (NOT
#'   QUOTED).
#'
#' @param pal Vector of colours. Must be the same length as the number of speed
#'   factor levels.
#'
#' @param speed_label Title of the current speed legend. Default is "Current
#'   Speed (cm/s)".
#'
#' @return Returns a ggplot object, a rose plot of current speed and direction.
#'
#' @importFrom dplyr reframe
#' @importFrom ggplot2 aes coord_radial element_blank element_line element_rect
#'   geom_col ggplot scale_fill_manual scale_x_discrete theme
#' @importFrom scales percent
#' @importFrom viridis viridis
#'
#'
#' @export


adcp_plot_current_rose <- function(
    dat,
    pal = NULL,
    speed_col = sea_water_speed_cm_s_labels,
    direction_col = sea_water_to_direction_degree_labels,
    speed_label = "Current Speed (cm/s)"
) {

  if (is.null(pal)) {
    n_levels <-  nrow(reframe(dat, levels({{ speed_col }})))
    pal <- get_speed_colour_pal(n_levels)
  }

  dat %>%
    group_by({{ speed_col }}, {{ direction_col}}, drop = FALSE) %>%
    summarise(n = n()) %>%
    ungroup() %>%
    mutate(n_prop = n / sum(n)) %>%
    ggplot(
      aes({{ direction_col }}, n_prop, fill = {{ speed_col }})
    ) +
    geom_col(show.legend = TRUE) + #, col = "grey30") +
    scale_fill_manual("Current Speed (cm/s)", values = pal, drop = FALSE) +
    scale_x_discrete(
      expand = expansion(add = c(0.5, 0.5)),
      drop = FALSE
    ) +
    scale_y_continuous(labels = scales::percent) +
    coord_radial(start = -22.5 * pi / 180, r.axis.inside = TRUE) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),

      axis.ticks.x = element_blank(),
      axis.ticks.y = element_blank(),

      axis.text.x = element_text(color = 1),

      panel.border =  element_rect(colour = "gray50", fill = NA),
      panel.background = element_rect(fill = NA, color = NA),

      panel.grid = element_line(color = "gray70", linewidth = 0.5),
      panel.grid.minor.y = element_blank()
    )
}


#' Generate current old rose
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
#' @importFrom openair windRose
#' @importFrom viridis viridis
#'
#' @export


adcp_plot_current_rose_old <- function(
    dat,
    breaks,
    speed_column, direction_column,
    speed_colors = NULL,
    speed_label = "Current Speed (cm/s)"
   # add_dir_labs = TRUE
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

  # if(isTRUE(add_dir_labs)) {
  #
  #   p <- p$plot +
  #     latticeExtra::layer(
  #       lattice::ltext(0, 5, "N", cex = 0.75, col = "darkgrey")
  #     ) +
  #     latticeExtra::layer(
  #       lattice::ltext(5, 0, "E", cex = 0.75, col = "darkgrey")
  #     ) +
  #     latticeExtra::layer(
  #       lattice::ltext(-5, 0, "W", cex = 0.75, col = "darkgrey")
  #     ) +
  #     latticeExtra::layer(
  #       lattice::ltext(0, -5, "S", cex = 0.75, col = "darkgrey")
  #     )
  # }

  p

}







