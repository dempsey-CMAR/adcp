#' Cut wind direction into 8 bins
#'
#' Adapted from \code{cutVecWinddir()} from \code{OpenAir}.
#'
#' Likely more efficient in the original vectorized form. Modified to match
#' \code{adcp_label_speed()}. Could re-visit both.
#'
#' Assigns direction data in bins of 45 degree C. -22.5 to 22.5 degree is North,
#' 22.5 to 67.5 is NNE, etc.
#'
#' @param dat Data frame with column sea_water_to_direction_degree.
#'
#' @returns Returns \code{dat} with an additional column
#'   \code{sea_water_to_direction_degree_labels}, the direction labels as an
#'   ordered factor.
#'
#' @export


adcp_label_direction <- function(dat) {

  dat$sea_water_to_direction_degree_labels <- cut(
    dat$sea_water_to_direction_degree,
    breaks = seq(22.5, 382.5, 45),
    labels = c("NE", "E", "SE", "S", "SW", "W", "NW", "N")
  )

  levels <- c("N", "NE", "E", "SE", "S", "SW", "W", "NW")

  # dat[
  #   is.na(dat$sea_water_to_direction_degree_labels),
  #   "sea_water_to_direction_degree_labels"
  # ] <- "N"


  dat %>%
    mutate(
      # for direction <= 22.5
      sea_water_to_direction_degree_labels = if_else(
        is.na(sea_water_to_direction_degree_labels) &
          sea_water_to_direction_degree >= 0 &
          sea_water_to_direction_degree <= 22.5, "N",
        sea_water_to_direction_degree_labels
      ),
      sea_water_to_direction_degree_labels =
             ordered(sea_water_to_direction_degree_labels, levels = levels)
      )

}
