#' Apply multiple quality control tests to current data
#'
#' This function has been deprecated. The rolling_sd and spike tests are not
#' applied to the current data prior to publication.
#'
#' @param dat Data frame of wave data in a wide format.
#'
#' @param qc_tests Character vector of quality control tests to apply to
#'   \code{dat}. Defaults to all available tests: \code{qc_tests =
#'   c("grossrange", "rolling_sd", "spike")}.
#'
#' @inheritParams adcp_test_grossrange
#' @inheritParams adcp_test_rolling_sd
#' @inheritParams adcp_test_spike
#'
#' @return Returns \code{dat} with additional quality control flag columns.
#'
#' @importFrom dplyr %>% arrange distinct left_join
#' @importFrom purrr reduce
#'
#' @export

adcp_test_all <- function(
    dat,
    qc_tests = NULL,
    county = NULL,

    current_grossrange_table = NULL,
    current_rolling_sd_table = NULL,
    current_spike_table = NULL,

    period_hours = 12,
    max_interval_hours = 2,
    align_window = "center",
    keep_sd_cols = FALSE,
    keep_spike_cols = FALSE
) {

  if (is.null(qc_tests)) {
    qc_tests <- c("grossrange", "rolling_sd", "spike")
  }

  qc_tests <- tolower(qc_tests)

  # use for the join and to order columns in output
  depl_cols <- c(
    "county",
    "waterbody",
    "station",
    "lease",
    "latitude" ,
    "longitude" ,
    "deployment_id",
    "timestamp_utc",
    #"depth_trim_flag",
    "bin_height_above_sea_floor_m",
    "bin_depth_below_surface_m",
    "trim_obs"
  )

  #  use for the join and to order columns in output
  var_cols <- dat %>%
    adcp_pivot_vars_longer() %>%
    distinct(variable) %>%
    arrange() %>%
    pull(variable)

  # apply tests
  dat_out <- list()

  if ("grossrange" %in% qc_tests) {
    dat_out[[1]] <- adcp_test_grossrange(
      dat,
      current_grossrange_table = current_grossrange_table,
      county = county
    )
  }

  if ("rolling_sd" %in% qc_tests) {
    dat_out[[2]] <- adcp_test_rolling_sd(
      dat,
      current_rolling_sd_table = current_rolling_sd_table,
      county = county,

      period_hours = period_hours,
      max_interval_hours = max_interval_hours,
      align_window = align_window,
      keep_sd_cols = keep_sd_cols
    )
  }

  if("spike" %in% qc_tests) {
    dat_out[[3]] <- adcp_test_spike(
      dat,
      county = county,
      current_spike_table = current_spike_table,
      keep_spike_cols = keep_spike_cols
    )
  }

  # join results from each test
  join_cols <- c(
    depl_cols[which(depl_cols %in% colnames(dat))], var_cols)

  # join by all common columns
  dat_out <- dat_out %>%
    purrr::reduce(dplyr::left_join, by = join_cols)

  dat_out
}

