#' Index of first bin column
#'
#' @inheritParams adcp_format_opendata
#'
#' @return Returns the index of the first column with bin data
#'
#' @importFrom stringr str_match str_remove
#' @importFrom stats na.omit

find_index <- function(dat){

  # so can use with output directly from adcp_read_text()
  colnames_numeric <- str_match(colnames(dat), "V\\d*$") %>%
    str_remove("V")

  if(length(na.omit(colnames_numeric)) > 0) {

    col_start <- which(
      colnames_numeric == min(as.numeric(colnames_numeric), na.rm = TRUE)
    )

    col_end <- which(
      colnames_numeric == max(as.numeric(colnames_numeric), na.rm = TRUE)
    )

    colnames(dat)[col_start:col_end] <- colnames_numeric[col_start:col_end]

  }

  # index of the first measurement column
  suppressWarnings(
    which(colnames(dat) == min(as.numeric(colnames(dat)), na.rm = TRUE))
  )


}
