#' Index of first bin column
#'
#' @param dat_wide fill this in
#'
#' @return Returns the index of the first column with bin data
#'
#' @importFrom stringr str_match str_remove
#' @importFrom stats na.omit
#'
#' @export

find_index <- function(dat_wide){

  # so can use with output directly from adcp_read_text()
  colnames_numeric <- str_match(colnames(dat_wide), "V\\d*$") %>%
    str_remove("V")

  if(length(na.omit(colnames_numeric)) > 0) {

    col_start <- which(
      colnames_numeric == min(as.numeric(colnames_numeric), na.rm = TRUE)
    )

    col_end <- which(
      colnames_numeric == max(as.numeric(colnames_numeric), na.rm = TRUE)
    )

    colnames(dat_wide)[col_start:col_end] <- colnames_numeric[col_start:col_end]

  }

  # index of the first measurement column
  suppressWarnings(
    which(colnames(dat_wide) == min(as.numeric(colnames(dat_wide)), na.rm = TRUE))
  )

}




#' Extract deployment date and station name from file path
#'
#' @param file_path Path to the file, include file name. File name must include
#'   the deployment date and the station name, in the format YYYY-MM-DD_Station
#'   Name.txt (e.g., 2007-12-18_Spectacle Island.txt)
#'
#' @return Returns a tibble with three columns: \code{DEPLOYMENT},
#'   \code{Depl_Date}, and \code{Station_Name}.
#'
#' @importFrom dplyr mutate tibble
#' @importFrom lubridate as_datetime
#' @importFrom stringi stri_locate
#' @importFrom stringr str_remove str_sub
#' @importFrom tidyr separate
#'
#' @export

extract_deployment_info <- function(file_path){

  data.frame(file_path) %>%
    str_sub(stringi::stri_locate_last(file_path, regex = "/")[1] + 1) %>%
    str_remove(pattern = ".txt") %>%
    tibble(DEPLOYMENT = .) %>%
    separate(col = 1, sep = "_",
             into = c("Depl_Date", "Station_Name"),
             remove = FALSE) %>%
    mutate(Depl_Date = as_datetime(Depl_Date))

}




