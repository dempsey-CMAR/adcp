#' Check for duplicate TIMESTAMP values
#'
#' @param dat Dataframe, as exported from \code{adcp_read_txt()}
#'
#' @return Returns a warning if any duplicate values are detected.
#'
#' @importFrom dplyr filter select
#'
#' @export


adcp_check_duplicate_timestamp <- function(dat){

  depth <- dat %>%
    filter(VARIABLE == "SensorDepth") %>%
    select(contains("TIMESTAMP"))

  speed <- dat %>%
    filter(VARIABLE == "WaterSpeed") %>%
    select(contains("TIMESTAMP"))

  direction <- dat %>%
    filter(VARIABLE == "WaterDirection") %>%
    select(contains("TIMESTAMP"))

  if(any(duplicated(depth[,1])) |
     any(duplicated(speed[,1])) |
     any(duplicated(direction[,1]))) {

    warning("Duplicate TIMESTAMP values found.")

    return(TRUE)

  }


}
