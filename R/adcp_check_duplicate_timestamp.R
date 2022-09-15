#' Check for duplicate timestamp values
#'
#' @param dat_wide Data frame of ADCP data, as returned from
#'   \code{adcp_read_txt()}.
#'
#' @return If duplicate timestamps are detected, returns a warning and
#'   \code{TRUE}. Otherwise returns \code{FALSE}.
#'
#' @importFrom dplyr filter select
#'
#' @export


adcp_check_duplicate_timestamp <- function(dat_wide){

  depth <- dat_wide %>%
    filter(variable == "SensorDepth") %>%
    select(contains("timestamp"))

  speed <- dat_wide %>%
    filter(variable == "WaterSpeed") %>%
    select(contains("timestamp"))

  direction <- dat_wide %>%
    filter(variable == "WaterDirection") %>%
    select(contains("timestamp"))

  if(any(duplicated(depth[,1])) |
     any(duplicated(speed[,1])) |
     any(duplicated(direction[,1]))) {

  #  warning("Duplicate TIMESTAMP values found.")

    return(TRUE)

  } else return(FALSE)


}
