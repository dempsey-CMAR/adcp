#' Plot SENSOR_DEPTH colour-coded by FLAG
#'
#' @param dat same same
#' @param title Plot title
#'
#' @return ggplot object
#'
#' @importFrom ggplot2 aes geom_point ggplot labs scale_colour_manual
#' @importFrom dplyr distinct mutate select
#'
#' @export


adcp_plot_depth_flags <- function(dat, title = NULL){

  #"#66C2A5" "#FC8D62" "#8DA0CB"
  dat %>%
    select(TIMESTAMP, SENSOR_DEPTH, FLAG) %>%
    distinct() %>%
    ggplot(aes(TIMESTAMP, SENSOR_DEPTH, col = FLAG)) +
    geom_point(alpha = 0.7, size = 1) +
    scale_colour_manual("Flag", values = c("#66C2A5", "#FC8D62")) +
    labs(title = title)

}


#' Plot SENSOR_DEPTH
#'
#' @param dat same same
#' @param title Plot title
#'
#' @return ggplot object
#'
#' @importFrom ggplot2 aes geom_point ggplot labs scale_colour_manual
#' @importFrom dplyr distinct mutate select
#' @importFrom lubridate as_datetime
#'
#' @export

adcp_plot_depth <- function(dat, title = NULL){

  #"#66C2A5" "#FC8D62" "#8DA0CB"
  dat %>%
    select(TIMESTAMP, SENSOR_DEPTH) %>%
    mutate(TIMESTAMP = as_datetime(TIMESTAMP)) %>%
    distinct() %>%
    ggplot(aes(TIMESTAMP, SENSOR_DEPTH), col = "#66C2A5") +
    geom_point(alpha = 0.7, size = 1) +
    labs(title = title)

}
