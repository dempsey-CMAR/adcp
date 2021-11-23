#' Filter out ensembles with no speed or direction data
#'
#' @param dat Output from \code{read_adcp_txt()}.
#'
#' @return Returns \code{dat} filtered to exclude ensembles (rows) with no water
#'   speed or direction data (typically as the sensor is deployed and
#'   retrieved).
#'
#' @importFrom dplyr across everything filter group_by if_else mutate ungroup
#'   select
#' @export

adcp_trim_NA_ensembles <- function(dat){

  n_bins <- dat %>%
    select(V8:last_col()) %>%
    ncol()

  NA_sum <- dat %>%
    select(V8:last_col()) %>%
    mutate(across(everything(), ~if_else(is.na(.), 1, 0))) %>%
           mutate(NA_sum = rowSums(.)) %>%
    select(NA_sum)

  # filter out ensembles with NA for each bin for WaterSpeed and WaterDirection
  cbind(dat, NA_sum) %>%
    mutate(TRIM = if_else(NA_sum == n_bins, TRUE, FALSE)) %>%
    filter(!TRIM) %>%
    group_by(Num) %>%
    mutate(n_GROUP = n()) %>%
    filter(n_GROUP != 1) %>%
    ungroup() %>%
    select(-TRIM, -n_GROUP, -NA_sum)

}

#' Filter out bins with no depth, speed or direction data
#'
#' @param dat Output from \code{read_adcp_txt()}.
#'
#' @return Returns \code{dat} filtered to exclude bins (columns) with no water
#'   speed or direction data (typically NA because of side lobe interference).
#'
#' @export


adcp_trim_NA_bins <- function(dat){

  dat_NA <- data.frame(is.na(dat))

  colsum_NA <- apply(dat_NA, 2, sum)

  keep_col <- colsum_NA < nrow(dat_NA)

  dat[ , keep_col]

}


