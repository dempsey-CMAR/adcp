#' Check for duplicate TIMESTAMP values
#'
#' @param dat_wide Dataframe of ADCP data, as returned from
#'   \code{adcp_read_txt()}.
#'
#' @return If duplicate TIMESTAMPs are detected, returns a warning and
#'   \code{TRUE}. Otherwise returns \code{FALSE}.
#'
#' @importFrom dplyr filter select
#'
#' @export


adcp_check_duplicate_timestamp <- function(dat_wide){

  depth <- dat_wide %>%
    filter(VARIABLE == "SensorDepth") %>%
    select(contains("TIMESTAMP"))

  speed <- dat_wide %>%
    filter(VARIABLE == "WaterSpeed") %>%
    select(contains("TIMESTAMP"))

  direction <- dat_wide %>%
    filter(VARIABLE == "WaterDirection") %>%
    select(contains("TIMESTAMP"))

  if(any(duplicated(depth[,1])) |
     any(duplicated(speed[,1])) |
     any(duplicated(direction[,1]))) {

    warning("Duplicate TIMESTAMP values found.")

    return(TRUE)

  } else return(FALSE)


}
