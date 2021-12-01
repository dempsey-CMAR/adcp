#' Assign altitude (height above sea floor) to each bin
#'
#' @details The altitude of the bins is calculated as:
#'
#'   first bin altitude = inst altitude + first bin range
#'
#'   second bin altitude = first bin altitude + bin size
#'
#'   third bin altitude = second bin altitude + bin size
#'
#'   And so on.
#'
#' @param dat_wide Dataframe of ADCP data, as exported from
#'   \code{adcp_read_txt()}.
#'
#' @param metadata Dataframe with metadata information for the deployment in
#'   \code{dat_wide} (e.g., a row from the NSDFA tracking sheet). Must include
#'   columns \code{Inst_Altitude}, \code{Bin_Size}, and \code{First_Bin_Range}.
#'   Option to use default value \code{metadata = NULL} and provide the required
#'   values in the remaining arguments.
#'
#' @param inst_alt Height of the instrument above the sea floor (in metres). Not
#'   required if \code{metadata} argument is specified.
#'
#' @param bin_size Size of each bin (in metres). Not required if \code{metadata}
#'   argument is specified.
#'
#' @param first_bin_range Size of the first bin (in metres). Not required if
#'   \code{metadata} argument is specified.
#'
#' @return Returns \code{dat_wide}, with bin columns re-named with corresponding
#'   altitude (in metres).
#'
#' @export

adcp_assign_altitude <- function(dat_wide,
                            metadata = NULL,
                            inst_alt = NULL,
                            bin_size = NULL,
                            first_bin_range = NULL){

  if(!is.null(metadata)){

    inst_alt <- metadata$Inst_Altitude
    bin_size <- metadata$Bin_Size
    first_bin_range <- metadata$First_Bin_Range

  }

  # number of bins to name
  index <- find_index(dat_wide) # index of first bin column
  n_bins <- dat_wide %>% select(all_of(index):last_col()) %>% ncol()

  # altitude of the first bin
  first_bin <- inst_alt + first_bin_range

  # altitude of each bin
  colnames_bins <- seq(first_bin, by = bin_size, length.out = n_bins)

  # keep TIMESTAMP, Num, and VARIABLE column names
  colnames_keep <- colnames(dat_wide)[1:(index - 1)]

  colnames_new <- c(colnames_keep, colnames_bins)

  names(dat_wide) <- colnames_new

  dat_wide

}
