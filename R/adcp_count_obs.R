#' Count number and proportion of observations in equal intervals
#'
#' @param dat_speed Data observations to assign intervals. The interval size is determined by the
#'   range of these observations and \code{n_ints}.
#'
#' @param n_ints Number of intervals to divide observations into. The interval size is
#'   determined by the range of these observations and \code{n_ints}.
#'
#' @param n_digits Number of digits to show in interval limits.
#'
#' @param label_sep Separator for the interval labels ("lower to upper"). Default is
#'   a new line to save room on plot axis.
#'
#' @return Returns a dataframe of upper and lower interval limits (lower inclusive),
#'   and frequency and proportion of observations in each interval.
#'
#' @importFrom dplyr mutate select tibble
#'
#' @export

adcp_count_obs <- function(dat_speed, n_ints = 12, n_digits = 2, label_sep = "\n"){

  if(ncol(data.frame(dat_speed)) > 1){

    stop("Multiple columns detected in dat_speed.\nHINT: input only the column to be binned")

  }

  ints <- cut(
    dat_speed,
    breaks = n_ints,
    dig.lab = n_digits,
    right = FALSE,
    include.lowest = TRUE
  ) %>%
    table() %>%
    data.frame() %>%
    separate(col = 1, into = c("lower", "upper"), sep = ",") %>%
    mutate(
      lower = as.numeric(str_remove(lower, pattern = "\\["))
    )

  # to avoid negative intervals and very small start intervals
  if(min(ints$lower) < 1e-4) {

    ints[which(ints$lower == min(ints$lower)), "lower"] <- 0

    message("Lower bound of first interval set to 0")

  }

  ints %>%
    mutate(
      upper = str_remove(upper, pattern = "\\)"),
      upper = as.numeric(str_remove(upper, pattern = "\\]")),
      ints_label = paste(lower, "to", upper, sep = label_sep),
      prop = Freq / sum(Freq) * 100
    ) %>%
    select(lower, upper, ints_label, freq = Freq, prop)

}
